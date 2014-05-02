#!/bin/bash

BASEDIR="$(git rev-parse --show-toplevel)"

PYTHON="python"
# virtualenv
if [ -f "$BASEDIR/vendor/bin/python" ]; then
    PYTHON="$BASEDIR/vendor/bin/python"
fi

for notebook in $(git --no-pager diff --cached --name-only | egrep ".*\.ipynb$"); do
    git reset --quiet HEAD $notebook
    mv $notebook{,.dirty}
    $PYTHON $BASEDIR/scripts/remove_output.py $notebook.dirty > $notebook
    git add $notebook
    rm -f $notebook.dirty
done
