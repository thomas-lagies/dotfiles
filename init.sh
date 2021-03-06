#!/bin/bash

# https://stackoverflow.com/questions/59895/getting-the-source-directory-of-a-bash-script-from-within
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

pushd "${dir}" || exit 1

. ./lib/common.sh

echo "Sourcing private environment variables..."
if [ -f "/vagrant/private/environment" ]; then
  . "/vagrant/private/environment"
fi

if [ -f "${HOME}/dotfiles/private/environment" ]; then
  . "${HOME}/dotfiles/private/environment"
fi

if [ "$1" != "--no-scripts" ]; then
  echo "Executing scripts in 'scripts'..."
  find -s "./scripts" -name '*.sh' -type f -exec bash -c '
    if [ -x "$1" ]; then
      echo "Running $1..."
      cd "$(dirname $1)"
      "./$(basename $1)"
    fi
  ' _ {} \;

  if [ $? != 0 ]; then
    echo "Error running scripts. Abort."
    exit 1
  fi
fi

echo "Restoring config files..."
find "./files" -type f -exec bash -c '
  file="$1"
  target="${file#./files}"       # Remove common dir of files
  targetPath="${target%/*}"      # Path without filename
  mkdir -p "$HOME$targetPath"
  cp -afv "$file" "$HOME$target"
' _ {} \;

if [ $? != 0 ]; then
  echo "Error restoring files. Abort."
  exit 1
fi

popd || exit 1

echo ""
echo "Done: System has been (re-)initialized."
