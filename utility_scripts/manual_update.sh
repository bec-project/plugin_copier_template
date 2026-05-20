#!/bin/bash
# HOW TO USE:
# - Get an access token from gitea with repository:write permissions
# - Have an ssh key loaded for gitea
# - Be in a python environment with copier available
# - run './manual_update.sh <token>'
# clean up the tmp dir when finished: it is not automatically deleted for help in debugging

TMP_DIR="./tmp"
if [ -d "$TMP_DIR" ]; then
  echo "Directory '$TMP_DIR' already exists. Exiting."
  exit 1
fi
mkdir "$TMP_DIR"

REPOS=("addams_bec" "csaxs_bec" "debye_bec" "microxas_bec" "phoenix_bec" "pxi_bec" "pxii_bec" "pxiii_bec" "sim_bec" "superxas_bec" "tomcat_bec" "xtreme_bec" "xil_bec" "pearl_bec" "iss_bec" "detector_group_bec")
BASE_URL="git@gitea.psi.ch:bec"

process_repo() {
    local repo_dir="$1"
    local token="$2"
    echo "Processing: $repo_dir"

    branch="chore/update-template-$(python -m uuid)"
    echo "switching to branch $branch"
    git checkout -b $branch

    echo "Running copier update..."
    copier update --trust --defaults --conflict inline 2>&1 | tee ../copier.log
    output="$(cat ../copier.log)"
    echo $output
    msg="$(printf '%s\n' "$output" | head -n 1)"

    if ! grep -q "make_commit: true" .copier-answers.yml ; then
        echo "Autocommit not made, committing..."
        git add -A
        git commit -a -m "$msg"
    fi

    git push -u origin $branch
    curl -X POST "https://gitea.psi.ch/api/v1/repos/bec/$repo_dir/pulls" \
        -H "Authorization: token $token" \
        -H "Content-Type: application/json" \
        -d "{
                \"title\": \"Template: $(echo $msg)\",
                \"body\": \"Manually triggered update from util script.\",
                \"head\": \"$(echo $branch)\",
                \"base\": \"main\"
            }"
}

for name in "${REPOS[@]}"; do
    git clone "${BASE_URL}/${name}.git" "${TMP_DIR}/${name}"
    (cd "${TMP_DIR}/${name}" && process_repo "$name" "$1")
done
