#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

: "${JAVA_HOME:?Set JAVA_HOME to a Java 25 JDK}"
jobs="${BUILD_JOBS:-4}"
cmake -S native -B build/linux -G Ninja \
    -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
    -DMCVR_ENABLE_STREAMLINE=OFF -DMCVR_ENABLE_XESS=OFF \
    -DMCVR_ENABLE_NRD=ON -DMCVR_ENABLE_FFX_UPSCALER=ON -DUSE_AMD=ON
cmake --build build/linux --parallel "$jobs"
cmake --install build/linux
bash ./gradlew :fabric:build --no-daemon --max-workers="$jobs"
