should = require 'should'
clusterCreator = require '../src/clusterCreator'
workstationIdentifier = require '../src/workstationIdentifier'
_ = require 'lodash'
path = require 'path'

describe 'clusterCreator', ->

	class emrStub

		constructor: (addTagsResults, runJobFlowResults) ->
			@addTagsResults = addTagsResults ? [ ]
			@runJobFlowResults = runJobFlowResults ? [ ]
			@addTagsCalls = [ ]
			@runJobFlowCalls = [ ]

		addTags: (params, callback) =>
			@addTagsCalls.push(params)
			callback(null, @addTagsResults.pop())

		runJobFlow: (params, callback) =>
			@runJobFlowCalls.push(params)
			callback(null, @runJobFlowResults.pop())

	describe 'constructor', ->

		it 'should set the emr property', ->

			emr = { }
			cc = new clusterCreator(emr)

			should.strictEqual(cc.emr, emr)

		it 'should populate the emr property if nothing is passed.', ->

			cc = new clusterCreator()
			should.exist(cc.emr)

		it 'should set the workstationIdentifier property', ->

			wi = { }
			cc = new clusterCreator(null, wi)

			should.strictEqual(cc.workstationIdentifier, wi)

		it 'should populate the workstationIdentifier property if nothing is passed.', ->

			cc = new clusterCreator()
			should.exist(cc.workstationIdentifier)

		it 'should set the q property', ->

			q = { }
			cc = new clusterCreator(null, null, q)

			should.strictEqual(cc.q, q)

		it 'should populate the q property if nothing is passed.', ->

			cc = new clusterCreator()
			should.exist(cc.q)
		
		it 'should set the process property', ->

			target = { }
			cc = new clusterCreator(null, null, null, target)

			should.strictEqual(cc.process, target)

		it 'should populate the q property if nothing is passed.', ->

			cc = new clusterCreator()
			should.exist(cc.process)
		
		it 'should set the extender property', ->

			target = { }
			cc = new clusterCreator(null, null, null, null, target)

			should.strictEqual(cc.extender, target)

		it 'should populate the extender property if nothing is passed.', ->

			cc = new clusterCreator()
			should.exist(cc.extender)
		
		it 'should set the gatherer property', ->

			target = { }
			cc = new clusterCreator(null, null, null, null, null, target)

			should.strictEqual(cc.gatherer, target)

		it 'should populate the gatherer property if nothing is passed.', ->

			cc = new clusterCreator()
			should.exist(cc.gatherer)
		
		it 'should set the resolver property', ->

			target = { }
			cc = new clusterCreator(null, null, null, null, null, null, target)

			should.strictEqual(cc.resolver, target)

		it 'should populate the resolver property if nothing is passed.', ->

			cc = new clusterCreator()
			should.exist(cc.resolver)

	describe 'create', ->

		it 'should set the name', (done) ->

			emr = new emrStub()
			wi = new workstationIdentifier()

			cc = new clusterCreator(emr, wi)

			cc.create()
				.done =>
						emr.runJobFlowCalls[0].Name.should.equal(wi.getName())
						done()

		it 'should add the name tag if it doesn\'t exist', (done) ->

			emr = new emrStub()
			wi = new workstationIdentifier()
			extender =
				extend: ->
					return { Tags: [ ] }

			cc = new clusterCreator(emr, wi, null, null, extender)

			cc.create()
				.done =>
						emr.runJobFlowCalls[0].Tags[0].Value.should.equal(wi.getName())
						done()

		it 'should pass the command line variables to the template resolver', (done) ->

			emr = new emrStub()
			wi = new workstationIdentifier()
			dataArray = [ ]
			data = { a: 'b' }
			gatherer =
				gather: ->
					[ 'test' ]
				findFiles: ->
					[ ]
			resolver =
				resolve: (template, data) ->
					dataArray.push(data)
					'{ }'

			cc = new clusterCreator(emr, wi, null, null, null, gatherer, resolver)

			cc.create(data)
				.done =>
					dataArray.length.should.equal(1)
					for item in dataArray
						item.should.be.deepEqual(data)
					done()

		it 'should create the appropriate json object', (done) ->

			emr = new emrStub()
			wi = new workstationIdentifier()
			extender = require '../src/extender'
			processStub =
				cwd: ->
					path.normalize(path.join(path.dirname(__filename), './test_files'))
			targetExtender = new extender(null, { })

			cc = new clusterCreator(emr, wi, null, processStub, targetExtender)

			cc.extender.should.equal(targetExtender)

			cc.create({ var1: "there again"})
				.done =>
					emr.runJobFlowCalls.length.should.equal 1
					emr.runJobFlowCalls[0].should.deepEqual
						Name: wi.getName(),
						Tags: [ { Key: "Name", Value: wi.getName() } ]
						a: true,
						b: "there again"
						c:
							d: "There"
					done()

