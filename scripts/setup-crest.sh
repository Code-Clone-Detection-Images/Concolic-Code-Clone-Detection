source /varsrc
cd "$HOME_FOLDER"

echo " - Installing CREST [v$CREST_VERSION | $CREST_FILE | $CREST_FOLDER]"
# the github tarball and zipball are broken
if [ -f "/$CREST_FILE" ]; then
   echo "    - Found offline CREST"
   mv "/$CREST_FILE" "$HOME_FOLDER/"
else
   echo "    - Downloading CREST"
   wget "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/crest/$CREST_FILE"
fi
tar -xvzf "$CREST_FILE"

# Note: we do not install here as there will be modifications with cccd