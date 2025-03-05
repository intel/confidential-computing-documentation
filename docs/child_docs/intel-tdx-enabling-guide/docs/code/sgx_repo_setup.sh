# --8<-- [start:pccs-cent-os-stream-9]
sudo dnf install -y wget yum-utils
sudo mkdir /opt/intel
cd /opt/intel
sudo wget https://download.01.org/intel-sgx/sgx-dcap/1.21/linux/distro/centos-stream9/sgx_rpm_local_repo.tgz -O sgx_rpm_local_repo_1_21.tgz
sudo mkdir sgx_rpm_local_repo_1_21
sudo tar xvf sgx_rpm_local_repo_1_21.tgz -C sgx_rpm_local_repo_1_21 --strip-components=1
sudo yum-config-manager --add-repo file:///opt/intel/sgx_rpm_local_repo_1_21
# --8<-- [end:pccs-cent-os-stream-9]

# --8<-- [start:cent-os-stream-9]
sudo dnf install -y wget yum-utils
sudo mkdir /opt/intel
cd /opt/intel
sudo wget https://download.01.org/intel-sgx/latest/dcap-latest/linux/distro/centos-stream9/sgx_rpm_local_repo.tgz
sudo tar xvf sgx_rpm_local_repo.tgz
sudo yum-config-manager --add-repo file:///opt/intel/sgx_rpm_local_repo
# --8<-- [end:cent-os-stream-9]

# --8<-- [start:rhel_9_4_kvm]
sudo dnf install -y yum-utils wget
sudo mkdir /opt/intel
cd /opt/intel
sudo wget https://download.01.org/intel-sgx/latest/dcap-latest/linux/distro/rhel9.2-server/sgx_rpm_local_repo.tgz
sudo tar xvf sgx_rpm_local_repo.tgz
sudo yum-config-manager --add-repo file:///opt/intel/sgx_rpm_local_repo
# --8<-- [end:rhel_9_4_kvm]

# --8<-- [start:ubuntu_23_10]
echo 'deb [signed-by=/etc/apt/keyrings/intel-sgx-keyring.asc arch=amd64] https://download.01.org/intel-sgx/sgx_repo/ubuntu mantic main' | sudo tee /etc/apt/sources.list.d/intel-sgx-mantic.list
cat <<EOF | sudo tee /etc/apt/preferences.d/intel-sgx-mantic-pin-4000
Package: *
Pin: release o=Intel\ Corporation,n=mantic,c=main
Pin-Priority: 499
EOF
wget https://download.01.org/intel-sgx/sgx_repo/ubuntu/intel-sgx-deb.key
sudo mkdir -p /etc/apt/keyrings
cat intel-sgx-deb.key | sudo tee /etc/apt/keyrings/intel-sgx-keyring.asc > /dev/null
sudo apt-get update
# --8<-- [end:ubuntu_23_10]

# --8<-- [start:ubuntu_24_04]
echo 'deb [signed-by=/etc/apt/keyrings/intel-sgx-keyring.asc arch=amd64] https://download.01.org/intel-sgx/sgx_repo/ubuntu noble main' | sudo tee /etc/apt/sources.list.d/intel-sgx.list
wget https://download.01.org/intel-sgx/sgx_repo/ubuntu/intel-sgx-deb.key
sudo mkdir -p /etc/apt/keyrings
cat intel-sgx-deb.key | sudo tee /etc/apt/keyrings/intel-sgx-keyring.asc > /dev/null
sudo apt-get update
# --8<-- [end:ubuntu_24_04]

# --8<-- [start:opensuse_leap_15_5]
sudo mkdir /opt/intel
cd /opt/intel
sudo wget https://download.01.org/intel-sgx/latest/dcap-latest/linux/distro/suse15.4-server/sgx_rpm_local_repo.tgz
sudo tar xvf sgx_rpm_local_repo.tgz
sudo zypper addrepo /opt/intel/sgx_rpm_local_repo sgx_rpm_local_repo
# --8<-- [end:opensuse_leap_15_5]
