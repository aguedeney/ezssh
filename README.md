# ezssh
password-less ssh configuration

Usage examples:
wget -qLO- http://bit.ly/ezssh | bash -s "<username@mybox.aws.com>"
wget -qLO- --no-check-certificate https://bit.ly/ezssh | bash -s username@10.0.1.1
wget -qLO- --no-check-certificate https://bit.ly/ezssh | bash -s "<username@mybox.aws.com>"

curl -sLo- http://bit.ly/ezssh | bash -s username@10.0.1.1
curl -sLo- http://bit.ly/ezssh | bash -s "<username@mybox.aws.com>"
