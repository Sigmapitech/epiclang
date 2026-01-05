{
  description = "Compiler wrapper used to compile Epitech C projects";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    ruleset-v4 = {
      url = "git+ssh://git@github.com/Epitech/banana-coding-style-checker.git?rev=f56825bb8bd6c99cb4391a3a4da1d5057b4c3260";
      flake = false;
    };

    epiclang-src = {
      url = "git+ssh://git@github.com/Epitech/epiclang.git";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    ruleset-v4,
    epiclang-src
  }: let
    supportedSystems = [
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-linux"
      "x86_64-darwin"
    ];

    forAllSystems = f: nixpkgs.lib.genAttrs
      supportedSystems (system: f (import nixpkgs {
       inherit system;
       config.allowUnfree = true;
      }));
  in {
    devShells = forAllSystems (pkgs: let
      inherit (pkgs.stdenv.hostPlatform.system) system;
    in {
      default = pkgs.mkShell {
        packages = [ self.packages.${system}.epiclang ];
        CC = pkgs.lib.getExe self.packages.${system}.epiclang;
      };

      dev = pkgs.mkShell {
        inputsFrom = [ self.packages.${system}.epiclang ];
      };
    });

    packages = forAllSystems (pkgs: let
      inherit (pkgs.stdenv.hostPlatform.system) system;
    in {
      default = self.packages.${system}.epiclang;

      banana-plugin = pkgs.callPackage ./banana-plugin.nix {
        inherit ruleset-v4;
      };

      epiclang = pkgs.callPackage ./epiclang.nix {
        inherit (self.packages.${system}) banana-plugin;
        inherit epiclang-src;
      };
    });
  };
}
