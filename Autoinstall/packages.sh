#!/usr/bin/env bash
REAL_PATH=$0

source ${REAL_PATH}/../Shell/colors.sh
source ${REAL_PATH}/../Shell/functions/confirm

REPOS=(
	remmina-ppa-team/remmina-next
)

PACKAGES=(
	zsh
	remmina
	remmina-plugin-rdp
	remmina-plugin-secret
	gcc
	g++
	clang
	picocom
	avrdude
	gcc-avr
	avr-libc
	avr-gdb
	gcc-arm-none-eabi
	libnewlib-arm-none-eabi
	build-essential
	libstdc++-arm-none-eabi-newlib
	gdb-multiarch
	just
	openocd
	cmake
    just
	texlive
	latexmk
	texlive-latex-extra
	texlive-lang-polish
	texlive-fonts-extra
	texlive-bibtex-extra
	biber
	htop
	wine
	fzf
	wl-clipboard
	ddcui
	ddcutil
	git
    trash-cli
    npm
    brightnessctl
)

PYTHON_LIB=(
	python3-numpy
	python3-pandas
	python3-matplotlib
	python3-scipy
	python3-venv
)

install_repository() {
	sudo apt update
	for ppa_name in $REPOS; do
		if grep -r -q "$ppa_name" /etc/apt/sources.list /etc/apt/sources.list.d/ 2>/dev/null; then
			echo -e "${ORANGE}PPA '$ppa_name' alredy exist. Skip.${NC}"
		else
			echo -e "Add PPA: ${YELLOW}$ppa_name${NC}"
			sudo add-apt-repository -y "ppa:$ppa_name"
		fi
	done
	sudo apt update
}

display_packages() {
	if [[ $1 == "-y" ]]; then
		shift
	fi
	echo "Packages list:"
	printf ${GREEN}
	echo $@ | tr ' ' '\n' | column -c $(tput cols)
	printf ${NC}
}

install_packages() {
	display_packages $@
	if confirm $1 "Install this package"; then
		if [[ $1 == "-y" ]]; then
			shift
		fi
		local pass=()
		local fail=()

		for PACK in $@; do
			echo "${YELLOW}Install package: ${PACK}${NC}"
			if sudo apt install "${PACK}" -y; then
				pass+=("$PACK")
			else
				fail+=("$PACK")
			fi
		done

		echo "${GREEN}Sucessful install:"
		echo "${pass[@]}" | tr ' ' '\n' | column -c $(tput cols)
		echo "${RED}"
		echo "FAILED install:"
		echo "${fail[@]}" | tr ' ' '\n' | column -c $(tput cols)
		echo "${NC}"

	fi
}

rustup(){
	confirm $1 "Install rust?" && \
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

autoinstall(){
	sudo apt update
	sudo apt upgrade -y
	install_repository
	install_packages -y $PACKAGES
	install_packages -y $PYTHON_LIB

	# confirm "Initialize git" && ./git_init.sh
	# rustup
}
