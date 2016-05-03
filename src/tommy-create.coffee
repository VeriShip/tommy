'use strict'

program = require('commander')
clusterCreator = require('./clusterCreator')
regionHelper = require './regionHelper'
regionHelper 'us-west-2'
newCreator = new clusterCreator()
variableCollection = { }

collect = (val, varCollection) ->
	splits = val.split('=')
	if splits.length != 2 then throw Error("Please supply your variables in the format of 'key=value'. @{val}")
	varCollection[splits[0]] = splits[1]
	varCollection

program.version(process.env.npm_package_version)
	.description("Creates an AWS EMR cluster based off of the templates and variables supplied in the current working directory and command line")
	.usage('[options]')
	.option('-v, --var [key=value]', 'A key/value pair to pass to the underlying create templates.', collect, variableCollection)
	.option('-r,--region [region]', 'The AWS region to interact with.  Default: us-west-2', regionHelper)
	.parse(process.argv)

success = (data) ->
	console.log(data)
	process.exit(0)

failure = (err) ->
	console.log(err)
	process.exit(1)

newCreator.create(variableCollection).done(success, failure)
