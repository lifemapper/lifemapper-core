#!/bin/bash
#
# Build and install prerequisites for compiling lmcore dependencies
#
. /opt/rocks/share/devel/src/roll/etc/bootstrap-functions.sh

# No opt-python for yum
module unload opt-python
yum install src/RPMS/screen-4.1.0-0.25.20120314git3c2946.el7.x86_64.rpm

# add dynamic libs
echo "/etc/alternatives/jre/lib/amd64" > /etc/ld.so.conf.d/lifemapper-lab-ld.conf
echo "/etc/alternatives/jre/lib/amd64/server" >> /etc/ld.so.conf.d/lifemapper-lab-ld.conf
echo "/opt/lifemapper/lib" >> /etc/ld.so.conf.d/lifemapper-lab-ld.conf
echo "/opt/python/lib/" >> /etc/ld.so.conf.d/lifemapper-lab-ld.conf
/sbin/ldconfig

# pip for wheels
module load opt-python
python3.6 -m ensurepip --default-pip
# Leave with opt-python loaded


