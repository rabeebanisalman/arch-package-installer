#!/usr/bin/bash

install(){
	local pac=$1
	if pacman -Qi "$pac" &> /dev/null || yay -Qi "$pac" &> /dev/null; then
		echo "$pac already exists."
	else
		if pacman -Si "$pac" &> /dev/null; then
			if sudo pacman -S "$pac" --noconfirm &> /dev/null < /dev/null; then
				echo "$pac successfully installed."
			else
				echo "error: $pac couldn't be installed."
			fi
		elif yay -Si "$pac" &> /dev/null; then
			if yay -S "$pac" --noconfirm &> /dev/null < /dev/null; then
				echo "$pac successfully installed."
			else
				echo "error: $pac couldn't be installed."
			fi
		else
			echo "error: $pac couldn't be found."
		fi
	fi
}

loading(){
	sleep 1
	printf "."
	sleep 1
	printf "."
	sleep 1
	printf "."
}


if [ "$#" -eq 1 ]; then
	file=$1
	printf "synchronizing package database(this might take some time)"
	loading
	echo
	sudo pacman -Syu &> /dev/null < /dev/null
	while read line; do
		printf "downloading $line"
		loading
		echo
		install "$line"
	done < "$file"
else
	echo "error: provide only target file."
fi
