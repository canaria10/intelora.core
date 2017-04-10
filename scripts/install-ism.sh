#!/usr/bin/env bash

SKILLS_DIR='/opt/mycroft/skills'
# exit on any error
set -Ee
rm -rf ism
cd mycroft
git clone https://github.com/intelora/intelora.skill.manager.git ism
chmod +x ism/ism

if [[ ${IS_TRAVIS} != true ]]; then
    echo "Create /opt/mycroft/skills if it doesn't exist"
    if [ ! -d ${SKILLS_DIR} ]; then
        sudo chown $USER:$USER ${SKILLS_DIR}
    fi

    if [ ! -w ${SKILLS_DIR} ]; then
    	sudo mkdir -p ${SKILLS_DIR}
    fi
fi