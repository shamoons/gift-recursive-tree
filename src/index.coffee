'use strict'

gift = require 'gift'

module.exports =
  getTree: (repo, commits, getTreeCb) ->
    getTreeCb null
