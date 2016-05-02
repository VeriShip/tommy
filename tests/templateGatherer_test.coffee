'use strict'

should = require 'should'
Gatherer = require '../src/templateGatherer'

describe 'TemplateGatherer', ->
	context 'constructor', ->
		
		it 'should pass fsObj to @fs', ->
			expectedValue = { }
			target = new Gatherer(expectedValue)
			should.strictEqual(target.fs, expectedValue)
		
		it 'should pass pathObj to @path', ->
			expectedValue = { }
			target = new Gatherer(null, expectedValue)
			should.strictEqual(target.path, expectedValue)

	context 'findFiles', ->

		it 'should return all files in current directory with .tommy extension', ->

			fs =
				readdirSync: ->
					return [ 'one.tommy', 'dummy.txt', 'two.tommy' ]
				statSync: ->
					return { isFile: -> return true }

			expected = [
				'/cwd/one.tommy',
				'/cwd/two.tommy'
			]

			target = new Gatherer(fs)

			should.deepEqual(target.findFiles("/cwd"), expected)

		it 'should return nothing if there are not .tommy files', ->

			fs =
				readdirSync: ->
					return [ 'dummy.txt' ]
				statSync: ->
					return { isFile: -> return true }

			expected = [ ]

			target = new Gatherer(fs)

			should.deepEqual(target.findFiles("/cwd"), expected)

		it 'should only return files and not directories', ->

			fs =
				readdirSync: ->
					return [ 'dir.tommy', 'dummy.txt' ]
				statSync: ->
					{ isFile: -> return false }

			expected = [ ]

			target = new Gatherer(fs)

			should.deepEqual(target.findFiles("/cwd"), expected)

	context 'gather', ->
		
		it 'should throw an error if we do not pass an array of objects', ->
			should.throws ->
				target = new Gatherer()
				target.gather([ 1, 2, 3 ])
			
			should.throws ->
				target = new Gatherer()
				target.gather([ 1.0, 2, 3 ])
			
			should.throws ->
				target = new Gatherer()
				target.gather("hello")

		it 'should return the contents of each file as a json object', ->

			contents = [
				'{"test": "value"}',
				'{"another": "value Again"}'
			]

			fs =
				readFileSync: ->
					return contents.pop()

			expected = [
				'{"test": "value"}',
				'{"another": "value Again"}'
			]
			
			target = new Gatherer(fs)
			should.deepEqual(target.gather(["one", "two"]), expected)
