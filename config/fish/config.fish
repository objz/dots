if not status is-interactive
    exit
end


function fish_greeting
    if type -q fortune
        set_color magenta
        fortune
        set_color normal
    else
        set_color magenta
        echo "Welcome back, $USER!"
        set_color normal
    end
end


starship init fish | source
zoxide init fish --cmd cd| source

# Environment / PATH
if type -q archlinux-java
    set -gx JAVA_HOME /usr/lib/jvm/(archlinux-java get)
    set -gx PATH $JAVA_HOME/bin $PATH
end

set -gx EDITOR nvim
set -gx PATH $HOME/.cargo/bin $HOME/.local/bin $HOME/go/bin $PATH
set -q XDG_DATA_DIRS; or set -gx XDG_DATA_DIRS /usr/local/share:/usr/share
set -gx XDG_DATA_DIRS $XDG_DATA_DIRS /var/lib/flatpak/exports/share $HOME/.local/share/flatpak/exports/share

ulimit -n 4096 


# Simple aliases
alias c='clear'
alias ls='eza -1 --icons=auto'
alias lsa='eza -lha --icons=auto --sort=name --group-directories-first'
alias lst='eza --icons=auto --tree'
alias mkdir='mkdir -p'

set -gx AUR_HELPER paru
abbr -a pr   '$AUR_HELPER -Rns'                # remove with deps
abbr -a ps   '$AUR_HELPER -Syu'                # system update
abbr -a pl   '$AUR_HELPER -Qs'                 # search installed
abbr -a lr   '$AUR_HELPER -Ss'                 # search repo
abbr -a ca   '$AUR_HELPER -Sc'                 # clean cache
abbr -a cu   '$AUR_HELPER -Qtdq | $AUR_HELPER -Rns -'  # remove orphans

function spf
    set -gx SPF_LAST_DIR (string join '' $XDG_STATE_HOME $HOME/.local/state)/superfile/lastdir
    command spf $argv
    if test -f "$SPF_LAST_DIR"
        source "$SPF_LAST_DIR" ^/dev/null
        rm -f -- "$SPF_LAST_DIR" ^/dev/null
    end
end


if test -x /home/linuxbrew/.linuxbrew/bin/brew
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end


function fish_command_not_found
    set -l cmd $argv[1]
    printf 'fish: command not found: %s\n' $cmd

    if type -q pkgfile
        set -l entries (pkgfile -v -b -q $cmd 2>/dev/null)
        if test (count $entries) -gt 0
            echo "$cmd may be found in:"
            for pkg in $entries
                echo "  $pkg"
            end
        end
    end
    return 127
end

