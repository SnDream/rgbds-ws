#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# 脚本的用途和目标：
# 编写一个脚本，读取原始的文本文件，输出如下的内容
# autogen/pointer.asm - 文本指针的汇编文件
# autogen/text.asm - 文本内容的汇编文件
# autogen/charmap.inc - 自动生成的码表，汇编文件格式
# autogen/text.tbl - 自动生成的码表，自定义格式，建议为 编码=文字

pointer_asm = [
	"include \"include/macros.inc\"\n",
	"\n",
]

text_asm = [
	"include \"include/macros.inc\"\n",
	"include \"include/overlay.inc\"\n",
	"include \"autogen/charmap.inc\"\n",
	"\n",
]

charmap_asm = [
	"include \"include/charmap_w.inc\"\n",
	"\n",
	"\tnewcharmap_w 2\n",
	"\n",
]

text_tbl = [

]

# 编写你自己的文本读取和生成

# 分为三种生成的方式
# 第一种，是使用text.asm，里面包含文本的汇编方式组织的数据
# 第二种，生成一系列的bin文件，包含文本的数据，然后在text.asm中通过INCBIN的方式获取
# 第三种，完全不用这个脚本，自己编写额外的程序导入

with open('autogen/pointer.asm', 'w') as f:
	f.writelines(pointer_asm)

with open('autogen/text.asm', 'w') as f:
	f.writelines(text_asm)

with open('autogen/charmap.inc', 'w') as f:
	f.writelines(charmap_asm)

with open('autogen/text.tbl', 'w') as f:
	f.writelines(text_tbl)
