sudo apt-get update
sudo apt update
sudo apt -y install curl git
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.11.1
bash
. "$HOME/.asdf/asdf.sh"
. "$HOME/.asdf/completions/asdf.bash"
sudo apt-get -y install build-essential autoconf m4 libncurses5-dev libwxgtk3.0-gtk3-dev libwxgtk-webview3.0-gtk3-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev libssh-dev unixodbc-dev xsltproc fop libxml2-utils libncurses-dev openjdk-11-jdk
asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
asdf install erlang latest
asdf install elixir latest
asdf global erlang latest
asdf global elixir latest
mix local.hex --force
mix deps.get