include mkdefs.select

RUN = hsp_irq.prg

all: hsp_irq.prg

run: $(RUN)
	$(EMU) $(RUN) &

%.prg: %.asm
	$(ASS) $(*)

%_exo.prg: %.prg
	$(EXO) sfx basic -M 512 -p 1 -t4 -n -o $@ $<

clean :
	@-$(RM) *.prg *.lst *.inc
