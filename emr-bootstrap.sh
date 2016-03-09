#!/bin/bash

PRESHARED_KEY='SET THIS TO SOMETHING'

# install SciSpark puppet module
sudo bash < <(curl -skL https://raw.githubusercontent.com/pymonger/puppet-scispark/master/install.sh)

sudo rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-pc1-el-6.noarch.rpm
sudo yum install -y puppet-agent redhat-lsb-core

INSTANCE_ID=`wget -q -O - http://169.254.169.254/latest/meta-data/instance-id`

# Configure puppet, use the instance ID as the certname
sudo bash -c "cat > /etc/puppetlabs/puppet/puppet.conf" << EOF
[main]
server = puppet.jpl.nasa.gov
waitforcert = 15
certname = $INSTANCE_ID
EOF

sudo bash -c "cat > /etc/puppetlabs/puppet/csr_attributes.yaml" << EOF
extension_requests:
    pp_preshared_key: $PRESHARED_KEY
EOF

sudo bash -c "cat > /opt/puppetlabs/facter/facts.d/role.yaml" << EOF
role: aws-emr
EOF

# Allow root to ssh-in with ssh keys
sudo sed -i 's/^PermitRootLogin.*/PermitRootLogin without-password/' /etc/ssh/sshd_config
sudo service sshd restart


sudo /opt/puppetlabs/bin/puppet agent --onetime --no-daemonize --verbose --no-splay
sleep 15
sudo /opt/puppetlabs/bin/puppet agent --onetime --no-daemonize --verbose --no-splay
sudo service puppet start
