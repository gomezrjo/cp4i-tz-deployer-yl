#!/bin/bash
echo -e "\033[1;33mGenerate Key Store to connect to Queue Manager\033[0m"
###################
# INPUT VARIABLES #
###################
QMGR_NAME='qmgr-native-ha'
QMGR_NAMESPACE='cp4i-mq'
######################
# GENERATE KEY STORE #
######################
echo -e "\033[1;32mGetting Keys from Secret...\033[0m"
oc extract secret/${QMGR_NAME}-tls-secret -n ${QMGR_NAMESPACE} --keys=ca.crt
oc extract secret/${QMGR_NAME}-tls-secret -n ${QMGR_NAMESPACE} --keys=tls.crt
oc extract secret/${QMGR_NAME}-tls-secret -n ${QMGR_NAMESPACE} --keys=tls.key
echo -e "\033[1;32mCreating P12 Key Store...\033[0m"
openssl pkcs12 -export -in tls.crt -inkey tls.key -certfile ca.crt -out artifacts/qmgr-server-nha-tls.p12 -name "${QMGR_NAME}-app" -passout pass:password
( echo "cat <<EOF" ; cat templates/template-mq-nha-mqclient.ini ;) | \
    QMGR_CCDT_NAME='mqnhaccdt' \
    QMGR_CERT_NAME='qmgr-server-nha-tls' \
    sh > artifacts/mqclient-nha.ini
echo -e "\033[1;32mCleaning up temp file...\033[0m"
rm -f ca.crt
rm -f tls.crt
rm -f tls.key
echo -e "\033[1;32mKeyStore has been created.\033[0m"