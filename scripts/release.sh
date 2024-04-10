#!/bin/bash
set -eu

if [[ "${CI_COMMIT_REF_NAME:-}" != 'main' ]] && ! [[ "${CI_COMMIT_REF_NAME:-}"  =~ ^hotfix-*  ]]; then
  echo "Building on branch ${CI_COMMIT_REF_NAME}. Release only runs on main (or hotfix) branch"
  exit 0
fi

git config --global user.name "${GITLAB_USER_NAME}"
git config --global user.email "${GITLAB_USER_EMAIL}"
git tag "v$(cat package_version)"
git push --tags "https://pipeline-access-token:${GL_TOKEN}@${CI_SERVER_HOST}/${CI_PROJECT_PATH}.git"
