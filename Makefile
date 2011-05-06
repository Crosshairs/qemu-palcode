CROSS = alphaev67-linux-
CC = $(CROSS)gcc
LD = $(CROSS)ld

CORE = typhoon
SYSTEM = clipper

ASFLAGS = -Wa,-m21264 -Wa,--noexecstack
CFLAGS = -Os -g -Wall -fvisibility=hidden -fno-strict-aliasing \
  -msmall-text -msmall-data -mno-fp-regs -mbuild-constants
CPPFLAGS = -DSYSTEM_H='"sys-$(SYSTEM).h"'

CFLAGS += -mcpu=ev67

OBJS = pal.o sys-$(SYSTEM).o init.o crb.o uart.o console.o console-low.o \
	memset.o printf.o util.o ps2port.o

all: palcode-$(SYSTEM)

palcode-$(SYSTEM): palcode.ld $(OBJS)
	$(LD) -relax -o $@ -T palcode.ld -Map $@.map $(OBJS)

clean:
	rm -f *.o
	rm -f palcode-*

pal.o: pal.S osf.h sys-$(SYSTEM).h core-$(CORE).h
init.o: init.c hwrpb.h osf.h uart.h sys-$(SYSTEM).h core-$(CORE).h
printf.o: printf.c uart.h
uart.o: uart.c uart.h protos.h
crb.o: crb.c hwrpb.h protos.h console.h uart.h
console.o: console.c console.h protos.h
