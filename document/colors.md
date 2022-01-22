# strings

[api](README.md)

用戶修改終端的輸出顏色，對 8/16 色的函數化封裝

導入代碼
```
Import "core:colors.sh"
```

名稱前綴
```
local colors="core_colors"
```

函數列表：

* [reset](#reset)
* [default](#default)
* [set colors](#colors)
# reset

`func reset()` 將前景色和背景色都恢復到默認顏色

```
$colors.reset
```
# default

`func default(background:any=0)` 如果第一個參數傳入0則將背景色恢復到默認顏色，否則將前景色恢復到默認顏色

```
# 重置前景色
$colors.default

# 重置背景色
$colors.default 1
```
# colors

本庫還提供了多個函數用於設置前景色或背景色，它用法完全一致，只是設置的顏色依據函數名而各異，同時它們第一個可選參數如果傳入非 0 則設置背景色，否則設置前景色。


函數名如下可分爲4組：

1. white black 
2. dark_gray light_gray
3. red green yellow blue magenta cyan
4. light_red  light_green light_yellow light_blue light_magenta light_cyan