#!/bin/sh
echo "APP = $APP"
if [ "$APP" = "starter" ]; then
    ./zbctl deploy process.bpmn --address gateway:26500

    while true; do
        ./zbctl create instance demo-process --address gateway:26500
        sleep 0.01
    done
elif [ $APP = "worker" ]; then
    ./zbctl create worker demo --handler cat --address gateway:26500
else
    echo "Unknown type $APP"
fi
