sudo apt update
sudo apt -y install erlang
sudo git clone https://github.com/elixir-lang/elixir /opt/elixir
sudo chown -R axetang /opt/elixir
cd /opt/elixir
make clean test
echo 'export PATH="${PATH}:/opt/elixir/bin"' >> ~/.bashrc
bash