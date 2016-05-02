'use strict'
check = require 'check-types'

class TemplateGatherer
	constructor: (fsObj, pathObj) ->
		@fs = fsObj ? require 'fs'
		@path = pathObj ? require 'path'

	findFiles: (cwd) =>
		result = [ ]
		@fs.readdirSync(cwd).forEach (item) =>
			targetPath = @path.join(cwd, item)
			stat = @fs.statSync(targetPath)
			if @path.extname(targetPath) == '.tommy' and stat.isFile()
				result.push(targetPath)

		return result

	gather: (files) =>
		if not check.array(files)
			throw Error("You must supply an array of files.")
		files.forEach (item) ->
			if not check.string(item)
				throw Error('You must supply an array of strings that represent paths.')

		result = [ ]
		files.forEach (item) =>
			result.splice(result, 0,  @fs.readFileSync(item, 'utf8'))

		return result

module.exports = TemplateGatherer
