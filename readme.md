Web minify helper!
========

Let me help to minify the css and js files automatically and easily!

This is only a shell script, depends on curl and bash shell,

and it's based on [javascript-minifier.com](http://javascript-minifier.com) & [cssminifier.com](http://cssminifier.com),

you can support this two sites by using their referral code for Digital Ocean.

(You can got the referral code from their websites, BTW, they aren't my website)

Requirement
========
Bash shell(version > 4.0) & Curl (version > 7.0)

How to use?
========
Use git or curl, wget to get the script:

E.G.

`curl -kO https://raw.githubusercontent.com/PeterDaveHello/web-minify-helper/master/minify.sh` 

`wget  https://raw.githubusercontent.com/PeterDaveHello/web-minify-helper/master/minify.sh` 

`git clone https://github.com/PeterDaveHello/web-minify-helper.git`

Git method is recommended, because it's easy to update and no file permission issue,

if you downloaded the shell script by your self, please give it a executable permission by:
`chmod +x minify.sh`

And go to the directory you want to minify, run the script(`path_of_script/minify.sh`)!

You can even put the file or make link under `$HOME/bin`, then you can run this script everywhere easily!

Explaination
========
The script will scan all the directory under the current working directory, except path with '.git',

and check all the js & css files if they already have a minified verion(currently, recognize by `.min` in filename, before file ext),

if not, just minify it, otherwise, compare the last modify time between the origin and the minified version,

if the origin one is newer than the minified one, meens the minified file was older, then do the minify again!
