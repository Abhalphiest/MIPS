#
# Makefile for CCS Project
#

#
# Location of the processing programs
#
RASM  = /home/fac/wrc/bin/rasm
RLINK = /home/fac/wrc/bin/rlink

#
# Suffixes to be used or created
#
.SUFFIXES:	.asm .obj .lst .out

#
# Object files
#
OBJFILES = three_in_row.obj print.obj solve.obj stepback.obj

#
# Transformation rule: .asm into .obj
#
.asm.obj:
	$(RASM) -l $*.asm > $*.lst

#
# Transformation rule: .obj into .out
#
.obj.out:
	$(RLINK) -m -o $*.out $*.obj > $*.map

#
# Main target
#
three_in_row.out:	$(OBJFILES)
	$(RLINK) -m -o $*.out $(OBJFILES) > $*.map

clean:
	$(RM)	$(OBJFILES) three_in_row.out three_in_row.map three_in_row.lst
