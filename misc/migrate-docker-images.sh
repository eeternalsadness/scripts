#!/bin/bash

# Source and target registries
SOURCE_REGISTRY="registry.citigo.net"
TARGET_REGISTRY="docker.citigo.com.vn"

# Image names (each includes a specific version tag)
IMAGE_NAMES=(
  einvoice-backend:25.7.4
  einvoice-file-manager:1.0.0
  einvoice-frontend:25.7.2
  einvoice-helper:1.8.1
  einvoice-kafka-site:25.7.4
  einvoice-landing-page:2025.06.03
  einvoice-mail:1.0.0
  einvoice-version-manager:1.0.0
)

# Loop over all image:tag pairs
for NAME_TAG in "${IMAGE_NAMES[@]}"; do
  # Split name and tag
  IMAGE_NAME="${NAME_TAG%%:*}"
  IMAGE_TAG="${NAME_TAG##*:}"

  FULL_NAME="einvoice/${IMAGE_NAME}"
  SRC_IMAGE="${SOURCE_REGISTRY}/${FULL_NAME}:${IMAGE_TAG}"
  DEST_IMAGE_VERSION="${TARGET_REGISTRY}/${FULL_NAME}:${IMAGE_TAG}"
  DEST_IMAGE_LATEST="${TARGET_REGISTRY}/${FULL_NAME}:latest"

  echo "Pulling ${SRC_IMAGE}"
  docker pull "$SRC_IMAGE" || {
    echo "❌ Failed to pull $SRC_IMAGE"
    continue
  }

  echo "Tagging as ${DEST_IMAGE_VERSION}"
  docker tag "$SRC_IMAGE" "$DEST_IMAGE_VERSION"

  echo "Tagging as ${DEST_IMAGE_LATEST}"
  docker tag "$SRC_IMAGE" "$DEST_IMAGE_LATEST"

  echo "Pushing ${DEST_IMAGE_VERSION}"
  docker push "$DEST_IMAGE_VERSION" || {
    echo "❌ Failed to push $DEST_IMAGE_VERSION"
    continue
  }

  echo "Pushing ${DEST_IMAGE_LATEST}"
  docker push "$DEST_IMAGE_LATEST" || {
    echo "❌ Failed to push $DEST_IMAGE_LATEST"
    continue
  }

  echo "✔ Successfully pushed ${FULL_NAME} as :${IMAGE_TAG} and :latest"
  echo "--------------------------------------------------------------"
done
