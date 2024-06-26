#!/bin/bash

. ./gitlab_helper.sh

docker compose up -d

echo ""
echo -e "\033[1mWill wait for gitlab to become ready, this may take between 3 to 5 minutes:\033[0m"
echo ""

until curl -s --fail "${GITLAB_URL}/users/sign_in" > /dev/null
do
  echo -n "."
  sleep 4
done
echo ""
echo ""
echo -e "\033[1mGitlab is READY\033[0m"
echo ""
echo -e "Open \033[4mhttp://localhost:8929/users/sign_in\033[0m to enter"
echo ""
echo -e "\033[1mUsername:\033[0m root"
echo -e "\033[1mPassword:\033[0m supersecret"
echo ""
