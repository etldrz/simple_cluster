#!/bin/bash
cd /local
sudo chown axetang:PowderSandbox .
sudo apt-get update
sudo apt-get -y install curl git
sudo apt-get -y install iperf3
sudo add-apt-repository ppa:rabbitmq/rabbitmq-erlang -y
sudo apt -y update
sudo apt -y install elixir erlang-dev erlang-xmerl
cd /local/repository
mix local.hex --force
mix local.rebar --force
mix deps.get
MIX_ENV=prod mix release
# bash ./generate.sh
sudo cp executer.service /lib/systemd/system
sudo cp executer.service /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable executer
sudo systemctl start executer
bash