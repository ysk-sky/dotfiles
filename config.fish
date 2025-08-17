# viでもvimで開く
alias vi='/usr/bin/vim'

# fish設定変更スニペット
abbr -a vc vim ~/.config/fish/config.fish
abbr -a sc source ~/.config/fish/config.fish

## How to install EZA -> https://github.com/eza-community/eza/blob/main/INSTALL.md
if command -q eza
	abbr -a ls eza --icons
    abbr -a ll eza --icons -lhg --time-style long-iso
    abbr -a la eza --icons -lhag --time-style long-iso
    abbr -a lt eza --icons --tree
end

## Useful common command snippets
abbr -a head head -n5
abbr -a tail tail -n5
abbr -a c clear
abbr -a t htop  # htop is a modern replacement of top
abbr -a wc wc -l
abbr -a h "history | grep"
abbr -a sed --set-cursor "sed 's/%//g'"
abbr -a awk --set-cursor "awk -F, '{print \$1%}'"
abbr -a cnt "awk -F, '{cnt[\$1]++}END{for(i in cnt)print i,cnt[i]}'"
abbr -a unq "awk -F, '{cnt[\$1]++}END{for(i in cnt)print i}'"
abbr -a header --set-cursor "head -n1 % | awk -F, '{for(i=1;i<=NF;i++)print i,\$i}' | column -t"
## Useful git command snippets
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -D'
alias gcm='git commit -m'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gd='git diff'
alias glog="git log --graph --date=iso --pretty='[%ad]%C(auto) %h%d %Cgreen%an%Creset : %s'"
alias gll="git log --pretty=format:'%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]' --decorate --numstat"

alias pip='uv pip'

# function fish_user_key_bindings
#   bind \cr 'peco_select_history (commandline -b)' # Bind for prco history to Ctrl+r
#   bind \c] peco_change_directory # Bind for prco change directory to Ctrl+]
# end

# function cd
#     if test (count $argv) -eq 0
#         return 0
#     else if test (count $argv) -gt 1
#         printf "%s\n" (_ "Too many args for cd command")
#         return 1
#     end
#     # Avoid set completions.
#     set -l previous $PWD

#     if test "$argv" = "-"
#         if test "$__fish_cd_direction" = "next"
#             nextd
#         else
#             prevd
#         end
#         return $status
#     end
#     builtin cd $argv
#     set -l cd_status $status
#     # Log history
#     if test $cd_status -eq 0 -a "$PWD" != "$previous"
#         set -q dirprev[$MAX_DIR_HIST]
#         and set -e dirprev[1]
#         set -g dirprev $dirprev $previous
#         set -e dirnext
#         set -g __fish_cd_direction prev
#     end

#     if test $cd_status -ne 0
#         return 1
#     end
#     ls
#     return $status
# end

## For TypeScript/JavaScript PJ
alias nrb='npm run build'
alias nrd='npm run dev'

## npx (modify to use bun)
alias ccusage="bunx --bun ccusage@latest"
alias ncu="bunx --bun npm-check-updates"
alias npx="bunx --bun"
alias difit="bunx --bun difit (git log --oneline --decorate | peco --prompt 'COMMIT >' | string split ' ' --)[1]"


##for Mac
# alias bu='brew upgrade'
# alias bcs='brew cleanup -s'
# function purge
	#sudo purge
	#rm -rf /Users/yusuke/Library/Caches/Google/
# 	du -sx / &> /dev/null &; sleep 5; kill $last_pid
# end
# alias mem='top -l 1 -s 0 | grep PhysMem'
## rmでゴミ箱に入れる
#alias rm='rmtrash'