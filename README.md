# Gift Recursive Tree

Simple utility to take a [Gift](https://github.com/notatestuser/gift) repository and get a recursive tree

# Installation

    $ npm install gift-recursive-tree

# Usage

You must have first instantiated an `Gift` repository. Passing in an array of `Commits`, will yield the tree, recursively, for those commits. The result will be one concatenated list.

Example:

    git = require 'gift'
    giftRecursiveTree = 'gift-recursive-tree'

    git.clone "git@host:path/to/remote/repo.git", "path/to/local/clone/repo", (err, _repo) ->
      repo = _repo

      repo.current_commit (err, _commit) ->
        giftRecursiveTree.getTree [_commit], (err, tree) ->
          console.log tree