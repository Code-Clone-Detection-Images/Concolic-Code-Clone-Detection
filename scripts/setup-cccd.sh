source /varsrc

cd "$HOME_FOLDER"

echo " - Downloading CCCD base"

# svn seems to be broken
# wget https://storage.googleapis.com/google-code-archive-source/v2/code.google.com/dk-crest-java/source-archive.zip -O cccd.zip
# TODO: update offline command
mv /cccd.zip "$HOME_FOLDER/"
unzip cccd.zip
