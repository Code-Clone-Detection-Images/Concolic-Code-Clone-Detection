source /varsrc
cd "$HOME_FOLDER"

echo " - Installing CREST [v$CREST_VERSION | $CREST_FILE | $CREST_FOLDER]"
# the github tarball and zipball are broken
wget "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/crest/$CREST_FILE"
tar -xvzf "$CREST_FILE"

# Note: we do not install here as there will be modifications with cccd