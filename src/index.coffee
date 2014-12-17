'use strict'

_ = require 'lodash'
async = require 'async'
gift = require 'gift'

module.exports =
  getTree: (repo, commits, getTreeCb) ->
    if not repo?.path or not repo?.dot_git or not repo?.git
      return getTreeCb new Error 'Not a valid gift repo object'

    if not _.isArray commits
      return getTreeCb new Error 'Commits must be passed as an array'

    _.each commits, (commit) ->
      if not commit?.repo or not commit?.id or not commit?.tree
        return getTreeCb new Error 'All commits are not valid gift commit objects'

    # commits = commits[0
    console.log commits
    async.concat commits, (gitCommit, concatCb) ->
      gitCommit.tree().contents (err, gitTreeContents) ->
        parseTree '', gitTreeContents, (err, recursiveTree) ->
          concatCb err, recursiveTree

    , (err, gitRecursiveTree) -> # async.concat gitCommits COMPLETE
      getTreeCb err, _.uniq gitRecursiveTree, (tree) ->
          tree.id

    parseTree = (treePath, gitTreeContents, parseTreeCb) ->
      trees = []

      async.eachLimit gitTreeContents, 10, (gitTreeContent, eachLimitCb) ->
        sourceFilePath = "#{treePath}/#{gitTreeContent.name}".replace /^\//, ''
        
        if gitTreeContent.mode is '040000'
          # This is a directory / tree
          gitTreeContent.contents (err, gitChildContents) ->
            return eachLimitCb err if err

            parseTree sourceFilePath, gitChildContents, (err, innerContents) ->
              return eachLimitCb err if err

              trees = trees.concat innerContents

              eachLimitCb null
        else
          # This is a blob
          gitTreeContent.path = sourceFilePath

          trees.push gitTreeContent
          eachLimitCb null

      , (err) -> # async.eachLimit COMPLETE
        parseTreeCb err, trees