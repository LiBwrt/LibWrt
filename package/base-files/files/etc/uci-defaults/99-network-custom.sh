#!/bin/sh

# Import thu vi?n
. /lib/functions.sh
. /etc/openwrt_release

# Ð?nh nghia bi?n
WIFI_KEY="TPTlam011205@!"
SSID_2G="TPT Lam"
SSID_5G="TPT Lam 5G"
SSID_6G="KU BO"
HOSTNAME="DOANDUY"

# C?u hình Dropbear (SSH)
uci set dropbear.@dropbear[0].PasswordAuth='on'
uci set dropbear.@dropbear[0].RootPasswordAuth='on'
chmod -R u=rwX,go= /etc/dropbear
uci commit dropbear
/etc/init.d/dropbear restart

# T?t ki?m tra ch? ký gói
sed -i -re 's/^(option check_signature.*)/#\1/g' /etc/opkg.conf

# C?u hình m?ng LAN
uci set network.lan.ipaddr="192.168.1.1"
uci commit network
/etc/init.d/network restart

# T?t IPv6
uci set 'network.lan.ipv6=0'
uci set 'network.wan.ipv6=0'
uci set 'dhcp.lan.dhcpv6=disabled'
/etc/init.d/odhcpd disable
/etc/init.d/odhcpd stop
uci commit
uci -q delete dhcp.lan.dhcpv6
uci -q delete dhcp.lan.ra
uci commit dhcp
/etc/init.d/odhcpd restart
uci set network.lan.delegate="0"
uci commit network
/etc/init.d/network restart

# Ki?m tra xem có 6GHz không
radio_count=$(uci show wireless | grep -c "wireless.radio[0-9]*\.type")
has_6ghz=0
for i in $(seq 0 $((radio_count - 1))); do
    radio="radio$i"
    band=$(uci get wireless.$radio.band 2>/dev/null)
    if [ "$band" = "6g" ]; then
        has_6ghz=1
        break
    fi
done

# C?u hình WiFi
for i in $(seq 0 $((radio_count - 1))); do
    radio="radio$i"
    band=$(uci get wireless.$radio.band 2>/dev/null)

    # Ð?t country code
    uci set wireless.$radio.country='DE'

    # Ð?t channel thành auto
    uci set wireless.$radio.channel='auto'

    # T?o wifi-iface n?u chua có
    if ! uci show wireless | grep -q "wireless.@wifi-iface\[$i\]"; then
        uci add wireless wifi-iface >/dev/null
        uci set wireless.@wifi-iface[$i].device="$radio"
        uci set wireless.@wifi-iface[$i].mode='ap'
        uci set wireless.@wifi-iface[$i].network='lan'
    fi

    # Phân lo?i theo band
    case "$band" in
        2g) # 2.4GHz
            uci set wireless.@wifi-iface[$i].ssid="$SSID_2G"
            if [ "$has_6ghz" -eq 1 ]; then
                uci set wireless.@wifi-iface[$i].encryption='sae'
            else
                uci set wireless.@wifi-iface[$i].encryption='psk2'
            fi
            ;;
        5g) # 5GHz
            uci set wireless.@wifi-iface[$i].ssid="$SSID_5G"
            if [ "$has_6ghz" -eq 1 ]; then
                uci set wireless.@wifi-iface[$i].encryption='sae'
            else
                uci set wireless.@wifi-iface[$i].encryption='psk2'
            fi
            ;;
        6g) # 6GHz
            uci set wireless.@wifi-iface[$i].ssid="$SSID_6G"
            uci set wireless.@wifi-iface[$i].encryption='sae'
            ;;
    esac
    uci set wireless.@wifi-iface[$i].key="$WIFI_KEY"
done

# Commit và áp d?ng thay d?i WiFi
uci commit wireless
/etc/init.d/network restart
ubus call uci reload_config

# C?u hình NTP và h? th?ng
uci delete system.ntp.server
uci add_list system.ntp.server='0.vn.pool.ntp.org'
uci add_list system.ntp.server='2.asia.pool.ntp.org'
uci add_list system.ntp.server='1.asia.pool.ntp.org'
uci add_list system.ntp.server='125.235.4.198'
uci add_list system.ntp.server='115.73.220.183'
uci add_list system.ntp.server='222.255.146.26'
uci set system.@system[0]=system
uci set system.@system[0].hostname="${HOSTNAME}"
uci set system.@system[0].zonename='Asia/Ho_Chi_Minh'
uci set system.@system[0].timezone='<+07>-7'
uci commit system

# T?o file r?ng disable_interface.sh
cat << EOI >> /etc/init.d/disable_interface.sh
EOI
chmod 755 /etc/init.d/disable_interface.sh

exit 0
