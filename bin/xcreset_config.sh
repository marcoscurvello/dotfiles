#!/bin/zsh
############
### script backup current xcode settings and reset to default
###
############

# backup function
function backupXcodeConfigs() {
	setopt nomatch
    local filename="com.apple.dt.Xcode-$(date +"%Y-%m-%d_%H%M%S")"

    echo "Creating: $filename"
    defaults read com.apple.dt.Xcode > "$HOME/.dotfiles/xcode/config-backups/$filename"

    # if [ "defaults read com.apple.dt.Xcode > "~/.dotfiles/xcode/config-backups/$filename"" ]; then
    #     echo "Creating: $filename"
    #     defaults read com.apple.dt.Xcode > "~/.dotfiles/xcode/config-backups/$filename"
    # else 
    #     echo "FUCK THIS"
    # fi
    
    
    
}

# ensures that you have a Xcode config file
# function ensureConfigExists() {

#     if [ defaults read com.apple.dt.Xcode ]; then
#         return $(true)
#     else
#         return $(false)
#     fi
# }

# script main entry point
unsetopt nomatch

backupXcodeConfigs


# ensureConfigExists contains_xcode_config

# if $contains_xcode_config; then
# 	echo "✓ Backing-up Xcode config..."
# 	backupXcodeConfigs
# else
# 	echo "⨯ Xcode config not found"
# fi