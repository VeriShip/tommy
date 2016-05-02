aws = require 'aws-sdk'

module.exports = (value) =>
	value = value ? 'us-west-2'
	aws.config.update({region: value})
