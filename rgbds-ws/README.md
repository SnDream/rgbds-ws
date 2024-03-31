# rgbds-workspace

rgbds的简易编译工程。

# 使用方法

- 在 `patch.asm` 中编写补丁代码。
- 在 `ram.asm` 中配置使用到的内存。
- 在 `orisymbols.asm` 中配置原始ROM的代码。
- 将 `baserom.gbc` 放置在本目录下，作为编译的基础文件
- 执行 `make` 来进行编译。 执行 `make clean` 来清除编译内容。
- 输出文件为 `output.gbc` 和 `output.sym`

# 扩展用法

