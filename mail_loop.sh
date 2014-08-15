#!/bin/bash
# mymail_gmail_loop.sh

while [ 1 ]; do
	val=$(~/.config/awesome/mymail_unread.py)
	echo $val > ~/.mymail_count
	sleep 30
	val=$(~/.config/awesome/gmail_unread.py)
	echo $val > ~/.gmail_count
	sleep 30
done
