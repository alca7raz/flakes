{ lib, self, nixpkgs, inputs, ... }:
let
  RESERVED_WORDS = [
    "default" "default.nix"
    "sample" "sample.nix"
    "test" "test.nix"
    "example" "example.nix"
    "Module"
  ];

  # Load Flake Utilities
  util_in_flake_set = builtins.readDir ( ./in-flake );
  UtilsInFlake = lib.fold (x: y: rec { ${x} = import ./in-flake/${x} { inherit lib self nixpkgs inputs; }; } // y) {} 
    (lib.subtractLists RESERVED_WORDS (lib.fold (x: y: if util_in_flake_set.${x} == "directory" then [x] ++ y else y) [] 
    (builtins.attrNames util_in_flake_set)));

  # Load Properties
  property_set = builtins.readDir ( ./. );
  Properties = lib.fold (x: y: rec { ${x} = import ./${x}.nix; } // y) {} 
    (lib.forEach (lib.subtractLists RESERVED_WORDS (lib.fold (x: y: if property_set.${x} == "regular" then [x] ++ y else y) [] 
    (builtins.attrNames property_set))) (x: lib.removeSuffix ".nix" x));

  # Load Module Utilities
  util_in_module_set = builtins.readDir ( ./in-module );
  UtilsInModule = lib.fold (x: y: [ ./in-module/${x} ] ++ y) [] 
    (lib.subtractLists RESERVED_WORDS (lib.fold (x: y: if util_in_module_set.${x} == "directory" then [x] ++ y else y) [] 
    (builtins.attrNames util_in_module_set)));

in UtilsInFlake // Properties // rec {
  Module.utils = { config, pkgs, lib, ... }: {
    imports = UtilsInModule;
  };
}
