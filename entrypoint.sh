#!/bin/sh

set -e
set -x

CLONE_DIR=$(mktemp -d)

echo "Cloning destination git repository"
git clone "https://$API_TOKEN_GITHUB@github.com/$INPUT_DESTINATION_REPO.git" "$CLONE_DIR"

if [[ -z "$INPUT_DESTINATION_REPO" || -z "$INPUT_TYPE" ]]; then
  echo "You need to specify 'destination_repo' and 'type'"
  exit 1
fi

if [[ "$INPUT_TYPE" == "summary" ]]; then
    gh api repos/:owner/:repo > summary.json
    echo "::set-output name=summary::$(cat summary.json)"
elif [[ "$INPUT_TYPE" == "labels" ]]
    gh api repos/:owner/:repo/labels -t '{{range  .}}{{.name}}{{"\n"}}{{end}}' > /tmp/labels.json
    echo "::set-output name=labels::$(cat labels.json)"
fi