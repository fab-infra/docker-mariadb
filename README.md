[![build](https://github.com/fab-infra/docker-mariadb/actions/workflows/build.yml/badge.svg)](https://github.com/fab-infra/docker-mariadb/actions/workflows/build.yml)

# MariaDB Docker image

## Ports

The following ports are exposed by this container image.

| Port | Description |
| ---- | ----------- |
| 3306 | TCP port |

## Environment variables

The following environment variables can be used with this container.

| Variable | Description | Default value |
| -------- | ----------- | ------------- |
| MYSQL_ROOT_PASSWORD | Root password | |
| MYSQL_DATABASE | Database(s) to create (comma-separated) | |
| MYSQL_USER | User name to create | |
| MYSQL_PASSWORD | User password | |

## Volumes

The following container paths can be used to mount a dedicated volume or to customize configuration.

| Path | Description |
| ---- | ----------- |
| /var/lib/mysql | Database directory |

## Useful links

- [MariaDB documentation](https://mariadb.com/kb/en/documentation/)
