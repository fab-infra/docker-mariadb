# MariaDB server based on openSUSE Leap 15.4
FROM ghcr.io/fab-infra/base-image:opensuse15.4

# MariaDB
RUN zypper in -y mariadb &&\
	zypper clean -a

# Files
COPY ./root /
RUN chmod a+rw /etc/passwd /etc/group &&\
	mkdir -p /var/lib/mysql /var/run/mysql &&\
	chmod -R a+rwX /var/lib/mysql /var/run/mysql &&\
	sed -i 's/^systemd-tmpfiles/#systemd-tmpfiles/g' /usr/lib/mysql/mysql-systemd-helper

# Ports
EXPOSE 3306
