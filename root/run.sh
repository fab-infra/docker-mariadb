#!/bin/sh -ex

/usr/lib/mysql/mysql-systemd-helper install
/usr/lib/mysql/mysql-systemd-helper upgrade

exec /usr/lib/mysql/mysql-systemd-helper start
