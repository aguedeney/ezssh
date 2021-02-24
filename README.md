```
#
# Automate SSH passwordless process (does the ugly manual work for you)
#
# IMPORTANT Requirement(s):
# This script requires Bash (latest version possible).
# This script will not work in Bourne (/bin/sh).
# BEWARE: In some older Unix/Linux based systems, /bin/sh points to bourne shell
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
# 10. Custom port assignment is supported (see example below), otherwise port 22 is used.
#
# Usage examples: <...> indicates information you are required to enter
# Linux (and Cygwin and MSYS, etc)
# wget -qLO- http://bit.ly/ezsshpass | bash -s "<your username>@<ip address or hostname>"
# wget -qLO- http://bit.ly/ezsshpass | bash -s <2222> "<your username>@<ip address or hostname>"
# wget -qLO- --no-check-certificate https://bit.ly/ezsshpass | bash -s "<your username>@<ip address or hostname>"
# wget -qLO- --no-check-certificate https://bit.ly/ezsshpass | bash -s <2222> "<your username>@<ip address or hostname>"
#
# MacOS X
# curl -sLo- http://bit.ly/ezsshpass | bash -s "<your username>@<ip address or hostname>"
# curl -sLo- http://bit.ly/ezsshpass | bash -s <2222> "<your username>@<ip address or hostname>"
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
```
