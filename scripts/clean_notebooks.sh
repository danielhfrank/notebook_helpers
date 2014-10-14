#!/bin/bash

BASEDIR="$(git rev-parse --show-toplevel)"


function clean_notebook {
    notebook="$1"
    git reset --quiet HEAD $notebook
    mv $notebook{,.dirty}
    python $BASEDIR/scripts/remove_output.py $notebook.dirty > $notebook
    git add $notebook
    rm -f $notebook.dirty
}


if [ $# -gt 0 ]
then
    notebooks=$@
else
    notebooks=$(git --no-pager diff --cached --name-only | egrep ".*\.ipynb$")
fi

for notebook in $notebooks; do
    clean_notebook $notebook
done
