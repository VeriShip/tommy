/*jshint node:true */
'use strict';

module.exports = {
  Instances: {
    HadoopVersion: '2.7.1',
    KeepJobFlowAliveWhenNoSteps: true
  },
  JobFlowRole: "EMR_EC2_DefaultRole",
  ServiceRole: "EMR_DefaultRole",
  ReleaseLabel: 'emr-4.4.0',
  VisibleToAllUsers: true
};
