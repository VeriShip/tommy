'use strict'

should = require 'should'
Resolver = require '../src/templateResolver'

describe 'TemplateResolver', ->
	context 'constructor', ->
		
		it 'should pass lodashObj to @lodash', ->
			expectedValue = { }
			target = new Resolver(expectedValue)
			should.strictEqual(target.lodash, expectedValue)

	context 'resolve', ->

		it 'should do nothin to a blank template', ->
			template = "Hi there"
			target = new Resolver()
			should.strictEqual(target.resolve(template), template)

		it 'should apply variable', ->
			template = "Hi there <%= name %>"
			expected = "Hi there mitch"
			target = new Resolver()
			should.strictEqual(target.resolve(template, {name: "mitch"}), expected)


