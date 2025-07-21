# iTerm2 Configuration

## Important: Don't use symlinks!

iTerm2 preferences should NOT be symlinked because:
- iTerm dynamically updates its plist file while running
- macOS may cache or ignore symlinked preference files
- Symlinks can cause conflicts and corrupted settings

## Managing iTerm2 Preferences

### To backup your current iTerm settings:
```bash
cd ~/.dotfiles
./scripts/iterm-sync.sh backup
```

### To restore iTerm settings on a new machine:
```bash
cd ~/.dotfiles
./scripts/iterm-sync.sh restore
```

**Note:** You must quit iTerm2 before restoring preferences.

## Alternative Method: Using iTerm's Built-in Features

iTerm2 has built-in preference syncing:

1. **To save preferences:**
   - iTerm2 → Settings → General → Preferences
   - Check "Load preferences from a custom folder or URL"
   - Set to: `~/.dotfiles/iterm`
   - Check "Save changes to folder when iTerm2 quits"

2. **To load preferences on a new machine:**
   - Copy the same settings as above
   - Restart iTerm2

## Manual Export/Import

You can also manually export/import:
- **Export:** iTerm2 → Settings → General → Preferences → Save Current Settings to Folder
- **Import:** iTerm2 → Settings → General → Preferences → Load from folder

## Files in this directory

- `com.googlecode.iterm2.plist` - Main preferences file
- Color schemes (`.itermcolors` files) should go in `../iterm-colors/`