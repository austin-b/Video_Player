#!/bin/bash

video_list="player_video_lists.txt"

video_streams=()

video_names=()

get_urls() {
	for url in `cat $video_list`
	do
		video_streams+=("$url")
	done
}

get_name() {
	name=$(youtube-dl --get-title $1 2> /dev/null)
	if [ $? != 0 ] # checks to see if last command failed
	then
		name="unavailable"
	fi
	echo $name
}

get_all_names() {
	for url in "${video_streams[@]}"
	do
		# only get first 50 characters
		name=$(get_name $url | head -c 50) 
		video_names+=("$name")
	done
}

edit_list() {
	vim $video_list
}

play_video() {
	# check to make sure choice isn't out of counds
	if [ $(( $1 + 1 )) -gt ${#video_streams[@]} ]
	then
		echo "incorrect choice"
	else
		youtube-dl -o- ${video_streams[$1]} | mplayer -vo caca - > /dev/null 2>&1
	fi
}

clear

tput setaf 2

echo "Loading ..."

get_urls
get_all_names

tput setaf 2

clear
echo ""
echo "Tom's Video Player Script"
echo ""

length=${#video_names[@]}

for (( i=0; i<${length}; i++ ))
do
	echo "		$i	${video_names[$i]}"
done

echo ""
echo "		e	Edit"
echo "		x	Exit"
echo ""
echo -n "Enter selection: "
read selection
echo ""

case $selection in
	"e") edit_list ;;
	"x") clear && exit ;;
	*) play_video $selection;;
esac
