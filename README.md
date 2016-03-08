# emr-bootstrap

A [Bootstrap Action](http://docs.aws.amazon.com/ElasticMapReduce/latest/DeveloperGuide/emr-plan-bootstrap.html) script that gets EMR nodes to talk to the Puppetmaster back at JPL to get security requirements like sshd banners, BigFix client, etc. installed and running so security scans will pass.

## Usage

Generate (or ask the SA team to provide) a pre-shared key. This is a random string that is used as part of the Puppet client certificate signing process. The `PRESHARED_KEY` variable in the script should be set to this value. Then upload the script to a private bucket in S3 that your EMR cluster can read from. Set up the bootstrap action when provisioning your EMR cluster as described [here](http://docs.aws.amazon.com/ElasticMapReduce/latest/DeveloperGuide/emr-plan-bootstrap.html#CustombootstrapConsole).
