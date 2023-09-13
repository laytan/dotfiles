export ZSH="$HOME/.oh-my-zsh"
export NVM_DIR="$HOME/.nvm"

# Directory of this file.
dir=$0:A:h

# Gitignored local configuration.
[ -f "$dir/.zshrc_local" ] && . "$dir/.zshrc_local"

ZSH_THEME="amuse"

plugins=(git zsh-autosuggestions autojump)

. $ZSH/oh-my-zsh.sh

alias disable-full-group-by="echo \"SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));\" | mysql -uroot -proot"
alias grum="vendor/bin/grumphp run"
alias drupal="vendor/bin/drupal"
alias drush="vendor/bin/drush"
alias sail="vendor/bin/sail"
alias cat="bat"

alias update-nvim-stable='asdf uninstall neovim stable && asdf install neovim stable'
alias update-nvim-nightly='asdf uninstall neovim nightly && asdf install neovim nightly'
alias update-nvim-master='asdf uninstall neovim ref:master && asdf install neovim ref:master'

[ -f /usr/local/etc/profile.d/autojump.sh ]        && . "/usr/local/etc/profile.d/autojump.sh"
# NVM
[ -s "$NVM_DIR/nvm.sh" ]                           && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ]                  && . "$NVM_DIR/bash_completion"
# Google cloud SDK
[ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]       && . "$HOME/google-cloud-sdk/path.zsh.inc"
[ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ] && . "$HOME/google-cloud-sdk/completion.zsh.inc"
[ -f "/opt/homebrew/opt/asdf/libexec/asdf.sh" ]    && . "/opt/homebrew/opt/asdf/libexec/asdf.sh"
[ -f "$HOME/.fzf.zsh" ]                            && . "$HOME/.fzf.zsh"
[ -f "$HOME/.opam/opam-init/init.zsh" ]            && . "$HOME/.opam/opam-init/init.zsh"

[ -x "$(which thefuck)" ]                          && eval $(thefuck --alias)
[ -x "$(which jira)" ]                             && jira completion zsh > "${fpath[1]}/_jira"

autoload -U compinit; compinit

bindkey -v
