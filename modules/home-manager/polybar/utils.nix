{ lib }:
{
  modulesWithSharedAttrs =
    modules: common:
    lib.listToAttrs (map (x: x // { value = lib.recursiveUpdate common x.value; }) modules);
}
