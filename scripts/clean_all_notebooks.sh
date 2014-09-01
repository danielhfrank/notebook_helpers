#!/bin/bash

BASEDIR="$(git rev-parse --show-toplevel)"

PYTHON="python"
# virtualenv
if [ -f "$BASEDIR/vendor/bin/python" ]; then
    PYTHON="$BASEDIR/vendor/bin/python"
fi

function clean_notebook {
    notebook="$1"
    git reset --quiet HEAD $notebook
    mv $notebook{,.dirty}
    $PYTHON $BASEDIR/scripts/remove_output.py $notebook.dirty > $notebook
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
