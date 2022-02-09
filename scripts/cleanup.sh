#!/bin/sh

source /varsrc
source /varsrc-extra

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

echo "   - removing variables"
rm "/varsrc"
rm "/varsrc-extra"

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