#!/usr/bin/env bash

host="laravel_eleven_app_mysql"
shift
port="3306"
shift

cmd="$@"

until nc -z "$host" "$port"; do
    >&2 echo "MySQL is unavailable - sleeping"
    sleep 1
done

>&2 echo "MySQL is up - executing command"
exec $cmd