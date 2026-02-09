# Production-Ready Docker Compose Web Server

## Docker Compose based web server stack with Nginx and Laravel

- Container Architecture:
  - App Container: php:8.4-fpm-alpine
  - Web Server Container: nginx:1.26-alpine
  - Db Container: mariadb:11.4
  - Network: bridge network

## Setup Directory & Environment

🔹 Directory Structure

```bash
{PROJECT_DIR}/
│ ├── mysql/
│ │ └── Dockerfile
│ │ └── conf.d
│ │ │ └── my.cnf
│ ├── nginx/
│ │ └── default.conf
│ └── php/
│ │ └── Dockerfile
│ │ └── php.ini
│ │ └── www.conf
├── .env
├── set-permissions.sh
└── docker-compose.yml
```

🔹 Create a project directory

<sub>_Must match PROJECT_DIR in .env_</sub>

```bash
sudo mkdir -p /srv/windocker/laravelnginx

sudo chown -R $USER:$USER /srv/windocker/laravelnginx
sudo chmod -R 755 /srv/windocker/laravelnginx
```

<sub>_Keep working in this directory_</sub>

```bash
cd /srv/windocker/laravelnginx
```

🔹 Clone the repository or download-upload manually via SFTP.

```bash
git clone https://github.com/anamseri/docker-compose-web-server.git .
```

🔹 Set Docker Compose Environment

```bash
cp .env.anamseri .env
ls -l .env

nano .env
```

<sup>_Configure environment_</sup>

## Setup Permissions

```bash
chmod +x set-permissions.sh

./set-permissions.sh
```

## Deploy Docker Compose

```bash
docker compose up -d

or:
docker compose up -d --build


Rebuild:
docker compose down -v
docker builder prune -af
docker compose build --no-cache
docker compose up -d
```

🔹 Check container:

```bash
docker compose ps
```

🔹 Debug:

```bash
docker compose logs app
docker compose logs nginx
docker compose logs db
```

🔹 Check internal connectivity and ensure a reply.

```bash
docker compose exec nginx ping app
```

🔹 Access

```bash
http://<IP-HOST>:8081

Example:
http://192.168.1.103:8081
```

# Install or Upload Laravel Project

🔹 Check path app:

```bash
docker compose exec app ls /var/www

ls -ld wwwapp
drwxrwxr-x . www-data www-data .... ...  . ..:.. wwwapp
```

🔹 Recreate directory (if needed)

<sub>_Make sure it matches PATH_APP in .env_</sub>

```bash
ls -al
sudo rm -rf ./wwwapp
mkdir -p ./wwwapp

sudo chown -R www-data:www-data ./wwwapp
sudo chmod -R 775 ./wwwapp

docker compose restart
```

🔹 Check composer in app container

```bash
Try running:
docker compose exec app which composer

or:
docker compose exec app composer --version
```

<sup>_If empty, app container has no composer binary._</sup>
<sub>_The solution is to rebuild the PHP image without cache._</sub>

```bash
docker compose build --no-cache app

Restart container:
docker compose up -d

Check again:
docker compose exec app composer --version
```

<sup>Composer version 2.9.5 2026-01-29 11:40:53</sup>
<sup>PHP version 8.4.17 (/usr/local/bin/php)</sup>
<sup>...</sup>

> **INSTALL NEW LARAVEL**
>
> ```bash
> docker compose exec -w /var/www/wwwapp app composer create-project --no-dev laravel/laravel .
> or:
> docker compose exec app composer create-project --no-dev laravel/laravel .
> ```

> **CLONE OR UPLOAD LARAVEL PROJECT**
>
> ```bash
> docker compose exec -u www-data app git clone https://github.com/laravel/laravel.git .
>
>
> Or: (Dev Only, Not Production)
> Upload Laravel project into the ./wwwapp directory
> Then:
> sudo chown -R www-data:www-data wwwapp/*
>
>
>
> Update vendor:
>
> docker compose exec -w /var/www/wwwapp app composer install --no-dev --optimize-autoloader --no-interaction
> or:
> docker compose exec app composer install --no-dev --optimize-autoloader --no-interaction
> ```

🔹 Set up .env (Skip if exist)

```bash
docker compose exec app cp /var/www/wwwapp/.env.example /var/www/wwwapp/.env
or:
docker compose exec app cp .env.example .env
```

🔹 Configure .env

```bash
sudo nano wwwapp/.env
```

<sub>_Make sure it matches with .env docker compose_</sub>

```bash
DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=dblaranginx
DB_USERNAME=dbuser
DB_PASSWORD=dbpassword
```

<sup>_Adjust other configurations as needed_</sup>

🔹 Set Laravel permissions

```bash
docker compose exec app find /var/www/wwwapp -type d -exec chmod 755 {} \;
or:
docker compose exec app find -type d -exec chmod 755 {} \;


docker compose exec app find /var/www/wwwapp -type f -exec chmod 644 {} \;
or:
docker compose exec app find -type f -exec chmod 644 {} \;


docker compose exec app chmod -R 775 /var/www/wwwapp/storage /var/www/wwwapp/bootstrap/cache
or:
docker compose exec app chmod -R 775 storage bootstrap/cache

```

🔹 Set .env laravel permissions

```bash
docker compose exec app chmod -R 600 /var/www/wwwapp/.env
or:
docker compose exec app chmod -R 600 .env
```

🔹 Generate key (if needed)

```bash
docker compose exec app php /var/www/wwwapp/artisan key:generate
or:
docker compose exec app php artisan key:generate
```

🔹 Check db connections

```bash
docker compose exec app php artisan db:monitor
```

🔹 Db migrations

```bash
docker compose exec app php /var/www/wwwapp/artisan migrate
or:
docker compose exec app php artisan migrate
```

🔹 Optional: Optimize

```bash
docker compose exec app php /var/www/wwwapp/artisan config:cache
docker compose exec app php /var/www/wwwapp/artisan route:cache
docker compose exec app php /var/www/wwwapp/artisan view:cache
or:
docker compose exec app php artisan config:cache
docker compose exec app php artisan route:cache
docker compose exec app php artisan view:cache
```

🔹 Restart container

```bash
docker compose restart
```

🔹 Access in browser

```bash
http://<IP-HOST>:8081
```
