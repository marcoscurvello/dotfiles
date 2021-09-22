#!/bin/zsh
############
### zsh script to clear xcode caches and project
###
############

# clean up function
function cleanXcode() {
	setopt nomatch
	pkill -int com.apple.CoreSimulator.CoreSimulatorService
	killall Xcode
	xcrun -k
	xcodebuild -alltargets clean
	rm -rf "$(getconf DARWIN_USER_CACHE_DIR)/org.llvm.clang/ModuleCache"
	rm -rf "$(getconf DARWIN_USER_CACHE_DIR)/org.llvm.clang.$(whoami)/ModuleCache"
	rm -rf "${HOME}/Library/Developer/Xcode/DerivedData/*"
	rm -rf "${HOME}/Library/Caches/com.apple.dt.Xcode/*"
	xed "$TARGET" .
}

# ensures that you are inside a Xcode folder
function ensureFolder() {
	local workspace project return variable=$1

	workspace=(*.xcworkspace)
	project=(*.xcodeproj)

	if [ -e "${workspace}" ] || [ -e "${project}" ]; then
		return=true
	else
		return=false
	fi

	eval $variable="'$return'"
}

# script main entry point
unsetopt nomatch

ensureFolder contains_xcode_project

if $contains_xcode_project; then
	echo "✓ Cleaning Xcode..."
	cleanXcode
else
	echo "⨯ Xcode workspace or project not found"
fi
