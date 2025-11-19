#!/bin/sh
set -e
echo "Mariadb entrypoint started"

DATA_DIR=/data/mariadb

sql_escape_string_literal() {
	local newline=$'\n'
	local escaped=${1//\\/\\\\}
	escaped="${escaped//$newline/\\n}"
	echo "${escaped//\'/\\\'}"
}

setup_db() {
	local SQL=""

	if [ -n "$MARIADB_ROOT_PASSWORD" ]; then
		local rootPasswordEscaped=$(docker_sql_escape_string_literal "${MARIADB_ROOT_PASSWORD}")
		SQL+="ALTER USER 'root'@'localhost' IDENTIFIED BY '${rootPasswordEscaped}';"$'\n'
	fi
	
	if [ -n "$MARIADB_DATABASE" ]; then
		SQL+="CREATE DATABASE IF NOT EXISTS \`$MARIADB_DATABASE\`;"$'\n'
	fi

	if  [ -n "$MARIADB_PASSWORD" ] && [ -n "$MARIADB_USER" ]; then
		local userPasswordEscaped=$(docker_sql_escape_string_literal "${MARIADB_PASSWORD}")
		SQL+="CREATE USER '$MARIADB_USER'@'%' IDENTIFIED BY '$userPasswordEscaped';"$'\n'
		if [ -n "$MARIADB_DATABASE" ]; then
			SQL+="GRANT ALL ON \`${MARIADB_DATABASE//_/\\_}\`.* TO '$MARIADB_USER'@'%';"$'\n'
			SQL+="FLUSH PRIVILEGES;"$'\n'
		fi
	fi

	if [ -n "$SQL" ]; then
		echo "Initializing database..."
		mysqld --datadir="$DATA_DIR" --skip-networking --user=mysql &

		local MARIADB_PID=$!
	        until mariadb -e "SELECT 1" &>/dev/null; do sleep 0.5; done
	        
		echo "$SQL" | mariadb

		kill "$MARIADB_PID"
        	wait "$MARIADB_PID"
	fi
	
}

echo "UID ->> " | id -u mysql | cat 

if [ ! -d "$DATA_DIR/mysql" ]; then
  echo "Data directory is empty. Running initial setup..."  
  chown -R mysql:mysql $DATA_DIR
  mariadb-install-db --user=mysql --basedir=/usr --datadir="$DATA_DIR"
  docker_setup_db
fi

exec gosu mysql "$@"
