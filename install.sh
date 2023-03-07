echo "Install plugins in target/repository to target/products/org.adempiere.server.product"

script_dir=$(realpath $(dirname "$0"))
if [ -z "$IDEMPIERE_SOURCE" ]; then
   if [[ -f "$script_dir/idempiere_source.properties" ]]; then
       source "$script_dir/idempiere_source.properties"
   fi
fi

if [ -z "$IDEMPIERE_SOURCE" ]; then
    if [ -d "$script_dir/../idempiere/org.idempiere.p2.targetplatform" ]; then
        IDEMPIERE_SOURCE=$(realpath "$script_dir/../idempiere")
    fi 
fi

set -u
: "$IDEMPIERE_SOURCE"

echo $IDEMPIERE_SOURCE

mkdir -p target
cd target
rm -r -f products
rm -r -f eclipserun-work
cp -r $IDEMPIERE_SOURCE/org.idempiere.p2/target/products .
cd ..

if  [ ! -d "target/repository/plugins" ]; then
	echo "target/repository/plugins folder doesn't exists";
	exit 1
fi

cd target/repository/plugins
PLUGINS=""
for filename in *.jar;do
	[ -f "$filename" ] || continue
    PLUGINS=$PLUGINS,"${filename%_*}"
done
if [ -z "$PLUGINS" ]; then
	echo "No plugin jars in target/repository/plugins folder";
	exit 1
fi

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

cd target/repository/plugins
for filename in *.jar;do
	escaped_line=$(echo "$filename" | sed 's/\./\\./g')
	escaped_line=$(echo "$escaped_line" | sed 's/\//\\\//g')

	sed -i "/$escaped_line/s/4,false/5,true/" ../../products/org.adempiere.server.product/linux/gtk/x86_64/configuration/org.eclipse.equinox.simpleconfigurator/bundles.info
	sed -i "/$escaped_line/s/4,false/5,true/" ../../products/org.adempiere.server.product/win32/win32/x86_64/configuration/org.eclipse.equinox.simpleconfigurator/bundles.info
	sed -i "/$escaped_line/s/4,false/5,true/" ../../products/org.adempiere.server.product/macosx/cocoa/x86_64/Eclipse.app/Contents/Eclipse/configuration/org.eclipse.equinox.simpleconfigurator/bundles.info
done
