echo "Publish jars in plugins to target/repository"

mkdir -p target
cd target
rm -r -f repository
cd ..

mvn -P publishPlugins $*
