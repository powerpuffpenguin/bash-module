# lib

* [strings](strings.md)
* [colors](colors.md)

# core

導入代碼
```
source core.sh
```

函數列表：
* [Import](#Import)
* [Copy](#Copy)
* [GetField](#GetField)
* [SetField](#SetField)
* [Field](#Field)
* [Error](#Error)
* [ErrorStack](#ErrorStack)

# Import

Import 函數用於導入一個模塊

```
Import a.sh
Import core:strings.sh
```

所有以 **core:** 爲前綴的模塊會從 core.sh 所在的路徑下的 lib 檔案夾中查找，所有非此前綴的將以相對與調用 Import 函數所在腳本的相對路徑查找

比如上述腳本存儲在 **~/project/bash/main.sh** 中，**core.sh** 存儲在 **/usr/local/bin/core.sh**則：
* `Import a.sh` 將加載 **~/project/bash/a.sh**
* `Import core:strings.sh` 將加載 **/usr/local/bin/lib/strings.sh**

這樣設計的目的在於，同一個庫的實現者可以方便的使用相對路徑加載本庫中的代碼。

當使用第三方庫時將其存儲到 lib 下以全局的 **core:xxx** 路徑加載會比較方便

# Copy

`Copy dst src` 函數是一個語法糖，它將使用 eval 來複製數組，因爲我覺得 bash 複製數組的寫法要敲太多次鍵盤很不利於鍵盤的保養

```
local a=(a b c)
local b
# 將 數組 a 拷貝到 數組 b
Copy b a # b=("${a[@]}")
# eval b=("${a[@]}")
```

# GetField

GetField 是獲取數組元素的語法糖，也使用 eval 實現

> 通常數組沒有必要這麼操作，但如果你要模擬一個 object 時，GetField 會讓代碼更可讀，要模擬 objcet 可以參考 test/core/zoo.sh 的實現

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

SetField 是設置數組元素的語法糖，也使用 eval 實現

> 通常數組沒有必要這麼操作，但如果你要模擬一個 object SetField 會讓代碼更可讀，要模擬 objcet 可以參考 test/core/zoo.sh 的實現

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

Field 是 GetField SetField 的語法糖，當傳入兩個參數時，它會調用 GetField，當傳入三個參數時它會調用 SetField。這在模擬 object 時可以方便的爲其模擬 setter 和 getter 方法

```
# func Field(object: string, i: number, value?: any)
function Field
{
    ...
}
```

# Error

Error 實際上是 `echo "$@" 1>&2` 的語法糖，使用方法和 echo 一樣，它只將 使用 stderror 而非 stdout 來輸出

bash 中的函數如果要返回字符串需要使用 stdout，所以最好將錯誤輸出到 stderror 這樣就避免的 錯誤輸出 和 返回輸出 都交錯在 stdout 中

```
Error "Error: an error occurred"
```
# ErrorStack

ErrorStack 將當前的調用棧打印到 stderror，此外 ErrorStack 的第一個參數可以指定要跳過多少層棧信息 

```
ErrorStack
ErrorStack 1
```