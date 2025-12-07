{
  description = "Rust Nightly Dev Shell";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    # The overlay allows us to access nightly versions
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
        
        # Select the nightly toolchain here
        # You can specify a date: rust-bin.nightly."2024-01-01".default
        # Or just use the absolute latest:
        rustToolchain = pkgs.rust-bin.selectLatestNightlyWith (toolchain: toolchain.default.override {
          extensions = [ "rust-src" "rust-analyzer" ];
        });
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [ 
            rustToolchain
            pkgs.openssl 
            pkgs.stack
            pkgs.pkg-config 
            pkgs.yarn
            pkgs.go-task
            pkgs.delve
          ];

          shellHook = ''
            echo "🦀 Rust Nightly $(rustc --version) Activated!"
          '';
        };
      }
    );
}
