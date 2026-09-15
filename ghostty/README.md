# Ghostty Configuration

Ghostty is managed like the rest of this repo: the versioned source of truth
lives in `home/Library/Application Support/com.mitchellh.ghostty/config.ghostty`, and Home Manager links it to:

`~/Library/Application Support/com.mitchellh.ghostty/config.ghostty`

That path matches Ghostty's preferred macOS config location and avoids the
split-brain of keeping a second copy under `~/.config`.

## Apply changes

```bash
cd ~/.dotfiles
./rebuild.sh
```

Then reload Ghostty from the app menu or restart it.
