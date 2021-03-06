#!/bin/bash
#
# Convenience script to run the "runserver" debug server, as the correct user,
# with DEBUG=True.
#

# Load config
DIR="$( builtin cd "$( dirname "$( readlink -f "${BASH_SOURCE[0]}" )" )" && pwd )"
source "$DIR/load_config.sh"

# allow port to change
port=8000
if [ $# -ge 1 ]; then
	port=$1
fi

# kill the public nginx/gunicorn server, if running
bash "$DIR/nginx_make_private.sh"

# set DEBUG=True
F="$SRC_SETTINGS_DIR/settings_local.py"
sed -r -i -e 's/^\s*DEBUG\s*=.*$/DEBUG = True/' "$F"
echo "setting DEBUG=True in $SRC_SETTINGS_DIR/settings_local.py"

# start the private webserver
bash "$DIR/django_collect_static.sh"
builtin cd "$SRC_DIR"
sudo -u $SERVER_USER ./manage.py runserver 0.0.0.0:$port
