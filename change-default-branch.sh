#!/bin/bash

COLOR_WHITE="\033[0;37m"
COLOR_END="\033[0m"

BRANCH_OLD="master"
BRANCH_NEW="main"

echo -e "${COLOR_WHITE}"
echo -e "Changing default branch from \"${BRANCH_OLD}\" to \"${BRANCH_NEW}\".\n"
echo -ne "Ready to proceed? [Y/N] " && read PROCEED

if [[ "${PROCEED}" == "y" || "${PROCEED}" == "Y" ]]; then
	REPOS=$(curl -s -X GET -H "Authorization: token ${GITHUB_TOKEN}" -H "Accept: application/vnd.github.v3+json" "https://api.github.com/user/repos?per_page=100" | jq -r .[].full_name)
	for REPO in ${REPOS}; do
		echo -ne "\n${REPO}..."
		COMMIT_SHA=$(curl -s -X GET -H "Authorization: token ${GITHUB_TOKEN}" -H "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/${REPO}/git/refs/heads/${BRANCH_OLD}" | jq -r '.object.sha')
		curl -s -X POST -H "Authorization: token ${GITHUB_TOKEN}" -H "Accept: application/vnd.github.v3+json" -d "{\"ref\": \"refs/heads/${BRANCH_NEW}\",\"sha\": \"${COMMIT_SHA}\"}" "https://api.github.com/repos/${REPO}/git/refs" > /dev/null 2>&1
		curl -s -X PATCH -H "Authorization: token ${GITHUB_TOKEN}" -H "Accept: application/vnd.github.v3+json" -d "{\"default_branch\": \"origin/${BRANCH_NEW}\" }" "https://api.github.com/repos/${REPO}/git/refs" > /dev/null 2>&1
		curl -s -X DELETE -H "Authorization: token ${GITHUB_TOKEN}" -H "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/${REPO}/git/refs/heads/${BRANCH_OLD}" > /dev/null 2>&1
		echo "done!"
	done
	echo -e "\nComplete!"
else
	echo -e "\nExiting...."
fi

echo -ne "\n${COLOR_END}"