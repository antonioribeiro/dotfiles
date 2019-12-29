#!/bin/bash

#---
# Keep this file clean to avoid genral failures
#---

function install
{
    check_variables

    configure_macos 

    configure_git

    install_homebrew

    install_hushlogin

    install_ohmyzsh

    install_global_gitignore

    install_zsh_prefs

    install_vim_prefs

    install_yarn_prefs

    # install_ohmyzsh_themes ### looks line this one is not working anymore

    install_powerline_fonts ### looks like the current fix for oh my zsh fonts
    
    install_z

    install_php

    install_composer

    install_node

    install_pkg_config

    install_wget 

    install_httpie

    install_ncdu

    install_hub
    
    install_ack
    
    install_doctl
    
    install_imagemagick

    install_memcached
    
    install_redis

    install_postgresql

    install_mysql

    install_yarn

    install_ghostscript

    install_mackup

    install_zsh_autosuggestions
    
    install_quicklook_plugins

    install_autoconf

    install_xcode_select

    install_php_pear

    install_joe

    install_nginx

    install_dnsmasq

    install_laravel_valet

    install_prettier

    install_composer_packages

    install_brew_packages

    install_npm_packages

    install_pecl_packages

    fix_file_permissions

    display_instructions    
}


function configure_environment()
{
    source config.defaults.sh
    check_errors; [ "$_FATAL_ERROR" = "YES" ] && return 0

    source helpers.sh
    check_errors; [ "$_FATAL_ERROR" = "YES" ] && return 0

    source installers.sh
    check_errors; [ "$_FATAL_ERROR" = "YES" ] && return 0

    source shell/.aliases
    check_errors; [ "$_FATAL_ERROR" = "YES" ] && return 0

    [ "$_FATAL_ERROR" = "YES" ] && return 0    
    load_installable_packages

    # overrides
    source config.sh 2>/dev/null
}


function check_errors() 
{    
    if [ $? -ne 0 ]
    then
        echo

        echo_error "=== COMMAND EXECUTION FAILED ==="

        FATAL_ERROR=YES
    fi  
}


function display_errors()
{
    [ "$FATAL_ERROR" != "YES" ] && return 0

    echo "------------------------------------ COMMAND:"

    echo $_COMMAND

    echo "------------------------------------ OUTPUT:"

    cat $_OUTPUT_FILE

    echo "------------------------------------ ERROR:"

    cat $_ERROR_FILE

    tput bold
    tput setaf 1

    echo "=== CHECK ERROR LOG ABOVE ==="

    tput sgr0
}

