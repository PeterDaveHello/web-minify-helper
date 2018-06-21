Web minify helper!
========

[![Gitter chat](https://badges.gitter.im/PeterDaveHello/web-minify-helper.svg)](https://gitter.im/PeterDaveHello/web-minify-helper)
[![dependencies Status](https://david-dm.org/PeterDaveHello/web-minify-helper/status.svg)](https://david-dm.org/PeterDaveHello/web-minify-helper)

Let me help you minify css and js files automatically and easily!

This is only a shell script; it depends on bash shell, grep, wc, curl and nodejs/npm.

It is based on [clean-css](https://github.com/jakubpawlowicz/clean-css), [uglify-js](https://github.com/mishoo/UglifyJS2) and [javascript-minifier.com](https://javascript-minifier.com)/[cssminifier.com](https://cssminifier.com).

Feel free to contribute to the project if you want!

Requirements
========
- Bash shell
- grep
- wc (word count)
- curl
- Node.js >= (4.0)

How to use?
========

```sh
$ git clone --recursive https://github.com/PeterDaveHello/web-minify-helper.git
$ cd web-minify-helper
$ npm install
```

First go to the target directory you want to minify, then run the script(`path_of_script/minify.sh`). Or you can pass the directory's path as a parameter to the script!

You may even place the script file (or make a link to it) under the `$HOME/bin` directory, allowing you to conveniently run this script from any directory!

Explanation
========
The script will scan all the directories under the current working directory, except path with '.git'.

Then, it will check all the js & css files to see if they already have a minified version (currently, it recognizes it by looking for a `.min` in the filename, before the file extension).

If the file does not have a minified version, it will minify it.

Furthermore, even if there is a minified version available, the script will compare the last modified time between the original file and its minified version. If the original one is newer than the minified one -- which means the minified file is older than the original -- then it will replace the old minified file with a new minified version!
