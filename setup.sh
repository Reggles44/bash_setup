#!/bin/bash
declare -A osInfo;
osInfo[/etc/redhat-release]=yum
osInfo[/etc/arch-release]=pacman
osInfo[/etc/gentoo-release]=emerge
osInfo[/etc/SuSE-release]=zypp
osInfo[/etc/debian_version]=apt-get
osInfo[/etc/alpine-release]=apk

for f in ${!osInfo[@]}
do
	if [[ -f $f ]];then
		package_manager=${osInfo[$f]}
		echo Package manager: ${osInfo[$f]}
	fi
done

function setup_zsh {
	#Install zsh
    	$package_manager install zsh

	#Install Pure
    	mkdir -p "$HOME/.zsh"
	git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"

	#Install ohmyzsh
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

function setup_neovim {
	#Install Neovim
	$package_manager install neovim

	#Install NvChad
	git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim --headless -c
}

function help {
cat << EOF
Usage: ${0##*/} [-n|--nvim|--neovim] [-z|--zsh] 

    -h          display this help and exit
    -f OUTFILE  write the result to OUTFILE instead of standard output.
    -v          verbose mode. Can be used multiple times for increased
                verbosity.
EOF
}


$package_manager update -y
$package_manager upgrade -y

if [ $# -eq 0 ]; then
    setup_zsh
    setup_neovim
    exit 1
fi

while :; do
	case $1 in
		-h|-\?|--help)
			help
			exit
			;;
		-z|-zsh)
			setup_zsh
			;;
		-n|--nvim|--neovim)
			setup_neovim
			;;
		*)
			break
	esac
	shift
done


