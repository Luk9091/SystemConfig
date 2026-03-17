#!/usr/bin/env bash
pushd ${0%/*} >> /dev/null
cd ..
CURRENT_PATH=$PWD
CONFIG_PATH="$CURRENT_PATH/Config"
ZSH_PATH=$CONFIG_PATH/zsh
TEX_PATH=$CONFIG_PATH/tex
VIM_PATH=$CONFIG_PATH/nvim
CAD_PATH=$CONFIG_PATH/FreeCAD


# zsh
echo -e "Link zshrc"
ln -sf $ZSH_PATH/zshrc "${HOME}/.zshrc"
echo -e "Link zprofile"
ln -sf $ZSH_PATH/zprofile "${HOME}/.zprofile"

mkdir -p "${HOME}/.config/zsh"
for file in $(ls "$CURRENT_PATH/Shell/"); do
    ln -sf "$CURRENT_PATH/Shell/${file}" "${HOME}/.config/zsh/"
done


if [[ -f "${HOME}/.config/zsh/zsh-autocomplete" ]]; then
    git clone git@github.com:marlonrichert/zsh-autocomplete.git
fi
if [[ -f "${HOME}/.config/zsh/zsh-autosuggestions" ]]; then
    git clone git@github.com:zsh-users/zsh-autosuggestions.git
fi
if [[ -f "${HOME}/.config/zsh/zsh-syntax-highlighting" ]]; then
    git clone git@github.com:zsh-users/zsh-syntax-highlighting.git
fi

# nVim path
echo -e "Link nVim"
ln -sf $VIM_PATH "${HOME}/.config/"

# Tex
echo -e "Link tex"
ln -sf $TEX_PATH "${HOME}/.config/"

# FreeCAD keybinds
# if [[ ! -f "${HOME}/.var/app/org.freecad.FreeCAD/config/FreeCAD" ]]; then
#    echo -e "Link FreeCAD"
#    rm -r "${HOME}/.var/app/org.freecad.FreeCAD/config/FreeCAD" 2> /dev/null
#    ln -sf $CAD_PATH "${HOME}/.var/app/org.freecad.FreeCAD/config/"
# fi

popd >> /dev/null
