_ = require 'lodash'
params = require './createParameters'
check = require 'check-types'

class Extender
	constructor: (lodashObj, paramObj) ->
		@lodash = lodashObj ? _
		@params = paramObj ? params

	extend: (sources) =>
		if not check.array(sources)
			throw Error("You must supply an array as sources.")
		sources.forEach (item) ->
			if not check.object(item)
				throw Error('You must supply an array of objects as sources.')

		sources.splice(0, 0, @params)
		
		merge = _.spread(_.merge)
		return merge(sources)

module.exports=Extender
