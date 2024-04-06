.SUFFIXES:
.PHONY: all clean
.SECONDEXPANSION:
.PRECIOUS:
.SECONDARY:

DIR_ATG := autogen
DIR_DAT := data

RGBASM := rgbasm
RGBLINK := rgblink
RGBFIX := rgbfix
RGBGFX := rgbgfx

PIXGEN := tools/pixgen.py
TEXTGEN := tools/textgen.py

BASEROM := baserom.gbc

SRC := patch
LIB := ram orisymbols
INC := hardware constants macros charmap_w
GFX := 

SRC_ASM := $(addsuffix .asm,$(SRC))
LIB_ASM := $(addsuffix .asm,$(LIB))
INC_ASM := $(addprefix include/,$(addsuffix .inc,$(INC)))
GFX_PNG := $(addprefix gfx/,$(addsuffix .png,$(GFX)))

POIN_ASM := $(DIR_ATG)/pointer.asm
TEXT_DAT := $(DIR_DAT)/text.txt
TEXT_ASM := $(DIR_ATG)/text.asm
TEXT_TBL := $(DIR_ATG)/text.tbl
TEXT_CMP := $(DIR_ATG)/charmap.inc
FONT_ASM := $(DIR_ATG)/font.asm
FONT_DAT := $(DIR_DAT)/font.dat

ASM := $(SRC_ASM) $(LIB_ASM) $(TEXT_ASM) $(FONT_ASM) $(POIN_ASM)
OBJ := $(ASM:.asm=.o)
2BPP := $(GFX_PNG:.png=.2bpp)

ROM := output.gbc
MAP := $(ROM:.gbc=.map)
SYM := $(ROM:.gbc=.sym)

all: $(ROM)

textgen: $(TEXT_DAT) $(TEXTGEN)
	mkdir -p $(DIR_ATG)
	$(TEXTGEN)

pixgen: $(FONT_DAT) $(TEXT_TBL) $(PIXGEN)
	mkdir -p $(DIR_ATG)
	$(PIXGEN)

$(TEXT_CMP): textgen

$(TEXT_TBL): textgen

$(TEXT_ASM): textgen

$(POIN_ASM): textgen

$(FONT_ASM): pixgen

$(ROM): $(BASEROM) $(OBJ)
	$(RGBLINK) -n $(SYM) -m $(MAP) -o $@ -O $^
	$(RGBFIX) -p 0x00 -v $@

%.o: %.asm $(INC_ASM) $(LIB_ASM) $(TEXT_ASM) $(2BPP)
	$(RGBASM) -o $@ $<

gfx/%.2bpp: gfx/%.png
	$(RGBGFX) -o $@ $<

clean:
	rm -rf $(ROM) $(OBJ) $(MAP) $(SYM) $(2BPP) $(DIR_ATG)
