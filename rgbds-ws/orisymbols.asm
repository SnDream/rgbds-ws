include "include/overlay.inc"

; 建议使用这个文件存放游戏原有的符号入口，以便调用使用

; 下面的为例子，不会被实际编译，供参考
IF 0
; HOMEBANK ROM的符号
	org $0000
oExampleSymRomHomeBank_Addr0000::

; BANK1 ROM的符号
	org $4000, $01
oExampleSymRomBank1_Addr4000::

; VRAM的符号
	org $8000
oExampleSymVram_Addr8000::

; BANK1 VRAM的符号
	org $8000, $1
oExampleSymVramBank1_Addr8000::

; BANK1 SRAM的符号
	org $a000, $1
oExampleSymSramBank1_AddrA000::

; WRAM的符号
	org $c000
oExampleSymWram_AddrC000::

; BANK1 WRAM的符号
	org $d000, $1
oExampleSymWramBank1_AddrD000::

; HRAM的符号
	org $ff80
oExampleSymHram_AddrFF80::
ENDC

; 可以照上述格式，在下面继续编写符号

