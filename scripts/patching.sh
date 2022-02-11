source /varsrc

echo "   - patching the cccd script"

mv "/cccd.new" "$CCCD_DIRTY/bashScripts/cccd"
chmod +x "$CCCD_DIRTY/bashScripts/cccd"