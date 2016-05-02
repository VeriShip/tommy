'use strict'

program = require('commander')
listHelper = require('./listHelper')
regionHelper = require './regionHelper'
regionHelper 'us-west-2'

program.version(process.env.npm_package_version)
	.description("Lists all AWS EMR clusters that are visible by your AWS credentials.")
	.usage('[options]')
	.option('-r,--region [region]', 'The AWS region to interact with.  Default: us-west-2', regionHelper)
	.parse(process.argv)

newListHelper = new listHelper()

success = (data) ->
	console.log(JSON.stringify(data, null, 2))
	process.exit(0)

failure = (err) ->
	console.log(err)
	process.exit(1)

newListHelper.listAll().done(success, failure)
