#!/usr/bin/env bash

if [[ -z "$SCP_PASSWORD" ]]; then
  export SCP_PASSWORD=balena
fi

# here we set up the config for openSSH.
mkdir /var/run/sshd
echo "root:$SCP_PASSWORD" | chpasswd
sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

export NOTVISIBLE="in users profile"
echo "export VISIBLE=now" >> /etc/profile

exec /usr/sbin/sshd -D
