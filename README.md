![HOX](https://github.com/LeanMeanFightingMachine/HOX/raw/master/assets/icons/png/48x48.png)
===

About HOX
-----

![HOX Screenshot](http://soulwire.co.uk/files/drag-file.jpg)

HOX is an Air application built from several small modules, each designed to serve as useful time-saving components in your web development workflow.

The interface is entirely _drag-and-drop_ — drag in files and folders, then drag the processed results out to the filesystem, FTP client, program or other module. None of your original files will be modified, instead temporary copies are made for you to use as you need them.

Modules
-------

### Combine

The __Combine__ module will pack the contents of all CSS and JavaScript files into a single CSS or JavaScript file. Folders can be dragged in and recursively searched for files with either a _.css_ or _.js_ extension, producing one or both of the outputs: __combined.js__ and __combined.css__


---------------------------------------


### Minify

The __Minify__ module will validate, clean and minify your CSS and JavaScript code. If multiple files or folders are dragged onto the module, HOX will combine them before minification. Simply drag your project folder onto the __Minify__ module and all CSS and JavaScript files detected will be combined and minified.

The __Minify__ module uses the [Google Closure Compiler](http://code.google.com/closure/compiler/) to minify JavaScript and the [YUI Compressor](http://developer.yahoo.com/yui/compressor/) to minify CSS.

JavaScript syntax is also checked and if minification cannot take place due to code errors, an error log window will appear providing detailed feedback.


---------------------------------------


### Export

The __Export__ module will recursively clean all directories and subdirectories, removing files such as __.svn__ and __.DS_Store__, without touching other important hidden files. This lets you quickly clean a project before uploading or sharing.