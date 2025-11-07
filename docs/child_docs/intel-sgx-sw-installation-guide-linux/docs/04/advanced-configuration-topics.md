---
description: Advanced configuration topics for Intel SGX, including ECDSA-based quote generation, DCAP quoting library, and AESM service setup.
keywords: Intel SGX, installation guide, advanced configuration, ECDSA, DCAP, AESM, Linux, quote generation, attestation
---
<!---
Copyright (C) 2025 Intel Corporation
SPDX-License-Identifier: CC-BY-4.0
-->

# Advanced Configuration Topics

In this chapter, we describe the following advanced configuration topics:

- Details on [ECDSA-based Quote Generation using the DCAP Quoting Library](#ecdsa-based-quote-generation-using-the-dcap-quoting-library).
- Details on the [Configuration of AESM Service](#configuration-of-aesm-service).


## ECDSA-based Quote Generation using the DCAP Quoting Library

For an enclave to attest to a remote entity, it must obtain an SGX Report of itself and then use the Quoting Enclave (QE) on the platform to convert it to a signed SGX Quote.
Using the QE in an application requires the user to have special privilege on the system.
As some processes may not have this privilege, DCAP Quoting Library offers two options to obtain an ECDSA-based quote:

- In-Process ECDSA-based Quote Generation: the DCAP Quoting Library will load the QE itself and obtain the quote with a direct call to the enclave.

- Out-of-Process ECDSA-based Quote Generation: the DCAP Quoting Library makes an out-of-process call to the AESM Service to get the quote.

Each of these options has specific requirements on the configuration of the software and environment on the platform or on the privilege of the user application, which will be described in the following subsections.


### In-Process ECDSA-based Quote Generation

In this mode, which is the default mode, the DCAP Quoting Library will load the QE itself and obtain the SGX Quote with a direct call to the enclave.
This may cause issues if you use the Intel SGX Linux driver because you must have specific access privileges in order to launch an enclave capable of signing SGX Quotes.
In detail, you must have permission to launch an enclave with the *Provision Bit* set.

An enclave may set the Provision Bit in its attributes to be able to request the *Provision Key*.
Acquiring the Provision Key may have privacy implications and thus the permission to acquire the key should be limited to privileged users.
Enclave with the Provision Bit set are referred to as *Provisioning Enclaves* below.

For applications loading Provisioning Enclaves, the platform owner (administrator) must grant provisioning access to the app process as described below.


#### Process Permissions and Flow

A process that launches a Provisioning Enclave is required to use the `SET_ATTRIBUTE IOCTL` before the `INIT_ENCLAVE IOCTL` to notify the driver that the enclave being launched requires Provision Key access.
The `SET_ATTRIBUTE IOCTL` input is a file handle to `/dev/sgx_provision`, which fails to open if the process does not have the required permission.
To summarize, the following flow is required by the platform admin and a process that requires Provision Key access:

- Software installation flow:

    - Add the user running the process to the `sgx_prv` group:

        ```console
        sudo usermod -a -G sgx_prv <user name>
        ```

- Enclave launch flow:

    - Create the enclave via the `CREATE_ENCLAVE IOCTL`

    - Open a handle to `/dev/sgx_provision`

    - Issue the `SET_ATTRIBUTE IOCTL` with the handle as a parameter

    - Continue the load and initialization of the enclave

!!! Note
    The Enclave Common Loader library is following the above flow and launching enclave based on it.
    Failure to grant correct access to the launch process will cause a failure in the enclave initialization.


### Out-of-Process ECDSA-based Quote Generation

In this mode, which is not the default, the DCAP Quoting Library uses Universal Quote Generation (using the `libsgx-quote-ex` library), which makes a remote process call to the AESM Service to obtain an SGX Quote from the AESM Service.
To do this:

- **Ensure that the proper packages are installed** as described in the [Use Universal Quote Generation](../03/software-packages.md#use-universal-quote-generation) section.

- **Create an environment variable named `SGX_AESM_ADDR`**, which will instruct the DCAP Quoting Library to use out-of-process ECDSA-based quote generation.
    Among others, the following alternatives can be used to set this environment variable:
    - Add the environment variable to the command line when running the application:

        ```console
        SGX_AESM_ADDR=1 <app_name>
        ```

        This only configures the out-of-process quote generation for the application being executed

    - Add the following line to the environment variable file `/etc/environment`:

        ```console
        SGX_AESM_ADDR=1
        ```

        This configures the out-of-process quote generation for the whole system.

The AESM Service is preconfigured to run with a `sgx_prv` privilege.


## Configuration of AESM Service

The AESM Service provides functionality to applications on the platform.
Many of the Intel SGX library packages are installed as plug-ins to the AESM service and thus provide their functionality to the system while running within the AESM service.

Information about the AESM service:

- Its executable is installed to the directory `/opt/intel/sgx-aesm-service`.
- Its installer configures the service to run as a system daemon, which starts with the user ID `aesmd`.
- Its default home directory is `/var/opt/aesmd`.
- To perform certain functions the AESM service needs Internet access.
    If your network is using a proxy service, you may need to configure a proxy for the AESM service.
    For instructions on setting up the proxy, refer to the file `/etc/aesmd.conf`.
- By default, `systemd` and `syslog` are used for the AESM service.
    The following can be used when these are not available, e.g., in cloud native K8s deployments.
    - To manually start the service, use the following command:

        ```console
        ./aesm_service --no-daemon
        ```

    - To write logs to `stdout`/`stderr`, use the following command:

        ```console
        ./aesm_service --no-daemon --no-syslog
        ```

    - To specify which attestation types are supported, use the following command:

        ```console
        ./aesm_service --supported_attestation_types=ECDSA
        ```

        If an attestation type is specified but AESM fails to load the corresponding modules, AESM will stop running.
        Currently only ECDSA-based attestation is supported
