#!/bin/bash

function install_homebrew() 
{
    [ "$_FATAL_ERROR" = "YES" ] && return 0

    [ "$_INSTALL_BREW" != "YES" ] && return 0

    echo_info 'Installing homebrew...'

    _BREW=`command -v brew`

    if [ $_BREW != "" ]
    then 
        echo_success "Homebrew is already installed."

        [ "$_REINSTALL_BREW" != "YES" ] && return 0

        echo_info "Reinstalling brew..."
        
        echo_info "Removing brew old files..."

        sudo_warning "Reinstalling brew"

        sudo rm -rf /usr/local/Cellar /usr/local/.git && brew cleanup

        check_errors

        [ "$_FATAL_ERROR" = "YES" ] && return 0
    fi

    echo_comment "> ruby install brew"

    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

    check_errors; [ "$_FATAL_ERROR" = "YES" ] && return 0

    echo_done
}


function install_hushlogin()
{
   [ "$_FATAL_ERROR" = "YES" ] && return 0

   [ "$_INSTALL_HUSHLOGIN" != "YES" ] && return 0

    echo_info 'Configuring hushlogin...'

    # Hide "last login" line when starting a new terminal session
    execute touch $HOME/.hushlogin
}


function install_ohmyzsh()
{
    [ "$_FATAL_ERROR" = "YES" ] && return 0

    [ "$_INSTALL_OHMYZSH" != "YES" ] && return 0

    echo_info 'Clearing oh-my-zsh directory...'

    execute rm -rf $HOME/.oh-my-zsh

    [ "$_FATAL_ERROR" = "YES" ] && return 0

    echo_info 'Installing oh-my-zsh...'

    curl -L https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh > $_OUTPUT_FILE 2> $_ERROR_FILE

    check_errors; [ "$_FATAL_ERROR" = "YES" ] && return 0

    echo_done

    install_zsh_prefs
}


function install_global_gitignore()
{
    [ "$_INSTALL_HUSHLOGIN" != "YES" ] && return 0

    [ "$_FATAL_ERROR" = "YES" ] && return 0

    # Add global gitignore

    delete_if_exists $HOME/.global-gitignore

    [ "$_FATAL_ERROR" = "YES" ] && return 0

    echo_info 'Linking global-gitignore...'

    execute ln -s $_DOTFILES_ROOT/shell/.global-gitignore $HOME/.global-gitignore

    [ "$_FATAL_ERROR" = "YES" ] && return 0

    echo_info "Configuring git global-gitignore..."

    execute git config --global core.excludesfile $HOME/.global-gitignore
}


function install_zsh_prefs() 
{
    [ "$_FATAL_ERROR" = "YES" ] && return 0

    delete_if_exists $HOME/.zshrc

    [ "$_FATAL_ERROR" = "YES" ] && return 0

    # Symlink zsh prefs

    echo_info 'Creating .zsrc link...'

    echo _DOTFILES_ROOT=$_DOTFILES_ROOT

    execute ln -s $_DOTFILES_ROOT/shell/.zshrc $HOME/.zshrc
}


function install_vim_prefs() 
{
    [ "$_FATAL_ERROR" = "YES" ] && return 0

    [ "$_INSTALL_VIM_PREFS" != "YES" ] && return 0

    # Symlink vim prefs

    delete_if_exists $HOME/.vimrc

    [ "$_FATAL_ERROR" = "YES" ] && return 0

    echo_info 'Creating .vimrc link...'

    execute ln -s $_DOTFILES_ROOT/shell/.vimrc $HOME/.vimrc

    [ "$_FATAL_ERROR" = "YES" ] && return 0


    delete_if_exists $HOME/.vim

    [ "$_FATAL_ERROR" = "YES" ] && return 0

    echo_info 'Creating .vim link...'

    execute ln -s $_DOTFILES_ROOT/shell/.vim $HOME/.vim
}


function install_yarn_prefs() 
{
    [ "$_FATAL_ERROR" = "YES" ] && return 0

    [ "$_INSTALL_YARN_PREFS" != "YES" ] && return 0

    # Symlink yarn prefs

    delete_if_exists $HOME/.yarnrc

    [ "$_FATAL_ERROR" = "YES" ] && return 0

    echo_info 'Creating .yarnrc link...'

    execute ln -s $_DOTFILES_ROOT/shell/.yarnrc $HOME/.yarnrc
}


function install_mackup() 
{
    [ "$_FATAL_ERROR" = "YES" ] && return 0

    [ "$_INSTALL_MACKUP" != "YES" ] && return 0

    echo_info "Install and configure mackup"

    delete_if_exists $HOME/.mackup.cfg

    [ "$_FATAL_ERROR" = "YES" ] && return 0

    echo_info 'Creating .mackup.cfg link...'

    # Symlink the Mackup config
    execute ln -s $_DOTFILES_ROOT/macos/.mackup.cfg $HOME/.mackup.cfg

    [ "$_FATAL_ERROR" = "YES" ] && return 0

    brew_install mackup
}


function install_ohmyzsh_themes() 
{
    [ "$_FATAL_ERROR" = "YES" ] && return 0

    [ "$_INSTALL_OHMYZSH_THEMES" != "YES" ] && return 0

    # Fix missing fƒont characters (see https://github.com/robbyrussell/oh-my-zsh/issues/1906)

    echo_info 'Fixing missing font characters...'

    cd $HOME/.oh-my-zsh/themes/

    execute git checkout d6a36b1 agnoster.zsh-theme
}


function install_powerline_fonts() 
{
    [ "$_FATAL_ERROR" = "YES" ] && return 0

    [ "$_INSTALL_POWERLINE_FONTS" != "YES" ] && return 0

    cd /tmp

    delete_if_exists powerline

    echo_info 'Creating powerline temo dir...'
    
    execute mkdir powerline

    [ "$_FATAL_ERROR" = "YES" ] && return 0

    cd powerline

    # clone

    echo_info 'Cloning powerline...'

    execute git clone https://github.com/powerline/fonts.git --depth=1

    [ "$_FATAL_ERROR" = "YES" ] && return 0

    # install
    cd fonts

    echo_info 'Installing powerline fonts...'

    execute bash ./install.sh

    # clean-up a bit
    cd $_DOTFILES_ROOT
}


function install_php() 
{
    [ "$_FATAL_ERROR" = "YES" ] && return 0

    [ "$_INSTALL_PHP" != "YES" ] && return 0

    brew_install php@7.2

    brew_install php@7.3

    brew_install php@7.4

    echo_info 'Link PHP 7.4'
    execute brew link --force --overwrite php@7.4
}


function install_composer()
{
    [ "$_FATAL_ERROR" = "YES" ] && return 0

    [ "$_INSTALL_COMPOSER" != "YES" ] && return 0

    echo_info 'Installing Composer...'
    
    cd /tmp
    
    delete_if_exists composer-setup.php

    php_exec "copy('https://getcomposer.org/installer', 'composer-setup.php');"

    _MD5=`md5 -q composer-setup.php`

    if [ "$_MD5" != "94ba596cb59085f4b8036863c4a6b237" ]
    then
        set_error "composer-setup.php file's MD5 does not match 94ba596cb59085f4b8036863c4a6b237"

        return 0
    fi

    execute php composer-setup.php

    delete_if_exists composer-setup.php

    delete_if_exists $_COMPOSER_EXECUTABLE

    execute mv composer.phar $_COMPOSER_EXECUTABLE

    if command -v composer > /dev/null
    then 
        echo_success "Composer ($_COMPOSER_EXECUTABLE) was sucessfully installed and tested."
    else
        set_error "ERROR: Composer was installed but it's not available."        
    fi
}


function install_php_pear() 
{
    [ "$_FATAL_ERROR" = "YES" ] && return 0

    [ "$_INSTALL_PEAR" != "YES" ] && return 0

    echo_info 'Install pear'

    cd /tmp

    echo_info "Downloading pear..."

    execute curl -s -O https://pear.php.net/install-pear-nozlib.phar

    echo_info "Installing pear..."
    
    sudo_warning "Installing Pear"

    execute_sudo php install-pear-nozlib.phar -d /usr/local/lib/php -b /usr/local/bin

    echo_info "Update pecl channels..."

    execute_sudo pecl channel-update pecl.php.net

    cd $_DOTFILES_ROOT
}

function install_xcode_select() 
{
    [ "$_FATAL_ERROR" = "YES" ] && return 0

    [ "$_INSTALL_XCODE_SELECT" != "YES" ] && return 0

    echo_info 'Installing xcode select...'

    xcode-select --install 2>/dev/null

    echo
}


function install_postgresql() 
{
    [ "$_FATAL_ERROR" = "YES" ] && return 0

    [ "$_INSTALL_POSTGRESQL" != "YES" ] && return 0

    brew_install postgresql

    [ "$_FATAL_ERROR" = "YES" ] && return 0

    echo_info "Starting PostgreSQL..."

    execute brew services start postgresql
}


function install_laravel_valet() 
{
    [ "$_FATAL_ERROR" = "YES" ] && return 0

    [ "$_INSTALL_LARAVEL_VALET" != "YES" ] && return 0

    composer_install laravel/valet 

    [ "$_FATAL_ERROR" = "YES" ] && return 0

    add_composer_to_path

    sudo_warning "Installing Valet"
  
    echo_comment "> valet install"

    valet install

    check_errors
}


function install_mysql() 
{
    [ "$_FATAL_ERROR" = "YES" ] && return 0

    [ "$_INSTALL_MYSQL" != "YES" ] && return 0

    brew_install mysql@5.7

    [ "$_FATAL_ERROR" = "YES" ] && return 0

    echo_info "Starting MySQL..."

    execute brew services start mysql@5.7
}



function install_zsh_autosuggestions() 
{
    [ "$_FATAL_ERROR" = "YES" ] && return 0

    [ "$_INSTALL_ZSH_AUTOSUGGESTIONS" != "YES" ] && return 0

    brew_install zsh-autosuggestions
}


function display_instructions()
{
    [ "$_FATAL_ERROR" = "YES" ] && return 0

    echo '++++++++++++++++++++++++++++++'
    echo '++++++++++++++++++++++++++++++'
    echo 'All done!'
    echo 'Things to do to make the agnoster terminal theme work:'
    echo '1. Install menlo patched font included in ~/.dotfiles/misc https://gist.github.com/qrush/1595572/raw/Menlo-Powerline.otf'
    echo '2. Install patched solarized theme included in ~/.dotfiles/misc'

    echo '++++++++++++++++++++++++++++++'
    echo 'Some optional tidbits'

    echo '1. Make sure dropbox is running first. If you have not backed up via Mackup yet, then run `mackup backup` to symlink preferences for a wide collection of apps to your dropbox. If you already had a backup via mackup run `mackup restore` You'\''ll find more info on Mackup here: https://github.com/lra/mackup.'
    echo '2. Set some sensible os x defaults by running: $_DOTFILES_ROOT/macos/set-defaults.sh'
    echo '3. Make a .dotfiles-custom/shell/.aliases for your personal commands'

    echo '++++++++++++++++++++++++++++++'
    echo '++++++++++++++++++++++++++++++'
}


function configure_macos()
{
    [ "$_FATAL_ERROR" = "YES" ] && return 0

    echo_info "Configuring macOS..."
    
    sudo_warning "macOS configuration"

    source macos-config.sh > $_OUTPUT_FILE 2> $_ERROR_FILE
}


function configure_git() 
{
    [ "$_FATAL_ERROR" = "YES" ] && return 0

    echo_info "Configuring git globals..."

    execute git config --global --replace-all user.name "\"$___NAME___\""

    [ "$_FATAL_ERROR" = "YES" ] && return 0

    execute git config --global --replace-all user.email "\"$___EMAIL___\""
}


function install_composer_packages()
{
    install_all_packages $_INSTALL_COMPOSER_PACKAGES "Composer" ".composer_packages" composer_install
}


function install_brew_packages()
{
    install_all_packages $_INSTALL_BREW_PACKAGES "Homebrew" ".brew_packages" brew_install
}


function install_brew_cask_packages() 
{
    install_all_packages $_INSTALL_BREW_CASK_PACKAGES "brew cask" ".brew_cask_packages" brew_cask_install
}


function install_npm_packages() 
{
    install_all_packages $_INSTALL_NPM_PACKAGES "npm" ".npm_packages" npm_install
}


function install_pecl_packages() 
{
    install_all_packages $_INSTALL_PECL_PACKAGES "pecl" ".pecl_packages" pecl_install
}

function create_shortcuts()
{
    [ "$_FATAL_ERROR" = "YES" ] && return 0

    _SUBLIME="/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl"

    if [ -f "$_SUBLIME" ]
    then
        echo_comment "Creating Sublime Text links..."
        link "$_SUBLIME" /usr/local/bin/subl
        link "$_SUBLIME" /usr/local/bin/sublime
    fi
}
