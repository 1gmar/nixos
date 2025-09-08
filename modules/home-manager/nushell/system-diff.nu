def main [...nix_diff_cmd: string] {
  let diff_closure = (run-external $nix_diff_cmd)
  let table = ($diff_closure
    | lines
    | where $it =~ KiB
    | where $it =~ →
    | parse -r '^(?<Package>\S+): (?<Old>[^,]+)(?:.*) → (?<New>[^,]+)(?:.*), (?<DiffBin>.*)$'
    | insert Diff { get DiffBin | ansi strip | into filesize }
    | sort-by -r Diff
    | reject DiffBin
  )
  if ($table | get Diff | is-not-empty) {
    print ""
    $table
    | append [[Package Old New Diff]; ["" "" "" ""]]
    | append [[Package Old New Diff]; ["" "" "Total:" ($table | get Diff | math sum)]]
    | print
    print ""
  }
}
