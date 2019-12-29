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

    install_vim_prefs

    install_yarn_prefs

    # install_ohmyzsh_themes ### looks line this one is not working anymore

    install_powerline_fonts ### looks like the current fix for oh my zsh fonts
    
    install_php

    install_composer

    install_postgresql

    install_mysql

    install_yarn

    install_ghostscript

    install_mackup

    install_zsh_autosuggestions
    
    install_xcode_select

    install_php_pear

    install_laravel_valet

    install_composer_packages

    install_brew_packages

    install_brew_cask_packages

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

        set_error "=== COMMAND EXECUTION FAILED ==="
    fi  
}


function display_errors()
{
    [ "$_FATAL_ERROR" != "YES" ] && return 0

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

function set_error()
{
    _MESSAGE=$1

    if [ "$_FATAL_ERROR_MESSAGE_GIVEN" != "YES" ]
    then
        if [ "$_MESSAGE" = "" ]
        then
            _MESSAGE="A FATAL ERROR OCURRED"
        fi

        tput bold
        tput setaf 1

        echo "=== $_MESSAGE ==="

        tput sgr0

        _FATAL_ERROR_MESSAGE_GIVEN=YES
    fi    

    _FATAL_ERROR=YES
}