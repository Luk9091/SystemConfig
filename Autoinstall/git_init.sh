#!/usr/bin/env bash
REAL_PATH=$0

source ${REAL_PATH}/../Shell/colors.sh


ssh_key_path="${HOME}/.ssh/git_rsa"
EMAIL=$1
if [[ -z "$EMAIL" ]]; then
    echo -e "${RED}Error: Email argument is required!${NC}"
    echo "Usage: $0 <email>"
    exit 1
fi

# Check if ssh-key exist
if [[ -f $ssh_key_path ]]; then
	echo -e "${ORANGE}Key already exist"
else
	ssh-keygen -t rsa -b 4096 -C $EMAIL -f "${HOME}/.ssh/git" -N "" -q
	cat "${HOME}/.ssh/git_rsa.pub" | wl-copy -n
	echo -e "New ssh key generate and place in ${BLUE}clipboard${NC}"
fi


echo "Set git aliases"
# Git alias:
git config --global alias.adog "log --all --decorate --oneline --graph"
git config --global alias.alog 'log --graph  --format=format:"%C(yellow)%h%C(reset) %C(bold green)(%ar) %C(bold dim cyan)%an %C(reset)%s"'
git config --global alias.cm   "commit -m"
git config --global alias.cma  "commit --amend -m"
git config --global alias.ca   "commit --amend --no-edit"
git config --global alias.cl   "clone"

# Profile settings:
git config --global user.email $EMAIL
git config --global user.name "Łukasz Przystupa"
git config --global init.defaultBranch main
