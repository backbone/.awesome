#!/usr/bin/python

# Create credentials.py with mymail_login, mymail_password, mymail_server, mymail_port variables

import imaplib,ssl

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
    # read credentials
    from credentials import mymail_server,mymail_port,mymail_login,mymail_password

    M=imaplib.IMAP4(mymail_server, mymail_port)
    M.starttls()
    M.login(mymail_login,mymail_password)

    status, counts = M.status("Inbox","(MESSAGES UNSEEN)")

    unread = counts[0].split()[4][:-1]
    M.logout()
    print(int(unread))
except:
    print("?")
