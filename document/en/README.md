# lib

* [strings](strings.md)
* [colors](colors.md)

# core

import code:
```
source core.sh
```

namespace:
```
core
```

function list:
* [Import](#Import)
* [Copy](#Copy)
* [GetField](#GetField)
* [SetField](#SetField)
* [Field](#Field)
* [Error](#Error)
* [ErrorStack](#ErrorStack)

# Import

Import function is used to import a module

```
core.Import a.sh
core.Import core:strings.sh
```

All modules prefixed with **core:** will be searched from the core.libs folder under the path where core.sh is located, and all modules other than this prefix will be searched relative to the script where the Import function is called.

For example, the above script is stored in **~/project/bash/main.sh**, and **core.sh** is stored in **/usr/local/bin/core.sh**:
* `core.Import a.sh` will load **~/project/bash/a.sh**
* `core.Import core:strings.sh` will load **/usr/local/bin/core.libs/strings.sh**

The purpose of this design is that the implementers of the same library can easily use relative paths to load the code in this library.

When using a third-party library, it is more convenient to store it under lib and load it with the global **core:xxx** path

# Copy

The `Copy dst src` function is a syntactic sugar, it will use eval to copy the array, because I think the bash copy array writing method requires too many keystrokes, which is not conducive to the maintenance of the keyboard

```
local a=(a b c)
local b
# copy array a to array b
core.Copy b a # b=("${a[@]}")
# eval b=("${a[@]}")
```

# GetField

GetField is syntactic sugar for getting array elements, also implemented using eval

> Usually it is not necessary to do this with arrays, but if you want to simulate an object, GetField will make the code more readable. To simulate objcet, you can refer to the implementation of test/core/zoo.sh

```
# func GetField(object: string, i: number)
function GetField
{
    eval "echo \${$1[$2]}"
}
```

```
a=(a b c)
v=`GetField a 0`
echo $v #a
v=`GetField a1`
echo $v #b
```

# SetField

SetField is syntactic sugar for setting array elements, also implemented using eval

> Usually it is not necessary to do this with arrays, but if you want to simulate an object SetField to make the code more readable, to simulate objcet you can refer to the implementation of test/core/zoo.sh

```
# func SetField(object: string, i: number, value: any)
function SetField
{
    eval "$1[$2]=\"$3\""
}
```

```
a=(a b c)
SetField a 0 A
SetField a 1 B
echo ${a[@]} # A B c
```

# Field

Field is syntactic sugar for GetField SetField, which calls GetField when two arguments are passed, and SetField when three arguments are passed. This can be convenient for mocking setter and getter methods when mocking object

```
# func Field(object: string, i: number, value?: any)
function Field
{
    ...
}
```

# Error

rror is actually syntactic sugar for `echo "$@" 1>&2`, it is used in the same way as echo, it will only use stderr instead of stdout to output

Functions in bash need to use stdout if they want to return a string, so it is better to output errors to stderr so that the error output and return output are avoided in stdout

```
core.Error "Error: an error occurred"
```
# ErrorStack

ErrorStack prints the current call stack to stderr, and the first parameter of ErrorStack can specify how many layers of stack information to skip

```
core.ErrorStack
core.ErrorStack 1
```