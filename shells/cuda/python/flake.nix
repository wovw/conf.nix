{
  # cuda setup from https://gist.github.com/r3rer3/de4be0ad6be012264c641222eecb359a
  description = "Python Jupyter + CUDA";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };
  nixConfig = {
    extra-substituters = [ "https://cuda-maintainers.cachix.org" ];
    extra-trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.cudaSupport = true;
      };
    in
    {
      devShells."${system}".default = pkgs.mkShell {
        NIX_LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
          pkgs.stdenv.cc.cc.lib
          pkgs.linuxPackages.nvidia_x11
          pkgs.ncurses5
        ];
        NIX_LD = pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker";

        packages = with pkgs; [
          cudaPackages.cudatoolkit
          cudaPackages.cudnn
          cudaPackages.cuda_cudart
          linuxPackages.nvidia_x11
          libGLU
          libGL

          python312
          uv
        ];

        shellHook = ''
          # CUDA setup
          export CUDA_PATH=${pkgs.cudaPackages.cudatoolkit}
          export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH
          export EXTRA_LDFLAGS="-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib"
          export EXTRA_CCFLAGS="-I/usr/include"

          uv sync
          source .venv/bin/activate

          # jupyter setup
          uv add --dev ipykernel
        '';
      };
    };
}
