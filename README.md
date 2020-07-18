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
Benefits and features of this script:<br>
 1. New accounts that have never had ssh password-less enabled<br>
 2. Can run this script from anywhere you have access to this website.<br>
 3. Deletes old entries and updates them with new ones<br>
 4. Works (tested) on MacOSX, Linux, and Cygwin (Windows)<br>
 5. Generates password-less keys automatically if they do not exist<br>
 6. Backs-up previous existing authorized_keys file (remote machine) if one exists<br>
 7. You can pass in a non-standard port (optional)<br>
 8. Support for DSA, RSA, and ECDSA<br>
 9. CYGWIN_NT supported along with Window's space character in username<br>
    .ssh/config trick to support other methods for usernames with spaces<br>

Important Notes and Conditions:<br>
 1.  The first time this script runs you'll need to login with your password.<br>
     However, the second time you should just be able to login password-less.<br>
 2.  This also assumes the SSHD (server) allows password-less configurations<br>
 3.  Cygwin - Sometimes Cygwin home directories are not setup correctly.<br>
     In which case, please make sure your HOME directory is pointing to the correct physical<br>
     location in the filesystem.<br>
 4.  Some administrators have password-less turned off. Therefore, if this script does<br>
     not accomplish a password-less login, see your administrator. It *may* not be the<br>
     fault of this script.<br>
 5.  Ubuntu requires /bin/bash not /bin/sh (defaults to Dash) - Yes, this is non-standard.<br>
     Technically, /bin/sh points to bourne shell similar implementation of bourne again shell (Bash).<br>
<br>
Author: Alan Guedeney<br>
