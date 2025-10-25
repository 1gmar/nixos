export def ns [term: string]: nothing -> table<package: string, description: string, version: string> {
  let info = (sysctl -n kernel.arch kernel.ostype
    | lines
    | {arch: ($in.0 | str downcase), ostype: ($in.1 | str downcase)}
  )
  nix search --json nixpkgs $term
    | from json
    | transpose package description
    | flatten
    | select package description version
    | update package { str replace $"legacyPackages.($info.arch)-($info.ostype)." '' }
}
