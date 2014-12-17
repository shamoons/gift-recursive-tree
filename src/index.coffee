'use strict'

gift = require 'gift'
giftRecursiveTree = '../src'

module.exports =
  getTree: (repo, commits, getTreeCb) ->
