#!/bin/bash
# mymail_gmail_loop.sh

MAILDIR=/tmp/$USER-mail_loop
mkdir --mode=700 $MAILDIR 2>/dev/null

while [ 1 ]; do
	val=$(timeout -k 30 25 ~/.config/awesome/mail_loop_mymail.py)
	if [[ "$val" == "" ]]; then val = "?"; fi
	echo $val > $MAILDIR/mymail_count
	sleep 30
	val=$(timeout -k 30 25 ~/.config/awesome/mail_loop_gmail.py)
	if [[ "$val" == "" ]]; then val = "?"; fi
	echo $val > $MAILDIR/gmail_count
	sleep 30
done
