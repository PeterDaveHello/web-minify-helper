#!/bin/bash

#ls time format depends on OS
if [ "FreeBSD" = `uname` ] || [ "Darwin"  = `uname` ]; then
    LS='ls -l -D %Y%m%d%H%M%S'
else
    LS='ls -l --time-style +%Y%m%d%H%M%S'
fi

echo "Scaning direcotry..."

#list all the directories except git directory
for dir in `find . -type d | grep -v \/\.git\/`
do
    echo "Finding js to be compressed under $dir ..."
    #list js files exclude already minified files
    for js in `ls $dir/*.js 2> /dev/null | sed 's/\.js//g' | grep -v \.min$`
    do
        do_min=0
        #echek if exist a minified version
        if [ -f  $js\.min\.js ]; then
            #already exist a minified version, compare the modify time to decide compressing or not
            orig_ver_time=`eval $LS $js\.js | awk '{print $6}'`
            mini_ver_time=`eval $LS $js\.min\.js | awk '{print $6}'`
            if [ $mini_ver_time -lt $orig_ver_time ]; then
                do_min=1
            fi
        else
            do_min=1
        fi
        if [ 0 -lt $do_min ]; then
            echo "Compressing $js.js ..."
            curl -X POST -s --data-urlencode "input@$js.js" http://javascript-minifier.com/raw > $js\.min.js
        fi
    done
    #list css files exclude already minified files
    echo "Finding css to be compressed under $dir ..."
    for css in `ls $dir/*.css 2> /dev/null | sed 's/\.css//g' | grep -v \.min$`
    do
        do_min=0
        #echek if exist a minified version
        if [ -f  $css\.min\.css ]; then
            #already exist a minified version, compare the modify time to decide compressing or not
            orig_ver_time=`eval $LS $css\.css | awk '{print $6}'`
            mini_ver_time=`eval $LS $css\.min\.css | awk '{print $6}'`
            if [ $mini_ver_time -lt $orig_ver_time ]; then
                do_min=1
            fi
        else
            do_min=1
        fi
        if [ 0 -lt $do_min ]; then
            echo "Compressing $css.css ..."
            curl -X POST -s --data-urlencode "input@$css.css" http://cssminifier.com/raw > $css\.min.css
        fi
    done
done

echo "All done!"
