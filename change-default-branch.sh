#!/bin/bash
BRANCH_OLD="master"
BRANCH_NEW="main"
# REPOS=$(curl -s -X GET -H "Authorization: token ${GITHUB_TOKEN}" -H "Accept: application/vnd.github.v3+json" https://api.github.com/user/repos?per_page=100 | jq -r .[].full_name)
REPOS="aaronfagan/github-scripts"

for REPO in ${REPOS}; do
	COMMIT_SHA=$(curl -s -X GET -H "Authorization: token $TOKEN" https://api.github.com/repos/${REPO}/git/refs/heads/${BRANCH_OLD} | jq -r '.object.sha')
	# Create New Branch
	curl -s -X POST -H "Authorization: token ${GITHUB_TOKEN}" -H "Accept: application/vnd.github.v3+json" -d "{\"ref\": \"refs/heads/${BRANCH_NEW}\",\"sha\": \"${COMMIT_SHA}\"}" https://api.github.com/repos/${REPO}/git/refs
	# Swap Default Branch to New One
	curl -s -X PATCH -H "Authorization: token ${GITHUB_TOKEN}" -H "Accept: application/vnd.github.v3+json" -d "{\"default_branch\": \"origin/${BRANCH_NEW}\" }"https://api.github.com/repos/${REPO}/git/refs
	# Delete old Branch
	curl -s -X DELETE -H "Authorization: token ${GITHUB_TOKEN}" -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/${REPO}/git/refs/heads/${BRANCH_OLD}

done
