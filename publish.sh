echo "Publish jars in plugins to repository"

cd repository
rm -f *.xml
rm -r -f plugins
rm -r -f features
cd ..

mvn -P publishPlugins
