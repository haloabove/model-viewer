#!/bin/bash
set -eu
#
# This script pre-generates both package_version and image_version before any release has happened.
# It is useful to pre-generate the version numbers so they can be available at build time
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd)" # Figure out where the script is running

# This is the version about to be released in the build pipeline right now. It is semver.
function next_version() {
  local major minor patch currentVersion increment
  currentVersion="${1}"
  increment="${2}"

  major=$(echo "${currentVersion}" | cut -d'.' -f1)
  minor=$(echo "${currentVersion}" | cut -d'.' -f2)
  patch=$(echo "${currentVersion}" | cut -d'.' -f3 | cut -d'+' -f1)

  if [[ "${increment}" =~ "major" ]]; then
    major=$((major + 1))
    minor=0
    patch=0
  elif [[ "${increment}" =~ "minor" ]]; then
    minor=$((minor + 1))
    patch=0
  else
    patch=$((patch + 1))
  fi

  echo "${major:-0}.${minor:-0}.${patch:-0}"
}


if [[ "${CI_COMMIT_REF_NAME:-}"  =~ ^hotfix-*  ]]; then
  # merged - version tags on HEAD only, -l is a glob pattern, to make the pattern more explicit use grep -E (hotfix allowed on hotfix branch), end cut removes the 'v'
  CURRENT_VERSION="$(git tag --merged HEAD -l "v*" --sort=-version:refname | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+(\+hotfix)?$' | head -n 1 | cut -c 2-)"
else
  # merged - version tags on HEAD only, -l is a glob pattern, to make the pattern more explicit use grep -E (ignore hotfix/branch tags), end cut removes the 'v'
  CURRENT_VERSION="$(git tag --merged HEAD -l "v*" --sort=-version:refname | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' | head -n 1 | cut -c 2-)"
fi
RECOMMENDED_BUMP="$(npx conventional-recommended-bump -p 'angular' -v)"
RELEASING_VERSION="$(next_version "${CURRENT_VERSION}" "${RECOMMENDED_BUMP}")"

if [[ "${CI_COMMIT_REF_NAME:-}"  =~ ^hotfix-*  ]]; then
  # make sure the release number is valid SemVer v2 (required by helm)
  RELEASING_VERSION="${RELEASING_VERSION}+hotfix"
elif [ "${CI_COMMIT_REF_NAME:-}" != 'main' ]; then
  # as we only release from main or hotfix, just use the short sha for other branches
  RELEASING_VERSION="${RELEASING_VERSION}-${CI_COMMIT_SHORT_SHA}"
fi

# This is the docker image tag version.
#
# The only allowed characters in a docker tag are alphanumeric,
# underscore, period, and dash.
#
# So, here we replace all other characters in the version string with a '_'
# There are also characters forbidden at the beginning and end of a docker tag.
# This script doesn't handle these, because it assumes the RELEASING_VERSION
# is semver, and those characters aren't allowed in a semver either.
#
# See https://docs.docker.com/engine/reference/commandline/tag/ for more
IMAGE_VERSION="$(echo "${RELEASING_VERSION}" | tr -c "[:alnum:]_\.\n\-" '_')"

# Now we save the versions to the respective files
echo "${RELEASING_VERSION}" > package_version
echo "${IMAGE_VERSION}" > image_version

# Now we report the versions in the build output
# because it's good for build scripts to be chatty.
echo "Current version is ${CURRENT_VERSION}"
if [[ "${CI_COMMIT_REF_NAME:-}"  =~ ^hotfix-* ]]; then
  echo "Due to building on a hotfix branch, +hotfix is appended to version"
elif [ "${CI_COMMIT_REF_NAME:-}" != 'main' ]; then
  echo "Due to building on a branch version commit sha is appended to version"
fi

echo "Recommended to bump: ${RECOMMENDED_BUMP}"
echo "This release will be version: $(cat package_version)"
echo "The Docker image tag will be: $(cat image_version)"
