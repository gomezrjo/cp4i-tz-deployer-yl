#!/bin/bash
# This script requires the oc command being installed in your environment
if [ ! command -v oc &> /dev/null ]; then echo "oc could not be found"; exit 1; fi;
echo "Checking compute capacity in cluster..."
total_cpu=0
while read -r cpu
do   
    ((total_cpu += cpu))
done < <(oc get nodes -o jsonpath='{range .items[?(@.metadata.labels.node-role\.kubernetes\.io/worker)]}{.status.capacity.cpu}{"\n"}{end}')
if [[ "$total_cpu" -ge 80 ]]
then
    echo "vCPU Pass"
else
    echo "vCPU Fail"
fi
#
total_mem=0
while read -r mem
do   
    mem=${mem/Ki/}
    ((total_mem += mem))
done < <(oc get nodes -o jsonpath='{range .items[?(@.metadata.labels.node-role\.kubernetes\.io/worker)]}{.status.capacity.memory}{"\n"}{end}')
if [[ "$total_mem" -ge 329066552 ]]
then
    echo "Memory Pass"
else
    echo "Memory Fail"
fi
#