FROM debian:buster

# set up apt properly
ENV DEBIAN_FRONTEND noninteractive

# add the security updates for debian to our list
RUN mkdir -p /root/install
ADD ./scratch/buster_deb_security.list /root/install/buster_deb_security.list
RUN cat /root/install/buster_deb_security.list >> /etc/apt/sources.list && \
    apt-get update -y && apt-get upgrade -y && apt-get install -y apt-utils apt-utils python3-software-properties

# now we need to get the wmf key for the wmf apt repos
RUN apt-get install -y gnupg wget && \
    wget -O - -o /dev/null http://apt.wikimedia.org/autoinstall/keyring/wikimedia-archive-keyring.gpg | apt-key add -

# with the key added, we can add all the wmf repos to our list
ADD ./scratch/buster_wikimedia.list /root/install/buster_wikimedia.list
RUN cat /root/install/buster_wikimedia.list >> /etc/apt/sources.list.d/wikimedia.list

# set the preferences to always use wmf versions of packages
ADD ./scratch/wikimedia.pref /etc/apt/preferences.d/wikimedia.pref

# update again, setup for sshd
RUN apt-get update -y && apt-get upgrade -y && apt-get install -y openssh-server && \
    mkdir -p /var/run/sshd  && echo 'root:testing' |chpasswd

# debian build scripts and helpers
RUN apt-get install -y build-essential dpkg-dev devscripts debhelper quilt autoconf automake dh-make git fakeroot && \
    apt-get install -y cdbs dh-autoreconf wdiff lintian && \
    apt-get install -y zip unzip debian-archive-keyring ubuntu-archive-keyring

# various config files
COPY ["./scratch/root_gitconfig", "./scratch/quiltrc-dpkg", "./scratch/bashrc_addons", "/root/install/"]
RUN cat /root/install/bashrc_addons >> /root/.bashrc && \
    cp /root/install/root_gitconfig /root/.gitconfig

# some nice to haves
RUN apt-get install -y bash-completion dh-systemd python-sphinx python-debian emacs meld

# make sshd response quicker; allow login as root with password
RUN cat /etc/ssh/sshd_config | sed -e 's/#GSSAPIAuthentication no/GSSAPIAuthentication no/; s/#PermitRootLogin prohibit-password/PermitRootLogin yes/' > /etc/ssh/sshd_config.new
RUN mv /etc/ssh/sshd_config.new /etc/ssh/sshd_config

EXPOSE 22
CMD /usr/sbin/sshd -D
