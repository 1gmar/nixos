def main [user_name: string, ...nix_diff_cmd: string] {
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
    let log_path = $"/home/($user_name)/.local/state/system-rebuild"
    let totals = ($table
    | append [[Package Old New Diff]; ["" "" "" ""]]
    | append [[Package Old New Diff]; ["" "" "Total:" ($table | get Diff | math sum)]])
    $totals | print
    mkdir $log_path
    $totals | save -f ($log_path | path join 'diff-log.nuon')
    print ""
  }
}
