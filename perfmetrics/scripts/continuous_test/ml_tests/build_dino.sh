#!/bin/bash

cd "${KOKORO_ARTIFACTS_DIR}/github/gcsfuse/perfmetrics/scripts"

echo "Setting up the machine with Docker and Nvidia Driver"
chmod +x ml_tests/pytorch_dino_model/setup_host.sh
source ml_tests/pytorch_dino_model/setup_host.sh

cd "${KOKORO_ARTIFACTS_DIR}/github/gcsfuse"
echo "Building docker image containing all pytorch libraries..."
sudo docker build . -f perfmetrics/scripts/ml_tests/pytorch_dino_model/Dockerfile --tag pytorch-gcsfuse

mkdir container_artifacts

echo "Running the docker image build in the previous step..."
sudo docker run --runtime=nvidia --name=pytorch_automation_container --privileged -d -v ${KOKORO_ARTIFACTS_DIR}/github/gcsfuse/container_artifacts:/pytorch_dino/run_artifacts:rw,rshared \
--shm-size=128g pytorch-gcsfuse:latest

# Wait for the script completion as well as logs output.
sudo docker logs -f pytorch_automation_container