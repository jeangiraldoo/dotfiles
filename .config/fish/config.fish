if not status is-interactive
	return
end

fish_vi_key_bindings

set -U fish_greeting ""
set -Ux EDITOR nvim

alias G=lazygit
alias ls="eza --all --icons=always"
alias grep="grep --line-number --colour=always"
alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'

abbr dots "cd ~/.config"
abbr sudo!! 'eval sudo $history[1]'

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

starship init fish | source
zoxide init fish --cmd cd | source
