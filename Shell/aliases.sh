#!/usr/bin/env zsh

# Main config file:
alias zshrc="${EDITOR} ~/.zshrc"
alias vimrc="${EDITOR} ~/.config/nvim/init.lua"
alias aliasrc="${EDITOR} ~/.config/zsh/aliases.sh"
alias functionrc="${EDITOR} ~/.config/zsh/functions/"
alias poshrc="${EDITOR} ~/.config/zsh/oh-my-posh.yaml"
alias colorsrc="${EDITOR} ~/.config/zsh/colors.sh"
alias profilerc="${EDITOR} ~/.zprofile"
alias aghVPN="sudo openvpn $HOME/.config/VPN-AGH.2026.ovpn"

alias reload="source ~/.zprofile; source ~/.zshrc; echo -e '${RED}Reloaded${NC}'"
alias reload_alias="source ~/.config/zsh/als.zsh && printf '${RED}Reload aliasys${NC}\n'"
alias reload_functions="source ~/.config/zsh/fun.zsh && printf '${RED}Reload functions${NC}\n'"

alias story="${EDITOR} ~/.cache/zsh/history"

# Shell
alias clr='clear'

alias ok='sudo $(fc -nl -1)'
alias rm="trash"
alias rmdir="trash"
alias mkdir="mkdir -p"
alias ls="ls --color=auto"
alias ll="ls --color=auto -la"
alias ...="popd >> /dev/null"
alias bat="batcat"


# Applications
alias fd='fdfind'
alias python="python3"

# Devices
alias brightness_ext="sudo ddcutil setvcp 10"
alias keyboard="sudo -b /home/lukasz/.config/zsh/functions/apex7tkl_linux/./cli.py"
alias reset_wifi="sudo modprobe -r mt7921e &&  sudo modprobe mt7921e"


# Microcontroller
# PICO SDK
alias PICOprobe='openocd -f interface/cmsis-dap.cfg -c "adapter speed 5000" -f target/rp2040.cfg -s tcl'
alias PICO2probe='openocd -f interface/cmsis-dap.cfg -c "adapter speed 5000" -f target/rp2350.cfg -s tcl'
alias PICOprobeC0='openocd -f interface/cmsis-dap.cfg -c "adapter speed 5000" -f target/rp2040.cfg -s tcl -c "target smp disable" -c "targets rp2040.core0"'
alias PICOprobeC0='openocd -f interface/cmsis-dap.cfg -c "adapter speed 5000" -f target/rp2350.cfg -s tcl -c "target smp disable" -c "targets rp2350.core0"'

# ESP IDF
alias esp_init="source /opt/esp/esp-idf/export.sh"
