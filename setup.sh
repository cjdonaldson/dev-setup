#!/bin/bash

function notInstalled() {
  dpkg -s $1 > /dev/null 2>&1

  if [ $? -eq 0 ]; then
    echo "$1 is installed"
    return 1
  else
    echo "$1 not installed"
    return 0
  fi
}

function easyInstall() {
  notInstalled $1 && sudo apt install $1
}

(
  sudo apt update 
  sudo apt upgrade 
  sudo apt clean 
  sudo apt autoremove 
  sudo apt dist-upgrade 
  echo
  echo
) #> /dev/null 2>&1

function ontime() {
sudo apt-get remove mono-runtime-common gnome-orca ndiswrappe*
sudo cp -v /usr/share/systemd/tmp.mount /etc/systemd/system/
chmod -v 700 $HOME

sudo cat <<EOFSWAPPINESS
# Decrease swap usage to a more reasonable level
# 10 for HD, 1 for SSD
vm.swappiness=1
EOFSWAPPINESS >> /etc/sysctl.conf

sudo ufw enable
}


[ ! -d ~/.mfc-j825dw ] && (
  cat <<EOFPRINTER

    Must install printer
      download http://support.brother.com/g/b/downloadend.aspx?c=us&lang=en&prod=mfcj825dw_all&os=128&dlid=dlf006893_000&flang=4&type3=625
      mkdir ~/.mfc-j825dw
      cd ~/.mfc-j825dw
      mv ~/Downloads/linux-brprinter-installer-2.1.1-1.gz .
      gunzip linux-brprinter-installer-2.1.1-1.gz 
      sudo su
      bash linux-brprinter-installer-2.1.1-1 MFC-J825DW


EOFPRINTER
)

easyInstall openssh-server 
easyInstall vim 
easyInstall silversearcher-ag
easyInstall tidy
easyInstall wkhtmltopdf

notInstalled git && (
  sudo apt install git
  git config --global push.default simple
  git config --global user.email 'charles.j.donaldson@gmail.com'
  git config --global user.name 'Charles Donaldson'
  git config --global diff.tool 'vimdiff'
  git config --global core.editor 'vim'
  git config --global --add difftool.prompt false
)
easyInstall tig

easyInstall openjdk-8-jdk-headless
easyInstall scala

notInstalled sbt && (
  echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
  sudo apt update
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
  sudo apt install sbt
)
easyInstall maven

notInstalled atom-beta && (
  curl -L https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add -
  sudo sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'
  sudo apt update
  sudo apt upgrade
  sudo apt install atom-beta
)

notInstalled docker && (
  sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
  sudo apt-add-repository 'deb https://apt.dockerproject.org/repo ubuntu-xenial main'
  sudo apt update
  sudo apt install linux-image-generic linux-image-extra-virtual
  sudo apt install docker-engine
  sudo usermod -a -G docker $USER
cat <<EOFDOCKER

   <<<< reboot required >>>>

  docker run hello-world
  docker run -p 80:80 nginx
  docker run -d -p 80:80 nginx
  docker run -it debian bash
EOFDOCKER
)

(
  echo
  echo
  sudo apt check
  sudo apt autoclean
  sudo apt autoremove
) #> /dev/null 2>&1

#sudo tar xzf ideaIC-2017.3.3.tar.gz -C /opt/
#cd /opt/idea-IC-173.4301.25
#bin/idea.sh
