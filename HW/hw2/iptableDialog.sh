#!/bin/bash

# Dialog Menu Options
options=("Add Security Rule" "Modify Security Rule" "Delete Security Rule" 
			"Display IP Tables" "Export IP Table to report.html" "Exit")
add_options=("Block Every Ping (IPv4)" "Block Every Ping (IPv6)")
mod_options=("")
del_options=("Remove Block Every Ping (IPv4)" "Remove Block Every Ping (IPv6)")

add_security_rule() {
	echo "Add" # DEBUG
	PS3="Please enter your choice [a number]: "
	select opt in "${add_options[@]}"; do
		printf "you chose choice $REPLY which is $opt\n"
		case $opt in
			"${add_options[0]}")
				tempEval=$(eval "sudo iptables -L -v -n | grep -i '*       0.0.0.0/0'")
				tempScript="sudo iptables -A INPUT -p icmp --icmp-type echo-request -j DROP"
				tempOpt=0
				break;;
			"${add_options[1]}")
				tempEval=$(eval "sudo ip6tables -L -v -n | grep -i 'DROP       icmpv6'")
				if [[ -z "$tempEval" ]]; then
					eval "sudo ip6tables -A INPUT -p icmpv6 --icmpv6-type echo-request -j DROP"
					printf "you successfully added ${opt}\n\n"
				else
					printf "you alreay have ${opt}\n\n"
				fi;break;;
			*) printf "invalid option $REPLY\n";;
		esac
	done
	if [[ -z "$tempEval" ]];then
    	eval "$tempScript"
       	printf "you successfully added ${add_options[$tempOpt]}\n"
    else
        printf "you already have ${add_options[$tempOpt]}\n"
    fi
}
modify_security_rule() {
	echo "Mod" # DEBUG
}
delete_security_rule() {
	echo "Del" # DEBUG	
	PS3="Please enter your choice [a number]: "
	select opt in "${del_options[@]}"; do
		printf "you chose choice $REPLY which is $opt\n"
		case $opt in
			"${del_options[0]}")
				eval "sudo iptables -D INPUT -p icmp --icmp-type echo-request -j DROP"
				printf "you successfully removed ${add_options[0]}\n\n"; break;;
			"${del_options[1]}")
				eval "sudo ip6tables -D INPUT -p icmpv6 --icmpv6-type echo-request -j DROP"
				printf "you successfully removed ${add_options[1]}\n\n"; break;;
			*) printf "invalid option $REPLY\n\n";;
		esac
	done
}
display_ip_tables() {
	echo "Dis" # DEBUG

	printf "\nIPv4 Table:\n%s\n" "$(eval 'iptables -L -v -n | more')"
	printf "\nIPv6 Table:\n%s\n\n" "$(eval 'ip6tables -L -v -n | more')"
}
export_report() {
	{
		echo "<html>"
		echo "<head>"
		echo "<style type=\"text/css\">"
		echo "table{background-color:#DCDCDC}"
		echo "thead {color:#708090}"
		echo "tbody {color:#191970}"
		echo "</style>"
		echo "</head>"
		echo "<body>"
		echo "<table border=\"1\">"
		echo "<thead>"
		echo "<tr width="100" bgcolor='#C0C0C0'><center><td colspan="3"><font color="#000000"><b>CONSOLIDATED RUNBOOK</b></font></center></td>"
		echo "</h4>"
		echo "</tr>"
		echo "<tr>"
		echo "<th><col width="100"><font color="000000">APP NAME</font></th>"
		echo "<th><col width="100"><font color="000000">STATUS</font></th>"
		echo "<th><col width="100"><font color="000000">STATUS AS ON</font></th>"
		echo "</tr>"
	}> text.html
}
main() {
	PS3='Please enter your choice: '; clear
    while true; do
        select opt in "${options[@]}"; do
            clear; printf "you choose choice $REPLY which is $opt\n"
            case $opt in
                "${options[0]}")          # Add Security Rule
                    add_security_rule;    break;;
                "${options[1]}")          # Modify Security Rule
                    modify_security_rule; break;;
                "${options[2]}")          # Delete Security Rule
                    delete_security_rule; break;;
                "${options[3]}")          # Display Security Rules
                    display_ip_tables;    break;;
				"${options[4]}")		  # Export report as report.html
					export_report;        break;;
                "${options[5]}")          # Exit Dialog
                    break 2;;
                *) printf "invalid option $REPLY\n";;
            esac
        done
    done
}

# RUN MAIN
main
