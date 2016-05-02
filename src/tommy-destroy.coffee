'use strict'

destroyer = require('./clusterDestroyer')
program = require('commander')
regionHelper = require './regionHelper'
regionHelper 'us-west-2'

program.version(process.env.npm_package_version)
	.description("Destroys an AWS EMR cluster given the cluster id supplied.")
	.usage('[options]')
	.option('-C, --clusterid <id>', 'The ids of the EMR clusters that will be destroyed.')
	.option('-r,--region [region]', 'The AWS region to interact with.  Default: us-west-2', regionHelper)
	.parse(process.argv)

newDestroyer = new destroyer()

success = (data) ->
	process.exit(0)

failure = (err) ->
	console.log(err)
	process.exit(1)

newDestroyer.destroy(program.clusterid).done(success, failure)
