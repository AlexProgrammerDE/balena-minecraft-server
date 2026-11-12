#!/usr/bin/env bash
# SSH/SCP/SFTP access to /serverfiles as root, with the password from SCP_PASSWORD.

SCP_PASSWORD=${SCP_PASSWORD:-balena}
echo "root:$SCP_PASSWORD" | chpasswd

# Keep host keys in the cache volume so clients don't see a new host key after every update
KEY_DIR=/servercache/ssh
mkdir -p "$KEY_DIR" /run/sshd
CONF=/etc/ssh/sshd_config.d/balena.conf
printf 'PermitRootLogin yes\nPasswordAuthentication yes\n' >"$CONF"
for type in ed25519 rsa; do
  key="$KEY_DIR/ssh_host_${type}_key"
  [[ -f "$key" ]] || ssh-keygen -q -N "" -t "$type" -f "$key"
  echo "HostKey $key" >>"$CONF"
done

exec /usr/sbin/sshd -D -e
