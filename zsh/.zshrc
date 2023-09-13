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
[ -x "$(which bat)" ] && alias cat="bat"

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

export PROMPT="
%{$fg_bold[green]%}%~%{$reset_color%}$(git_prompt_info)%F{red}%(?..%B exit code %?% %b)%{$reset_color%}
$ "

function preexec() {
  timer=$(($(print -P %D{%s%6.})/1000))
}

function precmd() {
  if [ $timer ]; then
    now=$(($(print -P %D{%s%6.})/1000))
    elapsed=$(($now-$timer))

    export RPROMPT="%{$fg[black]%}$(format_duration elapsed)%{$reset_color%}"
    unset timer
  fi
}

# Function to format milliseconds into larger units
format_duration() {
    local duration_in_ms=$1

    # Define the conversion factors
    local ms_per_second=1000
    local seconds_per_minute=60
    local minutes_per_hour=60
    local hours_per_day=24

    # Calculate the values for each unit
    local days=$((duration_in_ms / (ms_per_second * seconds_per_minute * minutes_per_hour * hours_per_day)))
    local hours=$((duration_in_ms / (ms_per_second * seconds_per_minute * minutes_per_hour) % hours_per_day))
    local minutes=$((duration_in_ms / (ms_per_second * seconds_per_minute) % minutes_per_hour))
    local seconds=$((duration_in_ms / ms_per_second % seconds_per_minute))
    local milliseconds=$((duration_in_ms % ms_per_second))

    # Format and display the duration
    local formatted_duration=""
    
    if [[ $days -gt 0 ]]; then
        formatted_duration="${days}d"
    fi
    
    if [[ $hours -gt 0 ]]; then
        formatted_duration="${formatted_duration}${hours}h"
    fi
    
    if [[ $minutes -gt 0 ]]; then
        formatted_duration="${formatted_duration}${minutes}m"
    fi
    
    if [[ $seconds -gt 0 ]]; then
        formatted_duration="${formatted_duration}${seconds}"
        if [[ $milliseconds -gt 0 ]]; then
            formatted_duration="${formatted_duration}."
        else
            formatted_duration="${formatted_duration}s"
        fi
    fi
    
    if [[ $milliseconds -gt 0 ]]; then
        if [[ $seconds -gt 0 ]]; then
            formatted_duration="${formatted_duration}${milliseconds}s"
        else
            formatted_duration="${formatted_duration}${milliseconds}ms"
        fi
    fi

    echo $formatted_duration
}
