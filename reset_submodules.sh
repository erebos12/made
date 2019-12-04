#!/usr/bin/env bash

if [ -z $1 ]; then
   echo "ERROR: Specify to which submodule branches you want to update. master OR staging"
   exit 1
fi

branch=$1

regex="^master$|^staging$"
if [[ ! $branch =~ $regex ]]; then
  echo "ERROR: Invalid branch name specified! Just master or staging is valid!"
  exit 1
fi

echo "Reset all submodules to branch '$branch'..."
git submodule foreach git remote update
git submodule foreach git checkout -B $branch origin/$branch

git commit -a -m "reset all submodules to $branch (done by $0)"
git checkout -B $branch HEAD

echo ">>> DONE --- All submodules are now on branch '$branch'"
git submodule
