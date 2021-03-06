#!/usr/bin/env bash

ROOT_GIT=$(git rev-parse --show-toplevel)
BUILD_ARTIFACT_REPO="quay.io/recaptime-dev/gitpod-workspace-images-artifacts"
BUILD_ARTIFACT_TAGNAME=${BUILD_ARTIFACT_TAGNAME:-"gl-madebythepinshub-infra-keycloak-iam"}
BUILD_ARTIFACT_TAGNAME_BRANCH=$(git rev-parse --abbrev-ref HEAD | git rev-parse --abbrev-ref HEAD | iconv -t ascii//TRANSLIT | sed -r s/[^a-zA-Z0-9]+/-/g | sed -r s/^-+\|-+$//g | tr A-Z a-z)
BUILD_ARTIFACT_TAGNAME_COMBINED="$BUILD_ARTIFACT_REPO:$BUILD_ARTIFACT_TAGNAME-$BUILD_ARTIFACT_TAGNAME_BRANCH"
BUILD_ARTIFACT_TAGNAME_UUID="$(cat /proc/sys/kernel/random/uuid)"
BUILD_ARTIFACT_TAGNAME_UUID_COMBINED="$BUILD_ARTIFACT_REPO:$BUILD_ARTIFACT_TAGNAME_UUID"

DOCKER_BUILDKIT=1 docker build \
    --pull \
    --file "$ROOT_GIT/.gitpod.Dockerfile" \
    --tag "$BUILD_ARTIFACT_TAGNAME_COMBINED" --tag "$BUILD_ARTIFACT_TAGNAME_UUID_COMBINED" \
    "$ROOT_GIT"

if [[ $PUBLISH_ARTIFACT_TO_RHQCR != "" ]]; then
  docker push "$BUILD_ARTIFACT_TAGNAME_COMBINED"
  docker push "$BUILD_ARTIFACT_TAGNAME_UUID_COMBINED"
fi