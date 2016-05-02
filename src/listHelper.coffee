'use strict'
q = require('q')
aws = require('aws-sdk')
workstationIdentifier = require('./workstationIdentifier')

class ListHelper
	constructor: (emrObj, workstationIdentifierObj, qObj) ->
		@emr = emrObj ? new aws.EMR()
		@workstationIdentifier = workstationIdentifierObj ? new workstationIdentifier()
		@q = qObj ? q

	listAll: (marker, clusters) =>
		listClusters = @q.nbind(@emr.listClusters, @emr)
		
		if !clusters?
			clusters = []

		params = ClusterStates: ['STARTING','BOOTSTRAPPING','RUNNING','WAITING','TERMINATING']

		if marker?
			params.Marker = marker
		
		listClusters(params)
			.then (data) =>
				for cluster in data.Clusters
					clusters.push(cluster)
				if data.Marker?
					@listAll data.Marker, clusters
				else
					clusters

	list: () =>
		userClusters = []
		@listAll()
		.then (clusters) =>
			for cluster in clusters
				if @workstationIdentifier.isOwned(cluster.Name)
					userClusters.push(cluster)
			#console.dir(userClusters)
			userClusters

	# listDefault: () =>
	# 	defaultCluster = {}
	# 	@list()
	# 	.then (userClusters) =>
	# 		for cluster in clusters
	# 			for tag in cluster.Tags
	# 				if tag.Key == "tommy_default"
	# 					defaultCluster = cluster
	# 					break
	# 		defaultCluster

module.exports = ListHelper
