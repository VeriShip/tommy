os = require 'os'
q = require 'q'
moment = require 'moment'

class workstationIdentifier
	constructor: (processObj, osObj, momentObj, qObj) ->
		@process = processObj ? process
		@os = osObj ? os
		@moment = momentObj ? moment
		@q = qObj ? q

	pinCluster: (id, emr) =>
		addTags = @q.nbind(emr.addTags, emr)
		return addTags
			ResourceId: id
			Tags: [
				{
					Key: 'tommy_default',
					Value: @moment().utc().format()
				}
			]
	getName: =>
		if @process.platform == "win32"
			return "#{@os.hostname()}_#{@process.env['USERNAME']}"
		else
			return "#{@os.hostname()}_#{@process.env['USER']}"
	isOwned: (name) =>
		return name == @getName()

module.exports = workstationIdentifier
