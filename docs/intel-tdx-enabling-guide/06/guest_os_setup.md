---
description: To use Intel® TDX, the guest operating system (OS) must be enabled. Multiple distribtuions are ready for Intel TDX as a guest OS.
keywords: enabling guide, Intel TDX, Trust Domain Extension, Confidential Computing, guest OS, operating system
---
<!---
Copyright (C) 2024 Intel Corporation
SPDX-License-Identifier: CC-BY-4.0
-->

# Guest OS Setup

On this page, we will introduce [how an Intel TDX-enabled guest image can be generated](#prepare-an-intel-tdx-enabled-guest-image) and [how a TD using this image can be started](#launch-a-trust-domain).
We assume that the [host OS setup](../05/host_os_setup.md) was done before.


## Prepare an Intel TDX-enabled Guest Image

To start an Intel TDX protected VM (i.e., a TD), it is necessary to prepare an Intel TDX-enabled guest image.
The *TDX Early Preview* distributions are the preferred way to prepare such an image.
The TDX Early Preview distributions are special distributions provided by partners for a convenient Intel TDX enablement experience.
Currently, the following Intel TDX-enabled guest OSes are supported by TDX Early Preview distributions:

- [CentOS Stream 9](https://sig.centos.org/virt/tdx/)
- [Ubuntu 23.10](https://github.com/canonical/tdx/tree/mantic-23.10?tab=readme-ov-file#5-setup-td-guest)
- [Ubuntu 24.04](https://github.com/canonical/tdx/tree/noble-24.04)

    !!! Note
        This guide currently does not cover Ubuntu 24.04

- [openSUSE Leap 15.5 or SUSE Linux Enterprise Server 15-SP5](https://github.com/SUSE/tdx-demo/tree/main)

To prepare a guest image for these OSes, follow the instructions provided by the individual TDX Early Preview distributions:

- [CentOS Stream 9](https://sig.centos.org/virt/tdx/guest/)
- [Ubuntu 23.10](https://github.com/canonical/tdx/tree/mantic-23.10?tab=readme-ov-file#6-boot-td-guest)
- [openSUSE Leap 15.5 or SUSE Linux Enterprise Server 15-SP5](https://github.com/SUSE/tdx-demo/blob/main/INSTALL-SLES-15-SP5.md#preparing-the-guest-image)


## Launch a Trust Domain

To launch a TD, follow the instructions provided by the individual TDX Early Preview distributions:

- [CentOS Stream 9](https://sig.centos.org/virt/tdx/guest/)
- [Ubuntu 23.10](https://github.com/canonical/tdx?tab=readme-ov-file#boot-td-guest)
- [openSUSE Leap 15.5 or SUSE Linux Enterprise Server 15-SP5](https://github.com/SUSE/tdx-demo/blob/main/INSTALL-SLES-15-SP5.md#launching-a-tdx-guest)
