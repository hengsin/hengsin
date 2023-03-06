# Maven Build
* The build.sh script will set IDEMPIERE_SOURCE environment variable for you if your local setup follow one of the following structure:
<parent folder>
|
|-- idempiere
|-- hengsin/com.github.hengsin.sysconfig.init

OR 

<parent folder>
|
|-- idempiere
|-- com.github.hengsin.sysconfig.init

* If the above doesn't suite your local setup, create idempiere_source.properties file with IDEMPIERE_SOURCE=<absolute idempiere source path> line (for e.g IDEMPIERE_SOURCE=/home/hengsin/workspace/idempiere).
* Run ./build.sh
* Alternatively, you can set IDEMPIERE_SOURCE environment variable to idempiere source folder (for e.g export IDEMPIERE_SOURCE=/home/hengsin/workspace/idempiere) and run "mvn verify"

# Usage
* Customize AD_SysConfig system level entries with value from IDEMPIERE_HOME/sysconfig.properties
* To use, install this plugin and create sysconfig.properties (a simple key=value properties file) file for the AD_SysConfig entries that you want to change. 
* Put the sysconfig.properties file at IDEMPIERE_HOME and AD_SysConfig will be updated during the start up of the iDempiere server.
