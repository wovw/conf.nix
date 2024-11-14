{ pkgs }:

pkgs.writeShellApplication {
  name = "install-spotx";

  runtimeInputs = with pkgs; [
    curl
    bash
    coreutils
    gnused
    gawk
  ];

  text = ''
    # Create temporary directory
    temp_dir=$(mktemp -d)
    trap 'rm -rf "$temp_dir"' EXIT

    # Download the script to temporary location
    echo "Downloading SpotX installation script..."
    curl -sSL https://spotx-official.github.io/run.sh -o "$temp_dir/spotx.sh"

    # Make it executable
    chmod +x "$temp_dir/spotx.sh"

    # Execute the script
    echo "Running SpotX installation script..."
    bash "$temp_dir/spotx.sh"
  '';
}

