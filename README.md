# TED-Hacks
7360 TED video chip related stuff

## hsp_irq.asm

This is the demonstation of something what is called DMA delay on C64, except that it does not delay the DMA on TED. :) So, I prefer to call it HSP what stands for horizontal screen positioning, as it can shift the char/color matrix by 1-39 positions making large horizontal shift possible without rewriting the whole char/color matrix. 
This code is the essence of a LOT of experimntation with the infamous $FF1E register. I am not sure why it works yet. It most likely hacks the inner char position pointer by messing with some pointer increment start/stop (maybe reload) events mentioned in some TED documents.

## Requirements

 - GNU Make
 - The Macroassembler AS: http://john.ccac.rwth-aachen.de:8000/as/
 - Platform: Win, Linux or Android (Termux).
