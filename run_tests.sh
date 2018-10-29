#!/usr/bin/env sh
res=`docker image list agile-ble | grep -c agile-ble`
if [ $res == 0 ]; then
./build_local.sh
fi
docker run -d -v $(pwd)/tests:/tests agile-ble
container_id=`docker container list | grep agile-ble | awk '{print $1}'`
find ./tests/*.sh | sed "s/\.//" | xargs docker exec $container_id sh