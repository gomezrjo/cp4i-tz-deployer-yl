#!/bin/bash
echo -e "\033[1;33mBuilding CCDT to connect to Queue Manager\033[0m"
###################
# INPUT VARIABLES #
###################
QMGR_NAMESPACE='cp4i-mq'
QMGR_NAME='qmgr-native-ha'
QMGR_INT_NAME='QMGRNATIVEHA'
QMGR_CHANNEL="MTLS.SVRCONN"
QMGR_CERT_LABEL="qmgr-native-ha-app"
########################
# CREATE CCDT #
########################
echo -e "\033[1;32mPreparing CCDT...\033[0m"
QMGR_HOST=$(oc get route ${QMGR_NAME}-ibm-mq-qm -n ${QMGR_NAMESPACE} -o jsonpath="{.spec.host}")
( echo "cat <<EOF" ; cat templates/template-mq-nha-ccdt.json ;) | \
    QMGR_CHANNEL=${QMGR_CHANNEL} \
    QMGR_HOST=${QMGR_HOST} \
    QMGR_INT_NAME=${QMGR_INT_NAME} \
    QMGR_CERT_LABEL=${QMGR_CERT_LABEL} \
    sh > artifacts/mqnhaccdt.json
echo -e "\033[1;32mCCDT has been created.\033[0m"