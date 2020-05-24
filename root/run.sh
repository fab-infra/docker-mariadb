#!/bin/sh

# Load helper script
. /usr/lib/mysql/mysql-systemd-helper >/dev/null

# Start MySQL server with networking disabled
mysql_start_nonet() {
	/usr/sbin/mysqld \
		--defaults-file="$config" \
		--user="$mysql_daemon_user" \
		--skip-networking \
		$ignore_db_dir &
	mysql_wait || die "MySQL failed to start"
}

# Stop MySQL server
mysql_stop() {
	if [ -n "$MYSQL_ROOT_PASSWORD" ]; then
		/usr/bin/mysqladmin --socket="$socket" -uroot -p"$MYSQL_ROOT_PASSWORD" shutdown || die "MySQL failed to shutdown properly"
	else
		/usr/bin/mysqladmin --socket="$socket" -uroot shutdown || die "MySQL failed to shutdown properly"
	fi
}

# Execute MySQL client as root with no password
mysql_exec_nopw() {
	/usr/bin/mysql --socket="$socket" -uroot "$@"
}

# Execute MYSQL client as root with password
mysql_exec() {
	if [ -n "$MYSQL_ROOT_PASSWORD" ]; then
		mysql_exec_nopw -p"$MYSQL_ROOT_PASSWORD" "$@"
	else
		mysql_exec_nopw "$@"
	fi
}

# Perform initial setup
mysql_initial_setup() {
	mysql_install
	mysql_start_nonet

	if [ -n "$MYSQL_ROOT_PASSWORD" ]; then
		echo "Setting root password..."
		echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';" | mysql_exec_nopw
	fi

	echo "Removing insecure defaults..."
	echo "DROP DATABASE IF EXISTS test;" | mysql_exec
	echo "DELETE FROM mysql.user WHERE User='' OR (User='root' AND Host <> 'localhost');" | mysql_exec
	echo "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';" | mysql_exec

	if [ -n "$MYSQL_DATABASE" ]; then
		echo "Creating database $MYSQL_DATABASE..."
		echo "CREATE DATABASE \`$MYSQL_DATABASE\`;" | mysql_exec
	fi

	if [ -n "$MYSQL_USER" -a -n "$MYSQL_PASSWORD" ]; then
		echo "Creating user $MYSQL_USER..."
		echo "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" | mysql_exec
		if [ -n "$MYSQL_DATABASE" ]; then
			echo "Granting user $MYSQL_USER all privileges on database $MYSQL_DATABASE..."
			echo "GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%';" | mysql_exec
		fi
	fi

	mysql_stop
}

# Initialize MySQL if necessary
[ -e "$datadir/mysql" ] || mysql_initial_setup

# Start MySQL server
mysql_start
