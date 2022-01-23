# strings

[API](README.md)

常見的字符串處理

導入代碼：
```
core.Import "core:strings.sh"
```

名稱前綴：
```
strings="core_strings"
```

變量列表：
* [Ok](#core_strings_Ok)
* [Strings](#core_strings_Strings)

函數列表：
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

變量 Ok 的值爲 1 或 0，在一些返回 bool 類型的函數執行結束時，如果函數返回真將設置 core_strings_Ok 爲 1，否則設置 core_strings_Ok 爲 0

```
$strings.StartWith "abc" "ab"
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
$strings.StartWith "abc" "ab"
if [[ $($strings.Ok) == 1 ]];then
    echo yes
else
    echo no
fi
```

# func_Strings

Strings 函數將調用 `Copy "$1" core_strings_Strings`，這將使用 eval 特性將 core_strings_Strings 的值拷貝到 $1 指定的變量中

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

`func StartWith(str: string, sub: string): 1 or 0` 判斷字符串是否以 sub 爲前綴，其結果保存到 core_strings_Ok 變量中

# EndWith

`func EndWith(str: string, sub: string): 1 or 0` 判斷字符串是否以 sub 結尾，其結果保存到 core_strings_Ok 變量中

# Split

`func Split(str: string, separator: string=" "): []string` 將字符串 str 以 separator 分割爲字符串數組，結果保存到 core_strings_Strings 變量中

# Join

`func Join(name: string, separator: string=" "): string` 函數使用 eval 實現將變量 name 中的數組以 separator 連接到一起

```
a=(a b c)
echo $($strings.Join a ,) # a,b,c
```

# TrimLeft

`func TrimLeft(str: string, sub: string): string` 將 str 左邊的 sub 子串全部刪除，並返回刪除後的字符串

# TrimRight

`func TrimRight(str: string, sub: string): string` 將 str 右邊的 sub 子串全部刪除，並返回刪除後的字符串

# Trim

`Trim(str: string, sub: string): string` 將 str 左右兩邊的 sub 子串全部刪除，並返回刪除後的字符串
