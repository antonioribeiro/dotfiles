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

    execute ln -s $DOTFILES_ROOT/shell/.global-gitignore $HOME/.global-gitignore

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

    execute ln -s $DOTFILES_ROOT/shell/.zshrc $HOME/.zshrc
}


function install_vim_prefs() 
{
    [ "$_INSTALL_VIM_PREFS" != "YES" ] && return 0

    [ "$_FATAL_ERROR" = "YES" ] && return 0

    # Symlink vim prefs

    delete_if_exists $HOME/.vimrc

    [ "$_FATAL_ERROR" = "YES" ] && return 0

    echo_info 'Creating .vimrc link...'

    execute ln -s $DOTFILES_ROOT/shell/.vimrc $HOME/.vimrc

    [ "$_FATAL_ERROR" = "YES" ] && return 0


    delete_if_exists $HOME/.vim

    [ "$_FATAL_ERROR" = "YES" ] && return 0

    echo_info 'Creating .vim link...'

    execute ln -s $DOTFILES_ROOT/shell/.vim $HOME/.vim
}


function install_yarn_prefs() 
{
    [ "$_INSTALL_YARN_PREFS" != "YES" ] && return 0

    [ "$_FATAL_ERROR" = "YES" ] && return 0

    # Symlink yarn prefs

    delete_if_exists $HOME/.yarnrc

    [ "$_FATAL_ERROR" = "YES" ] && return 0

    echo_info 'Creating .yarnrc link...'

    execute ln -s $DOTFILES_ROOT/shell/.yarnrc $HOME/.yarnrc
}


function install_mackup() 
{
    [ "$_INSTALL_MACKUP" != "YES" ] && return 0

    [ "$_FATAL_ERROR" = "YES" ] && return 0

    echo_info "Install and configure mackup"

    delete_if_exists $HOME/.mackup.cfg

    [ "$_FATAL_ERROR" = "YES" ] && return 0

    echo_info 'Creating .mackup.cfg link...'

    # Symlink the Mackup config
    execute ln -s $DOTFILES_ROOT/macos/.mackup.cfg $HOME/.mackup.cfg

    [ "$_FATAL_ERROR" = "YES" ] && return 0

    brew_install mackup
}


function install_ohmyzsh_themes() 
{
    [ "$_INSTALL_OHMYZSH_THEMES" != "YES" ] && return 0

    [ "$_FATAL_ERROR" = "YES" ] && return 0

    # Fix missing fƒont characters (see https://github.com/robbyrussell/oh-my-zsh/issues/1906)

    echo_info 'Fixing missing font characters...'

    cd $HOME/.oh-my-zsh/themes/

    execute git checkout d6a36b1 agnoster.zsh-theme
}


function install_powerline_fonts() 
{
    [ "$_INSTALL_POWERLINE_FONTS" != "YES" ] && return 0

    [ "$_FATAL_ERROR" = "YES" ] && return 0

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
    cd $DOTFILES_ROOT
}


function install_php() 
{
    [ "$_INSTALL_PHP" != "YES" ] && return 0

    brew_install php@7.2

    brew_install php@7.3

    brew_install php@7.4

    echo_info 'Link PHP 7.4'
    execute brew link --force --overwrite php@7.4
}


function install_composer()
{
    [ "$_INSTALL_COMPOSER" != "YES" ] && return 0

    [ "$_FATAL_ERROR" = "YES" ] && return 0

    echo_info 'Installing Composer...'
    
    cd /tmp
    
    delete_if_exists composer-setup.php

    php_exec "copy('https://getcomposer.org/installer', 'composer-setup.php');"

    _MD5=`md5 -q composer-setup.php`

    if [ "$_MD5" != "94ba596cb59085f4b8036863c4a6b237" ]
    then
        FATAL_ERROR=YES

        echo_error "composer-setup.php file's MD5 does not match 94ba596cb59085f4b8036863c4a6b237"

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
        FATAL_ERROR=YES

        echo_error "ERROR: Composer was installed but it's not available."        
    fi
}


function install_quicklook_plugins() 
{
    [ "$_INSTALL_QUICKLOOK_PLUGINS" != "YES" ] && return 0

    [ "$_FATAL_ERROR" = "YES" ] && return 0

    echo_info 'Installing some nice quicklook plugins...'

    execute brew cask install --force qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzip webpquicklook suspicious-package
}


function install_php_pear() 
{
    [ "$_INSTALL_PEAR" != "YES" ] && return 0

    [ "$_FATAL_ERROR" = "YES" ] && return 0

    echo_info 'Install pear'

    cd /tmp

    echo_info "Downloading pear..."

    execute curl -s -O https://pear.php.net/install-pear-nozlib.phar

    echo_info "Installing pear..."
    
    execute_sudo php install-pear-nozlib.phar -d /usr/local/lib/php -b /usr/local/bin

    echo_info "Update pecl channels..."

    execute_sudo pecl channel-update pecl.php.net

    cd $DOTFILES_ROOT
}

function install_xcode_select() 
{
    [ "$_INSTALL_XCODE_SELECT" != "YES" ] && return 0

    [ "$_FATAL_ERROR" = "YES" ] && return 0

    echo_info 'Installing xcode select...'

    execute xcode-select --install
}


function install_postgresql() 
{
    [ "$_INSTALL_POSTGRESQL" != "YES" ] && return 0

    brew_install postgresql

    [ "$_FATAL_ERROR" = "YES" ] && return 0

    echo_info "Starting PostgreSQL..."

    execute brew services start postgresql
}


function install_laravel_valet() 
{
    [ "$_INSTALL_LARAVEL_VALET" != "YES" ] && return 0

    composer_install laravel/valet 

    [ "$_FATAL_ERROR" = "YES" ] && return 0

    echo_comment "> valet install"

    add_composer_to_path

    execute valet install
}


function install_mysql() 
{
    [ "$_INSTALL_MYSQL" != "YES" ] && return 0

    brew_install mysql@5.7

    [ "$_FATAL_ERROR" = "YES" ] && return 0

    echo_info "Starting MySQL..."

    execute brew services start mysql@5.7
}



function install_zsh_autosuggestions() 
{
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
    echo '2. Set some sensible os x defaults by running: $DOTFILES_ROOT/macos/set-defaults.sh'
    echo '3. Make a .dotfiles-custom/shell/.aliases for your personal commands'

    echo '++++++++++++++++++++++++++++++'
    echo '++++++++++++++++++++++++++++++'
}


function configure_macos()
{
    echo_info "Configuring macOS..."

    source macos-config.sh > $_OUTPUT_FILE 2> $_ERROR_FILE
}


function configure_git() 
{
    [ "$_FATAL_ERROR" = "YES" ] && return 0

    echo_info "Configuring git globals..."

    execute git config --global user.name "$___NAME___"

    [ "$_FATAL_ERROR" = "YES" ] && return 0

    execute git config --global user.email "$___EMAIL___"
}


function install_composer_packages()
{
    install_all_packages $_INSTALL_COMPOSER_PACKAGES "Composer" ".composer_packages" composer_install
}


function install_brew_packages()
{
    install_all_packages $_INSTALL_BREW_PACKAGES "Homebrew" ".brew_packages" brew_install
}


function install_npm_packages() 
{
    install_all_packages $_INSTALL_NPM_PACKAGES "npm" ".npm_packages" npm_install
}


function install_pecl_packages() 
{
    install_all_packages $_INSTALL_PECL_PACKAGES "pecl" ".pecl_packages" pecl_install
}
