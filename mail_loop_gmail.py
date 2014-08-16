#!/usr/bin/python

# Create ~/.local/share/keyrings/mail_loop_keys.py:
# gmail_login = 'username'
# gmail_password = 'password'

import imaplib,sys,os

try:
    sys.path.insert (0, os.getenv("HOME")+"/.local/share/keyrings")
    from mail_loop_keys import gmail_login,gmail_password
    M=imaplib.IMAP4_SSL("imap.gmail.com", 993)
    M.login(gmail_login,gmail_password)
    status, counts = M.status("Inbox","(MESSAGES UNSEEN)")
    unread = counts[0].split()[4][:-1]
    M.logout()
    print(int(unread))
except:
    print("?")
