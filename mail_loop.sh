#!/bin/bash
# mymail_gmail_loop.sh

MAILDIR=/tmp/$USERNAME-mail_loop
mkdir --mode=700 $MAILDIR

while [ 1 ]; do
	val=$(~/.config/awesome/mail_loop_mymail.py)
	echo $val > $MAILDIR/mymail_count
	sleep 30
	val=$(~/.config/awesome/mail_loop_gmail.py)
	echo $val > $MAILDIR/gmail_count
	sleep 30
done
