# Action get metadata from any repository 
This GitHub Action grabs project metadata
Data provided as JSON object


## Example Workflow
    name: Search in project

    on: push

    jobs:
      pull-request:
        runs-on: ubuntu-latest
        steps:
        - name: Checkout
          uses: actions/checkout@v2

        - name: Get labels from project
          uses: iits-consulting/action-get-project-metadata@main
          env:
            API_TOKEN_GITHUB: ${{ secrets.API_TOKEN_GITHUB }}
          with:
            destination_repo: 'user-name/repository-name'
            type: 'labels'

        - name: Search for chartName label
          run: |
            CHART_NAME=$(echo ${{ steps.labels.outputs }} | jq -r -c 'map(select(.name | contains("chartName")) | .name)')
            if [[ -z $CHART_NAME ]]; then
              echo "ERROR: There is no label 'chartName'"
              exit 1
            fi

## Variables
* destination_repo: The repository to place the file or directory in.
* labels: summary/labels/pull-requests


## ENV
* API_TOKEN_GITHUB: You must create a personal access token in you account. Follow the link:
- [Personal access token](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token)

> You must select the scopes: 'repo = Full control of private repositories', 'admin:org = read:org' and 'write:discussion = Read:discussion'; 
