'use strict'

program = require 'commander'

program.version(process.env.npm_package_version)
	.command('list', 'lists the clusters matching the current workstations signature.', {isDefault: true})
	.command('list-all', 'lists all the clusters currently active.')
	.command('create', 'creates a new EMR cluster.')
	.command('destroy', 'destroys an existing EMR cluster.')
	.parse(process.argv)

