#!/bin/bash -e

echo "Backing up config files in 'files'..."
find "./files" -type f -exec bash -c '
  target="{}"
  source="$HOME/${target#./files/}" # Replace common dir of files with $HOME
  cp -afv "$source" "$target"
' \;

echo "Retrieving list of installed Homebrew packages..."
brew leaves -1 > scripts/10_brew/packages.list
brew cask list -1 > scripts/10_brew/packages-cask.list

echo "Retrieving list of installed/disabled Atom plugins..."
apm ls --disabled --bare | sed 's/@.*$//' | sed '/^$/d' > scripts/atom-plugins/disabled.list
apm ls --installed --bare | sed 's/@.*$//' | sed '/^$/d' > scripts/atom-plugins/installed.list

echo ""
echo "Copied files from $HOME into the repository."
echo "Please do not forget to commit and push the changes."