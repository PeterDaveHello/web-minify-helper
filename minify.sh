#!/usr/bin/env bash
MYPATH=`dirname "$0"`

. $MYPATH/ColorEchoForShell/dist/ColorEcho.bash

#ls time format depends on OS
if [ "FreeBSD" = `uname` ] || [ "Darwin"  = `uname` ]; then
    LS='ls -l -D %Y%m%d%H%M%S'
else
    LS='ls -l --time-style +%Y%m%d%H%M%S'
fi

if [ -z "$1" ]; then
    TARGET='.'
else
    TARGET=$1
fi

types=(js css)
#For storing the URL of API to minify the files
declare -A urls
urls[js]="http://javascript-minifier.com/raw"
urls[css]="http://cssminifier.com/raw"

echo.BoldCyan "Scaning direcotry..."

#list all the directories except git directory
for dir in `find $TARGET -type d | grep -v \/\.git\/`
do
    if [ ! -w $dir ]; then
        echo.BoldRed "$dir is not writable, ignore it."
        continue
    fi

    for filetype in "${types[@]}"
    do
        echo.Green "Finding $filetype to be compressed under $dir ..."
        #list js/css files exclude already minified files
        for filename in `ls $dir/*.$filetype 2> /dev/null | sed "s/\.$filetype$//g" | grep -v .min$`
        do
            do_min=0
            #echek if exist a minified version
            if [ -f $filename\.min\.$filetype ]; then
                #already exist a minified version, compare the modify time to decide compressing or not
                orig_ver_time=`eval $LS $filename\.$filetype | awk '{print $6}'`
                mini_ver_time=`eval $LS $filename\.min\.$filetype | awk '{print $6}'`
                if [ $mini_ver_time -lt $orig_ver_time ]; then
                    do_min=1
                fi
            else
                do_min=1
            fi
            if [ 0 -lt $do_min ]; then
                echo.Magenta "Compressing $filename.$filetype ..."
                if [ "$filetype" = "css" ]; then
                    $MYPATH/node_modules/clean-css/bin/cleancss --compatibility --source-map --s0 -o $filename\.min.$filetype $filename.$filetype
                else
                    $MYPATH/node_modules/uglify-js/bin/uglifyjs --mangle --compress if_return=true --source-map $filename\.min.$filetype\.map -o $filename\.min.$filetype $filename.$filetype
                fi
                if [ ! $? -eq 0 ]; then
                    echo.Red "yuicompressor failed, try javascript-/cssminifier.com"
                    curl -X POST -s --data-urlencode "input@$filename.$filetype" ${urls[$filetype]} > $filename\.min.$filetype
                fi
            fi
        done
    done
done

echo.BoldGreen "All done!"
