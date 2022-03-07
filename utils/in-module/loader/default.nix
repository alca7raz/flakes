{ config, pkgs, lib, ... }:
let
  RESERVED_WORDS = [ "default.nix" ];

  loader_set = builtins.readDir ( ./. );
  Loaders = lib.fold (x: y: [ ./${x}.nix ] ++ y) [] 
    (lib.forEach (lib.subtractLists RESERVED_WORDS (lib.fold (x: y: if loader_set.${x} == "regular" then [x] ++ y else y) [] 
    (builtins.attrNames loader_set))) (x: lib.removeSuffix ".nix" x));

in rec { imports = Loaders; }
