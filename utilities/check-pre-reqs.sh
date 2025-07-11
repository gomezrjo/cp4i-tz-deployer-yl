#!/bin/bash
# This script requires the oc command being installed in your environment
if [ ! command -v oc &> /dev/null ]; then echo "oc could not be found"; exit 1; fi;
if [ ! command -v awk &> /dev/null ]; then echo "awk could not be found"; exit 1; fi;
echo "Checking required operators to use pipelines..."
if [ ! -z $(oc get csv | awk '$1 ~ "openshift-pipelines-operator-rh" {print "True"}') ]
then
    echo "RedHat OpenShift Pipelines Operator Pass"
else
    echo "RedHat OpenShift Pipelines Operator Fail"
fi
#
if [ ! -z $(oc get csv | awk '$1 ~ "ibm-tz-deployer" {print "True"}') ]
then
    echo "IBM TZ Deployer Operator Pass"
else
    echo "IBM TZ Deployer Operator Fail"
fi
#
echo
echo "Checking storage classes..."
if [ ! -z $(oc get sc --no-headers | wc -l | awk '{if ($1+0 > 0) print "True"}') ]
then
    echo "Storage Classes Pass"
else
    echo "Storage Classes Fail"
fi