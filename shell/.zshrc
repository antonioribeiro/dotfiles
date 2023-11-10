# Path to your oh-my-zsh configuration.

echo "Loading .zhrc..."

source $HOME/.dotfiles/environment.defaults.sh
source $HOME/.dotfiles/environment.sh
source $HOME/.dotfiles/.exports

ZSH=$HOME/.oh-my-zsh

ZSH_CUSTOM=$_DOTFILES_ROOT/misc/oh-my-zsh-custom

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="agnoster"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git laravel5 composer z)

source $ZSH/oh-my-zsh.sh

# Enable autosuggestions
source /System/Volumes/Data/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

#set numeric keys
# 0 . Enter
bindkey -s "^[Op" "0"
bindkey -s "^[Ol" "."
bindkey -s "^[OM" "^M"
# 1 2 3
bindkey -s "^[Oq" "1"
bindkey -s "^[Or" "2"
bindkey -s "^[Os" "3"
# 4 5 6
bindkey -s "^[Ot" "4"
bindkey -s "^[Ou" "5"
bindkey -s "^[Ov" "6"
# 7 8 9
bindkey -s "^[Ow" "7"
bindkey -s "^[Ox" "8"
bindkey -s "^[Oy" "9"
# + -  * /
bindkey -s "^[Ok" "+"
bindkey -s "^[Om" "-"
bindkey -s "^[Oj" "*"
bindkey -s "^[Oo" "/"

# Load the shell dotfiles, and then some:
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.dotfiles/shell/.{exports,aliases,functions}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file"
done

for file in ~/.dotfiles-custom/shell/.{exports,aliases,functions,zshrc}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

# Load rvm
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" 

# source /opt/homebrew/etc/profile.d/z.sh

# Alias hub to git
eval "$(hub alias -s)"

# Import ssh keys in keychain
ssh-add -A 2>/dev/null;

PERL5LIB="/Users/antonioribeiro/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/antonioribeiro/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/antonioribeiro/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/antonioribeiro/perl5"; export PERL_MM_OPT;
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

export COMPOSER_MEMORY_LIMIT=-1

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

export ARTISAN_OPEN_ON_MAKE_EDITOR='open -na "PhpStorm.app" '

## Stop Adobe Cloud from restarting after reboot
## launchctl unload -w {,~}/Library/LaunchAgents/com.adobe.*.plist -- this is not working

## mkdir -p /usr/local/bin
## ln -sf /System/Volumes/Data/opt/homebrew/bin/php /usr/local/bin/php --- NEEDS TO BE ROOT?
## ln -sf /System/Volumes/Data/opt/homebrew/bin/node /usr/local/bin/node

mkdir -p ~/.nvm

## zplug
export ZPLUG_HOME=$(brew --prefix)/opt/zplug
source $ZPLUG_HOME/init.zsh
zplug "lib/*",   from:oh-my-zsh


zstyle ':completion:*' menu select

#Fix PostgreSQL for Laravel Valet
PGGSSENCMODE=disable


