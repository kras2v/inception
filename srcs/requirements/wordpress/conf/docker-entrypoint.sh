#!/bin/sh

set -e
echo "Wordpress entrypoint started"

DATA_DIR=/var/www/html
CACHE_DIR=/home/www-data/.wp-cli/cache

install_wp() {
	mkdir -p "$DATA_DIR"
	cd "$DATA_DIR"
	echo "1"
	if ! id "www-data" >/dev/null 2>&1; then
		
	   	if ! getent group www-data >/dev/null 2>&1; then
		    addgroup -g 82 www-data
		    echo "Group www-data created with GID 82"
		else
		    echo "Group www-data already exists"
		fi
		adduser -D -H -u 82 -G www-data -s /bin/nologin www-data
	fi
	
	chown -R www-data:www-data "$DATA_DIR"
	
	mkdir -p "$CACHE_DIR"
	chown -R www-data:www-data "$CACHE_DIR"
	export WP_CLI_CACHE_DIR="$CACHE_DIR"

	if [ -n "$WORDPRESS_DB_PASSWORD_FILE" ]; then
	    local WORDPRESS_DB_PASSWORD=$(cat "$WORDPRESS_DB_PASSWORD_FILE")
	fi
	
	echo "3"
	gosu www-data wp core download
	
	echo "Connecting to MariaDB at $WORDPRESS_DB_HOST:3306 as $WORDPRESS_DB_USER"
	export MYSQL_PWD="$WORDPRESS_DB_PASSWORD"

	until mariadb -h "$WORDPRESS_DB_HOST" -P 3306 -u "$WORDPRESS_DB_USER" -e "SELECT 1;" >/dev/null 2>&1; do
	    echo "Waiting for MariaDB..."
	    sleep 1
	done

	unset MYSQL_PWD
	echo "MariaDB is ready, continuing..."

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
	wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	
	chmod +x wp-cli.phar
	mv wp-cli.phar /usr/local/bin/wp
	echo "Wordpress cli installed"
}

if [ ! -f "$DATA_DIR/index.php" ]; then
	install_wpcli
	install_wp
fi

exec "$@"





