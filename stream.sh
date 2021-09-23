#!/bin/zsh -l
DIR=${${(%):-%x}:A:h} # https://stackoverflow.com/a/23259585
cd "$DIR" || exit 1
export OVERMIND_AUTO_RESTART=stream,init
exec overmind start
