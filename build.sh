#!/bin/bash

function create {
	cd "$SRC"
	mkdir -p x1 x1_25 x1_5 x2
	cd "$SRC"/$1
	find . -maxdepth 1 -name "*.svg" -type f -exec sh -c 'inkscape -o "../x1/${0%.svg}.png" -w 32 -h 32 $0' {} \;
	find . -maxdepth 1 -name "*.svg" -type f -exec sh -c 'inkscape -o "../x1_25/${0%.svg}.png" -w 40 -h 40 $0' {} \;
	find . -maxdepth 1 -name "*.svg" -type f -exec sh -c 'inkscape -o "../x1_5/${0%.svg}.png" -w 48 -h 48 $0' {} \;
	find . -maxdepth 1 -name "*.svg" -type f -exec sh -c 'inkscape -o "../x2/${0%.svg}.png" -w 64 -h 64 $0' {} \;

	cd $SRC

	# generate cursors
	BUILD="$SRC"/../dist
	OUTPUT="$BUILD"/cursors
	ALIASES="$SRC"/cursorList

	if [ ! -d "$BUILD" ]; then
		mkdir "$BUILD"
	fi
	if [ ! -d "$OUTPUT" ]; then
		mkdir "$OUTPUT"
	fi

	echo -ne "Generating cursor theme...\\r"
	for CUR in config/*.cursor; do
		BASENAME="$CUR"
		BASENAME="${BASENAME##*/}"
		BASENAME="${BASENAME%.*}"

		xcursorgen "$CUR" "$OUTPUT/$BASENAME"
	done
	echo -e "Generating cursor theme... DONE"

	cd "$OUTPUT"

	#generate aliases
	echo -ne "Generating shortcuts...\\r"
	while read ALIAS; do
		FROM="${ALIAS#* }"
		TO="${ALIAS% *}"

		if [ -e $TO ]; then
			continue
		fi
		ln -sr "$FROM" "$TO"
	done < "$ALIASES"
	echo -e "Generating shortcuts... DONE"

	cd "$PWD"

	echo -ne "Generating Theme Index...\\r"
	INDEX="$OUTPUT/../index.theme"
	if [ ! -e "$OUTPUT/../$INDEX" ]; then
		touch "$INDEX"
		echo -e "[Icon Theme]\nName=$THEME\n" > "$INDEX"
	fi
	echo -e "Generating Theme Index... DONE"
}

# generate pixmaps from svg source
SRC=$PWD/src
THEME="Future Cursors Extra"

# --- SELECTION LOGIC ---

# 1. Check if user passed a folder name as an argument (e.g. ./build.sh svg-dark-yellow)
if [ -n "$1" ]; then
	if [ -d "$SRC/$1" ] && ls "$SRC/$1"/*.svg &>/dev/null; then
		create "$1"
		exit 0
	else
		echo "Error: '$1' is not a valid cursor folder inside src/"
		exit 1
	fi
fi

# 2. If no argument was provided, scan the directory and offer a menu selection
options=()
for dir in "$SRC"/*/; do
	dir=${dir%*/}
	folder_name=${dir##*/}
	if ls "$SRC/$folder_name"/*.svg &>/dev/null; then
		options+=("$folder_name")
	fi
done

if [ ${#options[@]} -eq 0 ]; then
	echo "No valid cursor folders with .svg files found inside src/"
	exit 1
fi

echo "Please select which cursor pack to build:"
select opt in "${options[@]}" "Quit"; do
	case $opt in
		"Quit")
			echo "Exiting."
			exit 0
			;;
		*)
			if [ -n "$opt" ]; then
				echo "Processing folder: $opt"
				create "$opt"
				break
			else
				echo "Invalid option. Please choose a number from the list."
			fi
			;;
	esac
done
