#!/bin/sh

set -e
set -x

CLONE_DIR=$(mktemp -d)
export GITHUB_TOKEN=$API_TOKEN_GITHUB
git config --global user.email "dlavrushko"
git config --global user.name "denis.lavrushko@iits-consulting.com"

echo "Cloning destination git repository"
git clone "https://$API_TOKEN_GITHUB@github.com/$INPUT_DESTINATION_REPO.git" "$CLONE_DIR"

if [[ -z "$INPUT_DESTINATION_REPO" || -z "$INPUT_TYPE" ]]; then
  echo "You need to specify 'destination_repo' and 'type'"
  exit 1
fi

if [[ "$INPUT_TYPE" == "summary" ]]; then
    gh api repos/:owner/:repo > summary.json
    echo "::set-output name=summary::$(cat summary.json)"
elif [[ "$INPUT_TYPE" == "labels" ]]; then
    gh api repos/:owner/:repo/labels -t '{{range  .}}{{.name}}{{"\n"}}{{end}}' > /tmp/labels.json
    echo "::set-output name=labels::$(cat labels.json)"
elif [[ "$INPUT_TYPE" == "pull-requests" ]]; then
    gh api repos/:owner/:repo/pulls > /tmp/pulls.json
    echo "::set-output name=pull-requests::$(cat pulls.json)"
fi
