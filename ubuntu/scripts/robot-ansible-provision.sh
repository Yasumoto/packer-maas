#!/bin/sh

set -eux

export DEBIAN_FRONTEND=noninteractive

rSW_DIR="${HOME}/src/sw"

apt-get install -y --no-install-recommends ansible git

mkdir -p "${HOME}/.ssh"
echo "|1|Mlbw0iwJHKvzRqeOOAe2DCrcdo4=|E1IkUAsWCcSeU7DQoksgPnLEi6c= ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBIuVnn1aklMAcm8FPV48dWeeW42SRCZxqO9X5r1mJ19KExk9VbFoCWlCMEqJpXzSkdYGKw2mk2AfpLtpIdOqBC4=
|1|jw8Yr9x40e3GOvHJKbUuL9PSDLo=|xeT+bBVXMXCQn75y+aYhOLe2+mE= ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBIuVnn1aklMAcm8FPV48dWeeW42SRCZxqO9X5r1mJ19KExk9VbFoCWlCMEqJpXzSkdYGKw2mk2AfpLtpIdOqBC4=
|1|DKvRHt4LMsMfnPuk7sBUAqZoN0w=|3TGhJpvp/W4KAvz/rj8A6037xeQ= ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBLZ2aeLWnIuddgFD/xAlg9INlxr4EzAD5IBbpgJda+eq9SMKiEDYM9Ba61C63pWybT+xZuJnEgaIUrlT+n7HLZc=" >> "${HOME}/.ssh/known_hosts"
cat "${HOME}/.ssh/known_hosts"

mkdir -p "/root/.ssh"
echo "|1|Mlbw0iwJHKvzRqeOOAe2DCrcdo4=|E1IkUAsWCcSeU7DQoksgPnLEi6c= ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBIuVnn1aklMAcm8FPV48dWeeW42SRCZxqO9X5r1mJ19KExk9VbFoCWlCMEqJpXzSkdYGKw2mk2AfpLtpIdOqBC4=
|1|jw8Yr9x40e3GOvHJKbUuL9PSDLo=|xeT+bBVXMXCQn75y+aYhOLe2+mE= ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBIuVnn1aklMAcm8FPV48dWeeW42SRCZxqO9X5r1mJ19KExk9VbFoCWlCMEqJpXzSkdYGKw2mk2AfpLtpIdOqBC4=
|1|DKvRHt4LMsMfnPuk7sBUAqZoN0w=|3TGhJpvp/W4KAvz/rj8A6037xeQ= ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBLZ2aeLWnIuddgFD/xAlg9INlxr4EzAD5IBbpgJda+eq9SMKiEDYM9Ba61C63pWybT+xZuJnEgaIUrlT+n7HLZc=" >> "/root/.ssh/known_hosts"
ssh -T git@git.int.n7k.io

mkdir -p "${HOME}/src"
git clone --depth=1 --filter=blob:none git@git.int.n7k.io:neuralink/sw.git "${rSW_DIR}"

cd "${rSW_DIR}/ops"
ansible-playbook -i dev.inv -l my_computer provision.yml --ask-become-pass
