echo "Publish jars in plugins to repository"

mkdir -p target
cd target
rm -r -f repository
cd ..

mvn -P publishPlugins $*
