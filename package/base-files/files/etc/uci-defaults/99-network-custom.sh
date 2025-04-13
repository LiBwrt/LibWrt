#!/bin/sh

. /lib/functions.sh
. /etc/openwrt_release

cp /rom/etc/luci-app-athena-led_0.0.7-20241029_all.ipk /etc/
cp /rom/etc/luci-i18n-athena-led-zh-cn_24.303.18056.a98d88b_all.ipk /etc/

cat <<EOF > /etc/rc.local
opkg install /etc/luci-app-athena-led_0.0.7-20241029_all.ipk
opkg install /etc/luci-i18n-athena-led-zh-cn_24.303.18056.a98d88b_all.ipk
rm -rf /etc/luci-app-athena-led_0.0.7-20241029_all.ipk
rm -rf /etc/luci-i18n-athena-led-zh-cn_24.303.18056.a98d88b_all.ipk
exit 0
EOF



# /etc/init.d/network restart

exit 0

