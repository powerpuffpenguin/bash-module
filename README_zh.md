# bash-module

[English](README.md)

這是一個 bash 腳本的編寫規範，以及在此規範下創建的庫，其主要目的在於解決 bash 腳本的模塊化問題

* [爲何創建此庫](#爲何創建此庫)
* [規範](#規範)
* [API](document/zh_Hant/README.md)
* [安裝](#安裝)
* [定義模塊](#定義模塊)
* [導入模塊](#導入模塊)

# 爲何創建此庫 

當我越來越多的使用 bash 腳本越發發現它的方便之處，基本所有 *inix 上的可以執行，無需額外的依賴。例如在一個 docker 中想要運行 python 或 js 還需要額外安裝運行環境，python 或 nodejs 環境會讓這個 docker 變得臃腫，但使用 bash 腳本就沒有這些問題。此外即時在 windows 上也有 msys 等環境可以運行 bash，這使 bash 的可用範圍變得更廣闊。

然而 bash 沒有一個很好的模塊化方案，所以想復用代碼變得比較困難，好在 bash 還算靈活，只要遵守一些規範並稍加封裝就可以實現模塊化，於是本喵創建了一些模塊化的規範並爲此提供了基礎的封裝 core.sh

# 規範

1. 一個腳本定義一個模塊，模塊提供的變量和函數都應該帶有一個統一的名稱前綴以避免名稱衝突，名稱前綴我們稱爲 **namespace**

    例如一個字符串處理的模塊，其 namespace 可以是 strings

    ```
    # 定義變量
    strings_Version="v1.0.0"

    # 定義 trim 函數
    function strings.trim
    {}
    ```

2. namespace 應該是全小寫的英文單詞，通常應該和其存儲的檔案路徑一致，多個單詞以**_** 連接，例如：

    * strings
    * cache
    * cache_lru
    * cache_lru_timer

3. 模塊應該在最前面加上一個 __module_flag_of_**namespace** 變量，用於避免被多次導入

    ```
    if [[ "$__module_flag_of_core_colors" == 1 ]];then
        return 0
    fi
    __module_flag_of_core_colors=1
    ```

4. 全局變量名和函數名使用駝峯式的英文單詞，公開的變量和函數應該首字母大小，私有的應該首字母小寫

5. 全局變量名應該使用 **_** 連接名稱和 namespace，私有的應該使用 **__** 連接名稱和 namespace 以避免最終名稱和其它 namespace 重名

    ```
    # 私有變量
    strings__var
    # 公有變量
    strings_Var
    ```

6. 公有函數應該使用 **.** 連接名稱和 namespace，私有的應該使用 **._** 連接名稱和 namespace 以避免調用公有方法時首字母錯誤的小寫調用到了同名私有方法

    ```
    # 私有方法
    function strings._hasPrefix
    {}
    # 公有方法
    function strings.HasPrefix
    {}
    ```