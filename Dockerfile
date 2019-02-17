# MariaDB server based on openSUSE Leap 15
FROM fcrespel/base-image:opensuse15

# MariaDB
RUN zypper in -y mariadb &&\
	zypper clean -a

# Files
COPY ./root /
RUN chmod +x /run.sh &&\
	chmod a+rw /etc/passwd /etc/group &&\
	mkdir -p /var/lib/mysql &&\
	chmod -R a+rwX /var/lib/mysql /var/run/mysql

# Ports
EXPOSE 3306
