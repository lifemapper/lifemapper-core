# lifemapper-core
Roll for base lifemapper dependencies

.. highlight:: rest

Lifemapper Core roll
======================
.. contents::  

Introduction
------------
This roll installs cherrypy and solr for Lifemapper S^n services.
All prerequisite software listed below are a part of the roll and 
will be installed and configured during roll installation. 
The roll has been tested with Rocks 7.

Prerequisites
~~~~~~~~~~~~~

This section lists all the prerequisites for lifemapper-lab code dependencies.
The dependencies are either build from source or installed from RPMs 
during the roll build.
 
    
Downloads
~~~~~~~~~

Individual package dependencies
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Required Rolls
~~~~~~~~~~~~~~


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

Debugging a roll
----------------


Recreate roll ISO
-----------------

When updating only a few packages in the roll, there is no need to re-create 
all packages anew. After re-making updated RPMs  from the top level of roll source tree ::   

   # make reroll

The new rpms will be inlcuded in the new ISO. 

Adding a roll
-------------
The roll (ISO file) can be added (1) during the initial installation of the 
cluster (frontend) or (2) to the existing frontend.


Adding a roll to a new server
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


Adding a roll to a live frontend
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


Where installed roll components are
-----------------------------------

#. **/state/partition1/lmscratch/** -  
   + /state/partition1/lmscratch/sessions - cherrypy sessions.
   + /state/partition1/lmscratch/tmpUpload - landing spot for uploaded files
   + /state/partition1/lmscratch/log - script and daemon logs.
   + /state/partition1/lmscratch/run - PID files.

#. **/var/www/tmp/** - for webserver temp files

#. **/var/www/html/roll-documentation/lifemapper-core** - roll documentation, bare  minimum as a place holder.


Removing a roll
---------------

When debugging a roll may need to remove the roll and all installed RPMs.
   # bash /opt/lifemapper/rocks/etc/clean-lifemapper-core.sh

These commands remove the installed roll from Rocks database and repo ::

   # rocks remove roll lifemapper-core
   # (cd /export/rocks/install; rocks create distro; yum clean all)  


#. **Free memory loss**: during building a roll some java-based packages are 
   not releasing allocated memory properly which results in available memory 
   loss. After building a roll check host memory with ``free -m`` and run::
   
      sync && echo 1 > /proc/sys/vm/drop_caches
 
