#!/bin/bash

function execute() 
{
    [ "$FATAL_ERROR" = "YES" ] && return 0

    clear_output_files

    _COMMAND=$@

    echo_comment "> $_COMMAND"             

    eval $_SUDO $_COMMAND > $_OUTPUT_FILE 2> $_ERROR_FILE

    check_errors
    
    _SUDO=$_SUDO_DEFAULT

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
        echo "" > $_OUTPUT_FILE
    fi

    if [ -f "$_ERROR_FILE" ] 
    then
        echo "" > $_ERROR_FILE
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

    echo_error "=== CHECK ERROR LOG ABOVE ==="
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


function echo_warning() 
{
    tput bold
    tput setaf 5

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


function update_homebrew() 
{
    [ "$_FATAL_ERROR" = "YES" ] && return 0

    [ "$_HOMEBREW_WAS_UPATED" = "YES" ] && return 0

    echo_comment "Updating Homebrew..."

    brew update > $_OUTPUT_FILE 2> $_ERROR_FILE

    check_errors

    [ "$_FATAL_ERROR" = "YES" ] && return 0

    _HOMEBREW_WAS_UPATED=YES
    
    echo_done
}


function update_composer() 
{
    [ "$_FATAL_ERROR" = "YES" ] && return 0

    [ "$_COMPOSER_WAS_UPATED" = "YES" ] && return 0

    echo_comment "Updating Composer..."

    composer self-update

    check_errors

    [ "$_FATAL_ERROR" = "YES" ] && return 0

    _COMPOSER_WAS_UPATED=YES
}


function brew_install()
{
    [ "$FATAL_ERROR" = "YES" ] && return 0

    update_homebrew

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
    
    check_errors
}


function pecl_install()
{
    [ "$FATAL_ERROR" = "YES" ] && return 0

    _PACKAGE=$1

    _INSTALLED=`pecl list | grep $_PACKAGE`

    echo_info "Installing PHP extension: $_PACKAGE..."

    if [ "$_INSTALLED" != "" ]
    then
        echo_success "Package $_PACKAGE is already installed."

        return 0
    fi

    echo_comment "> sudo pecl install $_PACKAGE"
    
    printf "\n" | sudo pecl install $_PACKAGE > $_OUTPUT_FILE 2> $_ERROR_FILE

    check_errors    

    [ "$FATAL_ERROR" = "YES" ] && return 0

    echo_done
}


function composer_install()
{
    [ "$FATAL_ERROR" = "YES" ] && return 0

    update_composer

    _PACKAGE=$1

    echo_info "Installing $_PACKAGE using Composer..."

    if [ -d "$_COMPOSER_HOME/vendor/$_PACKAGE" ]
    then
        echo_success "Package $_PACKAGE is already installed."

        echo

        return 0
    fi

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

        echo

        return 0
    fi

    execute npm install --global $_PACKAGE
}


function fix_file_permissions() 
{
    echo_comment "We now need to use sudo to fix some file permissions, please provide your password:"

    sudo chown -R $___USERNAME___:$___USERGROUP___ $HOME/.config
}


function load_file_to_array()
{
    _DEFAULTS=$1
    
    _OVERRIDE=$2

    _VARIABLE=$3

    if [ -f "$_OVERRIDE" ]
    then
        _FILE="$_OVERRIDE"
    else
        _FILE="$_DEFAULTS"
    fi

    ___ARRAY="EMPTY"

    IFS=$'\n' read -d '' -r -a ___ARRAY < $_FILE

    if [ "$___ARRAY" = "EMPTY" ]
    then
      FATAL_ERROR=YES 

      echo "ERROR LOADING FILE $_FILE" > $_OUTPUT_FILE
    fi

    eval "$_VARIABLE=(${___ARRAY[@]})"
}


function load_installable_packages()
{
    [ "$FATAL_ERROR" = "YES" ] && return 0

    load_file_to_array .composer_packages.defaults .composer_packages _COMPOSER_PACKAGES_TO_INSTALL

    [ "$FATAL_ERROR" = "YES" ] && return 0
    
    load_file_to_array .brew_packages.defaults .brew_packages _BREW_PACKAGES_TO_INSTALL

    [ "$FATAL_ERROR" = "YES" ] && return 0
    
    load_file_to_array .npm_packages.defaults .npm_packages _NPM_PACKAGES_TO_INSTALL
}

function install_all_packages()
{
    _ENABLED=$1

    [ "$_ENABLED" != "YES" ] && return 0

    [ "$_FATAL_ERROR" = "YES" ] && return 0

    _NAME=$2

    _FILE=$3

    _EXECUTABLE=$4

    load_file_to_array $_FILE.defaults $_FILE _PACKAGES

    echo_warning "Installing all $_NAME packages..."

    for _PACKAGE in "${_PACKAGES[@]}"
    do
        $_EXECUTABLE $_PACKAGE

        [ "$_FATAL_ERROR" = "YES" ] && return 0
    done
}

