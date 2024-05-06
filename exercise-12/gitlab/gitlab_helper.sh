GITLAB_URL="http://localhost:8929"
GITLAB_TOKEN="ypCa3Dzb23o5nvsixwPA"
PIPELINE_NAME="flask-app"

function wait_for_gitlab_to_be_ready() {
  until curl -s --fail "${GITLAB_URL}/users/sign_in" > /dev/null
  do
    echo "Waiting for Gitlab server to be ready ..."
    sleep 4
  done
}


function create_project() {
  curl --request POST --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
     --header "Content-Type: application/json" --data '{
        "name": "exercise-12", "description": "Exercise 12", "path": "exercise-12",
        "initialize_with_readme": "false"}' \
     --url "$GITLAB_URL/api/v4/projects/"
}

function create_ssh_key() {
  sshKey="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBjK+fcNUfDPMNy/f0lmFE3jSalyluq7KlRryoHj8k/K root@gitlab"

  curl -X POST -F "private_token=${GITLAB_TOKEN}" -F "title=root-ssh-key" -F "key=${sshKey}" "${GITLAB_URL}/api/v4/user/keys"
}

function push_code() {
  chmod 0600 ${GITHUB_WORKSPACE}/exercise-12/gitlab/fixtures/id_ed25519
  export GIT_SSH_COMMAND="ssh -i ${GITHUB_WORKSPACE}/exercise-12/gitlab/fixtures/id_ed25519 -o 'UserKnownHostsFile=/dev/null' -o 'StrictHostKeyChecking=no'"
  cd ${GITHUB_WORKSPACE}/exercise-12/1-python
  git remote add gitlab ssh://git@localhost:2424/root/exercise-12.git
  git push gitlab
}

function get_last_pipeline() {
  curl -s --fail --header "PRIVATE-TOKEN: $GITLAB_TOKEN" "$GITLAB_URL/api/v4/projects/1/pipelines/1"
}

function wait_for_pipeline_job_created() {
  until get_last_pipeline
  do
    echo "Waiting for pipeline to create ..."
    sleep 3
  done
}

function wait_for_pipeline_job_completion() {
  until [ $(get_last_pipeline | jq -r ".status") = "success" ]
  do
    echo "Waiting for pipeline to complete ..."
    sleep 3
  done
}
