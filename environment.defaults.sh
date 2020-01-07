#!/bin/bash

# Create a environment.sh file to override the defaults containing in this file.

# --- mandatory variables
# The variables below must be created manually or set in your environment.sh file
# 
# export ___HOSTNAME___=
# export ___USERNAME___=
# export ___USERGROUP___=
# export ___NAME___=
# export ___EMAIL___=
# export ___MYSQL_NAME___=mariadb
# export ___MYSQL_VERSION___=10.3
# export ___GITHUB_TOKEN___=
# ---

# DO NOT CHANGE / OR UPDATE OTHER REFERENCES
export _DOTFILES_ROOT=$HOME/.dotfiles

# You are free to change those
export _SUDO_DEFAULT=""
export _SUDO=$_SUDO_DEFAULT
 
export _OUTPUT_FILE=/tmp/__installer_output.txt
export _ERROR_FILE=/tmp/__installer_error.txt

export _COMPOSER_EXECUTABLE=/usr/local/bin/composer
export _COMPOSER_HOME=$HOME/.composer
export _COMPOSER_BIN=$COMPOSER_HOME/vendor/bin

export _BREW_EXECUTABLE=/usr/local/bin/brew
export _BREW_REINSTALL_ALL_PACKAGES=NO

export _XDEBUG_IDE_KEY=PHPSTORM

export _INSTALL_HUSHLOGIN=YES
export _INSTALL_OHMYZSH=YES
export _INSTALL_VIM_PREFS=YES
export _INSTALL_YARN_PREFS=YES
export _INSTALL_MACKUP=YES
export _INSTALL_OHMYZSH_THEMES=YES
export _INSTALL_COMPOSER=YES
export _INSTALL_PHP=YES
export _INSTALL_BREW=YES
export _REINSTALL_BREW=NO
export _INSTALL_QUICKLOOK_PLUGINS=YES
export _INSTALL_PEAR=YES
export _INSTALL_XCODE_SELECT=YES
export _INSTALL_POSTGRESQL=YES
export _INSTALL_LARAVEL_VALET=YES
export _INSTALL_MYSQL=YES
export _INSTALL_ZSH_AUTOSUGGESTIONS=YES
export _INSTALL_POWERLINE_FONTS=YES

export _INSTALL_COMPOSER_PACKAGES=YES
export _INSTALL_BREW_PACKAGES=YES
export _INSTALL_BREW_CASK_PACKAGES=YES
export _INSTALL_NPM_PACKAGES=YES
export _INSTALL_PECL_PACKAGES=YES

# Hide username in prompt
DEFAULT_USER=`whoami`

export PATH="$PATH:$HOME/.rvm/bin"

NPM_PACKAGES="${HOME}/.npm-packages"
export PATH="$NPM_PACKAGES/bin:$PATH"

# Sudoless npm https://github.com/sindresorhus/guides/blob/master/npm-global-without-sudo.md
# Unset manpath so we can inherit from /etc/manpath via the `manpath`
# command
unset MANPATH # delete if you already modified MANPATH elsewhere in your config
export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

export PATH=$HOME/.dotfiles/bin:$PATH

# Setup xdebug
export XDEBUG_CONFIG="idekey=$_XDEBUG_IDE_KEY"

# Extra paths
export PATH=Users/$DEFAULT_USER/.rvm/gems/ruby-2.1.2/bin:$PATH
export PATH="$HOME/.composer/vendor/bin:$PATH"
export PATH=/usr/local/bin:$PATH
export PATH="$HOME/.yarn/bin:$PATH"
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"
export PATH="/usr/local/opt/node@8/bin:$PATH"
