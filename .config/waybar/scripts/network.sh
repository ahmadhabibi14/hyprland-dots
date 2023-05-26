#!/usr/bin/env bash
#rofi
# notify-send "Getting list of available Wi-Fi networks..."
# Get a list of available wifi connections and morph it into a nice-looking list
wifi_list=$(nmcli --fields "SECURITY,SSID" device wifi list | sed 1d | sed 's/  */ /g' | sed -E "s/WPA*.?\S/  /g" | sed "s/^--/  /g")

connected=$(nmcli -fields WIFI g)
if [[ "$connected" =~ "enabled" ]]; then
	toggle="   Disable Wi-Fi"
elif [[ "$connected" =~ "disabled" ]]; then
	toggle="   Enable Wi-Fi"
fi

# Use rofi to select wifi network
chosen_network=$(echo -e "$toggle\n$wifi_list" | uniq -u | rofi -dmenu -i -selected-row 1 -p "" -theme ~/.config/waybar/scripts/rofi/networkmenu.rasi)
# Get name of connection
chosen_id=$(echo "${chosen_network:3}" | xargs)

# enter_password() {
# 	rofi -dmenu -no-fixed-num-lines -i -no-config -p "" -theme ~/.config/waybar/scripts/rofi/password.rasi	
# }

enter_password() {
	rofi -dmenu -no-fixed-num-lines -i -no-config -p "" -theme ~/.config/waybar/scripts/rofi/password.rasi
}

if [ "$chosen_network" = " " ]; then
	exit
elif [ "$chosen_network" = "   Enable Wi-Fi" ]; then
	nmcli radio wifi on
elif [ "$chosen_network" = "   Disable Wi-Fi" ]; then
	nmcli radio wifi off
else
	# Message to show when connection is activated successfully
	success_message="You are now connected to the Wi-Fi network \"$chosen_id\"."
	# Get saved connections
	# saved_connections=$(nmcli -g NAME connection)
	if [[ $(echo "$wifi_list" | grep -w "$chosen_id" | awk '//') = "$chosen_id" ]]; then
		nmcli connection up id "$chosen_id" | grep "successfully" && notify-send "Connection Established" "$success_message"
	# elif [[ $(echo "$wifi_list" | grep -w "$chosen_id" | awk '//') = "$chosen_id" ]]; then
	# 	wifi_password=$(rofi -dmenu -no-config -i -no-fixed-num-lines -p "Password? : " -theme ~/.config/waybar/scripts/rofi/confirm.rasi)
	# 	nmcli device wifi connect "$chosen_id" password "$wifi_password" | grep "successfully" && notify-send "Connection Established" "$success_message"
	# fi
	elif
		secure_wifi=$(echo "$wifi_list" | grep -w "$chosen_id" | awk '//')
		if [[ "$chosen_network" = "$secure_wifi" ]]; then
			wifi_password=$(enter_password &)
		fi
		nmcli device wifi connect "$chosen_id" password "$wifi_password" | grep "successfully" && notify-send "Connection Established" "$success_message"
	fi
fi
