#!/bin/bash
# mymail_gmail_loop.sh

MAILDIR=/tmp/$USERNAME-mail_loop
mkdir --mode=700 $MAILDIR

while [ 1 ]; do
	val=$(~/.config/awesome/mymail_unread.py)
	echo $val > $MAILDIR/mymail_count
	sleep 30
	val=$(~/.config/awesome/gmail_unread.py)
	echo $val > $MAILDIR/gmail_count
	sleep 30
done
