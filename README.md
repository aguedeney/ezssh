# ezssh
A simple automated password-less ssh configuration

Usage examples:<br>
wget -qLO- http://bit.ly/ezssh | bash -s "<username@mybox.aws.com>"<br>
wget -qLO- --no-check-certificate https://bit.ly/ezssh | bash -s username@10.0.1.1<br>
wget -qLO- --no-check-certificate https://bit.ly/ezssh | bash -s "<username@mybox.aws.com>"<br>
<br>
curl -sLo- http://bit.ly/ezssh | bash -s username@10.0.1.1<br>
curl -sLo- http://bit.ly/ezssh | bash -s "<username@mybox.aws.com>"<br>
<br>
Benefits and features of this script:
 1. New accounts that have never had ssh password-less enabled
 2. Can run this script from anywhere you have access to this website.
 3. Deletes old entries and updates them with new ones
 4. Works (tested) on MacOSX, Linux, and Cygwin (Windows)
 5. Generates password-less keys automatically if they do not exist
 6. Backs-up previous existing authorized_keys file (remote machine) if one exists<
 7. You can pass in a non-standard port (optional)
 8. Support for DSA, RSA, and ECDSA
 9. CYGWIN_NT supported along with Window's space character in username
    (Use .ssh/config trick to support other methods for usernames with spaces)
    
Important Notes and Conditions:
 1.  The first time this script runs you'll need to login with your password.
     However, the second time you should just be able to login password-less.
 2.  This also assumes the SSHD (server) allows password-less configurations
 3.  Cygwin - Sometimes Cygwin home directories are not setup correctly.
     In which case, please make sure your HOME directory is pointing to the correct physical
     location in the filesystem.
 4.  Some administrators have password-less turned off. Therefore, if this script does
     not accomplish a password-less login, see your administrator. It *may* not be the
     fault of this script.
 5.  Ubuntu requires /bin/bash not /bin/sh (defaults to Dash) - Yes, this is non-standard.
     Technically, /bin/sh points to bourne shell similar implementation of bourne again shell (Bash).
     
Author: Alan Guedeney<br>
