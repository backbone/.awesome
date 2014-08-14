#!/usr/bin/python

# Create credentials.py with gmail_login and gmail_password variables

import imaplib

#default imap port is 993, change otherwise
M=imaplib.IMAP4_SSL("imap.gmail.com", 993)
from credentials import gmail_login,gmail_password
M.login(gmail_login,gmail_password)

status, counts = M.status("Inbox","(MESSAGES UNSEEN)")

unread = counts[0].split()[4][:-1]

print(int(unread))

M.logout()
