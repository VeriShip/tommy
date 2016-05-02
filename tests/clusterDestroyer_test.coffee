clusterDestroyer = require '../src/clusterDestroyer'
q = require 'q'
should = require 'should'

describe 'clusterDestroyer', ->
	describe 'constructor', ->
		it 'should set the emr property', ->
			emr = {}
			newClusterDestroyer = new clusterDestroyer(emr)
			should.strictEqual(newClusterDestroyer.emr, emr)

		it 'should populate the emr property if it is not supplied', ->
			newClusterDestroyer = new clusterDestroyer()
			should.exist(newClusterDestroyer.emr)

		#it 'should set the listHelper property', ->
		#	listHelper = {}
		#	newClusterDestroyer = new clusterDestroyer(null, listHelper)
		#	should.strictEqual(newClusterDestroyer.listHelper, listHelper)

		#it 'should populate the listHelper property if it is not supplied', ->
		#	newClusterDestroyer = new clusterDestroyer()
		#	should.exist(newClusterDestroyer.listHelper)

		it 'should set the q property', ->
			q = {}
			newClusterDestroyer = new clusterDestroyer(null, q)
			should.strictEqual(newClusterDestroyer.q, q)

		it 'should populate the q property if it is not supplied', ->
			newClusterDestroyer = new clusterDestroyer()
			should.exist(newClusterDestroyer.q)

	describe 'destroy', ->

		class emrStub 
			constructor: (@throwError) ->

			terminateJobFlows: (params, callback) =>
				if @throwError
					throw "Error was thrown"
				else
					callback null, {data: "success"}

		class listHelperStub
			qObj = require 'q'
			constructor: (@clusterCount) ->

			list: () =>
				clusters = []
				i = 0
				while i < @clusterCount
					clusters.push({Id: i})
					i++
				
				qObj(clusters)

		it 'should throw an error if we don\'t pass in a string for the id.', ->

			newClusterDestroyer = new clusterDestroyer(new emrStub())

			should.throws ->
				newClusterDestroyer.destroy(null)
			should.throws ->
				newClusterDestroyer.destroy(1)

		it 'should return success when supplied clusterId', (done) ->

			clusterCount = 1

			newClusterDestroyer = new clusterDestroyer(new emrStub())

			newClusterDestroyer.destroy("clusterId")
			.done (data) ->
				should.exist(data.data)
				done()

		#it 'should return success when no id is supplied', (done) ->

		#	clusterCount = 1

		#	newClusterDestroyer = new clusterDestroyer(new emrStub(), new listHelperStub(clusterCount), null)

		#	newClusterDestroyer.destroy()
		#	.then (data) ->
		#		should.exist(data.message)
		#		done()


		#it 'should call destroy with supplied clusterId(s)', (done) ->

		#	clusterCount = 2

		#	newClusterDestroyer = new clusterDestroyer(new emrStub(), new listHelperStub(2), null)

		#	clusterId = "1"

		#	newClusterDestroyer.destroy(clusterId)
		#	.then (data) ->
		#		should.equal(data.message.JobFlowIds[0], clusterId)
		#		done()

		#it 'should call destroy with clusterIds from list when no id is supplied', (done) ->

		#	newClusterDestroyer = new clusterDestroyer(new emrStub(), new listHelperStub(1), null)

		#	newClusterDestroyer.destroy()
		#	.then (data) ->
		#		should.equal(data.message.JobFlowIds[0], "0")
		#		done()

		#it 'should retrun promise when error in chain', (done) ->

		#	newClusterDestroyer = new clusterDestroyer(new emrStub("returnError"), new listHelperStub(1), null)

		#	newClusterDestroyer.destroy()
		#	.catch (err) ->
		#		err.should.equal 'Error was thrown'
		#		done()




