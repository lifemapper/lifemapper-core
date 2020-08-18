# lifemapper-core
Roll for base lifemapper dependencies

.. highlight:: rest

Lifemapper Core roll
======================
.. contents::  

Introduction
------------
This roll installs mod-wsgi, cherrypy and solr for Lifemapper S^n services.
All prerequisite software are a part of the roll and will be installed and 
configured during roll installation. The roll has been tested with Rocks 7.

Roll includes
-------------
The roll sets up software elements common to all lifemapper installations and 
is a dependency for all other lifemapper rolls:: 

* Software (standard and lifemapper-configured RPMs, python libraries built from 
  source into RPMs or installed from wheels).
* Users: lmwriter and solr
* Common directories
  
Locations of installed roll components
--------------------------------------
#. **/opt/lifemapper/**
   + /opt/lifemapper/config - core definitions for solr indexes expected

#. **/opt/solr/** - solr installation

#. **/state/partition1/lmscratch/** -  
   + /state/partition1/lmscratch/sessions - cherrypy sessions.
   + /state/partition1/lmscratch/tmpUpload - landing spot for uploaded files
   + /state/partition1/lmscratch/log - script and daemon logs.
   + /state/partition1/lmscratch/run - PID files.

#. **/state/partition1/lmcore/** - lmcore specific code 

#. **/state/partition1/lm/** - exported as /share/lm for sharing data with nodes
   + /share/lm/solr/data/cores - solr indexes

#. **/var/www/tmp/** - for webserver temp files

#. **/var/www/html/roll-documentation/lifemapper-core** - roll documentation, bare  minimum as a place holder.


Building a roll
---------------
Checkout roll distribution from git repo :: 

   # git clone https://github.com/lifemapper/lifemapper-core.git 
   # cd lifemapper-core/

To build a roll, first execute a script that downloads and installs some packages 
and RPMS that are prerequisites for other packages during the roll build stage: ::

   # ./bootstrap.sh  

For each dependency to be built as an RPM ::  

   # cd src/solr
   # make prep 
   # make rpm

When all individual packages are building without errors build a roll via 
executing the command at the top level of the roll source tree ::

   # make roll

The resulting ISO file lifemapper-lab-*.iso is the roll that can be added to the
frontend.

Prerequisites
--------------------
The roll requires a base installation of Rocks 7 with the following rolls::

  * area51
  * base
  * CentOS 7.6.1810
  * core
  * ganglia
  * hpc
  * kernel
  * python
  * sge
  * Updates-CentOS-7.6.1810


Recreate roll ISO
-----------------

When updating only a few packages in the roll, there is no need to re-create 
all packages anew. 

If changing the structure (add or delete contained packages), first run the
following from the top level of roll source tree.  This also updates 
version/date of the roll. :: 

   # make profile
   
After re-making updated RPMs from the top level of roll source tree ::   

   # make reroll

The new rpms will be inlcuded in the new ISO. 


Adding a roll
-------------
The roll (ISO file) can be added (1) during the initial installation of the 
cluster (frontend) or (2) to the existing frontend.


Removing a roll
---------------

When debugging a roll may need to remove the roll and all installed RPMs.
   # bash /opt/lifemapper/rocks/etc/clean-lmcore.sh

These commands remove the installed roll from Rocks database and repo ::

   # rocks remove roll lifemapper-core
   # (cd /export/rocks/install; rocks create distro; yum clean all)  


#. **Free memory loss**: during building a roll some java-based packages are 
   not releasing allocated memory properly which results in available memory 
   loss. After building a roll check host memory with ``free -m`` and run::
   
      sync && echo 1 > /proc/sys/vm/drop_caches
 
