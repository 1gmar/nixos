export def ns [term: string]: nothing -> table<package: string, description: string, version: string> {
  let info = sysctl -n kernel.arch kernel.ostype
    | lines
    | str downcase
    | {arch: $in.0 ostype: $in.1}

  nix search --json nixpkgs $term
  | from json
  | transpose package description
  | flatten
  | select package description version
  | update package { str replace $"legacyPackages.($info.arch)-($info.ostype)." '' }
}
