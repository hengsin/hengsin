# Maven Build
* Set IDEMPIERE_SOURCE environment variable to idempiere source folder (for e.g export IDEMPIERE_SOURCE=/home/hengsin/workspace/idempiere)
* Run mvn verify

# Usage
* Customize AD_SysConfig system level entries with value from IDEMPIERE_HOME/sysconfig.properties
* To use, install this plugin and create sysconfig.properties (a simple key=value properties file) file for the AD_SysConfig entries that you want to change. 
* Put the sysconfig.properties file at IDEMPIERE_HOME and AD_SysConfig will be updated during the start up of the iDempiere server.
