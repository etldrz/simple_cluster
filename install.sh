sudo apt update
sudo apt-get update
sudo apt-get -y install build-essential autoconf m4 libncurses5-dev libwxgtk3.0-gtk3-dev libwxgtk-webview3.0-gtk3-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev libssh-dev unixodbc-dev xsltproc fop libxml2-utils libncurses-dev openjdk-11-jdk
sudo git clone https://github.com/erlang/otp.git /opt/erlang
sudo chown -R axetang /opt/erlang
cd /opt/erlang
git checkout maint-25
./configure
make
make install
sudo git clone https://github.com/elixir-lang/elixir /opt/elixir
sudo chown -R axetang /opt/elixir
cd /opt/elixir
make clean test
echo 'export PATH="${PATH}:/opt/elixir/bin"' >> ~/.bashrc
echo 'export PATH="${PATH}:/opt/erlang/bin"' >> ~/.bashrc
bash