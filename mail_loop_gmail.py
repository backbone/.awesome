#!/usr/bin/python

# Create credentials.py with gmail_login and gmail_password variables

import imaplib

try:
    from credentials import gmail_login,gmail_password
    M=imaplib.IMAP4_SSL("imap.gmail.com", 993)
    M.login(gmail_login,gmail_password)
    status, counts = M.status("Inbox","(MESSAGES UNSEEN)")
    unread = counts[0].split()[4][:-1]
    M.logout()
    print(int(unread))
except:
    print("?")
