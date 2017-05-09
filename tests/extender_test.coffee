'use strict'

should = require 'should'
Extender = require '../src/extender'

describe 'Extender', ->
	context 'constructor', ->
		
		it 'should pass lodashObj to @lodash', ->
			expectedValue = { }
			target = new Extender(expectedValue)
			should.strictEqual(target.lodash, expectedValue)

		it 'should pass param to @params', ->

			expectedValue = { }
			target = new Extender(null, expectedValue)
			should.strictEqual(target.params, expectedValue)

	context 'extend', ->

		it 'should throw an error if we do not pass an array of objects', ->
			should.throws ->
				target = new Extender()
				target.extend([ 1, 2, 3 ])
			
			should.throws ->
				target = new Extender()
				target.extend([ 1.0, 2, 3 ])
			
			should.throws ->
				target = new Extender()
				target.extend("hello")

		it 'should not merge non-empty object with the default object', ->

			params =
				a: true
				b:
					c: false

			source0 =
				a: false
				b:
					d: 1

			source1 =
				h: "hello"

			expected =
				a: false
				b:
					d: 1
				h: "hello"

			target = new Extender(null, params)
			should.deepEqual(target.extend([source0, source1]), expected)

		it 'should merge empty object with the default object', ->

			params =
				a: true
				b:
					c: false

			source0 =

			source1 =

			expected =
				a: true
				b:
					c: false

			target = new Extender(null, params)
			should.deepEqual(target.extend([source0, source1]), expected)

