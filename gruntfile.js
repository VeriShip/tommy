/*jshint node:true */
'use strict';

module.exports = function(grunt) {

	grunt.option('mochareporter', grunt.option('mochareporter') || 'mocha-junit-reporter');

	grunt.initConfig({
		jshint: {
			all: ['gruntfile.js', 'src/**/*.js', 'test/**/*.js']
		},
		createDirectories: {
			dir: [ 'bin' ]
		},
		copy: {
			js: {
				files: [
					{
						expand: true,
						src: [ 'src/**/*.js', 'tests/**/*.js' ],
						dest: "bin"
					}
				]
			},
			test_files: {
				files: [
					{
						expand: true,
						src: [ 'tests/test_files/*' ],
						dest: "bin"
					}
				]
			}
		},
		coffee: {
			compile: {
				expand: true,
				src: ['./src/**/*.coffee', './tests/**/*.coffee'],
				dest: 'bin',
				ext: '.js'
			}
		},
		mochaTest: {
			test: {
				options: {
					reporter: "<%= grunt.option('mochareporter') %>",
					//captureFile: 'results.txt', // Optionally capture the reporter output to a file
					quiet: false, // Optionally suppress output to standard out (defaults to false)
					clearRequireCache: false // Optionally clear the require cache before running tests (defaults to false)
				},
				src: ['bin/tests/**/*.js']
			}
		}

	});

	grunt.registerMultiTask('createDirectories', function() {
		this.data.forEach(function(dir) {
			if(!grunt.file.exists(dir)) {
				grunt.file.mkdir(dir);
			}
		});
	});

	grunt.loadNpmTasks('grunt-contrib-jshint');
	grunt.loadNpmTasks('grunt-niteo-spawn');
	grunt.loadNpmTasks('grunt-contrib-coffee');
	grunt.loadNpmTasks('grunt-contrib-copy');
	grunt.loadNpmTasks('grunt-mocha-test');
	grunt.loadNpmTasks('grunt-bump');

	grunt.registerTask('default', ['test']);

	grunt.registerTask('test', [
		'jshint',
		'createDirectories',
		'copy',
		'coffee',
		'mochaTest'
	]);

	grunt.registerTask('deploy', function() {
		grunt.log.writeln('Not Implemented Yet');
	});

};
