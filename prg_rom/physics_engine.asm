PhysicsMachine:

	LDA player_state
	CMP #JUMP
	BNE .dontJump
	LDA PosY
	CLC
	ADC VectorY
	STA PosY
	
	CMP #$6F	;si PosY > Sol
	BCC .noReset
	LDA #$6F
	STA PosY
	LDA #$00
	STA state_tics
	LDA #RECEPTION
	STA player_state
	JMP .dontJump
.noReset:	
	
	LDA VectorDecY
	CLC
	ADC #GRAVITY_DEC
	STA VectorDecY
	BCC .noInc
	INC VectorY
.noInc
	
	
.dontJump:

	RTS