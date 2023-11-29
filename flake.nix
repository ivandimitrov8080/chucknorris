{
  description = ''
    Express flake
  '';

  inputs = {
    nixpkgs.url = "nixpkgs";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      buildInputs = with pkgs; [
        nodejs_16
      ];
    in
    {
      packages.${system}.default = pkgs.buildNpmPackage rec {
        buildInputs = with pkgs; [ nodejs_20 ];
        pname = "chucknorris";
        version = "1.0.0";
        src = ./.;
        npmDepsHash = "sha256-5wRKkq7IwIDaE45cczxZLbilwtkxcGASXk8lzssq0J0=";
        dontNpmBuild = true;
        postInstall = ''
          mkdir -p $out/bin/
          mv $out/lib/node_modules/$pname/* $out
          rm -rf $out/lib
          echo "cd $out && ${pkgs.nodejs_20}/bin/npm start" > $out/bin/$pname
          chmod +x $out/bin/$pname
        '';
      };
    };
}

