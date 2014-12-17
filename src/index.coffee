'use strict'

_ = require 'lodash'
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

    console.log repo
    getTreeCb null
