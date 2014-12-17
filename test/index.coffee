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

  xit 'should error if the repo is not a valid gift repo', (done) ->
    giftRecursiveTree.getTree null, [], (err) ->
      should.exist err
      done()

  xit 'should error if the commits are not an array', (done) =>
    giftRecursiveTree.getTree @repo, {}, (err) ->
      should.exist err
      done()

  xit 'should error if the commits are not valid gift commit objects', (done) ->
    giftRecursiveTree.getTree @repo, [1], (err) ->
      should.exist err
      done()

  xit 'should have the right amount of items in a commit tree', (done) =>
    @repo.commits '5693fd44cc4daff452ff02d54c5a216a094b66d0', 1, (err, commits) =>
      should.not.exist err

      giftRecursiveTree.getTree @repo, commits, (err, tree) ->
        should.not.exist err
        tree.length.should.equal 3
        done()

  it 'should properly concatenate trees of 2 commits', (done) =>
    @repo.commits '5693fd44cc4daff452ff02d54c5a216a094b66d0', 1, (err, commits) =>
      should.not.exist err
      commitArray = commits

      @repo.commits 'c6ad69027e43fee1aa74627a4e126087337ec8bc', 1, (err, nextCommits) =>
        should.not.exist err
        commitArray = commitArray.concat nextCommits[0]

        giftRecursiveTree.getTree @repo, commitArray, (err, tree) =>
          should.not.exist err
          tree.length.should.equal 8
          done()
