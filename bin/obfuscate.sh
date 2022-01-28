#!/bin/zsh
############
### zsh script to generate obfuscate strings from a given key
###
############

# Ensures both parameters are provided
# OBFUSCATOR_KEY: $1 
# STRING_TO_BE_OBFUSCATED: $2

function ensureParameters() {
    [[ -z $1 && -z $2 ]] && return false || return true
}

# script main entry point
unsetopt nomatch

ensureParameters contains_paramns

if $contains_paramns; then
    echo "✓ Obfuscation initiated..."
    echo "OBFUSCATOR_KEY: $1"
    echo "STRING_TO_BE_OBFUSCATED: $2"
    echo "################################# \n"
    
    SHA1HashKey=$(echo -n $1 | shasum | cut -b 1-40 | tr -d \\n)
    obfuscationTargetHex=$(echo -n $2 | xxd -pu | tr -d \\n)

    SHA1HashKeyLength=${#SHA1HashKey}
    obfuscationTargetHexLength=${#obfuscationTargetHex}

    # echo "SHA1HashKey: $SHA1HashKey"
    # echo "obfuscationTargetHex: $obfuscationTargetHex"
    # echo "SHA1HashKeyLength: $SHA1HashKeyLength"
    # echo "obfuscationTargetHexLength: $obfuscationTargetHexLength"
    # echo "###################################### \n"

    xorArray=()

    for ((i = 0; i < $obfuscationTargetHexLength; i += 2)); do

        obfuscatorSHA1Position=$(expr $i % $SHA1HashKeyLength)
        obfuscatorHashChar=${SHA1HashKey:$obfuscatorSHA1Position:2}
        targetStringChar=${obfuscationTargetHex:$i:2}

        echo "obfuscatorSHA1Position: ${obfuscatorSHA1Position}"
        echo "obfuscatorHashChar: ${obfuscatorHashChar}"
        echo "targetStringChar: ${targetStringChar}"

        obfuscatorHashChar=$(echo $obfuscatorHashChar | sed "s/../0x& /g")
        targetStringChar=$(echo $targetStringChar | sed "s/../0x& /g")

        echo "obfuscatorHashChar: ${obfuscatorHashChar}"
        echo "targetStringChar: ${targetStringChar}"

        let "xorResult = $obfuscatorHashChar ^ $targetStringChar"
        xorResultHex=$(printf "%02x" $xorResult)
        echo "xorResult: ${xorResult}"
        echo "xorResultHex: ${xorResultHex}"

        xorArray+=("0x${xorResultHex}")
        echo "$obfuscatorHashChar XOR $targetStringChar = $xorResultHex"
        echo "\n"

        obfuscatedString=$obfuscatedString$xorResultHex
    done

    echo "Result: $obfuscatedString"
    echo "XOR Result: $xorArray"
else
    echo "❌ Obfuscation failed..."
    echo "Please provide two parameters in the order:"
    echo "./obfuscate.sh OBFUSCATOR_KEY \"TEXT_TO_BE_OBFUSCATED\""
fi
