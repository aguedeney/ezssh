# ezssh
automated password-less ssh configuration

Usage examples:<br>
wget -qLO- http://bit.ly/ezssh | bash -s "<username@mybox.aws.com>"<br>
wget -qLO- --no-check-certificate https://bit.ly/ezssh | bash -s username@10.0.1.1<br>
wget -qLO- --no-check-certificate https://bit.ly/ezssh | bash -s "<username@mybox.aws.com>"<br>
<br>
curl -sLo- http://bit.ly/ezssh | bash -s username@10.0.1.1<br>
curl -sLo- http://bit.ly/ezssh | bash -s "<username@mybox.aws.com>"<br>
