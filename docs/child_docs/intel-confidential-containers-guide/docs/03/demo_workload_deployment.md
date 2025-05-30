---
description: This section provides instructions on deploying a sample Intel TDX-protected application in the configured Kubernetes cluster.
keywords: enabling guide, Intel TDX, Trust Domain Extension, Confidential Computing, Confidential Containers, workload deployment, nginx, KBS, Intel Trust Authority
---
<!---
Copyright (C) 2024 Intel Corporation
SPDX-License-Identifier: CC-BY-4.0
-->

# Demo Workload Deployment

In this chapter, we will present how workloads can be deployed as a Kubernetes pod with gradually increasing security levels:

1. [Regular Kubernetes pod](#regular-kubernetes-pod).
2. [Pod isolated by Kata Containers](#pod-isolated-by-kata-containers).
3. [Pod isolated by Kata Containers and protected by Intel TDX](#pod-isolated-by-kata-containers-and-protected-by-intel-tdx).
4. [Pod isolated by Kata Containers, protected with Intel TDX, and Quote verified using a KBS with an attestation service](#pod-isolated-by-kata-containers-protected-with-intel-tdx-and-quote-verified-using-a-kbs-with-an-attestation-service).

For now, we use nginx as a workload example.
Further workloads might be added later.

!!! warning "Disclaimer"
    The provided deployment files are only for demonstration purposes, which can be used in a development environment.
    You are responsible to properly set up your production environment.


## nginx Deployment in Pods of Increasing Security Levels

The following subsections describe how to deploy nginx in pods with the gradually increasing security levels listed in the introduction.
Finally, we will provide instructions on how to clean up all pods.


### Regular Kubernetes Pod

To start nginx in a regular Kubernetes pod and to verify the cluster setup, perform the following steps:

- Save the provided pod configuration as `nginx.yaml`:

    ```yaml
    apiVersion: v1
    kind: Pod
    metadata:
      name: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:1.27.4
          ports:
            - containerPort: 80
          imagePullPolicy: Always
    ```

- Start nginx:

    ``` { .bash }
    kubectl apply -f nginx.yaml
    ```

- Check the pod status:

    ``` { .bash }
    kubectl get pods
    ```

    Expected output:

    ``` { .text }
    NAME    READY   STATUS    RESTARTS        AGE
    nginx   1/1     Running    (...)
    ```


### Pod isolated by Kata Containers

To isolate nginx using a Kata Container pod and to be sure that the Kata Containers runtime is working, perform the following steps:

- Save the provided pod configuration as `nginx-vm.yaml`:

    ```yaml
    apiVersion: v1
    kind: Pod
    metadata:
      name: nginx-vm
    spec:
      runtimeClassName: kata-qemu
      containers:
        - name: nginx
          image: nginx:1.27.4
          ports:
            - containerPort: 80
          imagePullPolicy: Always
    ```

    Compared to the last security level, the only difference in the pod configuration is the pod name and the usage of `kata-qemu` as runtime class.

- Start nginx:

    ``` { .bash }
    kubectl apply -f nginx-vm.yaml
    ```

- Check the pod status:

    ``` { .bash }
    kubectl get pods
    ```

    Expected output:

    ``` { .text }
    NAME    READY   STATUS    RESTARTS        AGE
    nginx-vm   1/1     Running    (...)
    ```


### Pod Isolated by Kata Containers and Protected by Intel TDX

To isolate nginx using a Kata Container and to protect it using Intel TDX, perform the following steps:

- Save the provided pod configuration as `nginx-td.yaml` for this setup:

    ```yaml
    apiVersion: v1
    kind: Pod
    metadata:
      name: nginx-td
      annotations:
        io.containerd.cri.runtime-handler: kata-qemu-tdx
    spec:
      runtimeClassName: kata-qemu-tdx
      containers:
        - name: nginx
          image: nginx:1.27.4
          ports:
            - containerPort: 80
          imagePullPolicy: Always
    ```

    Compared to the last security level, the only difference in the pod configuration is the pod name and the usage of `kata-qemu-tdx` as runtime class.

- Start nginx:

    ``` { .bash }
    kubectl apply -f nginx-td.yaml
    ```

- Check the pod status:

    ``` { .bash }
    kubectl get pods
    ```

    Expected output for success:

    ``` { .text }
    NAME    READY   STATUS    RESTARTS        AGE
    nginx-td   1/1     Running   (...)
    ```

    In case the pods are not in `Running` state, refer to the [Troubleshooting](../04/troubleshooting.md#pods-failed-to-start) section.


### Pod Isolated by Kata Containers, Protected with Intel TDX, and Quote Verified using a KBS with an attestation service

Finally, we explore how to isolate nginx using Kata Containers, how to protect nginx using Intel TDX, and how to verify the nginx deployment using attestation - for which we use the attestation service integration into the Confidential Containers KBS.

To deploy and verify a protected nginx, follow the steps below:

- Create pod's yaml file `nginx-td-attestation.yaml` for this setup:

    ```yaml
    apiVersion: v1
    kind: Pod
    metadata:
      name: nginx-td-attestation
      annotations:
        io.containerd.cri.runtime-handler: kata-qemu-tdx
        io.katacontainers.config.hypervisor.kernel_params: "agent.guest_components_rest_api=all agent.aa_kbc_params=cc_kbc::${KBS_ADDRESS}"
    spec:
      runtimeClassName: kata-qemu-tdx
      initContainers:
        - name: init-attestation
          image: storytel/alpine-bash-curl:latest
          command: ["/bin/sh","-c"]
          args:
            - |
              echo starting;
              (curl http://127.0.0.1:8006/aa/token\?token_type\=kbs | grep -iv "get token failed" | grep -iv "error" | grep -i token && echo "ATTESTATION COMPLETED SUCCESSFULLY") || (echo "ATTESTATION FAILED" && exit 1);
      containers:
        - name: nginx
          image: nginx:1.27.4
          ports:
            - containerPort: 80
          imagePullPolicy: Always
    ```

    Compared to the last security level, the differences in the pod configuration are:

    - The name of the pod.
    - Additional annotation to enable the attestation component in Kata Containers.
    - Additional `init` container to trigger the attestation and ensure that nginx container is started only if the attestation is successful.

    For details about the used parameters and available parameters, see the following documentation:

    - [Kata Containers kernel parameters](https://github.com/kata-containers/kata-containers/blob/main/docs/how-to/how-to-set-sandbox-config-kata.md#hypervisor-options)
    - [Key Broker Service parameters](https://github.com/confidential-containers/trustee/blob/main/kbs/docs/initdata.md#initdata-specification)

- Set the KBS address to be used during deployment:

    ``` { .bash }
    export KBS_ADDRESS=http://$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[0].address}'):$(kubectl get svc kbs -n coco-tenant -o jsonpath='{.spec.ports[0].nodePort}')
    ```

- Start nginx using the exported `KBS_ADDRESS`:

    ``` { .bash }
    envsubst < nginx-td-attestation.yaml | kubectl apply -f -
    ```

- Check the pod status:

    ``` { .bash }
    kubectl get pods
    ```

    - If the output reports the pod in the `Running` state, it means that Intel TDX attestation completed successfully:

        ``` { .text }
        NAME    READY   STATUS    RESTARTS        AGE
        nginx-td-attestation   1/1     Running   (...)
        ```

    - If the pod is not in `Running` state for a few minutes, you can review the attestation logs to identify the issue:

        ``` { .bash }
        kubectl logs pod/nginx-td-attestation -c init-attestation
        ```

    - Expected output for success:

        ``` { .text }
        starting
        (...)
        {"token":"<TOKEN>","tee_keypair":"<TEE_KEYPAIR>"}
        ATTESTATION COMPLETED SUCCESSFULLY
        ```

        In case of attestation failure, refer to the [troubleshooting](../04/troubleshooting.md#attestation-failure) section.


### Cleanup All Pods

!!! warning

    If necessary, backup your work before proceeding with the cleanup.

To remove the deployed components from the Kubernetes cluster, execute the following commands to remove the pods:

``` { .bash }
kubectl delete -f nginx.yaml
kubectl delete -f nginx-vm.yaml
kubectl delete -f nginx-td.yaml
kubectl delete -f nginx-td-attestation.yaml
```


## Additional features

Refer to the [features section](https://confidentialcontainers.org/docs/features/) in official Confidential Containers guide for additional features such as authenticated registries, encrypted images, and more.
