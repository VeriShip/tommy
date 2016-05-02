_ = require 'lodash'
check = require 'check-types'

class TemplateResolver
	constructor: (lodashObj) ->
		@lodash = lodashObj ? _

	resolve: (template, data) ->
		compiled = _.template(template)
		compiled(data)

module.exports = TemplateResolver
