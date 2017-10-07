#!/usr/bin/env bash
MYPATH=$(dirname "$0")

. "$MYPATH/ColorEchoForShell/dist/ColorEcho.bash"

#determinate path to compress and generate map or not
if [ -z "$1" ]; then
    TARGET='.'
    NP=false
else
    if [ "$1" = "--no-map" ]; then
        TARGET='.'
        NP=true
    else
        TARGET="$1"
        if [ ! -z "$2" ] && [ "$2" = "--no-map" ]; then
            NP=true
        else
            NP=false
        fi
    fi
fi

types=(js css)
#For storing the URL of API to minify the files
declare -A urls
urls[js]="http://javascript-minifier.com/raw"
urls[css]="http://cssminifier.com/raw"

echo.BoldCyan "Scaning direcotry..."

#list all the directories except git directory
for dir in $(find "$TARGET" -type d | grep -E -v '\.git(\/|$)')
do
    if [ ! -w "$dir" ]; then
        echo.BoldRed "$dir is not writable, ignore it."
        continue
    fi
    (
    cd "$dir" || exit
    for filetype in "${types[@]}"
    do
        echo.Green "Finding $filetype to be compressed under $dir ..."
        #list js/css files exclude already minified files
        for filename in $(ls *.$filetype 2> /dev/null | sed "s/\.$filetype$//g" | grep -v '\.min$')
        do
            do_min=0
            #check if exist a minified version
            if [ -f "${filename}.min.$filetype" ]; then
                #already exist a minified version, compare the modify time to decide compressing or not
                if [ "${filename}.min.${filetype}" -ot "${filename}.${filetype}" ]; then
                    do_min=1
                fi
            elif [ $(wc -l "$filename.$filetype" | awk '{print $1}') -ge 15 ] || [ $(grep -E $'^(\t|\ )' "$filename.$filetype"  | wc -l) -ge 5 ]; then
                do_min=1
            else
                echo.Yellow "$filename.$filetype is small enough, not be minified:"
                echo.Yellow "It doesn't have more than 15 lines."
                echo.Yellow "Or it doesn't have more than 5 lines with tab(s) and blank(s) in the head of sentences."
            fi
            MAP_OP=""
            if [ 0 -lt $do_min ]; then
                echo.Magenta "Compressing $filename.$filetype ..."
                if [ ! "$NP" = "true" ]; then
                    MAP_OP="--source-map"
                fi
                if [ "$filetype" = "css" ]; then
                    "$MYPATH/node_modules/clean-css-cli/bin/cleancss" --compatibility $MAP_OP --s0 -o "${filename}.min.$filetype" "$filename.$filetype"
                else
                    "$MYPATH/node_modules/uglify-js/bin/uglifyjs" --mangle --compress if_return=true $MAP_OP -o "${filename}.min.$filetype" "${filename}.$filetype" || "$MYPATH/node_modules/uglify-es/bin/uglifyjs" --mangle --compress if_return=true $MAP_OP -o "${filename}.min.$filetype" "${filename}.$filetype"
                fi
                if [ ! $? -eq 0 ]; then
                    echo.Red "local compressor failed, now try to compress with javascript-/cssminifier.com"
                    curl -X POST -s --data-urlencode "input@${filename}.$filetype" ${urls[$filetype]} > "${filename}.min.$filetype"
                fi
            fi
        done
    done
    )
done

echo.BoldGreen "All done!"
