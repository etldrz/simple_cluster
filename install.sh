bash
cd /local
sudo chown axetang:PowderSandbox .
sudo apt-get update
sudo apt update
sudo apt-get -y install curl git
sudo apt-get -y install iperf3
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.11.1
. "$HOME/.asdf/asdf.sh"
echo '. "$HOME/.asdf/asdf.sh"' >> ~/.bashrc
sudo apt-get -y install \
  build-essential autoconf m4 libncurses5-dev libwxgtk3.0-gtk3-dev \
  libwxgtk-webview3.0-gtk3-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev \
  libssh-dev unixodbc-dev xsltproc fop libxml2-utils libncurses-dev \
  openjdk-11-jdk
asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
asdf install erlang 25.3.2
asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
asdf install elixir 1.14.4-otp-25
asdf global erlang 25.3.2
asdf global elixir 1.14.4-otp-25