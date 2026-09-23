# viでもvimで開く
alias vi='/usr/bin/vim'

# fish設定変更スニペット
abbr -a vc vim ~/.config/fish/config.fish
abbr -a sc source ~/.config/fish/config.fish

abbr -a head head -n5
abbr -a tail tail -n5
abbr -a c clear
abbr -a t htop
abbr -a wc wc -l
abbr -a h "history | grep"

abbr -a sed --set-cursor "sed 's/%//g'"
abbr -a awk --set-cursor "awk -F, '{print \$1%}'"
abbr -a cnt "awk -F, '{cnt[\$1]++}END{for(i in cnt)print i,cnt[i]}'"
abbr -a unq "awk -F, '{cnt[\$1]++}END{for(i in cnt)print i}'"
abbr -a header --set-cursor "head -n1 % | awk -F, '{for(i=1;i<=NF;i++)print i,\$i}' | column -t"

if command -q eza
    abbr -a ls eza --icons
    abbr -a ll eza --icons -lhg --time-style long-iso
    abbr -a la eza --icons -lhag --time-style long-iso
    abbr -a lt eza --icons --tree
end

## app alias
# claude CLI shortcuts
abbr -a cc 'claude -c'
abbr -a cr 'claude -r'
alias cot='open -a coteditor'
alias python='python3'
alias pip='uv pip'
abbr -a p python
alias bu='brew upgrade'
alias bcs='brew cleanup -s'
function purge
    sudo purge
end
alias mem='top -l 1 -s 0 | grep PhysMem'
alias weather="curl 'wttr.in/Tokyo?lang=ja'"

# git alias
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -D'
alias gbm="git branch --merged | grep -vE '^\*|main|master|develop'"
alias gbdm="git branch --merged | grep -vE '^\*|main|master|develop' | xargs -r git branch -d"
alias gcm='git commit -m'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gd='git diff'
alias gpull='git pull'
alias gpush='git push'
alias glog="git log --graph --date=iso --pretty='[%ad]%C(auto) %h%d %Cgreen%an%Creset : %s'"
function gmain
    git checkout main
    and git pull
    and gbdm
end
alias gll="git log --pretty=format:'%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]' --decorate --numstat"

command -q gh; and gh completion -s fish | source

alias nrb='npm run build'
alias nrd='npm run dev'

set -g fish_greeting
set -gx HOMEBREW_NO_ENV_HINTS TRUE

# Go
set -gx GOPATH $HOME/go

# AWS
set -gx AWS_DEFAULT_PROFILE dev

# pyenv
set -gx PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin
pyenv init - fish | source

# fzf (peco から移行)
set -gx GHQ_SELECTOR fzf

set -gx LDFLAGS "-L/opt/homebrew/opt/icu4c/lib -L/opt/homebrew/opt/openssl@3/lib -L/opt/homebrew/opt/readline/lib"
set -gx CPPFLAGS "-I/opt/homebrew/opt/icu4c/include -I/opt/homebrew/opt/openssl@3/include -I/opt/homebrew/opt/readline/include"
set -gx PKG_CONFIG_PATH "/opt/homebrew/opt/icu4c/lib/pkgconfig:/opt/homebrew/opt/openssl@3/lib/pkgconfig:/opt/homebrew/opt/readline/lib/pkgconfig"

fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin
fish_add_path $GOPATH/bin
fish_add_path /opt/homebrew/opt/openssl@3/bin
fish_add_path ~/.local/bin

# npx -> bun
alias ccusage="bunx --bun ccusage@latest"
alias ncu="bunx --bun npm-check-updates"
alias npx="bunx --bun"
function difit
    bunx --bun difit (git log --oneline --decorate | fzf --prompt 'COMMIT > ' | string split ' ' --)[1]
end

fzf --fish | source
zoxide init fish | source

