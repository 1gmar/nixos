def main [user_name: string ...nix_diff_cmd: string] {
  let diff_closure = run-external $nix_diff_cmd
  let table = $diff_closure
    | lines
    | ansi strip
    | each { if ($in | str ends-with 'B') { $in } else { $in + ',' } }
    | parse -r '^(?<Package>\S+): (?<Old>.+) → (?<New>.+),\s?(?<DiffBin>.*)?$'
    | insert Diff { get DiffBin | each { default -e 0B } | into filesize }
    | reject DiffBin
    | sort-by -c {|a b| if $a.Diff == $b.Diff { $a.Package < $b.Package } else { $a.Diff > $b.Diff } }

  if ($table | get Diff | is-not-empty) {
    let totals = $table
      | append [[Package Old New Diff]; ["" "" "" ""]]
      | append [[Package Old New Diff]; ["" "" "Total:" ($table | get Diff | math sum)]]
    let log_path = $"/home/($user_name)/.local/state/system-rebuild"
    mkdir $log_path
    $totals | save -f ($log_path | path join 'diff-log.nuon')
    print ""
    $totals | print
    print ""
  }
}
