#!/usr/bin/env bash

MYPATH=`dirname "$0"`

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

echo "Scaning direcotry..."

#list all the directories except git directory
for dir in `find $TARGET -type d | grep -v \/\.git\/`
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
                java -jar $MYPATH/yuicompressor.jar $filename.$filetype -o $filename\.min.$filetype
            fi
        done
    done
done

echo "All done!"
