#!/usr/bin/bash

install(){
	local pac=$1
	if ! pacman -Qi "$pac" &> /dev/null; then
		if pacman -Si "$pac" &> /dev/null; then
			sudo pacman -S "$pac"
		elif command -v yay &> /dev/null && yay -Si "$pac" &> /dev/null; then
			yay -S "$pac"
		elif git ls-remote "$pac" &> /dev/null; then
			git clone "$pac"
			local dir=$(basename "$pac" .git)
			(
				cd "$dir"||exit
				makepkg -si
			)
		else
			echo "$pac package not found"
		fi
	else
		echo "$pac package already exists"						
	fi
}

loading (){
	local pac=$1
	echo "$pac installing."
	sleep 1
	printf "."
	sleep 1
	printf "."
	echo
}

read -p "file: " file

while read line; do
	loading "$line"
	install "$line"
done < "$file"
