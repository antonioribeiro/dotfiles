#!/bin/bash

# Create a config.sh file to override the defaults containing in this file.

# The variables below should be created manually or set in your config.sh file
# 
# export ___HOSTNAME___=
# export ___USERNAME___=
# export ___USERGROUP___=
# export ___NAME___=
# export ___EMAIL___=
# 

export _DOTFILES_ROOT=$HOME/.dotfiles
export _SUDO_DEFAULT=""
export _SUDO=$_SUDO_DEFAULT
 
export _OUTPUT_FILE=/tmp/__installer_output.txt
export _ERROR_FILE=/tmp/__installer_error.txt

export _COMPOSER_EXECUTABLE=/usr/local/bin/composer
export _COMPOSER_HOME=$HOME/.composer
export _COMPOSER_BIN=$COMPOSER_HOME/vendor/bin

export _BREW_EXECUTABLE=/usr/local/bin/brew
export _BREW_REINSTALL_ALL_PACKAGES=NO

export _INSTALL_HUSHLOGIN=YES
export _INSTALL_OHMYZSH=YES
export _INSTALL_ZSH_PREFS=YES
export _INSTALL_VIM_PREFS=YES
export _INSTALL_YARN_PREFS=YES
export _INSTALL_MACKUP=YES
export _INSTALL_OHMYZSH_THEMES=YES
export _INSTALL_COMPOSER=YES
export _INSTALL_PHP=YES
export _INSTALL_BREW=YES
export _REINSTALL_BREW=NO
export _INSTALL_PHP_IMAGICK=YES
export _INSTALL_QUICKLOOK_PLUGINS=YES
export _INSTALL_PEAR=YES
export _INSTALL_XCODE_SELECT=YES
export _INSTALL_PHP_XDEBUG=YES
export _INSTALL_PHP_REDIS=YES
export _INSTALL_PHP_IMAGICK=YES
export _INSTALL_POSTGRESQL=YES
export _INSTALL_LARAVEL_VALET=YES
export _INSTALL_MYSQL=YES
export _INSTALL_ZSH_AUTOSUGGESTIONS=YES

export _INSTALL_COMPOSER_PACKAGES=YES
export _INSTALL_BREW_PACKAGES=YES
export _INSTALL_NPM_PACKAGES=YES