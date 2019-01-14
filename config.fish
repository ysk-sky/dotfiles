# viでもvimで開く
alias vi='/usr/bin/vim'

## rmでゴミ箱に入れる
alias rm='rmtrash'

function fish_user_key_bindings
  bind \cr 'peco_select_history (commandline -b)' # Bind for prco history to Ctrl+r
  bind \c] peco_change_directory # Bind for prco change directory to Ctrl+]
end

function cd
    if test (count $argv) -eq 0
        return 0
    else if test (count $argv) -gt 1
        printf "%s\n" (_ "Too many args for cd command")
        return 1
    end
    # Avoid set completions.
    set -l previous $PWD

    if test "$argv" = "-"
        if test "$__fish_cd_direction" = "next"
            nextd
        else
            prevd
        end
        return $status
    end
    builtin cd $argv
    set -l cd_status $status
    # Log history
    if test $cd_status -eq 0 -a "$PWD" != "$previous"
        set -q dirprev[$MAX_DIR_HIST]
        and set -e dirprev[1]
        set -g dirprev $dirprev $previous
        set -e dirnext
        set -g __fish_cd_direction prev
    end

    if test $cd_status -ne 0
        return 1
    end
    ls
    return $status
end

# alias
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -D'
alias gcm='git commit -m'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gd='git diff'
alias glog="git log --graph --date=iso --pretty='[%ad]%C(auto) %h%d %Cgreen%an%Creset : %s'"
alias gll="git log --pretty=format:'%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]' --decorate --numstat"
set -Ux GOPATH $HOME/go
set -U fish_user_paths $fish_user_paths $GOPATH/bin
