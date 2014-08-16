#!/usr/bin/python

# Create ~/.local/share/keyrings/mail_loop_keys.py:
# mymail_server = 'imap.example.com'
# mymail_port = 143
# mymail_login = 'username'
# mymail_password = 'password'

import imaplib,ssl,sys,os

# http://stackoverflow.com/questions/9713055/certificate-authority-for-imaplib-and-poplib-python
import imaplib,ssl
def IMAP_starttls(self, keyfile=None, certfile=None,cert_reqs=ssl.CERT_NONE,ca_certs=None):
  if not 'STARTTLS' in self.capabilities:
    raise self.error("STARTTLS extension not supported by server.")
  (resp, reply) = self._simple_command("STARTTLS")
  self.sock = ssl.wrap_socket(self.sock, keyfile, certfile,cert_reqs=cert_reqs,ca_certs=ca_certs)
  self.file = self.sock.makefile('rb')

imaplib.IMAP4.__dict__['starttls']=IMAP_starttls
imaplib.Commands['STARTTLS']=('NONAUTH',)

try:
    sys.path.insert (0, os.getenv("HOME")+"/.local/share/keyrings")
    from mail_loop_keys import mymail_server,mymail_port,mymail_login,mymail_password

    M=imaplib.IMAP4(mymail_server, mymail_port)
    M.starttls()
    M.login(mymail_login,mymail_password)

    status, counts = M.status("Inbox","(MESSAGES UNSEEN)")

    unread = counts[0].split()[4][:-1]
    M.logout()
    print(int(unread))
except:
    print("?")
