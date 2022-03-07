{ self, nixpkgs, inputs, lib, ... }:
let
  profile_set = builtins.readDir ( ../../../profiles );
  profile_list = lib.fold (x: y: if profile_set.${x} == "directory" then [x] ++ y else y) [] (builtins.attrNames profile_set);
in {
  nixosConfigurations = lib.fold (x: y: {
    ${x} = nixpkgs.lib.nixosSystem ((import ../../../profiles/${x}).nixosSystem { inherit self; });
  } // y) {} profile_list;

  colmena = lib.fold (x: y: {
    ${x} = (z: (z.nixosSystem { inherit self; }) // z.Host) (import ../../../profiles/${x});
  } // y) {} profile_list;
}
