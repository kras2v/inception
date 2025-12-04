#!/bin/sh

set -e
echo "Wordpress entrypoint started"

DATA_DIR=/var/www/html

connect_to_mariadb() {
	echo "Connecting to MariaDB at $WORDPRESS_DB_HOST:3306 as $WORDPRESS_DB_USER"
	export MYSQL_PWD=$1

	until mariadb -h "$WORDPRESS_DB_HOST" -P 3306 -u "$WORDPRESS_DB_USER" -e "SELECT 1;" >/dev/null 2>&1; do
	    echo "Waiting for MariaDB..."
	    sleep 1
	done

	unset MYSQL_PWD
	echo "MariaDB is ready, continuing..."
}

install_wp() {
	mkdir -p "$DATA_DIR"
	cd "$DATA_DIR"

	chown -R www-data:www-data "$DATA_DIR"

	if [ -n "$WORDPRESS_DB_PASSWORD_FILE" ]; then
	    local WORDPRESS_DB_PASSWORD=$(cat "$WORDPRESS_DB_PASSWORD_FILE")
	fi
	
	gosu www-data wp core download
	
	mv /tmp/myresume.html .
	connect_to_mariadb $WORDPRESS_DB_PASSWORD
	

    	if [ ! -f "$WP_DIR/wp-config.php" ]; then
		gosu www-data wp config create \
		--dbname=$WORDPRESS_DB_NAME \
		--dbuser=$WORDPRESS_DB_USER \
		--dbpass=$WORDPRESS_DB_PASSWORD \
		--dbhost=$WORDPRESS_DB_HOST
	        echo "wp-config.php created"
	fi

	gosu www-data wp core install \
	--url="kvalerii.42.fr" \
	--title="kvalerii website" \
	--admin_user="su_kvalerii" \
	--admin_password="su_kvalerii" \
	--admin_email="su_kvalerii@mail.org"
	
	gosu www-data wp user create \
	"simpleuser" \
	"simpleuser@mail.com" \
	--user_pass="simpleuser" \
	--role="subscriber"

	echo "Wordpress installed"
}

install_wpcli() {
	wget -q -O /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	
	chmod +x /usr/local/bin/wp
	echo "Wordpress cli installed"
}

adduser -D -H -u 82 -G www-data -s /bin/nologin www-data
if [ ! -f "$DATA_DIR/index.php" ]; then
	install_wpcli
	install_wp
fi

exec "$@"





