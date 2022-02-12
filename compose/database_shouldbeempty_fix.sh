podman-compose exec db mysql -u crater -p crater -e "drop database crater"
podman-compose exec db mysql -u crater -p crater -e "create database crater"
podman-compose exec app rm -rf /var/www/storage/app/database_created
