{ pkgs }:
pkgs.writeShellApplication {
  name = "yazi-wrapper";

  text = ''
    set -x

    multiple="$1"
    directory="$2"
    save="$3"
    path="$4"
    out="$5"
    cmd="yazi"
    last_selected_path_cfg="$HOME/.config/xdg-desktop-portal-termfilechooser/.last_selected"
    termcmd=''${TERMCMD:-ghostty}

    mkdir -p "$(dirname "$last_selected_path_cfg")"
    if [ ! -f "$last_selected_path_cfg" ]; then
        touch "$last_selected_path_cfg"
    fi
    last_selected="$(cat "$last_selected_path_cfg")"

    # Restore last selected path
    if [ -d "$last_selected" ]; then
        save_to_file=""
        if [ "$save" = "1" ]; then
            save_to_file="$(basename "$path")"
            path="$last_selected/$save_to_file"
        else
            path="$last_selected"
        fi
    fi
    if [[ -z "$path" ]]; then
        path="$HOME"
    fi

    if [ "$save" = "1" ]; then
        # Save/download file
        printf '%s' 'xdg-desktop-portal-termfilechooser saving files tutorial

        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        !!!                 === WARNING! ===                 !!!
        !!! The contents of *whatever* file you open last in !!!
        !!! yazi will be *overwritten*!                    !!!
        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

        Instructions:
        1) Move this file wherever you want.
        2) Rename the file if needed.
        3) Confirm your selection by opening the file, for
           example by pressing <Enter>.

        Notes:
        1) This file is provided for your convenience. You
           could delete it and choose another file to overwrite
           that.
        2) If you quit yazi without opening a file, this file
           will be removed and the save operation aborted.
        ' > "$path"
        set -- --chooser-file="$out" --cwd-file="$last_selected_path_cfg" "$path"
    elif [ "$directory" = "1" ]; then
        # upload files from a directory
        set -- --cwd-file="$out" "$path"
    elif [ "$multiple" = "1" ]; then
        # upload multiple files
        set -- --chooser-file="$out" --cwd-file="$last_selected_path_cfg" "$path"
    else
        # upload only 1 file
        set -- --chooser-file="$out" --cwd-file="$last_selected_path_cfg" "$path"
    fi

    $termcmd -e $cmd "$@"

    # Save the last selected path for the next time, only upload files from a directory operation is need
    # because `--cwd-file` will do the same thing for files(s) upload and download operations
    if [ "$save" = "0" ] && [ "$directory" = "1" ]; then
        head -n 1 < "$out" > "$last_selected_path_cfg"
    fi

    # Remove file if the save operation aborted
    if [ "$save" = "1" ] && [ ! -s "$out" ]; then
        rm "$path"
    fi
  '';
}
