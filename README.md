# Create custom idempiere product
* Check out iDempiere source
* At iDempiere source folder, run mvn verify
* Set IDEMPIERE_BUILD environment variable pointing to iDempiere source folder
* Copy your plugin jars to plugins folder
* Run publish.sh. Create p2 repository at the repository folder
* Run install.sh. Install plugins from repository folder to target/products/org.adempiere.server.product
* Archive target/products/org.adempiere.server.product for redistribution.
