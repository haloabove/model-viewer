#!/bin/bash
set -eu
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd)" # the directory this script resides in

cd "${DIR}/.."
npm ci --cache .npm --prefer-offline
#npm run test
# npm run lint:styles
# npm run lint
"${DIR}"/predict-versions.sh # Predict the version we're about to release so we can bake it in
RELEASING_VERSION=$(cat package_version) npm run build
"${DIR}"/release.sh
