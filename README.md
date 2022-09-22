# Create custom idempiere product
* Check out iDempiere source
* At iDempiere source, run mvn verify
* Set IDEMPIERE_BUILD environment variable to iDempiere source folder
* Copy your plugin jars to plugins folder
* Run publish.sh. This will use the plugin jars in plugins folder to create a p2 repository at the repository folder.
* Run install.sh. This install the plugins from repository folder to target/products/org.adempiere.server.product
* You can archive target/products/org.adempiere.server.product for redistribution.
