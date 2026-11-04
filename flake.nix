{
  description = "X-Plane 12 installer and FHS launcher for Nix and NixOS with Demo and Full feature flags";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          mkPackage = args: pkgs.callPackage ./default.nix args;
        in
        {
          default = mkPackage { enableDemo = true; enableFull = false; };
          demo = mkPackage { enableDemo = true; enableFull = false; };
          full = mkPackage { enableDemo = false; enableFull = true; };
          all = mkPackage { enableDemo = true; enableFull = true; };
        }
      );

      nixosModules.default = { config, lib, pkgs, ... }:
        let
          cfg = config.programs.xplane;
          pkg = pkgs.callPackage ./default.nix {
            inherit (cfg) enableDemo enableFull;
          };
        in
        {
          options.programs.xplane = {
            enableDemo = lib.mkEnableOption "X-Plane 12 Demo version";
            enableFull = lib.mkEnableOption "X-Plane 12 Full version";
          };

          config = lib.mkIf (cfg.enableDemo || cfg.enableFull) {
            environment.systemPackages = [ pkg ];
          };
        };

      homeManagerModules.default = { config, lib, pkgs, ... }:
        let
          cfg = config.programs.xplane;
          pkg = pkgs.callPackage ./default.nix {
            inherit (cfg) enableDemo enableFull;
          };
        in
        {
          options.programs.xplane = {
            enableDemo = lib.mkEnableOption "X-Plane 12 Demo version";
            enableFull = lib.mkEnableOption "X-Plane 12 Full version";
          };

          config = lib.mkIf (cfg.enableDemo || cfg.enableFull) {
            home.packages = [ pkg ];
          };
        };
    };
}
