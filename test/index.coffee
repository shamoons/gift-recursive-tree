'use strict'

fs = require 'fs-extra'
gift = require 'gift'
giftRecursiveTree = require '../src/index'
should = require 'should'

describe 'gift recursive tree', ->
  @repo = null
  before (done) =>
    fs.removeSync "#{process.cwd()}/.gitdata"
    gift.clone "git@github.com:shamoons/gift-recursive-tree.git", "#{process.cwd()}/.gitdata", (err, _repo) =>
      throw err if err
      @repo = _repo

      done()

  it 'should error if the repo is not a valid gift repo', (done) ->
    giftRecursiveTree.getTree null, [], (err) ->
      should.exist err
      done()

  it 'should error if the commits are not an array', (done) =>
    giftRecursiveTree.getTree @repo, {}, (err) ->
      should.exist err
      done()

  it 'should error if the commits are not valid gift commit objects', (done) ->
    giftRecursiveTree.getTree @repo, [1], (err) ->
      should.exist err
      done()

  it 'should have the right amount of items in a commit tree', (done) =>
    @repo.current_commit (err, currentCommit) ->
      console.log currentCommit
      done()
    # giftRecursiveTree.getTree @repo, [1], (err) ->
    #   should.not.exist err
    #   done()

  xit 'should properly concatenate trees of 2 commits', (done) ->
    done()