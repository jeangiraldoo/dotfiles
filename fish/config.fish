if not status is-interactive
	return
end

# Environment variables
set -Ux EDITOR nvim
set -U fish_greeting ""
set -g fish_key_bindings fish_vi_key_bindings

# Aliases
alias G=lazygit
alias e=$EDITOR
alias E=vim
alias ls="eza --all --icons=always"
alias grep="grep --line-number --colour=always"

# Abbreviations
abbr dots "cd ~/.config"
abbr g git

# Vi mode
fish_vi_key_bindings

# Initializations
starship init fish | source
zoxide init fish --cmd cd | source
