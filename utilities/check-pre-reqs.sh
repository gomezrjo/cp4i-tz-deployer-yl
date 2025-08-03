#!/bin/bash
# This script requires the oc command being installed in your environment
if [ ! command -v oc &> /dev/null ]; then echo "oc could not be found"; exit 1; fi;
if [ ! command -v awk &> /dev/null ]; then echo "awk could not be found"; exit 1; fi;
echo "Checking OCP version..."
OCP_VER=$(oc version -o json | jq -r '.openshiftVersion' | rev | cut -d'.' -f2- | rev)
case "$OCP_VER" in
    "4.14"|"4.15"|"4.16"|"4.17"|"4.18")
        echo "OCP version Pass"
        ;;
    *)
        echo "OCP version Fail"
        ;;
esac
#
echo
echo "Checking required operators to use pipelines..."
if [ ! -z $(oc get csv --no-headers --ignore-not-found | awk '$1 ~ "openshift-pipelines-operator-rh" {print "True"}') ]
then
    echo "RedHat OpenShift Pipelines Operator Pass"
else
    echo "RedHat OpenShift Pipelines Operator Fail"
fi
#
if [ ! -z $(oc get csv --no-headers --ignore-not-found | awk '$1 ~ "ibm-tz-deployer" {print "True"}') ]
then
    echo "IBM TZ Deployer Operator Pass"
else
    echo "IBM TZ Deployer Operator Fail"
fi
#
echo
echo "Checking storage classes..."
if [ ! -z $(oc get sc --no-headers --ignore-not-found  | wc -l | awk '{if ($1+0 > 0) print "True"}') ]
then
    echo "Storage Classes Pass"
else
    echo "Storage Classes Fail"
fi