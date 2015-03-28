#!/bin/bash

#ls time format depends on OS
if [ "FreeBSD" = `uname` ] || [ "Darwin"  = `uname` ]; then
    LS='ls -l -D %Y%m%d%H%M%S'
else
    LS='ls -l --time-style +%Y%m%d%H%M%S'
fi

types=(js css)
#For storing the URL of API to minify the files
declare -A urls
urls[js]="http://javascript-minifier.com/raw"
urls[css]="http://cssminifier.com/raw"

echo "Scaning direcotry..."

#list all the directories except git directory
for dir in `find . -type d | grep -v \/\.git\/`
do
    for filetype in "${types[@]}"
    do
        echo "Finding $filetype to be compressed under $dir ..."
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
                echo "Compressing $filename.$filetype ..."
                curl -X POST -s --data-urlencode "input@$filename.$filetype" ${urls[$filetype]} > $filename\.min.$filetype
            fi
        done
    done
done

echo "All done!"
