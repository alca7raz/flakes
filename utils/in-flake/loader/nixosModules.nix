{ lib, ... }:
let
  module_set = builtins.readDir ( ../../../modules );
  module_list = lib.fold (x: y: if module_set.${x} == "directory" then [x] ++ y else y) [] (builtins.attrNames module_set);
in
  lib.fold (x: y: rec { ${x} = import ../../../modules/${x}; } // y) {} module_list
