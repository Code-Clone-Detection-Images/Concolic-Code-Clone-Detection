#!/bin/sh

source /varsrc

echo " - Cleaning up"

echo "   - removing archives"
rm "$HOME_FOLDER/cccd.zip"
rm "$HOME_FOLDER/$CREST_FILE"
rm "$HOME_FOLDER/$CTAGS_FILE"
rm "/$YICES"

echo "   - removing installers"
rm "/install-yices.sh"

echo "   - removing test data"
rm "/kraw-expected.csv"
rm "/validate-test.py"

# We do not, as run needs them
# echo "   - removing variables"
# rm "/varsrc"

echo "   - remove scripts"
rm /install-cccd.sh
rm /install-java.sh
rm /setup-cccd.sh
rm /setup-crest.sh
rm /setup-ctags.sh
rm /setup-fedora.sh
rm /test-cccd.sh
rm /patching.sh
rm /cleanup.sh


echo "   - clean up dnf"
sudo dnf clean all

# https://opam.ocaml.org/doc/man/opam-clean.html
echo "   - clean up opam"
opam clean --yes --logs --download-cache --switch-cleanup --repo-cache --unused-repositories

echo "   - set \"\"\"permissions \"\"\" for fedora-user"
chmod -R 777 "$HOME_FOLDER"

echo " =Installed================================================ "
dnf list installed