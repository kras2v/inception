#!/bin/sh

#set -e
echo "Wordpress entrypoint started"

DATA_DIR=/data/wordpress

install_wp() {
	cd $DATA_DIR
	mkdir -p /var/www
	chown -R www-data:www-data /var/www

	gosu www-data wp core download

	gosu www-data wp config create \
	--dbname=$WORDPRESS_DB_NAME \
	--dbuser=$WORDPRESS_DB_USER \
	--dbpass=$WORDPRESS_DB_PASSWORD \
	--dbhost=$WORDPRESS_DB_HOST

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





