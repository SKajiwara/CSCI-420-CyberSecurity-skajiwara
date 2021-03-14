#!/bin/bash

# Dialog Menu Options
options=("Add Security Rule" "Modify Security Rule" "Delete Security Rule"
			"Display IP Tables" "Export IP Table to report.html" "Exit")
add_options=("Block Every Ping (IPv4)" "Block Every Ping (IPv6)" "Block Custom Ping (IPv4)"
				"Block Custom Ping (IPv6)" "Go Back")
mod_options=("")
del_options=("Remove Block Every Ping (IPv4)" "Remove Block Every Ping (IPv6)"
				"Remove Block Custom Ping (IPv4)" "Remove Block Custom Ping (IPv6)" "Go Back")

add_security_rule() {
    PS3="Please enter your choice [a number]: "
    select opt in "${add_options[@]}"; do
        printf "you chose choice $REPLY which is $opt\n\n"
        case $opt in
            "${add_options[0]}")
                tempEval=$(eval "iptables -L -v -n | grep -i '*       0.0.0.0/0'")
                tempScript="iptables -A INPUT -p icmp --icmp-type echo-request -j DROP"
                tempOpt=0
                break;;
            "${add_options[1]}")
                tempEval=$(eval "ip6tables -L -v -n | grep -i 'DROP       icmpv6'")
                tempScript="ip6tables -A INPUT -p icmpv6 --icmpv6-type echo-request -j DROP"
                tempOpt=1
                break;;
            "${add_options[2]}")
                echo -n "Type IP adress / range: "
                read ipAddr
                tempEval=$(eval "iptables -L INPUT -v -n | grep -i '$ipAddr'")
                tempScript="iptables -A INPUT -s $ipAddr -j DROP"
                tempOpt=2
                break;;
            "${add_options[3]}")
                echo -n "Type IP address / range: "
                read ipAddr
                tempEval=$(eval "ip6tables -L INPUT -v -n | grep -i '$ipAddr'")
                tempScript="ip6tables -A INPUT -s $ipAddr -j DROP"
                tempOpt=3
                break;;
			"${add_options[4]}")
				return 0; break;;
            *) printf "invalid option $REPLY\n\n";;
        esac
    done

    if [[ -z "$tempEval" ]]
		then
        result=$(eval "$tempScript | grep -i 'not found'")
    else
        printf "you already have ${add_options[$tempOpt]}\n\n"
    fi
}
modify_security_rule() {
	printf "This Feature is not Implemented yet...\n\n" # DEBUG
}
delete_security_rule() {
	PS3="Please enter your choice [a number]: "
	select opt in "${del_options[@]}"; do
		printf "you chose choice $REPLY which is $opt\n\n"
		case $opt in
			"${del_options[0]}")
				eval "sudo iptables -D INPUT -p icmp --icmp-type echo-request -j DROP"
				printf "you successfully removed ${add_options[0]}\n\n"; break;;
			"${del_options[1]}")
				eval "sudo ip6tables -D INPUT -p icmpv6 --icmpv6-type echo-request -j DROP"
				printf "you successfully removed ${add_options[1]}\n\n"; break;;
			"${del_options[2]}")
				echo -n "Type in IPv4 Address or Range: "
                read ipAddr
				eval "sudo iptables -D INPUT -s $ipAddr -j DROP"
                printf "you successfully removed ${add_options[2]}\n\n"; break;;
            "${del_options[3]}")
				echo -n "Type in IPv6 Address or Range: "
 				read ipAddr
				eval "ip6tables -D INPUT -s $ipAddr -j DROP"
                printf "you successfully removed ${add_options[3]}\n\n"; break;;
			"${del_options[4]}")
				return 0; break;;
			*) printf "invalid option $REPLY\n\n";;
		esac
	done
}
display_ip_tables() {
	printf "\nIPv4 Table:\n%s\n" "$(eval 'iptables -L -v -n')"
	printf "\nIPv6 Table:\n%s\n\n" "$(eval 'ip6tables -L -v -n')"
}
export_report() {
	Title="This is your security rule summary"
    {
        echo "<html>"
        echo "<head>"
        echo "<style type=\"text/css\">"
        echo "table {background-color:#DCDCDC}"
        echo "thead {color:#708090}"
        echo "tbody {color:#191970}"
        echo "th {text-align:left;max-width:300px;min-width:150px;word-wrap:break-word;}"
		echo "</style>"
        echo "</head>"
        echo "<body>"
        echo "<h1>$Title</h1>"
    } > report.html
    {
		echo "<h3>IPv4</h3>"
        echo "<table>"
        echo "<thead>"
        echo "<tr>"
        echo "<th>TYPE</th>"
        echo "<th>RULE</th>"
        echo "</tr>"
        echo "</thead>"
        echo "<tbody>"
    } >> report.html
	cal=$(iptables -L INPUT -v -n | grep -i pkts)
	input=$(iptables -L INPUT -v -n | grep -i icmp) 
    forward=$(iptables -L FORWARD -v -n | grep -i icmp)
    output=$(iptables -L OUTPUT -v -n | grep -i icmp)
   {
        echo "<tr>"
        echo "<td> </td>"
        printf "<td>$cal</td>"
        echo "</tr>"
		echo "<tr>"
		echo "<td>INPUT</td>"
		printf "<td>$input</td>"
		echo "</tr>"
        echo "<tr>"
        echo "<td>FORWARD</td>"
        printf "<td>$forward</td>"
        echo "</tr>"
        echo "<tr>"
        echo "<td>OUTPUT</td>"
        printf "<td>$output</td>"
        echo "</tr>"
		echo "</tbody>"
		echo "</table>"
    } >> report.html
	cal=$(ip6tables -L INPUT -v -n | grep -i pkts)
    input=$(ip6tables -L INPUT -v -n | grep -i icmp) 
    forward=$(ip6tables -L FORWARD -v -n | grep -i icmp)
    output=$(ip6tables -L OUTPUT -v -n | grep -i icmp)

	{
        echo "<h3>IPv6</h3>"
        echo "<table>"
        echo "<thead>"
        echo "<tr>"
        echo "<th>TYPE</th>"
        echo "<th>RULE</th>"
        echo "</tr>"
        echo "</thead>"
        echo "<tbody>" 
    } >> report.html  
   {
        echo "<tr>"
		echo "<td></td>"
		printf "<td>$cal</td>"
		echo "</tr>"
		echo "<tr>"
        echo "<td>INPUT</td>"
        printf "<td>$input</td>"
        echo "</tr>"
        echo "<tr>" 
        echo "<td>FORWARD</td>"
        printf "<td>$forward</td>"
        echo "</tr>"
        echo "<tr>"
        echo "<td>OUTPUT</td>"
        printf "<td>$output</td>"
        echo "</tr>"
		echo "</tbody>"
		echo "<table>"
        echo "</body>"
        echo "</html>"
    } >> report.html
	printf "IP Table Summary is successfully exported to report.html\n\n"
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
