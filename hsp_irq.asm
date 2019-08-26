
	include default.ini

	org $0fff
	adr $1001

	adr bas_end
	adr 2017
	byt $9e,"4109",0,0,0
bas_end = *-2

main:
	sei
	sta $ff3f
	
	lda #$17
	sta $ff06
	
	jsr irq_init
	
	ldx #0
	stx shift
	
	cli
	
	lda #$f0
loop:
	ldy #25
-   cmp $ff1d
	bne *-3
	cmp $ff1d
	beq *-3
	dey
	bne -

	if 1
	inx
	cpx #40
	bne +
	ldx #0
+   stx shift
	endif
	
	jmp loop
	
	

shift = $ff
raster_line = 0

	align 256

irq_init:
	lda #2+hi(raster_line)
	sta $ff0a
	lda #lo(raster_line)
	sta $ff0b
	
	lda #lo(irq)
	sta $fffe
	lda #hi(irq)
	sta $ffff
	dec $ff09
	rts

irq:
	pha
	txa
	pha
	dec $ff09
		
	ldx shift
	bne +
	
	;case: 0
	
	jmp irq_exit
	
+   lda tab_t,x
	bpl till38
	
	;case: 39
	
	tya
	pha
	
	lda $ff1d
	cmp $ff1d
	beq *-3
	nop
	nop
	lda $ff1e
	lsr
	lsr
	sta *+4
	bpl *+2
	byt [7] $c9
	cmp $ea
	
	lda # $CA ! $ff
	ldx # $8E ! $ff	;8E
	ldy # $A2 ! $ff
	sta $ff1e
	stx $ff1e
	sty $ff1e
	
	pla
	tay
	jmp irq_exit
	
	;case: 1-38
	
till38:
	sta timing
	lda tab_v1,x
	sta val1
	lda tab_v2,x
	tax
	
	lda $ff1d
	cmp $ff1d
	beq *-3
	nop
	nop
	lda $ff1e
	lsr
	asr #$fe
timing = *+1
	adc #0
	sta *+4
	bpl *+2
	byt [5+65-2] $c9
	cmp $ea
val1 = *+1
	lda #$35
	sta $ff1e
;val2 = *+1
	nop
	stx $ff1e
	
irq_exit:
	
	pla
	tax
	pla
	rti

tab_t:
    ;    0  1  2  3
	byt 29,29,29,29
	;    4  ...  36
	byt 29,28,27,26,25,24,23,22,21,20
	byt 19,18,17,16,15,14,13,12,11,10
	byt  9, 8, 7, 6, 5, 4, 3, 2, 1, 0
	byt 64,63,62
	;   37 38
	byt 62,62
	;    39
	byt 255 ; sentinel
	
tab_v1:
	byt $25,$25+4,$25+8,$25+12
	;    4  ...  36
	byt [33] $35
	;      37    38
	byt $35+4,$35+8
	
tab_v2:
	byt $f1,$f1,$f1,$f1
	;    4  ...  36
	byt $f1,$ed,$e9,$e5,$e1,$dd,$d9,$d5
	byt $d1,$cd,$c9,$c5,$c1,$bd,$b9,$b5
	byt $b1,$ad,$a9,$a5,$a1,$9d,$99,$95
	byt $91,$8d,$89,$85,$81,$7d,$79,$75,$71
	;    37  38
	byt $71,$71
	