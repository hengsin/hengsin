echo "Install plugins in repository to target/products/org.adempiere.server.product"

set -u
: "$IDEMPIERE_SOURCE"

mkdir -p target
cd target
rm -r -f products
rm -r -f eclipserun-work
cp -r $IDEMPIERE_SOURCE/org.idempiere.p2/target/products .
cd ..

cd target/repository/plugins
PLUGINS=''
for filename in *.jar;do
    PLUGINS=$PLUGINS,"${filename%_*}"
done
PLUGINS="${PLUGINS:1}"
export plugins=$PLUGINS

cd ../../..

export osgi_os=linux
export osgi_ws=gtk
export osgi_arch=x86_64
mvn -P installPlugins $*

export osgi_os=macosx
export osgi_ws=cocoa
mvn -P installPluginsMac $*

export osgi_os=win32
export osgi_ws=win32
mvn -P installPlugins $*

cp sysconfig.properties  target/products/org.adempiere.server.product/linux/gtk/x86_64
cp sysconfig.properties  target/products/org.adempiere.server.product/macosx/cocoa/x86_64
cp sysconfig.properties  target/products/org.adempiere.server.product/win32/win32/x86_64
