#!/bin/bash

trap stop_script INT


function stop_script() {
    clear
    echo -e "\n${red}[!] Saliendo... \n${resetStyle}"
    exit 1
}

# Colores
resetStyle="\e[0m"
red="\e[0;31m"
blue="\e[0;34m"
cyan="\e[0;36m"
green="\e[0;32m"
yellow="\e[0;33m"
purple="\e[0;35m"
white="\e[0;37m"
black="\e[0;30m"

username=$(whoami)
tmp_folder=/tmp/kalirice


# Para los mensajes de Ok: Cyan
# Para los mensajes de FAIL: Rojos
# Para resto de mensajes: Morado

function show_banner() {

    echo -e " _  __     _ _ ____  _" 
    echo -e "| |/ /__ _| (_)  _ \\(_) ___ ___"
    echo -e "| ' // _\` | | | |_) | |/ __/ _ \\   ~ by rcv11x"
    echo -e "| . \\\ (_| | | |  _ <| | (_|  __/ github.com/rcv11x"
    echo -e "|_|\\_\\__,_|_|_|_| \\_\\_|\\___\\___|\n\n"
}

function show_menu() {

    echo -e "\n[*] (1) Instalar KaliRice (Entorno completo)"
    echo -e "[*] (2) Instalar VMWare/Virtualbox Tools"
    echo -e "[*] (0) Salir\n"
}


function check_dependencies() {

     if [[ $? != 0 && $? != 130 ]]; then
        echo -e "\n${red}[${white} FAIL :( ${red}] ${blue} Ha habido un error y no se han podido instalar algunas dependencias${resetStyle}\n"
        sleep 2
    else
        echo -e "\n${red}[${white} OK ${red}] ${blue} Dependencias Instaladas correctamente${resetStyle}\n"
        sleep 2.5
    fi
}

function msg_ok() {
    echo -e "${red}[${white} OK ${red}] ${resetStyle}\n"
}

function installEnviroment() {
    mkdir $tmp_folder
    cp -r config/ fonts/ scripts/ $tmp_folder/
    echo -e "\n${purple}[!] Instalando entorno...${resetStyle}\n"
    sleep 2
    echo -e "\n${purple}[!] Actualizando sistema y upgradeando...${resetStyle}\n"
    sudo apt update && sudo apt full-upgrade -y
    sleep 2
    echo -e "\n${purple}Instalando dependencias necesarias...${resetStyle}\n"
    sudo apt install build-essential git cmake cmake-data make neovim neofetch htop kitty lsd bat pamixer rofi ranger scrot flameshot fzf xclip feh scrub wmname firejail cmatrix zsh python3-pip libxcb-xtest0-dev libpcre3-dev libgl1-mesa-dev libxcb-xinerama0-dev imagemagick evince tor torbrowser-launcher -y

    sudo apt install -y kitty rofi feh xclip ranger i3lock-fancy scrot scrub wmname firejail imagemagick cmatrix htop neofetch python3-pip procps tty-clock fzf lsd bat pamixer flameshot

    msg_ok
    sleep 2

    # Bspwm y sxhkd
    echo -e "${purple}Instalando dependencias para Bspwm y sxhkd...${resetStyle}\n"
    sleep 2
    sudo apt install bspwm libxcb-xinerama0-dev libxcb-icccm4-dev libxcb-randr0-dev libxcb-util0-dev libxcb-ewmh-dev libxcb-keysyms1-dev libxcb-shape0-dev -y
    check_dependencies
    echo -e "\n${purple}Instalando bspwm y sxhkd...${resetStyle}\n"
    git clone https://github.com/baskerville/bspwm.git $tmp_folder/repos/bspwm
    git clone https://github.com/baskerville/sxhkd.git $tmp_folder/repos/sxhkd
    cd $tmp_folder/repos/bspwm && make && sudo make install
    cd $tmp_folder/repos/sxhkd && make && sudo make install
    mkdir -p ~/.config/{bspwm,sxhkd}
    cp -v /usr/local/share/doc/bspwm/examples/bspwmrc ~/.config/bspwm/
    cp -v /usr/local/share/doc/bspwm/examples/sxhkdrc ~/.config/sxhkd/
    chmod +x ~/.config/bspwm/bspwmrc

    msg_ok
    sleep 2

    # Polybar
    echo -e "\n${purple}Instalando dependencias para Polybar...${resetStyle}\n"
    sleep 2
    sudo apt install pkg-config python3-sphinx libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev libmpdclient-dev libcurl4-openssl-dev libuv1-dev libnl-genl-3-dev -y
    check_dependencies
    git clone --recursive https://github.com/polybar/polybar $tmp_folder/repos/polybar
    cd  $tmp_folder/repos/polybar
    mkdir build && cd build/
    cmake ..
    make -j$(nproc)
    sudo make install

    msg_ok
    sleep 2

    # Picom
    echo -e "\n${purple}Instalando dependencias para Picom...${resetStyle}\n"
    sleep 2
    sudo apt install meson libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-present-dev libxcb-xinerama0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libpcre3-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev libxcb-glx0-dev -y
    check_dependencies
    git clone https://github.com/ibhagwan/picom.git $tmp_folder/repos/picom
    cd $tmp_folder/repos/picom
    git submodule update --init --recursive
    meson --buildtype=release . build
    ninja -C build
    sudo ninja -C build install
    cd ~

    msg_ok
    sleep 2

    # Instalacion de fuentes para el entorno
    echo -e "${purple}Instalando fuentes necesarias...${resetStyle}"
    sleep 2
    if [[ -d "~/.local/share/fonts" ]]; then
		cp -rv $tmp_folder/fonts/* ~/.local/share/fonts/
	else
		mkdir -p ~/.local/share/fonts
        cp -rv $tmp_folder/fonts/* ~/.local/share/fonts/
	fi

    msg_ok
    sleep 2

    # Configurando wallpaper
    mkdir ~/.config/wallpapers/
    cp -rv $tmp_folder/config/wallpapers/* ~/.config/wallpapers/

    msg_ok
    sleep 2

    # Instalacion de plugin ohmyzsh y tema powerlevel10k
    echo -e "${purple}Instalando OhMyZsh para $username y root...${resetStyle}"
    sleep 2
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    msg_ok
    echo -e "${purple}Instalando Powerlevel10k para $username y root...${resetStyle}"
    sleep 2
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
    sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/.oh-my-zsh/custom/themes/powerlevel10k
    msg_ok

    # Instalacion de pywal
    echo -e "\n${purple}Instalando pywal${resetStyle}\n"
    sleep 2
    sudo pip3 install pywal
    msg_ok

    # Instalacion de i3-lockfancy
    echo -e "\n${purple}Instalando i3lock-fancy${resetStyle}\n"
    git clone https://github.com/meskarune/i3lock-fancy.git $tmp_folder/repos/i3lock-fancy
    cd $tmp_folder/repos/i3lock-fancy
    sudo make install
    msg_ok

    # Moviendo toda la configuracion a ~/.config
    echo -e "\n${purple}Moviendo toda la configuracion a ~/.config ${resetStyle}\n"
    sleep 2
    cp -rv $tmp_folder/config/* ~/.config/
    #rm ~/.config/.zshrc
    #rm ~/.config/.p10k
    cp -v $tmp_folder/config/.zshrc ~/.zshrc
    cp -v $tmp_folder/config/.p10k.zsh ~/.p10k.zsh
    sudo ln -sfv ~/.zshrc /root/.zshrc
    sudo ln -sfv ~/.p10k.zsh /root/.p10k.zsh
    sudo cp -r $tmp_folder/scripts/*.sh ~/.config/polybar/forest/scripts/
    sudo touch /root/.config/polybar/forest/scripts/target

	chmod +x ~/.config/polybar/launch.sh
	chmod +x ~/.config/polybar/forest/scripts/*
	sudo chmod +x /usr/local/share/zsh/site-functions/_bspc
	sudo chown root:root /usr/local/share/zsh/site-functions/_bspc
	sudo mkdir -p /root/.config/polybar/forest/scripts/
    touch ~/.config/polybar/forest/scripts/target
	sudo ln -sfv ~/.config/polybar/forest/scripts/target /root/.config/polybar/forest/scripts/target
    msg_ok
	
}

function install_vm_tools() {

    echo -e " --> ¿Que tipo de hipervisor estas usando? VMware (1) o Virtualbox (2) o Salir (ENTER)<--\n"
    echo -e "${red}[!] Si estas en Virtualbox asegurate de insertar las Guest Additions Antes de ejecutar la opcion 2: Dirigete a VirtualBox > Dispositivos > Insertar Guest Additions${resetStyle}"

    read -p ">> " opt

    case $opt in
        1)
            echo -e "${red}[${white}*${red}] ${blue}Instalando VMWare tools...${resetStyle}"
            sleep 2.5
            sudo apt install -s open-vm-tools open-vm-tools-desktop

            if [[ $? != 0 && $? != 130 ]]; then
                echo -e "${red}[!] Ha habido un error y no se ha podido instalar VMware tools.${resetStyle}"
                exit 1
            else
                echo -e "${red}[${white}*${red}] ${blue}Vmware tools instalado correctamente.${resetStyle}"
                sleep 2.5
                init
            fi

            init
            ;;
        2)
            echo -e "${red}[${white}*${red}] ${blue}Instalando VBox Guest Addittions...${resetStyle}\n"
            sleep 2.5
            sudo apt install -s -y --reinstall virtualbox-guest-x11

            if [[ $? != 0 && $? != 130 ]]; then
                echo -e "\n${red}[!] Ha habido un error y no se ha podido instalar VMware tools.${resetStyle}"
                exit 1
            else
                echo -e "\n${red}[${white}*${red}] ${blue}Vbox Guest Addittions instalado correctamente.${resetStyle}"
                sleep 2.5
                init
            fi

            init
            ;;
        *)
            init
            ;;
    esac
}

function init() {
    clear
    if [[ $(id -u) = 0 || $(whoami) = "root"  ]]; then
        echo -e "\n${red}[!] Ejecuta el script sin sudo\n${resetStyle}"
        exit 1
    else
        while true; do
            show_banner
            show_menu
    
            read -p "$(whoami) >> " opcion

            case $opcion in
                1) 
                    installEnviroment
                    ;;
                2)
                    clear
                    install_vm_tools 
                    ;;
                3)
                    #
                    ;;
                0)
                    exit 0
                    ;;
                *)
                    echo -e "\n${red}[!] Opción no válida${resetStyle}"
                    echo -e "\nPresiona una tecla para continuar"
                    read -n 1 -s -r -p ""
                    clear
                    ;;
            esac
        done
    fi
}

# Ejecuta todo el script y aqui empieza todo
init
