# strings

[api](README.md)

導入代碼
```
Import "core:strings.sh"
```

名稱前綴
```
local strings="core_strings"
```

變量列表：
* [Ok](#core_strings_Ok)
* [Strings](#core_strings_Strings)

函數列表：

* [Ok](#Ok)
* [Strings](#Strings)
* [start_with](#start_with)
* [end_with](#end_with)
* [split](#split)
* [join](#join)
* [trim_left](#trim_left)
* [trim_right](#trim_right)
* [trim](#trim)

# core_strings_Ok

變量 Ok 的值爲 1 或 0，在一些返回 bool 類型的函數執行結束時，如果函數返回真將設置 core_strings_Ok 爲 1，否則設置 core_strings_Ok 爲 0

```
$strings.start_with "abc" "ab"
if [[ $core_strings_Ok == 1 ]];then
    echo yes
else
    echo no
fi
```

此外也可以調用 [Ok](#Ok) 函數來獲取 core_strings_Ok 的值

# core_strings_Strings

變量 core_strings_Strings 是一個字符串數組，在一些返回 []stirng 類型的函數執行結束時，這些函數的返回值將設置到 core_strings_Strings 中

# Ok

Ok 函數是獲取 core_strings_Ok 值的語法糖，通過此函數可以比寫 core_strings_Ok 變量名更容易判斷 core_strings_Ok 的結果

```
$strings.start_with "abc" "ab"
if [[ $($strings.Ok) == 1 ]];then
    echo yes
else
    echo no
fi
```

# Strings

Strings 函數將調用 `Copy "$1" core_strings_Strings`，這將使用 eval 特性將 core_strings_Strings 的值拷貝到 $1 指定的變量中

```
$strings.split "cd,e f,gh" ,
strs=()
$strings.Strings strs
for str in "${strs[@]}"
do
    echo $str
done
```

# start_with

`func start_with(str: string, sub: string): 1 or 0` 判斷字符串是否以 sub 爲前綴，其結果保存到 core_strings_Ok 變量中

# end_with

`func end_with(str: string, sub: string): 1 or 0` 判斷字符串是否以 sub 結尾，其結果保存到 core_strings_Ok 變量中

# split

`func split(str: string, separator: string=" "): []string` 將字符串 str 以 separator 分割爲字符串數組，結果保存到 core_strings_Strings 變量中

# join

`func join(name: string, separator: string=" "): string` 函數使用 eval 實現將變量 name 中的數組以 separator 連接到一起

```
a=(a b c)
echo $($strings.join a ,) # a,b,c
```

# trim_left

`func trim_left(str: string, sub: string): string` 將 str 左邊的 sub 子串全部刪除，並返回刪除後的字符串

# trim_right

`func trim_right(str: string, sub: string): string` 將 str 右邊的 sub 子串全部刪除，並返回刪除後的字符串

# trim

`trim(str: string, sub: string): string` 將 str 左右兩邊的 sub 子串全部刪除，並返回刪除後的字符串
