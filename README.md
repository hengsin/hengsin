# Create custom iDempiere installer with third party plugins
* Check out https://github.com/hengsin/hengsin
* Check out iDempiere source
* At iDempiere source folder, run mvn verify
* Copy third party plugin jars to hengsin/plugins folder
* At source folder for https://github.com/hengsin/hengsin, set IDEMPIERE_SOURCE environment variable pointing to iDempiere source folder (for e.g, export IDEMPIERE_SOURCE=/home/hengsin/workspace/idempiere)
* If you wants to add custom AD_SysConfig setting to your iDempiere installer, build hengsin/com.github.hengsin.sysconfig.init (see README.md there for build instruction) and copy hengsin/com.github.hengsin.sysconfig.init/target/com.github.hengsin.sysconfig.init-10.0.0-SNAPSHOT.jar to hengsin/plugins folder. Edit hengsin/sysconfig.properties to add custom AD_SysConfig settings.
* Run publish.sh script. The script will create a p2 repository at the hengsin/target/repository folder
* Run install.sh script. The script will install plugin jars from hengsin/target/repository folder to hengsin/target/products/org.adempiere.server.product (use --offline for faster build)
* Archive hengsin/target/products/org.adempiere.server.product for redistribution.
