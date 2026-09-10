# Future Cursors Extra
This is a fork of [Future cursors](https://github.com/yeyushengfan258/Future-cursors) that adds more variations, allowing a wider variety of cursor themes to choose from

# Future cursors
This is an x-cursor theme inspired by macOS and
based on [capitaine-cursors](https://github.com/keeferrourke/capitaine-cursors).

## Installation
To install the cursor theme simply copy the compiled theme to your icons
directory. For local user installation:

```
./install.sh
```

For system-wide installation for all users:

```
sudo ./install.sh
```

Then set the theme with your preferred desktop tools.

## Building from source
You'll find everything you need to build and modify this cursor set in
the `src/` directory. To build the xcursor theme from the SVG source
run:

```
./build.sh svg-light-yellow
```

Replace "svg-light-yellow" with the name of the folder under src/ you wish to build and install.

This will generate the pixmaps and appropriate aliases.
The freshly compiled cursor theme will be located in `dist/`

## Preview
![Future](preview.png)
![Future](preview-1.png)
