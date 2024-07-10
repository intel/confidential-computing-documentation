<!---
Copyright (C) 2024 Intel Corporation
SPDX-License-Identifier: CC-BY-4.0
-->

# Hardware Setup

On this page, we will present the settings that are necessary to setup the hardware for Intel TDX.
We assume that the [proper hardware is present](../03/hardware_selection.md).
At the moment, it is only necessary to [install an Intel TDX-enabled BIOS](#install-intel-tdx-enabled-bios) and [enable Intel TDX in the BIOS](#enable-intel-tdx-in-bios).


## Install Intel TDX-enabled BIOS

To use Intel TDX, a BIOS supporting the functionality is needed.
Please reach out to your OEM/ODM or independent BIOS vendor to learn if such a BIOS is available and follow the corresponding installation instructions.


## Enable Intel TDX in BIOS

Specific BIOS settings are needed to support Intel TDX.
In the following, we present BIOS settings for specific machines and processor generations.
Afterwards, we briefly describe these BIOS settings.

!!! note

    The necessary BIOS settings or the menus might differ based on the platform that is used.
    Please reach out to your OEM/ODM or independent BIOS vendor for instructions dedicated for your BIOS.

!!! warning

    It might be necessary to [enable Intel TDX on the host OS](../05/host_os_setup.md#enable-intel-tdx-in-the-host-os), before Intel TDX is enabled in the BIOS.

<!-- TODO: Decide if a "programmable", but large graph should be used or just a figure.  -->
??? info "BIOS settings for a Quanta S6Q system with 5th Gen Intel® Xeon® Scalable processors"

    ``` mermaid
    graph LR
    SC[Socket<br />Configuration];
    SC --> MC[Memory<br />Configuration];
    MC --> A1[Memory Map] --> A2[Volatile Memory Mode] --> A3[1LM];
    SC --> PC[Processor<br />Configuration];
    PC --> B1["Memory Encryption (TME)"] --> B2[Enabled];
    PC --> C1["Total Memory Encryption (TME) Bypass"] --> C2[Disabled];
    PC --> D1["Total Memory Encryption Multi-Tenant (TME-MT)"] --> D2[Enabled];
    PC --> E1["Memory integrity"] --> E2[Enabled or Disabled];
    PC --> F1["Trust Domain Extension (TDX)"] --> F2[Enabled];
    PC --> G1["TDX Secure Arbitration Mode Loader (SEAM Loader)"] --> G2[Enabled];
    PC --> H1[TME-MT/TDX key split] --> H2[Non-zero value]
    PC --> I1["SW Guard Extensions (SGX)"] --> I2[Enabled];
    PC --> J1[SGX PRM Size] --> J2[Whatever size<br />needed];
    ```

Explanation of BIOS settings:

| BIOS setting | Notes |
| :----------- | :---- |
| Volatile Memory Mode | Defines how memory is connected to the system. |
| Memory Encryption (TME) | Activates/deactivates Intel® Total Memory Encryption, which is a prerequisite for Intel® Total Memory Encryption–Multi-Key (Intel TME-MK). |
| Total Memory Encryption (TME) Bypass | Activates/deactivates the Intel TME bypass mode. This mode allows memory outside of Intel TME-MK VMs, Intel SGX enclaves, and Intel TDX Trust Domains to be unencrypted to improve the performance of non-confidential software. |
| Total Memory Encryption Multi-Tenant (TME-MT) | Activates/deactivates Intel® Total Memory Encryption–Multi-Key (Intel TME-MK), which is used by Intel TDX for the main memory encryption. |
| Memory integrity | If disabled, only Logical Integrity (SW integrity) is used for main memory protection. If enabled, Cryptographic Integrity (HW integrity) is also used for main memory protection. NOTE: Enabling Cryptographic Integrity requires DIMMs with specific specs to be installed. |
| Trust Domain Extension (TDX) | Activates/deactivates Intel TDX. |
| TDX Secure Arbitration Mode Loader (SEAM Loader) | Defines from where the Intel TDX Module is loaded. |
| TME-MT/TDX key split | Defines how many keys are used for Intel TME-MK and how many for Intel TDX. |
| SW Guard Extensions (SGX) | Activates/deactivates Intel SGX, which is used by Intel TDX for remote attestation. |
| SGX PRM Size | Defines the size of the Processor Reserved Memory (PRM), which is used by Intel SGX to hold enclaves and related protected data structures. A minimum SGX PRM is required to run the Quote Generation Service (QGS) on the host OS (or inside a dedicated VM). |
