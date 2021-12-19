#!/bin/sh

emacs -batch -q -l ./build.el -f org-publish-all
