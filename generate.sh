#!/bin/bash

exec 3<> executer.service
    echo "[Unit]" >&3
    echo "Description=Run Executer as a service." >&3
    echo $'' >&3
    echo "[Service]" >&3
    echo "Type=simple" >&3
    echo "User=${USER}" >&3
    echo "Group=${GROUP}" >&3
    echo "Restart=always" >&3
    echo "Environment=MIX_ENV=prod" >&3
    echo "Environment=LANG=en_US.UTF-8" >&3
    echo "WorkingDirectory=/local/repository" >&3
    echo "ExecStart=/local/repository/_build/prod/rel/simple_cluster/bin/simple_cluster start" >&3
    echo "ExecStop=/local/repository/_build/prod/rel/simple_cluster/bin/simple_cluster stop" >&3
    echo $'' >&3
    echo "[Install]" >&3
    echo "WantedBy=multi-user.target" >&3
exec 3>&-