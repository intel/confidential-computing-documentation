---
description: Overview of BIOS UEFI variables for SGX multi-package registration and privacy protocol.
keywords: Intel SGX, DCAP, UEFI, BIOS, multi-package, variables
---
<!---
Copyright (C) 2025 Intel Corporation
SPDX-License-Identifier: CC-BY-4.0
-->

# BIOS Multi-Package UEFI Variables

The UEFI variables used for communication between BIOS and software enable a protocol to control the availability of data structure on boot flows.
The data provided by BIOS and the registration authority service are considered privacy sensitive.
They contain hardware identifiers that a platform owner may want to restrict to software.
For this reason, the protocol includes the ability for software to indicate to BIOS that it finished processing the structures.
This increases the complexity of the UEFI protocol implementation.
If a platform owner does not need to implement the privacy protection provided by the protocol, they can consider simplifying the protocol and always provide the structures to software as read only values, and BIOS does not use the `complete` flags to remove the variables from a subsequent boot flow.

UEFI variable are not exposed to guest VMs by default - VMM must implement the exposure of the variables to a guest VM.
This may satisfy some platform owners that want to prevent the privacy sensitive information from guest workloads.
