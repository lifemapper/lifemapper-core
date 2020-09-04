
.. highlight:: rest

Install or Update a Lifemapper Core installation
==========================================================
.. contents::  

git config --global user.email "zzeppozz@gmail.com"
git config --global user.name "Aimee Stewart"

Current versions
----------------
#. **Download** new Lifemapper Core roll to server, then validate checksum::

   # sha256sum -c *sha

#. To **destroy** existing install, run::

   # bash /opt/lifemapper/rocks/etc/clean-lmcore-roll.sh

New roll install or update existing roll
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. **Remove old roll**::

   # rocks remove roll lifemapper-core
      
#. **Add new roll with rpms**, ensuring that old versions of rpms and files 
   are replaced::

   # rocks add roll lifemapper-core-*.iso clean=1
   
#. **Create distribution**::

   # rocks enable roll lifemapper-core
   # (module unload opt-python; \
      cd /export/rocks/install; \
      rocks create distro; \
      yum clean all)

#. **Create and run install script**::

    # (module unload opt-python; \
       rocks run roll lifemapper-core > add-core.sh; \
       bash add-core.sh 2>&1 | tee add-core.out)

#. **Finish FE with reboot** ::  

   # shutdown -r now
   
#. **Rebuild the compute nodes from FE** ::  

   # rocks set host boot compute action=install
   # rocks run host compute reboot     

Update existing code and script RPMs (without new roll)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. Copy individual rpms to /export/rocks/install/contrib/7.0/x86_64/RPMS/ 
   This will only update RPMs that are part of the original roll.
   To add rpms that are not yet part of the rolls, put them into a directory 
   shared from FE to nodes (/share/lm/). 
   
#. then rebuild distribution.  ::
   
   # (module unload opt-python; cd /export/rocks/install; rocks create distro; yum clean all)
   # yum list updates
   # yum update
   
#. Run ANY scripts to update config
      
#. Install new (not from existing roll) rpms on FE, placing in exported dir ::
   
   # rpm -iv /share/lm/*rpm

#. Update nodes ::
   
   # rocks set host boot compute action=install
   # rocks run host compute reboot

#. Update nodes with non-roll rpms::
   
   # rocks run host compute "(hostname; rpm -iv /share/lm/*rpm)"



      
Look for Errors
---------------
   
#. **Check log files** After the frontend boots up, check the success of 
   initialization commands in log files in /tmp (these may complete up to 5
   minutes after reboot).  The /tmp/post-99-lifemapper-core.log file contains all
   output from reinstall-reboot-triggered scripts and is created fresh 
   each time.  All other logfiles are in /state/partition1/lmscratch/log 
   and may be output appended to the end of an existing logfile (from previous 
   runs) and will be useful if the script must be re-run manually for testing.
   
   * /tmp/post-99-lifemapper-core.debug (calls init_lmcore on reboot) 
   * /state/partition1/lmscratch/log/init_core.log
     
