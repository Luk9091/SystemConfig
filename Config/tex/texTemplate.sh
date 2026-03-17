#! /usr/bin/zsh

function addVerticalPages(){
    local TEX_TEMPLATES=/home/lukasz/.config/tex
    local MY_PATH=${PWD}
    if [ $1 ]; then
        MY_PATH=$1
    fi
    
    FILE="${MY_PATH}/main.tex"
    ADD_TO_MAIN='\\input{verticalPages.tex}'

    cp ${TEX_TEMPLATES}/verticalPages.tex ${MY_PATH}

    if [[ ! ( -e $FILE ) ]]; then
        echo -e "${RED}File main.tex not exist${NC}"
        echo -e "Remember to add ${ORANGE}${ADD_TO_MAIN}${NC} in your main.tex"
    else 
        if grep -Fxq "$ADD_TO_MAIN" "$FILE"; then
            echo "Latex currently use vertical pages"
            exit 0
        fi  

        LINE=$(awk '/^$/{print NR; exit}' "$FILE")
        # sed -i "/^$/ {s/^$/$ADD_TO_MAIN/; :a;n;ba}" "$FILE"
        sed -i "${LINE}s/^$/$ADD_TO_MAIN/" "$FILE"

        echo -e "${GREEN}Add vertical pages in line ${LINE}${NC}"
    fi
}

function addBibliography(){
    local TEX_TEMPLATES=/home/lukasz/.config/tex
    local MY_PATH=${PWD}
    if [ $1 ]; then
        MY_PATH=$1
    fi
    
    FILE="${MY_PATH}/main.tex"
    ADD_TO_MAIN="\n"
    ADD_TO_MAIN+="\\\usepackage[polish]{babel}\n"
    ADD_TO_MAIN+="\\\usepackage{csquotes}\n"
    ADD_TO_MAIN+="\\\usepackage[sorting=none]{biblatex}\n"
    ADD_TO_MAIN+="\\\bibliography{bibliography.bib}\n"

    if [[ ! ( -e $FILE ) ]]; then
        echo -e "${RED}File main.tex not exist${NC}"
        echo -e "Remember to add ${ORANGE}${ADD_TO_MAIN}${NC} in your main.tex"
    else 
        if grep -Fxq "$ADD_TO_MAIN" "$FILE"; then
            echo "Latex currently use bibliography"
            exit 0
        fi  

        LINE=$(awk '/^$/{print NR; exit}' "$FILE")
        # sed -i "/^$/ {s/^$/$ADD_TO_MAIN/; :a;n;ba}" "$FILE"
        sed -i "${LINE}s/^$/$ADD_TO_MAIN/" "$FILE"

        echo -e "${GREEN}Add bibliography in line ${LINE}${NC}"
        touch bibliography.bib
    fi
}

function createRaport(){
    local TEX_TEMPLATES=/home/lukasz/.config/tex
    local MY_PATH=${PWD}
    if [ $1 ]; then
        MY_PATH=$1
    fi

    mkdir -p ${MY_PATH}/Img
    mkdir -p ${MY_PATH}/Chapters
    mkdir -p ${MY_PATH}/Measure

    cp /home/lukasz/.config/tex/agh_logo.jpg ${MY_PATH}/Img
    cp /home/lukasz/.config/tex/.gitignore ${MY_PATH}
    cp /home/lukasz/.config/tex/justfile ${MY_PATH}

    if [[ ! ( -e "${MY_PATH}/main.tex" ) ]]; then
        cp ${TEX_TEMPLATES}/raport_template.tex ${MY_PATH}/main.tex
    else
        echo -e "${RED}File main.tex exist${NC}"
        echo -e "${ORANGE}Override? [y/N]${NC}"
        read -q CHECK
        
        if [[ $CHECK == 'y' ]] then
            cp ${TEX_TEMPLATES}/raport_template.tex ${MY_PATH}/main.tex
        fi
    fi
}

function createPrezentation(){
    local TEX_TEMPLATES=/home/lukasz/.config/tex
    local MY_PATH=${PWD}
    if [ $1 ]; then
        MY_PATH=$1
    fi
    mkdir -p ${MY_PATH}/Img
    mkdir -p ${MY_PATH}/Chapters
    mkdir -p ${MY_PATH}/Measure

    cp /home/lukasz/.config/tex/.gitignore ${MY_PATH}
    cp /home/lukasz/.config/tex/justfile ${MY_PATH}

    if [[ ! ( -e "${MY_PATH}main.tex" ) ]]; then
        cp ${TEX_TEMPLATES}/prez.tex ${MY_PATH}/main.tex
    else
        echo -e "${RED}File main.tex exist${NC}"
        echo -e "${ORANGE}Override? [y/N]${NC}"
        read -q CHECK

        if [[ $CHECK == 'y' ]] then
            cp ${TEX_TEMPLATES}/prez.tex ${MY_PATH}/main.tex
        fi
    fi
}

