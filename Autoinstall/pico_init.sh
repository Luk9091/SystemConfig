#!/usr/bin/env bash
source ../Shell/colors.sh

export PICO_SDK_PATH=/opt/pico/pico-sdk

pushd /opt > /dev/null
# Pre-configuration file
mkdir -p pico
cd /opt/pico

# SDK
if [[ ! -f ./pico-sdk ]];  then
    echo -e "${RED}Pico-sdk already exist${NC}"
else
    echo -e "${Green}Download and init ${ORANGE}pico sdk${NC}"
    git clone https://github.com/raspberrypi/pico-sdk.git --branch master
    cd pico-sdk
    git submodule update --init
    # echo 'export PICO_SDK_PATH=/opt/pico/pico-sdk' >> $HOME/.zprofile
fi

# PICO tool
cd /opt/pico
if [[ ! -f ./picotool ]];  then
    echo -e "${RED}Picotool already exist${NC}"
else
    echo -e "${Green} Download and init ${ORANGE}picotool${NC}"
    git clone https://github.com/raspberrypi/picotool.git
    cd picotool
    mkdir -p build
    cd build
    cmake ..
    make -j4
    sudo make install
fi

# PICO Freertos Kernel
cd /opt/pico
if [[ ! -f ./FreeRTOS-Kernel ]];  then
    echo -e "${RED}Pico FreeRTOS-Kernel already exist${NC}"
else
    git clone https://github.com/raspberrypi/FreeRTOS-Kernel.git
    cd FreeRTOS-Kernel
    # echo 'export PICO_FREERTOS_PATH=/opt/pico/FreeRTOS-Kernel' >> $HOME/.zprofile
fi

popd > /dev/null
