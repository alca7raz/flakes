{ self, nixpkgs, inputs, lib, ... }:
let
  RESERVED_WORDS = [ "default.nix" ];

  loader_set = builtins.readDir ( ./. );
  Loaders = lib.fold (x: y: rec { ${x} = import ./${x}.nix { inherit lib self nixpkgs inputs; }; } // y) {} 
    (lib.forEach (lib.subtractLists RESERVED_WORDS (lib.fold (x: y: if loader_set.${x} == "regular" then [x] ++ y else y) [] 
    (builtins.attrNames loader_set))) (x: lib.removeSuffix ".nix" x));
in Loaders
