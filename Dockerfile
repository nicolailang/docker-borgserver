############################################################
# Dockerfile to build borgbackup server images
# Based on Debian
############################################################
FROM debian:latest

# Volume for SSH-Keys
VOLUME /sshkeys

# Volume for borg repositories
VOLUME /backup

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y --no-install-recommends install    openssh-server \
																	python3 python3-dev python3-pip python-virtualenv \
																	libssl-dev openssl \
																	libacl1-dev libacl1 \
																	liblz4-dev liblz4-1 \
																	python3-setuptools python3-wheel \
																	build-essential && \
	pip3 install borgbackup && \
	apt-get -y purge build-essential && apt-get -y autoremove && apt-get clean && \
	rm -f /etc/ssh/ssh_host*key* ; rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

RUN useradd -s /bin/bash -m borg ; \
	mkdir /home/borg/.ssh && chmod 700 /home/borg/.ssh && chown borg: /home/borg/.ssh ; \
	mkdir /run/sshd


COPY ./data/run.sh /run.sh
COPY ./data/sshd_config /etc/ssh/sshd_config

CMD /bin/bash /run.sh

# Default SSH-Port for clients
EXPOSE 22
