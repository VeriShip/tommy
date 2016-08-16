'use strict'

q = require 'q'
aws = require 'aws-sdk'
params = require './createParameters'
workstationIdentifier = require './workstationIdentifier'
extender = require './extender'
gatherer = require './templateGatherer'
resolver = require './templateResolver'
_ = require 'lodash'
check = require 'check-types'

class ClusterCreator

	constructor: (emrObj, workstationIdentifierObj, qObj, processObj,  extenderObj, gathererObj, resolverObj) ->
		@emr = emrObj ? new aws.EMR()
		@workstationIdentifier = workstationIdentifierObj ? new workstationIdentifier()
		@q = qObj ? q
		@process = processObj ? process
		@extender = extenderObj ? new extender()
		@gatherer = gathererObj ? new gatherer()
		@resolver = resolverObj ? new resolver()

	create: (templateData) =>
		resolvedTemplates = [ ]
		@gatherer.gather(@gatherer.findFiles(@process.cwd())).forEach (template) =>
			resolvedTemplates.splice(resolvedTemplates, 0, JSON.parse(@resolver.resolve(template, templateData)))
		params = @extender.extend(resolvedTemplates)
		params.Name = @workstationIdentifier.getName()
		nameTag = _.find(params.Tags, { Key: 'Name' })
		if not params.Tags then params.Tags = [ ]
		if not nameTag then params.Tags.push({ Key: 'Name', Value: params.Name })

		runJob = @q.nbind(@emr.runJobFlow, @emr)
		runJob params

module.exports = ClusterCreator
