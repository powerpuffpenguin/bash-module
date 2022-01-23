# strings

[API](README.md)

Common String Handling

import code:
```
core.Import "core:strings.sh"
```

namespace:
```
strings="core_strings"
```

variables list:
* [Ok](#core_strings_Ok)
* [Strings](#core_strings_Strings)

function list:
* [Ok](#Ok)
* [Strings](#func_Strings)
* [StartWith](#StartWith)
* [EndWith](#EndWith)
* [Split](#Split)
* [Join](#Join)
* [TrimLeft](#TrimLeft)
* [TrimRight](#TrimRight)
* [Trim](#Trim)

# core_strings_Ok

The value of the variable Ok is 1 or 0. At the end of the execution of some functions that return bool type, if the function returns true, core_strings_Ok will be set to 1, otherwise core_strings_Ok will be set to 0

```
$strings.StartWith "abc" "ab"
if [[ $core_strings_Ok == 1 ]];then
    echo yes
else
    echo no
fi
```

In addition, you can also call the [Ok](#Ok) function to get the value of core_strings_Ok

# core_strings_Strings

The variable core_strings_Strings is an array of strings, at the end of the execution of some functions returning []stirng type, the return value of these functions will be set to core_strings_Strings

# Ok

The Ok function is a syntactic sugar for obtaining the value of core_strings_Ok. Through this function, it is easier to judge the result of core_strings_Ok than writing the variable name of core_strings_Ok

```
$strings.StartWith "abc" "ab"
if [[ $($strings.Ok) == 1 ]];then
    echo yes
else
    echo no
fi
```

# func_Strings

The Strings function will call `Copy "$1" core_strings_Strings`, which will use the eval attribute to copy the value of core_strings_Strings into the variable specified by $1

```
$strings.Split "cd,e f,gh" ,
strs=()
$strings.Strings strs
for str in "${strs[@]}"
do
    echo $str
done
```

# StartWith

`func StartWith(str: string, sub: string): 1 or 0` Determine whether the string is prefixed with sub, and save the result to the core_strings_Ok variable

# EndWith

`func EndWith(str: string, sub: string): 1 or 0` Determine whether the string ends with sub, and save the result to the core_strings_Ok variable

# Split

`func Split(str: string, separator: string=" "): []string` Split the string str into a string array by "separator" and save the result to the core_strings_Strings variable

# Join

`func Join(name: string, separator: string=" "): string` The function is implemented using eval, which concatenates the arrays in the variable name with "separator"

```
a=(a b c)
echo $($strings.Join a ,) # a,b,c
```

# TrimLeft

`func TrimLeft(str: string, sub: string): string` Delete all the "sub" substrings on the left of string and return the deleted string

# TrimRight

`func TrimRight(str: string, sub: string): string` Delete all the "sub" substrings on the right of string and return the deleted string

# Trim

`Trim(str: string, sub: string): string` Delete all the "sub" substrings on the left and right sides of str, and return the deleted string
