echo "Install plugins in repository to target/products/org.adempiere.server.product"

mkdir -p target
cd target
rm -r -f *
cp -r $IDEMPIERE_BUILD/org.idempiere.p2/target/products .
cd ..

cd plugins
PLUGINS=''
for filename in *.jar;do
    PLUGINS=$PLUGINS,"${filename%_*}"
done
PLUGINS="${PLUGINS:1}"
export plugins=$PLUGINS

cd ..

export osgi_os=linux
export osgi_ws=gtk
export osgi_arch=x86_64
mvn -P installPlugins

export osgi_os=macosx
export osgi_ws=cocoa
mvn -P installPlugins

export osgi_os=win32
export osgi_ws=win32
mvn -P installPlugins
