for i in $(terraform output -json | jq '.extra_cluster_ips_worker.value[]' -r); do ssh -i testing_extra_cluster_key_rsa root@$i; done
