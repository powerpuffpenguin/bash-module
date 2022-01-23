# strings

[API](README.md)

用於修改終端的輸出顏色，對 8/16 色的函數化封裝

導入代碼：
```
core.Import "core:colors.sh"
```

名稱前綴：
```
colors="core_colors"
```

函數列表：
* [Reset](#Reset)
* [Default](#Default)
* [Set Colors](#Set_Colors)

# Reset

`func Reset()` 將前景色和背景色都恢復到默認顏色

```
$colors.Reset
```
# Default

`func Default(background:any=0)` 如果第一個參數傳入0則將背景色恢復到默認顏色，否則將前景色恢復到默認顏色

```
# 重置前景色
$colors.Default

# 重置背景色
$colors.Default 1
```
# Set_Colors

本庫還提供了多個函數用於設置前景色或背景色，它用法完全一致，只是設置的顏色依據函數名而各異，同時它們第一個可選參數如果傳入非 0 則設置背景色，否則設置前景色。


函數名如下可分爲4組：

1. White Black 
2. DarkGray LightGray
3. Red Green Yellow Blue Magenta Cyan
4. LightRed  LightGreen LightYellow LightBlue LightMagenta LightCyan