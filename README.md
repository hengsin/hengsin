# Create custom idempiere product
* Check out iDempiere source
* At iDempiere source folder, run mvn verify
* Set IDEMPIERE_SOURCE environment variable pointing to iDempiere source folder (for e.g export IDEMPIERE_SOURCE=/home/hengsin/workspace/idempiere)
* Copy your plugin jars to plugins folder
* Run publish.sh. Create p2 repository at the target/repository folder
* Run install.sh. Install plugins from target/repository folder to target/products/org.adempiere.server.product (use --offline for faster build)
* Archive target/products/org.adempiere.server.product for redistribution.
