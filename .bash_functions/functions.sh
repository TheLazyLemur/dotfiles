#!/bin/bash
 
mdless() {
    glow "$@" -s dark | less -r
}

genp(){
    password=$(openssl rand -base64 32)
    echo $password
}

itransfer(){
    if [ $# -eq 0 ];then echo "No arguments specified.\nUsage:\n  transfer <file|directory>\n  ... | transfer <file_name>">&2;return 1;fi;if tty -s;then file="$1";file_name=$(basename "$file");if [ ! -e "$file" ];then echo "$file: No such file or directory">&2;return 1;fi;if [ -d "$file" ];then file_name="$file_name.zip" ,;(cd "$file"&&zip -r -q - .)|curl --progress-bar --upload-file "-" "https://transfer.madebyeden.tech/$file_name"|tee /dev/null,;else cat "$file"|curl --progress-bar --upload-file "-" "https://transfer.madebyeden.tech/$file_name"|tee /dev/null;fi;else file_name=$1;curl --progress-bar --upload-file "-" "https://transfer.madebyeden.tech/$file_name"|tee /dev/null;fi;

    echo ""
}

xrplatform(){
    tmux new -s xrplatform -d

    while [ "$#" -gt 0 ]; do
        curr=$1
        shift

        case "$curr" in
        "-t")
            tmux neww -t xrplatform: -n caddyserver -d 'launchcaddy'
            tmux neww -t xrplatform: -n xrdocker -d 'cd ~/Workspace/Eden/XRPlatform && docker-compose up'
            tmux neww -t xrplatform: -n azure-server -d 'ssh eden@20.68.172.80'
            ;;
        *) echo "Unavaliable command.... $curr"
        esac
    done
}
