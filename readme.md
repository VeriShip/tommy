tommy
=====

[![Build Status](https://travis-ci.org/VeriShip/tommy.svg?branch=master)](https://travis-ci.org/VeriShip/tommy)

A simple command line tool written in [node](https://nodejs.org) that helps [VeriShip](https://twitter.com/veriship)'s Data Science team manage their running [EMR](https://aws.amazon.com/elasticmapreduce/) clusters in [AWS](https://aws.amazon.com/)

Install
-------

	npm install -g tommy

Credentials
----------

Tommy communicates with AWS.  Because of this, the current user needs to be an authorized user in AWS.  If you do not have an AWS account or access to one, you can signup for free.  (VeriShip is not resposible for any charges that may occur.)

You cannot pass your AWS credentials to Tommy in any way, so you need to setup a *credentials* file in your `~/.aws` directory.  See this guide for an example: [Configuring the SDK in Node.js](http://docs.aws.amazon.com/AWSJavaScriptSDK/guide/node-configuring.html)

Region
------

Tommy assumes that all clusters will be created in the `us-west-2` region.  However, if you would like to use a different region, you need to supply the --region flag in the command you are running.

	tommy list --region us-east-1

Creating
--------

Tommy is built on top of the [node AWS SDK](https://aws.amazon.com/sdk-for-node-js/). Creating a cluster from that SDK requires that all options in creating that cluster be defined in a JSON object.  Tommy uses this fact to streamline the creation process by allowing the user to define sepperate templates in the current working directory.  Tommy reads in those templates (tommy files), merges them, applies variables and then presents the final JSON object to the SDK for creation.

By default, Tommy uses the following template which all other provided templates are merged against.

	{
	  Instances: {
		HadoopVersion: '2.7.1',
		InstanceCount: 3,
		KeepJobFlowAliveWhenNoSteps: true,
		MasterInstanceType: 'm1.small',
		SlaveInstanceType: 'm1.small'
	  },
	  JobFlowRole: "EMR_EC2_DefaultRole",
	  ServiceRole: "EMR_DefaultRole",
	  ReleaseLabel: 'emr-4.4.0',
	  VisibleToAllUsers: true
	};

This is the minimum template needed to create a cluster.  You may override any or all of this by supplying your own tommy file/s in the currect working directory.

*Speaking of templates*, Tommy utilizes [lodash](https://lodash.com)'s templating in order to allow the users to pass in values to the create command line.

For example:  Let's say you wanted to create 4 instances in your cluster instead of three.  Actually, you may want to create more than that in the future, so you create the following tommy file: (`./dynamicCount.tommy`)

	{
		Instances: {
			InstanceCount: <%= count %>
		}
	}

When you're ready to create the cluster and know you want 10 instances in the group, you would run the following in the working directory of your tommy file/s:

	tommy create --var 'count=10'

It's that easy.

Help
----

To list all available commands:

	tommy help

To get specific help for any of those commands:

	tommy help <command>

Development
-----------

We like to use [coffeescript](http://coffeescript.org) and [grunt](http://gruntjs.com) here at VeriShip, so in order to build and run all tests, simply run:

	npm run dev

This will compile all source and test files then run all the tests.

Contributing
------------

If you encounter a bug or would like a feature that is not a part of Tommy yet, please fork and submit a pull request!

License
-------

MIT License

Copyright (c) 2016 VeriShip Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
