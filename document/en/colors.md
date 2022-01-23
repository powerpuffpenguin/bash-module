# strings

[API](README.md)

Used to modify the output color of the terminal, a functional encapsulation of 8/16 colors

import code:
```
core.Import "core:colors.sh"
```

namespace:
```
colors="core_colors"
```

function list:
* [Reset](#Reset)
* [Default](#Default)
* [Set Colors](#Set_Colors)

# Reset

`func Reset()` Restore both foreground and background colors to default colors

```
$colors.Reset
```
# Default

`func Default(background:any=0)` If the first parameter is passed in 0, restore the background color to the default color, otherwise restore the foreground color to the default color

```
# reset foreground color
$colors.Default

# reset background color
$colors.Default 1
```
# Set_Colors

This library also provides a number of functions for setting the foreground or background color. The usage is exactly the same, but the color set varies according to the function name. At the same time, if the first optional parameter of them is not 0, the background color is set. , otherwise set the foreground color.


Function names can be divided into 4 groups as follows:

1. White Black 
2. DarkGray LightGray
3. Red Green Yellow Blue Magenta Cyan
4. LightRed  LightGreen LightYellow LightBlue LightMagenta LightCyan