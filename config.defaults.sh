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
export _SUDO=$SUDO_DEFAULT
 
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
export _INSTALL_Z=YES
export _INSTALL_COMPOSER=YES
export _INSTALL_PHP=YES
export _INSTALL_BREW=YES
export _REINSTALL_BREW=NO
export _INSTALL_NODE=YES
export _INSTALL_PKG_CONFIG=YES
export _INSTALL_WGET=YES
export _INSTALL_HTTPIE=YES
export _INSTALL_NCDU=YES
export _INSTALL_HUB=YES
export _INSTALL_ACK=YES
export _INSTALL_DOCTL=YES
export _INSTALL_IMAGE_MAGICK=YES
export _INSTALL_IMAGIC=YES
export _INSTALL_MEMCACHED=YES
export _INSTALL_REDIS=YES
export _INSTALL_QUICKLOOK_PLUGINS=YES
export _INSTALL_AUTOCONF=YES
export _INSTALL_PEAR=YES
export _INSTALL_XCODE_SELECT=YES
export _INSTALL_PHP_XDEBUG=YES
export _INSTALL_PHP_REDIS=YES
export _INSTALL_PHP_IMAGICK=YES
export _INSTALL_POSTGRESQL=YES
export _INSTALL_LARAVEL_ENVOY=YES
export _INSTALL_LARAVEL_VALET=YES
export _INSTALL_SPATIE_PHPUNIT_WATCHER=NOv
export _INSTALL_SPATIE_MIXED_CONTENT_SCANNER=NO
export _INSTALL_MYSQL=YES
export _INSTALL_YARN=YES
export _INSTALL_GHOSTSCRIPT=YES
export _INSTALL_ZSH_AUTOSUGGESTIONS=YES
export _INSTALL_JOE=YES
export _INSTALL_NGINX=YES
export _INSTALL_DNSMASQ=YES
export _INSTALL_PRETTIER=YES
