source /varsrc
cd "$HOME_FOLDER"

echo " - Installing CTAGS"
wget "http://downloads.sourceforge.net/project/ctags/ctags/$CTAGS_VERSION/$CTAGS_FILE"
dnf install -y "$CTAGS_FILE"