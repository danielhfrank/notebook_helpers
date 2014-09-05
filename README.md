notebook_helpers
============

Scripts for working with deployable ipython notebooks.

## Overview

Serve private IPython notebooks and ensure reproducibility, in two acts.

I. Development: Strip outputs from notebook before committing (using pre-commit hook)
II. Deployment: Re-run notebook logic and generate html on display server (using rake)

## Development Setup

Run `rake setup_pre_commit_hook` on dev machine to enable commit-time output checks.
These checks will ensure that all notebooks checked in contain only code, not data.

## Deployment Setup

As part of deployment process, ensure that `rake build_notebooks` is run on your server.
This will re-run all notebook logic, and create rendered html files in a `nbviewer` subdir
of the deployed directory. Generated html files will be cached between runs under `/tmp/nbviewer`.

## Additional Rakefile Directions

Each ipython notebook may have an accompanying rakefile with a matching name,
e.g. `df.ipynb` and `df.rake`. That rakefile should declare a task `:deps`, which
will be run to fetch any dependencies for the notebook.

```ruby
file :some_data do
    sh "wget go/some_data"
end

file :other_data do
    sh "impala -f query.sql -o other_data"
end

file :joined_data => [:some_data, :other_data] do
    sh "join some_data other_data > joined_data"
end

task :deps => :joined_data do
end
```
