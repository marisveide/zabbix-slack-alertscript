#!/bin/bash

# Slack incoming web-hook URL and user name
url="$1"		# example: https://hooks.slack.com/services/QW3R7Y/D34DC0D3/BCADFGabcDEF123
username="$2"

## Values received by this script:
# To = $1 (Slack channel or user to send the message to, specified in the Zabbix web interface; "@username" or "#channel")
# Subject = $2 (usually either PROBLEM or RECOVERY)
# Message = $3 (whatever message the Zabbix action sends, preferably something like "Zabbix server is unreachable for 5 minutes - Zabbix server (127.0.0.1)")

# Get the Slack channel or user ($1) and Zabbix subject ($2 - hopefully either PROBLEM or RECOVERY)
to="$3"
subject="$4"

if [[ "$subject" == *"RECOVER"* ]]; then
	status_emoji=":white_check_mark: "
elif [[ "$subject" = *"PROBLEM"* ]]; then
	status_emoji=":exclamation: "
else
	status_emoji=""
fi

icon="\"icon_url\": \"https://jujucharms.com/_icon/120/zabbix-java-gateway.png\""


# The message that we want to send to Slack is the "subject" value ($2 / $subject - that we got earlier)
#  followed by the message that Zabbix actually sent us ($3)
message="*${status_emoji}${subject}:*\n$5"


# Build our JSON payload and send it as a POST request to the Slack incoming web-hook URL
payload="payload={\"channel\": \"${to//\"/\\\"}\", \"username\": \"${username//\"/\\\"}\", \"text\": \"${message//\"/\\\"}\", $icon}"
curl -m 5 --data-urlencode "${payload}" $url
