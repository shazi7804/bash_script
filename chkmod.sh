#!/bin/bash    
#                                                                 
# Program: Check the directory permissions
# Author: shazi
NginxRoot="/usr/share/nginx/html"
GitRoot="${NginxRoot}/git"
TestRoot="${NginxRoot}/test"
ProdRoot="${NginxRoot}/prod.*"

chkmod() {
	unset OPTIND
	while getopts "d:t:m:u:g:" opt
	do
		case $opt in
			d)
				dir="$OPTARG";;
			t)
				types="$OPTARG";;
			m)
				mode="$OPTARG";;
			u)
				ownerUser="$OPTARG";;
			g)
				ownerGroup="$OPTARG";;
		esac
	done

	if [[ "d" == $types ]]; then
		find $dir ! \( -perm $mode \) -type d -exec chmod -R $mode {} \;
		find $dir ! \( -user $ownerUser -group $ownerGroup \) -type d -exec chown -R $ownerUser:$ownerGroup {} \;
	elif [[ "f" == $types ]]; then
		find $dir ! \( -perm $mode \) -type f -exec chmod -R $mode {} \;
		find $dir ! \( -user $ownerUser -group $ownerGroup \) -type f -exec chown -R $ownerUser:$ownerGroup {} \;
	else
		echo "**Error: The file type not allow value."
	fi
}

cleantmp() {
    find $NginxRoot -type f -iname .DS_Store -delete
}

# chk GIT site
chkmod -t d -d $GitRoot -m 770 -u git -g nginx
chkmod -t f -d $GitRoot -m 660 -u git -g nginx

# chk Test site
chkmod -t d -d $TestRoot -m 700 -u nginx -g nginx
chkmod -t f -d $TestRoot -m 600 -u nginx -g nginx

cleantmp












