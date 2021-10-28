#!/bin/bash

REPOS=$(ls)
COMMIT_MSG='feat: update setting.yml'

for REPO in ${REPOS}; do
    cd ./${REPO}
    git add . && git commit -m ${COMMIT_MSG} && git push
    cd ~/Github
done