;;;;;;;;;;;
;Controller functions
ReadController:
  LDA #$01
  STA CONTROLLER
  LDA #$00
  STA CONTROLLER    ; tell both the controllers to latch buttons
  
  LDX #$08		  ; set x to 8
ReadControllerLoop:
  LDA CONTROLLER, y
  LSR A            ; bit0 -> Carry
  ROL temp		   ; bit0 <- Carry
  DEX			   ; decrement x
  BNE ReadControllerLoop
  RTS
  
;;;;;;;;;;;
;graphical functions

printTxt:
  LDA text, x	; load data from address (background + the value in x)
  SEC
  SBC #$20
  STA PPUDATA             ; write to PPU
  INX                   ; X = X + 1
  CPX printLong         ; Compare X to printLong, decimal 128 - copying 128 bytes
  BNE printTxt  ; Branch to LoadBackgroundLoop if compare was Not Equal to zero
                        ; if compare was equal to 128, keep going down
  RTS
  
printTxtBuff:
  LDX pointerBufferW
  LDY printStart
  LDA printLong
  STA PPUBUFFERW, x
  INX
  LDA pointerPPUHi
  STA PPUBUFFERW, x
  INX
  LDA pointerPPULo
  STA PPUBUFFERW, x
  INX
printTxtBuffLoop:
  LDA text, y
  SEC
  SBC #$20
  STA PPUBUFFERW, x
  INX
  INY
  LDA printLong
  SEC
  SBC #$01
  STA printLong
  CMP #$00
  BNE printTxtBuffLoop
  STX pointerBufferW
  RTS

clearTxt:
  LDA #$00			; load data from address (background + the value in x)
  STA PPUDATA             ; write to PPU
  INX                   ; X = X + 1
  CPX printLong         ; Compare X to printLong, decimal 128 - copying 128 bytes
  BNE clearTxt  ; Branch to LoadBackgroundLoop if compare was Not Equal to zero
                        ; if compare was equal to 128, keep going down
  RTS

clearTxtBuff:
  LDX pointerBufferW
  LDA printLong
  STA PPUBUFFERW, x
  TAY
  INX
  LDA pointerPPUHi
  STA PPUBUFFERW, x
  INX
  LDA pointerPPULo
  STA PPUBUFFERW, x
  INX
clearTxtBuffLoop:
  LDA #CLEARTULE
  STA PPUBUFFERW, x
  INX
  DEY
  CPY #$00
  BNE clearTxtBuffLoop
  STX pointerBufferW
  RTS
  
clearScreenBuff:
  ;before call the method you have to initate
  ;the pointer by the following code:
  ;LDA #$00
  ;STA pointerLo
  ;LDA #$20
  ;STA pointerHi
  LDX pointerBufferW
  LDA #$20			;size of a line
  STA PPUBUFFERW, x
  TAY
  INX
  LDA pointerHi
  STA PPUBUFFERW, x
  INX
  LDA pointerLo
  STA PPUBUFFERW, x
  INX
LineLoopBuff:
  LDA #CLEARTULE
  STA PPUBUFFERW, x
  INX
  DEY
  CPY #$00
  BNE LineLoopBuff
  
  LDA pointerLo
  CLC
  ADC #$20
  STA pointerLo
  BCC noIncHi
  LDA pointerHi	; if carry is not set, inrement Hi
  CLC
  ADC #$01
  STA pointerHi
noIncHi:

  LDA pointerHi
  CMP #$23
  BNE noResetCB
  LDA pointerLo
  CMP #$C0
  BNE noResetCB

  ;LDA #CLEARED
  ;STA substate
noResetCB:
  RTS
  
printVar:
  LDY pointerBufferW
  LDA #$02
  STA PPUBUFFERW, y
  INY
  LDA pointerPPUHi
  STA PPUBUFFERW, y
  INY
  LDA pointerPPULo
  STA PPUBUFFERW, y
  INY
  
  LDA temp
  AND #$F0
  CLC
  ROR A
  ROR A
  ROR A
  ROR A
  STA temp1
  JSR getHexa
  LDA temp1
  CLC
  ADC temp2
  STA PPUBUFFERW, y
  INY
  
  LDA temp
  AND #$0F
  STA temp1
  JSR getHexa
  LDA temp1
  CLC
  ADC temp2
  STA PPUBUFFERW, y
  INY
  
  STY pointerBufferW
  
  RTS
  
getHexa:
  LDA temp1
  CMP #$0A
  BCC hexaMinus
  LDA #$37
  STA temp2
  JMP hexaPlus
hexaMinus:
  LDA #$30
  STA temp2
hexaPlus:
  
  RTS

; input X et Y 
; output pointerPPU : position
setPPUADDR:
	LDA #$00
	STA pointerPPULo
	CLC
	TXA
	;CMP #$1F
	AND #$3F	;
	CMP #$20
	BCS .1
	LDA #$20
	JMP .2
.1
	LDA #$24
.2	
	STA pointerPPUHi

.yLoop:	
	CPY #$00
	BEQ .yOut		;si y != 0
	LDA pointerPPULo
	CLC
	ADC #$20
	STA pointerPPULo
	BCC .hiInc
	INC pointerPPUHi	
.hiInc:
	DEY
	JMP .yLoop
.yOut:

	TXA
	;CMP #$20
	;BCS .3
	AND #$1F
;.3
	CLC
	ADC pointerPPULo
	STA pointerPPULo
	
	RTS

; draw one tule (buffered fonction)
; input : 
;	- pointerPPU	: position
;		  arg1 		: tule
drawPPU:
	LDX pointerBufferW
	LDA #$01
	STA PPUBUFFERW, x
	INX
	LDA pointerPPUHi
	STA PPUBUFFERW, x
	INX
	LDA pointerPPULo
	STA PPUBUFFERW, x
	INX

	LDA arg1
	STA PPUBUFFERW, x
	INX
	STX pointerBufferW
	
	RTS
	
; read PPU fonction
; inputs :
;	Y	: Y position au tile to read
;	X	: X position au tile to read
;	arg1	: Hi part of memory dress to stock the result
;	arg2	: Lo part of memory dress to stock the result
readTilePPU:
	JSR setPPUADDR
	LDX pointerBufferL
	LDA pointerPPUHi
	STA PPUBUFFERL, x
	INX 
	LDA pointerPPULo
	STA PPUBUFFERL, x
	INX
	LDA arg1
	STA PPUBUFFERL, x
	INX 
	LDA arg2
	STA PPUBUFFERL, x
	INX
	STX pointerBufferL
	
	RTS


; --- SPRITE FONCTIONS ---  

LoadPlayerSprite:

  JSR getPlrSprAdr

  LDY #$00              
LoadSpriteLoop:			; only load tile and attr
  INY
  LDA [pointerLo], y    ;
  STA [pointer1Lo], y          ; $0200 pour P1, $0214 pour P2?
  INY                   ;
  LDA [pointerLo], y    ;
  STA [pointer1Lo], y  
  INY
  INY
  CPY #SPRITESIZE              ; 
  BNE LoadSpriteLoop

  RTS  
  
setPosPlrSpr:
  
  JSR getPlrSprAdr
  
  LDY #$00              
setSpriteLoop:			; only load tile and attr
  LDA [pointerLo], y    ;
  CLC
  ADC PosY
  STA [pointer1Lo], y          ; $0200 pour P1, $0214 pour P2?
  INY                   ;
  INY
  INY
  LDA [pointerLo], y    ;
  CLC
  ADC PosX
  STA [pointer1Lo], y  
  INY
  CPY #SPRITESIZE              ; 
  BNE setSpriteLoop
  
  RTS


;get Sprite memory adress
getPlrSprAdr:
  ; initiale vars for P1 or P2
  LDA #$02
  STA pointer1Hi
  LDA #$00			;set the low part of start sprite ardress
  STA pointer1Lo

  LDA player_stp
  CMP #$00
  BNE notStp00
  LDA #LOW(sprite_0)
  STA pointerLo
  LDA #HIGH(sprite_0)
  STA pointerHi
  JMP goodStpReach
notStp00:

  CMP #$01
  BNE notStp01
  LDA #LOW(sprite_1)
  STA pointerLo
  LDA #HIGH(sprite_1)
  STA pointerHi
  JMP goodStpReach
notStp01: 

  CMP #$02
  BNE notStp02
  LDA #LOW(sprite_2)
  STA pointerLo
  LDA #HIGH(sprite_2)
  STA pointerHi
  JMP goodStpReach
notStp02: 

  CMP #$03
  BNE notStp03
  LDA #LOW(sprite_3)
  STA pointerLo
  LDA #HIGH(sprite_3)
  STA pointerHi
  JMP goodStpReach
notStp03:
 
  CMP #$04
  BNE notStp04
  LDA #LOW(sprite_4)
  STA pointerLo
  LDA #HIGH(sprite_4)
  STA pointerHi
  JMP goodStpReach
notStp04:

  CMP #$05
  BNE notStp05
  LDA #LOW(sprite_5)
  STA pointerLo
  LDA #HIGH(sprite_5)
  STA pointerHi
  JMP goodStpReach
notStp05:
 
  CMP #$06
  BNE notStp06
  LDA #LOW(sprite_6)
  STA pointerLo
  LDA #HIGH(sprite_6)
  STA pointerHi
  JMP goodStpReach
notStp06:

  CMP #$07
  BNE notStp07
  LDA #LOW(sprite_7)
  STA pointerLo
  LDA #HIGH(sprite_7)
  STA pointerHi
  JMP goodStpReach
notStp07: 

  CMP #$08
  BNE notStp08
  LDA #LOW(sprite_8)
  STA pointerLo
  LDA #HIGH(sprite_8)
  STA pointerHi
  JMP goodStpReach
notStp08: 

  CMP #$09
  BNE notStp09
  LDA #LOW(sprite_9)
  STA pointerLo
  LDA #HIGH(sprite_9)
  STA pointerHi
  JMP goodStpReach
notStp09: 

goodStpReach:
  RTS
  
waitNextFrame:
  LDA nmiStatus
  CMP #DISABLENMI
  BEQ noWaitNmi
  
  LDA #WAITNMI
  STA nmiStatus
waitingForNmi:
  LDA nmiStatus
  BNE waitingForNmi
noWaitNmi:
  RTS

; NMI utils:
disableNmi:
  
  LDA #DISABLENMI
  STA nmiStatus
  
  LDA #%00010000   ; disable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  STA PPUCTRL
  LDA #%00000000   ; disable sprites, background
  STA PPUMASK
  RTS

enableNmi:
  LDA #%10010000
  STA PPUCTRL
  LDA #WAITNMI
  STA nmiStatus
  RTS
  
processNmiBufferW:
  LDX #$00
  LDA PPUSTATUS
.loadBuffer:
  ;load word length, if 00 then is the end of buffer
  
  LDA PPUBUFFERW, x
  BEQ .endBuffer
  TAY
  INX
  ;load adress to write
  LDA PPUBUFFERW, x
  STA PPUADDR
  INX
  LDA PPUBUFFERW, x
  STA PPUADDR
  INX
  ;load word
.loadBufferWord:
  LDA PPUBUFFERW, x
  STA PPUDATA
  INX
  DEY
  CPY #$00
  BNE .loadBufferWord

  JMP .loadBuffer
  
.endBuffer:
  RTS

; structure of the buffer :
; all the words are 6 bits long:
; - Hi part of tule to read
; - Lo part of tule to read
; - Hi part of the adress to stock the tule value
; - Lo part of the adress to stock the tule value
; if Hi part of tule to read = 0 then that's the end of the buffer
processNmiBufferL:
	LDX #$00
	LDY #$00
.loadBuffer:
	LDA PPUBUFFERL, x
	BEQ .endBuffer
	STA PPUADDR
	INX
	LDA PPUBUFFERL, x
	STA PPUADDR
	INX
	;load adress to stock
	LDA PPUBUFFERL, x
	STA pointerNMIHi
	INX
	LDA PPUBUFFERL, x
	STA pointerNMILo
	INX
	LDA PPUDATA		; Load first fake value
	LDA PPUDATA
	STA [pointerNMILo], y	; store tile value

	JMP .loadBuffer
.endBuffer:	
	RTS
	

; clear write and load buffers
clearBuffer:
  LDX pointerBufferW
  LDA #$00
.clearBufferLoop:
  STA PPUBUFFERW, x
  CPX #$00
  BEQ .endClearBuffer
  DEX 
  JMP .clearBufferLoop
.endClearBuffer:
  STA pointerBufferW
  
  LDX pointerBufferL
  LDA #$00
.1:
  STA PPUBUFFERL, x
  CPX #$00
  BEQ .2
  DEX 
  JMP .1
.2:
  STA pointerBufferL
  RTS
  
;RLE decompressor by Shiru (NESASM version)
;uses 4 bytes in zero page
;decompress data from an address in X/Y to PPU_DATA

unrle
	stx RLE_LOW			; RLE_data adress -> RLE_LOW
	sty RLE_HIGH		; RLE_data adress -> RLE_LOW
	ldy #0
	jsr rle_byte		
	sta RLE_TAG
.1
	jsr rle_byte
	cmp RLE_TAG
	beq .2
	sta PPUDATA
	sta RLE_BYTE
	bne .1
.2
	jsr rle_byte
	cmp #0
	beq .4
	tax
	lda RLE_BYTE
.3
	sta PPUDATA
	dex
	bne .3
	beq .1
.4
	rts

; lda [RLE_LOW],y 
; puis incremente RLE_LOW et RLE_HIGH
rle_byte				; incremente RLE_LOW et RLE_HIGH
	lda [RLE_LOW],y
	inc RLE_LOW
	bne .1
	inc RLE_HIGH
.1
	rts