#!/usr/bin/env python3

# 这个脚本用于生成字库
# 脚本的目标
# 1. 打开text.tbl文件，读取
# 2. 读取一个包含全部字库的数据文件
# 3. 根据text.tbl文件，生成字库的bin文件
# 4. 编写生成汇编文件的代码，在font.asm中引用这些bin文件

font_asm = [

]

# 编写你自己的字库读取和生成

with open('./autogen/font.asm', 'w') as f:
	f.writelines(font_asm)
