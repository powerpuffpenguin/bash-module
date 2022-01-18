# bash-module

bash 和 python js lua 等比起來超級難寫，但 bash 基本在所有 *inux 上都可用，故用 bash 作爲自動化腳本還是相當誘人的。

但 bash 真的很難寫，特別是沒有完善的模塊化方案，好在只要定義一些工作規範，按照這些規範可以降低這些難度，本項目就是本喵爲解決這些問題進行的研究和實踐

**注意** 本規範不考慮效率問題其中大量使用了 eval，因爲 bash 語法特性實在有限只能借用 eval 來實現一些語法糖特性，不過好在 bash 腳本通常不需要處理效率要求很高的東西，如果要求高效你應該選擇 lua nodejs 之類的腳本它們不但更高效而且比 bash 更加好寫。bash 的特色是系統內置，以低效的文字流黏合各種工具以替代人工

# 安裝

將 **core/core.sh** 檔案夾拷貝到 PATH 路徑下即可

```
sudo cp core/core.sh /usr/local/bin/ 
```

當然將 core.sh 添加到 PATH 路徑下也是同樣的效果


# 核心功能

核心功能提供了此規範的基礎工具，只需要 **core/core.sh** 即可工作

**core/lib** 是建立在 core 基礎下的一些常用功能實現，你可以選擇是否要使用，此外參照 core/lib 下的代碼你也可以容易的建立自己的 bash 模塊化代碼庫，如果要請將 **lib** 檔案夾和 **core.sh** 放到相同目錄

## 使用 core

此規模的所有代碼依賴於 core 的實現，所有主腳本應該首先保證 core.sh 已經被正確加載了，故推薦在所有代碼第一行寫下如下代碼

```
#!/usr/bin/env bash
source core.sh
```

如果不確定可以在所有腳本都加上上述代碼 core.sh 會檢測如果已經被加載過則什麼都不做

## 定義模塊

1. 一個模塊存儲在一個檔案中，模塊中所有 方法 和 變量都應該有一個 統一的 prefix (例如有一個處理字符串的模塊 prefix 可以是固定爲 **stirngs** )
2. 模塊提供的方法應該命名爲 prefix.XXX (例如 strings.start_with)
3. 模塊提供的變量應該命名爲 prefix_XXX (例如 strings_Ok)

## 導入模塊

core.sh 中提供了一個全局函數 `func Import(path: string)` 用於加載子模塊

1. path 應該是相對當前腳本的相對路徑
2. 有個例外是 以 **core:** 爲前綴的模塊會優先從 core.sh 所在檔案夾下的 lib 檔案夾中尋找子模塊如果沒有再以相對路徑加載

```
# 加載 strings.sh 模塊
Import "core:strings.sh"

# 定義一個變量簡化模塊方法調用
strings="core_strings"

# 調用模塊提供的函數
$strings.start_with "abcdef" "abc"

# 處理函數返回值
if [[ $core_strings_Ok == 1 ]];then 
    echo yes
else
    echo no
fi
```