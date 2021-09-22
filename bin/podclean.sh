#!/bin/zsh
############
### zsh script to clear cocoapods caches
###
############

function cleanCocoapods() {
    rm -rf "${HOME}/Library/Caches/CocoaPods\ Pods"
    rm -rf "${HOME}/Library/Developer/Xcode/DerivedData"
    rm -rf "${HOME}/Library/Caches/CocoaPods"
    rm -rf "`pwd`/Pods/"
    pod cache clean --all
    pod deintegrate
    pod install --repo-update
}

# ensures that you are inside a Xcode 
function ensureCocoapods() {
	local cocoapods return variable=$1

	cocoapods=(Pods/)

	if [ -e "${cocoapods}" ]; then
		return=true
	else
		return=false
	fi

	eval $variable="'$return'"
}

# script main entry point
unsetopt nomatch

ensureCocoapods contains_pod_folder

if $contains_pod_folder; then
	echo "✓ Cleaning Cocoapods..."
	cleanCocoapods
else 
    echo "⨯ No Pods folder found"
fi

