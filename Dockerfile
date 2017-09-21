#-------------------------------------------------------------------------------
# Copyright (C) 2017 Create-Net / FBK.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
#
# Contributors:
#     Create-Net / FBK - initial API and implementation
#-------------------------------------------------------------------------------

FROM agileiot/raspberry-pi3-zulujdk:8-jre
WORKDIR /usr/src/app

# install services
RUN echo "deb http://deb.debian.org/debian unstable main" >>/etc/apt/sources.list \
    && apt-get update && apt-get install --no-install-recommends -y \
    bluez/unstable \
    dbus \
    qdbus \
    libxrender1 \
    libxext6 \
    libxtst6 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY ./scripts scripts
COPY ./iot.agile.protocol.BLE/target/ble-1.0-jar-with-dependencies.jar iot.agile.protocol.BLE/target/ble-1.0-jar-with-dependencies.jar
COPY ./deps deps

# workaround for external startup command. To be removed.
RUN mkdir -p /usr/local/libexec/bluetooth/ && ln -s /usr/sbin/bluetoothd /usr/local/libexec/bluetooth/bluetoothd

CMD [ "bash", "/usr/src/app/scripts/start.sh" ]
