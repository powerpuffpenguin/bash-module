# bash-module

bash 和 python js lua 等比起來超級難寫，但 bash 基本在所有 *inux 上都可用，故用 bash 作爲自動化腳本還是相當誘人的。

但 bash 真的很難寫，特別是沒有完善的模塊化方案，好在只要定義一些工作規範，按照這些規範可以降低這些難度，本項目就是本喵爲解決這些問題進行的研究和實踐

# 安裝

將 **core** 檔案夾拷貝到 PATH 路徑下即可

```
sudo cp core /usr/local/bin/ -r
```

當然將 core 添加到 PATH 路徑下也是同樣的效果


# 核心功能

核心功能提供了此規範的基礎工具，只需要 **core/core.sh** 即可工作

**core/lib** 是建立在 core 基礎下的一些常用功能實現，你可以選擇是否要使用，此外參照 core/lib 下的代碼你也可以容易的建立自己的 bash 模塊化代碼庫

## 使用 core

此規模的所有代碼依賴於 core 的實現，所有所有腳本應該首先保證 core.sh 已經被正確加載了，故推薦在所有代碼第一行寫下如下代碼

```
#!/usr/bin/env bash
source core/core.sh
```

## 定義模塊 和 導入模塊
