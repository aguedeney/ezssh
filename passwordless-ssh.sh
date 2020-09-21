#!/usr/bin/env bash
#
# Automate SSH passwordless process (does the ugly manual work for you)
#
# Requirement:
# This script will not work with Bourne shell.
# This script requires Bash (latest version possible).
#
# Description:
# Benefits and features of this script:
# 1.  New accounts that have never had ssh password-less enabled
# 2.  Can run this script from anywhere you have access to this website.
# 3.  Deletes old entries and updates them with new ones
# 4.  Works (tested) on MacOSX, Linux, and Cygwin (Windows)
# 5.  Generates password-less keys automatically if they do not exist
# 6.  Backs-up previous existing authorized_keys file (remote machine) if one exists
# 7.  You can pass in a non-standard port (optional)
# 8.  Support for DSA, RSA, and ECDSA
# 9.  CYGWIN_NT supported along with Window's space character in username
#     .ssh/config trick to support other methods for usernames with spaces
# 10. Custom port assignment is supported (see example below), otherwise default port 22 is used.
#
# Usage examples:
# Linux
# wget -qLO- http://bit.ly/ezsshpass | bash -s "<your username>@<ip address or hostname"
# wget -qLO- http://bit.ly/ezsshpass | bash -s 2222 "<your username>@<ip address or hostname"
# wget -qLO- --no-check-certificate https://bit.ly/ezsshpass | bash -s "<your username>@<ip address or hostname"
# wget -qLO- --no-check-certificate https://bit.ly/ezsshpass | bash -s "<your username>@<ip address or hostname"
# wget -qLO- --no-check-certificate https://bit.ly/ezsshpass | bash -s 2222 "<your username>@<ip address or hostname"
#
# MacOS X
# curl -sLo- http://bit.ly/ezsshpass | bash -s "<your username>@<ip address or hostname"
# curl -sLo- http://bit.ly/ezsshpass | bash -s "<your username>@<ip address or hostname"
# curl -sLo- http://bit.ly/ezsshpass | bash -s 2222 "<your username>@<ip address or hostname"
#
# Notes and Conditions:
# 1.  The first time this script runs you'll need to login with your password.
#     However, the second time you should just be able to login password-less.
# 2.  This also assumes the SSHD (server) allows password-less configurations
# 3.  Cygwin - Sometimes Cygwin home directories are not setup correctly.
#     In which case, please make sure your HOME directory is pointing to the correct physical
#     location in the filesystem.
# 4.  Some administrators have password-less turned off. Therefore, if this script does
#     not accomplish a password-less login, see your administrator. It *may* not be the
#     fault of this script.
# 5.  On Ubuntu /bin/sh defaults to dash which will not work for this script.
#     Verify that /bin/sh points to bash not bourne shell.
#
# DISCLAIMER: Use at your own risk. We are not responsible for loss or damages of any kind
#             in the use of this script or indirect programs or applications.
#
# Author: Alan Guedeney

# Common defaults
SSH_HOME_DIR=${HOME}/.ssh
SSH_LOCAL_USER="$USER@$HOSTNAME"
EZSSH_DEBUG="${EZSSH_DEBUG}"
# Authorized/2 key filenames
AUTH_KEYS_FILE=authorized_keys
AUTH_KEYS_FILE2=authorized_keys2
# Public key location
DSA_PUB_FILE=id_dsa.pub
RSA_PUB_FILE=id_rsa.pub
DSA_PUB_LOCATION=${SSH_HOME_DIR}/${DSA_PUB_FILE}
RSA_PUB_LOCATION=${SSH_HOME_DIR}/${RSA_PUB_FILE}
AUTH_KEYS_LOCATION=${SSH_HOME_DIR}/${AUTH_KEYS_FILE}
# ssh-keygen is required.
SSH_KEYGEN=$(which ssh-keygen)
if [ -z "${SSH_KEYGEN}" ]; then
    echo "Please install openssh or put ${SSH_KEYGEN} in your PATH."
    exit 1
fi
# 2 arguments are passed, special non-standard port
if [ $# -eq 2 ]; then
    # Port may not be using standard, however empty will default to standard.
    SSH_REMOTE_PORT="$1"
    SSH_REMOTE_USER="$2"
# 1 argument is passed, standard port
else
    # Else it's the standard port 22
    SSH_REMOTE_PORT=${SSH_REMOTE_PORT:=22}
    SSH_REMOTE_USER="$1"
fi
# If argument is not passed, let's make sure the SSH_REMOTE_USER environment variable
# is set at least.
if [ -z "$SSH_REMOTE_USER" ]; then
   echo "Usage: $0 <remoteusername@remotemachine>"
   exit 1
fi
# ssh must be installed otherwise exit with fail exit code
if [ ! -f /usr/bin/ssh-keygen ]; then
   echo "Could not find ssh-keygen ... Please install ssh."
   exit 1
fi
# Set DSA public key file location, else generate it
if [ -f "${DSA_PUB_LOCATION}" ]; then
   DSAKEY=$(cat "${DSA_PUB_LOCATION}")
else
   ssh-keygen -f "$SSH_HOME_DIR/id_dsa" -t dsa -P '' >/dev/null 2>&1
fi
# Set RSA public key file location, else generate it
if [ -f "${RSA_PUB_LOCATION}" ]; then
   RSAKEY=$(cat "${RSA_PUB_LOCATION}")
else
   ssh-keygen -f "$SSH_HOME_DIR/id_rsa" -t rsa -P '' >/dev/null 2>&1
fi
# Extract the KEY only and retain it in an environment variable
DSA_KEY=$(cat "${DSA_PUB_LOCATION}" | cut -d' ' -f 2)
RSA_KEY=$(cat "${RSA_PUB_LOCATION}" | cut -d' ' -f 2)
# Some bash shells required this value to be an exported env. variable
export DSA_KEY RSA_KEY SSH_LOCAL_USER AUTH_KEYS_FILE
ssh -p ${SSH_REMOTE_PORT} "$SSH_REMOTE_USER" '/bin/bash -s' << EOF
# Keep track of return codes in an array stack for debugging LINENUMBER[RETURNCODE]
RETURNCODES=()
function rc() {
  if [[ "\$1" -eq "0" ]]; then
     RETURNCODES+=("\$2[\$1]:\t\$3\n")
  else
     echo "Bad return code: \$2[\$1]:\$3"
     echo "Please report this to AGuedeney: aguedeney@gmail.com."
     exit 1
  fi
}
# Print array stack
function printrc() {
  # Environment variable must be set to receive DEBUG messages from remote script
  if [ ! -z "${EZSSH_DEBUG}" ]; then
      for line in "\${RETURNCODES[@]}"
      do
        printf "\${line}"
      done
  fi
}
BKUPFILE=~/.ssh/.$AUTH_KEYS_FILE.\$$.bak
if [[ -f ~/.ssh/$AUTH_KEYS_FILE ]]; then
    if [[ ! -f ~/.ssh/$AUTH_KEYS_FILE2 ]]; then
        ln -s ~/.ssh/$AUTH_KEYS_FILE ~/.ssh/$AUTH_KEYS_FILE2 >/dev/null 2>&1
        rc \$? \$LINENO "Created AUTH2 symlink."
    fi
    grep -w "${SSH_LOCAL_USER}" ~/.ssh/$AUTH_KEYS_FILE >/dev/null 2>&1
    RC=\$?
    rc \$? \$LINENO "Grep'd through AUTH_KEYS_FILE."
    if [[ "\$RC" -eq "0" ]]; then
    # MacOS implementation (due to limited sed implementation)
       if [[ "\$(uname -s)" == "Darwin" ]]; then
           rc 0 \$LINENO "MacOS implementation"
           # First backup authorized_keys file before modifying it.
           cp ~/.ssh/$AUTH_KEYS_FILE \$BKUPFILE
           rc \$? \$LINENO "Created backup file for AUTH_KEYS_FILE."
           sed -i '/ssh-rsa.*[[:<:]]$SSH_LOCAL_USER[[:>:]]/d' ~/.ssh/$AUTH_KEYS_FILE
           rc \$? \$LINENO "Replaced ssh-rsa AUTH_KEYS_FILE with \$SSH_LOCAL_USER."
           sed -i '/ssh-dss.*[[:<:]]$SSH_LOCAL_USER[[:>:]]/d' ~/.ssh/$AUTH_KEYS_FILE
           rc \$? \$LINENO "Replaced ssh-dss AUTH_KEYS_FILE with \$SSH_LOCAL_USER."
           echo "ssh-dss $DSA_KEY $SSH_LOCAL_USER" >> ~/.ssh/$AUTH_KEYS_FILE
           echo "ssh-rsa $RSA_KEY $SSH_LOCAL_USER" >> ~/.ssh/$AUTH_KEYS_FILE
           chmod 700 ~/.ssh >/dev/null 2>&1
           rc \$? \$LINENO "Applied 700 permissions to .ssh directory"
           chmod 600 ~/.ssh/authorized_keys >/dev/null 2>&1
           rc \$? \$LINENO "Applied 600 permissions to ~/.ssh/\$AUTH_KEYS_FILE"
           rc \$? \$LINENO "Completed successfully!"
           printrc
           exit 0
       elif [[ "\$(uname -s)" == "CYGWIN_NT"* ]]; then
         rc 0 \$LINENO "CYGWIN"
         # Allow tilde to expand properly when special chars like spaces in username
         USER_HOME=~
         # First backup authorized_keys file before modifying it.
         cp "\${USER_HOME}/.ssh/$AUTH_KEYS_FILE" "\$BKUPFILE"
         rc \$? \$LINENO "Successfully created \$BKUPFILE backup file."
         # Delete DSA & RSA & ECDSA previous entries based on SSH_LOCAL_USER id
         sed -i '/ssh-dss.*\b$SSH_LOCAL_USER\b/d' "\${USER_HOME}/.ssh/$AUTH_KEYS_FILE"
         rc \$? \$LINENO "Replaced ssh-dss AUTH_KEYS_FILE with \$SSH_LOCAL_USER."
         sed -i '/ssh-rsa.*\b$SSH_LOCAL_USER\b/d' "\${USER_HOME}/.ssh/$AUTH_KEYS_FILE"
         rc \$? \$LINENO "Replaced ssh-rsa AUTH_KEYS_FILE with \$SSH_LOCAL_USER."
         echo "ssh-dss $DSA_KEY $SSH_LOCAL_USER" >> "\${USER_HOME}/.ssh/$AUTH_KEYS_FILE"
         echo "ssh-rsa $RSA_KEY $SSH_LOCAL_USER" >> "\${USER_HOME}/.ssh/$AUTH_KEYS_FILE"
         chmod 700 "\${USER_HOME}/.ssh" >/dev/null 2>&1
         rc \$? \$LINENO "Applied 700 permissions to .ssh directory"
         chmod 600 "\${USER_HOME}/.ssh/authorized_keys" >/dev/null 2>&1
         rc \$? \$LINENO "Applied 600 permissions to \${USER_HOME}/.ssh/\$AUTH_KEYS_FILE"
         rc \$? \$LINENO "Completed successfully!"
         printrc
         exit 0
       # GNU implementation (most platforms should work with this implementation)
       else
           rc 0 \$LINENO "GNU implementation"
           # First backup authorized_keys file before modifying it.
           cp ~/.ssh/$AUTH_KEYS_FILE \$BKUPFILE
           rc \$? \$LINENO "Successfully created \$BKUPFILE backup file."
           # Delete DSA & RSA & ECDSA previous entries based on SSH_LOCAL_USER id
           sed -i '/ssh-dss.*\b$SSH_LOCAL_USER\b/d' ~/.ssh/$AUTH_KEYS_FILE
           rc \$? \$LINENO "Replaced ssh-dss AUTH_KEYS_FILE with \$SSH_LOCAL_USER."
           sed -i '/ssh-rsa.*\b$SSH_LOCAL_USER\b/d' ~/.ssh/$AUTH_KEYS_FILE
           rc \$? \$LINENO "Replaced ssh-rsa AUTH_KEYS_FILE with \$SSH_LOCAL_USER."
           echo "ssh-dss $DSA_KEY $SSH_LOCAL_USER" >> ~/.ssh/$AUTH_KEYS_FILE
           echo "ssh-rsa $RSA_KEY $SSH_LOCAL_USER" >> ~/.ssh/$AUTH_KEYS_FILE
           chmod 700 ~/.ssh >/dev/null 2>&1
           rc \$? \$LINENO "Applied 700 permissions to .ssh directory"
           chmod 600 ~/.ssh/authorized_keys >/dev/null 2>&1
           rc \$? \$LINENO "Applied 600 permissions to ~/.ssh/\$AUTH_KEYS_FILE"
           rc \$? \$LINENO "Completed successfully!"
           printrc
           exit 0
       fi
    # Warn user of a potentially misconfigured HOME directory
    elif [[ "\$RC" -eq "2" ]]; then
        rc 0 \$LINENO "Please review \$HOME/.ssh/authorized_keys for duplications."
        rc 1 \$LINENO "Potentially misconfigured HOME directory."
    else
        echo "ssh-dss $DSA_KEY $SSH_LOCAL_USER" >> ~/.ssh/$AUTH_KEYS_FILE
        echo "ssh-rsa $RSA_KEY $SSH_LOCAL_USER" >> ~/.ssh/$AUTH_KEYS_FILE
        chmod 700 ~/.ssh >/dev/null 2>&1
        rc \$? \$LINENO "Applied 700 permissions to .ssh directory"
        chmod 600 ~/.ssh/authorized_keys >/dev/null 2>&1
        rc \$? \$LINENO "Applied 600 permissions to ~/.ssh/\$AUTH_KEYS_FILE"
        rc \$? \$LINENO "Completed successfully!"
        printrc
        exit 0
    fi
# Authorized key file does not exist, so we need to create it
else
     rc 0 \$LINENO "Create *new* .ssh directory and authorized key file."
     mkdir -p ~/.ssh
     rc \$? \$LINENO "Create ~/.ssh directory because it does not exist."
     chmod 700 ~/.ssh >/dev/null 2>&1
     rc \$? \$LINENO "Applied 700 permissions to .ssh directory"
     echo "ssh-dss $DSA_KEY $SSH_LOCAL_USER" >> ~/.ssh/$AUTH_KEYS_FILE
     echo "ssh-rsa $RSA_KEY $SSH_LOCAL_USER" >> ~/.ssh/$AUTH_KEYS_FILE
     chmod 600 ~/.ssh/authorized_keys >/dev/null 2>&1
     rc \$? \$LINENO "Applied 600 permissions to ~/.ssh/\$AUTH_KEYS_FILE"
     ln -s ~/.ssh/$AUTH_KEYS_FILE ~/.ssh/$AUTH_KEYS_FILE2 >/dev/null 2>&1
     rc \$? \$LINENO "Created AUTH2 symlink."
     rc \$? \$LINENO "Completed successfully!"
     printrc
     exit 0
fi
EOF
