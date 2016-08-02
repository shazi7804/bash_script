#! /bin/sh
# 
# Program: Optimize image file
# Author: shazi
trap 'stop' SIGUSR1 SIGINT SIGHUP SIGQUIT SIGTERM SIGSTOP

DIR="$1"

stop() {
	exit 0
}

helpmsg() {
	echo "Usage: $0 [DIR] [OPTION]"
    echo ""
    echo "OPTION:"
    echo "-jpg		use jpegoptim optimize jpg/jpeg."
    echo "-png		use optipng optimize png. (default level:o7)"
    echo ""
    echo "Example:"
    echo "$0 /image -jpg -png"
    echo ""
}

check_bin() {
	if [[ ! -x /usr/bin/jpegoptim ]]; then
		echo "Check jpegoptim install ... no"
		read -p "Do you want to install jpegoptim? [y/n]:" jpegoptim_ask
		if [[ $jpegoptim_ask = +(y|Y) ]]; then
			yum install -y jpegoptim
			echo "jpegoptim install finish."
		fi

	fi

	if [[ ! -x /usr/bin/optipng ]]; then
		echo "Check optipng install ... no"
		read -p "Do you want to install optipng? [y/n]:" optipng_ask
		if [[ $optipng_ask = +(y|Y) ]]; then
			yum install -y optipng
			echo "optipng install finish."
		fi
	fi
}

jpg_conv() {
    # Optimize JPEG/JPG images
    EXTENSIONS=jpe?g
    find "$DIR" -regextype posix-egrep -regex ".*\.(${EXTENSIONS})\$" -type f | xargs jpegoptim
}

png_conv() {
    find "$DIR" -name '*.png' | xargs optipng -nc -nb -o7 -full
}

convert=()

if [[ $# -gt 1 ]]; then
	for opt in $@
	do
		case $opt in
			-jpg)
				convert+=('jpg');;
			-png)
				convert+=('png');;
			-h|--help|-help)
				helpmsg
				exit;;
		esac
	done
else
	helpmsg
fi

for (( i = 0; i < ${#convert[@]}; i++ )); do
	check_bin
	if [[ "jpg" == ${convert[i]} ]]; then
		jpg_conv
	elif [[ "png" == ${convert[i]} ]]; then
		png_conv
	fi
done
