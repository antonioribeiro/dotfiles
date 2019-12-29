#!/bin/bash

function execute() 
{
    [ "$FATAL_ERROR" = "YES" ] && return 0

    clear_output_files

    fix_file_permissions

    _COMMAND=$@

    echo_comment "> $_COMMAND"             

    eval $_SUDO $_COMMAND > $_OUTPUT_FILE 2> $_ERROR_FILE

    checkErrors
    
    _SUDO=$SUDO_DEFAULT

    [ "$FATAL_ERROR" = "YES" ] && return 0

    echo_done
}


function execute_sudo() 
{
    _SUDO=sudo

    execute $@
}


function clear_output_files() 
{
    if [ -f "$_OUTPUT_FILE" ] 
    then
        rm $_OUTPUT_FILE
    fi

    if [ -f "$_ERROR_FILE" ] 
    then
        rm $_ERROR_FILE
    fi
}


function checkErrors() 
{    
    if [ $? -ne 0 ]
    then
        echo

        echo_error "=== COMMAND EXECUTION FAILED ==="

        FATAL_ERROR=YES
    fi  
}


function strlen() 
{
    IFS=''; a=$*;

    _LENGTH=${#a}
}


function header()
{   
    echo $@

    line $@
}


function line() 
{   
    strlen $@

    for ((i=1; i<=$_LENGTH; i++)); do printf "-"; done  

    echo
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
}


function echo_error() 
{
    tput bold
    tput setaf 1

    echo $1

    tput sgr0
}


function echo_info() 
{
    tput bold
    tput setaf 6

    echo $1

    tput sgr0
}


function echo_success() 
{
    tput bold
    tput setaf 2

    echo $1

    tput sgr0
}


function echo_comment() 
{
    tput bold
    tput setaf 3

    echo $1

    tput sgr0
}


function echo_done() 
{
    echo_success "DONE"
    echo
}


function delete_if_exists()
{
    _FILE_NAME=$1
    _SHOW_MESSAGES=$2

    if [ "$_SHOW_MESSAGES" = "" ]
    then
        _SHOW_MESSAGES=YES
    fi    

    if [ "$_FILE_NAME" = "" ] || [ "$_FILE_NAME" = "." ] || [ "$_FILE_NAME" = ".." ] || [ "$_FILE_NAME" = "/" ]
    then
        FATAL_ERROR=YES

        if [ "$_SHOW_MESSAGES" = "YES" ]
        then
            echo_error "WRONG FILE NAME OR DIRECTORY"
        fi
    fi

    if [ -f "$_FILE_NAME" ] 
    then
        if [ "$_SHOW_MESSAGES" = "YES" ]
        then
            echo_info "Deleting FILE $_FILE_NAME..."
        fi        

        execute rm $_FILE_NAME
    fi

    if [ -L "$_FILE_NAME" ] 
    then
        if [ "$_SHOW_MESSAGES" = "YES" ]
        then
            echo_info "Deleting LINK $_FILE_NAME..."
        fi        

        execute rm $_FILE_NAME
    fi

    if [ -d "$_FILE_NAME" ] 
    then
        if [ "$_SHOW_MESSAGES" = "YES" ]
        then
            echo_info "Deleting DIRECTORY $_FILE_NAME..."
        fi        

        execute rm -rf $_FILE_NAME
    fi
}


function brew_install()
{
    [ "$FATAL_ERROR" = "YES" ] && return 0

    echo_info "Installing $1..."
     
    if brew ls --versions $1 > /dev/null
    then
        echo_success "Package '$1' is already installed."

        _SUBCOMMAND=reinstall

        if [ "$_BREW_REINSTALL_ALL_PACKAGES" != "YES" ] 
        then 
            echo

            return 0
        fi
    else
        _SUBCOMMAND=install
    fi

    execute brew $_SUBCOMMAND $1
}


function php_exec()
{
    [ "$FATAL_ERROR" = "YES" ] && return 0

    _COMMAND=$@

    echo_comment '> php -r "'$_COMMAND'"'             

    php -r "$_COMMAND" > $_OUTPUT_FILE 2> $_ERROR_FILE
    
    checkErrors
}


function pecl_install()
{
    [ "$FATAL_ERROR" = "YES" ] && return 0

    _PACKAGE=$1

    _INSTALLED=`pecl list | grep $_PACKAGE`

    echo_info "Installing $_PACKAGE..."

    if [ "$_INSTALLED" != "" ]
    then
        echo_success "Package $_PACKAGE is already installed."

        return 0
    fi

    echo_comment "> sudo pecl install $_PACKAGE"
    
    printf "\n" | sudo pecl install $_PACKAGE > $_OUTPUT_FILE 2> $_ERROR_FILE

    checkErrors    

    [ "$FATAL_ERROR" = "YES" ] && return 0

    echo_done
}


function composer_install()
{
    [ "$FATAL_ERROR" = "YES" ] && return 0

    _PACKAGE=$1

    if [ -d "$_COMPOSER_HOME/vendor/$_PACKAGE" ]
    then
        echo_success "Package $_PACKAGE is already installed."

        return 0
    fi

    echo_info "Installing $_PACKAGE using Composer..."

    execute composer global require $_PACKAGE
}


function check_variables()
{
    names=(___HOSTNAME___ ___USERNAME___ ___USERGROUP___ ___NAME___ ___EMAIL___)
    
    for _VAR_NAME in "${names[@]}"
    do
        _VAR_NAME="${_VAR_NAME}"
        _VALUE=${!_VAR_NAME}

        if [ "$_VALUE" = "" ]
        then
            echo_error "The variable '$_VAR_NAME' was not set. Please check the config.dewfaults.sh file."

            FATAL_ERROR=YES
        fi            
    done
}


function add_composer_to_path()
{
    export PATH="$_COMPOSER_BIN:$PATH"
}


function npm_install()
{
    [ "$FATAL_ERROR" = "YES" ] && return 0

    _PACKAGE=$1

    _INSTALLED=`npm list --global | grep $_PACKAGE@`

    echo_info "Installing $_PACKAGE using npm..."

    if [ "$_INSTALLED" != "" ]
    then
        echo_success "Package $_PACKAGE is already installed."

        return 0
    fi

    execute npm install --global $_PACKAGE
}


function fix_file_permissions() 
{
    sudo chown -R $___USERNAME___:$___USERGROUP___ $HOME/.config
}