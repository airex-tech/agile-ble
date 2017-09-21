#!/bin/sh

./scripts/mvn-build.sh

docker build . -t agile-iot/agile-ble
