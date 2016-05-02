'use strict'

#_ = require 'lodash'
q = require 'q'
aws = require 'aws-sdk'
check = require 'check-types'
#listHelper = require './listHelper'

class ClusterDestroyer
	constructor: (emrObj, qObj) ->
		@emr = emrObj ? new aws.EMR()
		#@listHelper = listHelperObj ? new listHelper()
		@q = qObj ? q

	destroy: (id) =>
		if not check.string(id)
			throw Error("You must supply a string for the id of the cluster to destroy.")

		terminateJobFlows = @q.nbind(@emr.terminateJobFlows, @emr)
		terminateJobFlows({JobFlowIds:[id]})

#	destroy: (ids) =>
#		terminateJobFlows = @q.nbind(@emr.terminateJobFlows, @emr)
#		params = {}
#
#		@populateJobFlowIds(ids)
#		.then (jobFlowIds) =>
#			if jobFlowIds.length == 0
#				@q("no cluster(s) to terminate")
#			else
#				params = {JobFlowIds:jobFlowIds}
#				terminateJobFlows(params)
#		.then (data) ->
#			{data: data, message: params}
#
#	populateJobFlowIds: (ids) =>
#		jobFlowIds = []
#		if ids?
#			@q(ids.split(','))
#		else
#			@listHelper.list()
#			.then (clusters) ->
#				if clusters.length != 0
#					jobFlowIds.push(clusters[0].Id)
#				jobFlowIds

module.exports = ClusterDestroyer
