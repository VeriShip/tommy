should = require 'should'

workstationIdentifier = require '../src/workstationIdentifier'

describe 'workstationIdentifier', ->

	class emrStub

		addTags: (params, callback) =>
			callback(null, params)

	emrstub = new emrStub()
	
	processObj = 
		env:
			USERNAME: 'windowsuser'
		platform: 'win32'
	osObj = 
		result: "windowsmachine"
		hostname: =>
			return osObj.result 
	momentObj = 
		result: "some time"
		moment: ->
			utc: ->
				format: ->
					return momentObj.result

	describe 'pinCluster', ->
		it 'should pass in the appropriate parameters to the request', (done) ->
			wi = new workstationIdentifier(null, null, momentObj.moment, null)
			promise = wi.pinCluster('dummy id', emrstub)

			promise
				.done (data)=>
					data.should.have.property 'ResourceId', 'dummy id'
					data.should.have.property 'Tags', [ { Key: "tommy_default", Value: "some time" } ]
					done()

	describe 'getName', ->
		
		it 'should return windowsmachine_windowsuser when hostname is "win32"', ->
			wi = new workstationIdentifier(processObj, osObj, null)
			wi.getName().should.equal('windowsmachine_windowsuser')

		it 'should return darwinmachine_darwinuser when hostname is "darwin"', ->
			processObj.env.USER = "darwinuser"
			processObj.platform = "darwin"
			osObj.result = "darwinmachine"
			wi = new workstationIdentifier(processObj, osObj, null)
			wi.getName().should.equal('darwinmachine_darwinuser')

		it 'should return linuxmachine_linuxuser when hostname is "linux"', ->
			processObj.env.USER = "linuxuser"
			processObj.platform = "linux"
			osObj.result = "linuxmachine"
			wi = new workstationIdentifier(processObj, osObj, null)
			wi.getName().should.equal('linuxmachine_linuxuser')

	describe 'isOwned', ->

		it 'should return true when name is linuxmachine_linuxuser and platform=linux, process.env.USER=linuxuser, and os.hostname()=linuxmachine', ->
			processObj.env.USER = "linuxuser"
			processObj.platform = "linux"
			osObj.result = "linuxmachine"
			wi = new workstationIdentifier(processObj, osObj, null)
			wi.isOwned('linuxmachine_linuxuser').should.be.true()

		it 'should return false when name is somename and platform=linux, process.env.USER=linuxuser, and os.hostname()=linuxmachine', ->
			processObj.env.USER = "linuxuser"
			processObj.platform = "linux"
			osObj.result = "linuxmachine"
			wi = new workstationIdentifier(processObj, osObj, null)
			wi.isOwned('somename').should.be.false()

