{ homeDirectory, ... }:
''
  # For documentation, FAQ, additional configuration options and technical help, visit: https://github.com/dockur/windows

  name: "winapps" # Docker Compose Project Name.
  volumes:
    # Create Volume 'data'.
    # Located @ '/var/lib/docker/volumes/winapps_data/_data' (Docker).
    # Located @ '/var/lib/containers/storage/volumes/winapps_data/_data' or '~/.local/share/containers/storage/volumes/winapps_data/_data' (Podman).
    data:
  services:
    windows:
      image: ghcr.io/dockur/windows:latest
      container_name: WinApps # Created Docker VM Name.
      environment:
        # Version of Windows to configure. For valid options, visit:
        # https://github.com/dockur/windows?tab=readme-ov-file#how-do-i-select-the-windows-version
        # https://github.com/dockur/windows?tab=readme-ov-file#how-do-i-install-a-custom-image
        VERSION: "tiny11"
        RAM_SIZE: "4G" # RAM allocated to the Windows VM.
        CPU_CORES: "4" # CPU cores allocated to the Windows VM.
        DISK_SIZE: "64G" # Size of the primary hard disk.
        #DISK2_SIZE: "32G" # Uncomment to add an additional hard disk to the Windows VM. Ensure it is mounted as a volume below.
        USERNAME: "wovw" # Uncomment to set a custom Windows username. The default is 'Docker'.
        PASSWORD: "asdf" # Uncomment to set a password for the Windows user. There is no default password.
        HOME: "${homeDirectory}" # Set path to Linux user home folder.
      privileged: true # Grant the Windows VM extended privileges.
      ports:
        - 8006:8006 # Map '8006' on Linux host to '8006' on Windows VM --> For VNC Web Interface @ http://127.0.0.1:8006.
        - 3389:3389/tcp # Map '3389' on Linux host to '3389' on Windows VM --> For Remote Desktop Protocol (RDP).
        - 3389:3389/udp # Map '3389' on Linux host to '3389' on Windows VM --> For Remote Desktop Protocol (RDP).
      stop_grace_period: 120s # Wait 120 seconds before sending SIGTERM when attempting to shut down the Windows VM.
      restart: on-failure # Restart the Windows VM if the exit code indicates an error.
      volumes:
        - data:/storage # Mount volume 'data' to use as Windows 'C:' drive.
        - ${homeDirectory}:/shared # Mount Linux user home directory @ '\\host.lan\Data'.
        #- /path/to/second/hard/disk:/storage2 # Uncomment to mount the second hard disk within the Windows VM. Ensure 'DISK2_SIZE' is specified above.
        # - ${./oem}:/oem # Enables automatic post-install execution of 'oem/install.bat', applying Windows registry modifications contained within 'oem/RDPApps.reg'.
        #- /path/to/windows/install/media.iso:/custom.iso # Uncomment to use a custom Windows ISO. If specified, 'VERSION' (e.g. 'tiny11') will be ignored.
      devices:
        - /dev/kvm # Enable KVM.
        #- /dev/sdX:/disk1 # Uncomment to mount a disk directly within the Windows VM (Note: 'disk1' will be mounted as the main drive).
        #- /dev/sdY:/disk2 # Uncomment to mount a disk directly within the Windows VM (Note: 'disk2' and higher will be mounted as secondary drives).
''
