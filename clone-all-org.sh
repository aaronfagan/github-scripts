#!/bin/bash

ORG=""
REPOS=$(curl -s -X GET -H "Authorization: token ${GITHUB_TOKEN}" -H "Accept: application/vnd.github.v3+json" "https://api.github.com/orgs/${ORG}/repos?per_page=100" | jq -r .[].full_name)

for REPO in ${REPOS}; do
    git clone git@github.com:${REPO}.git
done
