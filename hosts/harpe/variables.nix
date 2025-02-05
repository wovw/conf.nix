{ pkgs, ... }:
{
  # placeholder wallpaper for stylix
  wallpaper = pkgs.fetchurl {
    url = "https://www.pixelstalk.net/wp-content/uploads/2016/05/Epic-Anime-Awesome-Wallpapers.jpg";
    sha256 = "enQo3wqhgf0FEPHj2coOCvo7DuZv+x5rL/WIo4qPI50=";
  };

  # Git Configuration ( For Pulling Software Repos )
  gitUsername = "wovw";
  gitEmail = "anthonypasala12@gmail.com";

  terminal = "ghostty";

  # Program Options
  keyboardLayout = "us";
}
