#!/bin/sh

# load environment variables
set -e

export VERSION=`cat VERSION || echo Unknown`

echo "Starting nextjs-git-app $VERSION"

# check required env variable set
if [[ -z "${REPO_URL}" ]]; then
    echo "Missing ENV variable: REPO_URL"
    exit 1
fi

HAS_SSH_KEY=1

if [[ ! -f id_git ]]; then
    echo "SSH key "/id_git" missing"
    HAS_SSH_KEY=0
else
    # we need 600 so ssh will open it
    cp /id_git /id_git.priv
    chmod 600 /id_git.priv
fi

if [[ "$HAS_SSH_KEY" -eq 1 ]]; then
    if [[ "${REPO_URL}" == "http"* ]]; then
        echo "SSH key only works with SSH repo urls"
        exit 1
    fi
fi

# fix git complaining about ownership of /app
# fatal: detected dubious ownership in repository at '/app'
git config --global --add safe.directory /app

# check if the repo has been cloned
if [[ "$(ls -A app)" ]]; then
    echo "/app not empty, please empty /app if you want the repository to be re-cloned"
else
    # delete all files in app dir (including hidden), but not the app dir itself
    find app -mindepth 1 -delete || exit 1
    echo "Cloning Repository..."
    if [[ "$HAS_SSH_KEY" -eq 1 ]]; then
        GIT_TERMINAL_PROMPT=0 git clone -c "core.sshCommand=ssh -i /id_git.priv -o StrictHostKeyChecking=no -F /dev/null" -q "${REPO_URL}" app || (echo "Cloning failed, please check the supplied SSH key '/id_git' is valid"; exit 1)
    else
        GIT_TERMINAL_PROMPT=0 git clone -q "${REPO_URL}" app || (echo "Cloning failed, you may need to supply an SHH key ('/id_git')"; exit 1)
    fi
fi

cd app

echo "Pulling latest..."
git pull

dos2unix entrypoint.sh
chmod +x entrypoint.sh

if [[ -f healthcheck.sh ]]; then
    dos2unix healthcheck.sh
fi

echo "Starting app entrypoint.sh"
./entrypoint.sh
