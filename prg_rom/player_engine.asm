PStateMachine:
	
	LDA player_state
	; RUN STATE
	CMP #RUN
	BNE .dontRun
	
	LDX #RUNSPEED
	JSR incPlayerStp

	LDA buttons		; controls
	AND #A_BUTTON	; A button
	BEQ .noAPress
	LDA #INIT_JUMP
	STA player_state
	LDA #$FF 	;init jump vector
	STA jump_vector
	JMP endStateMachine
.noAPress
	
.dontRun

	; INIT_JUMP STATE
	CMP #INIT_JUMP
	BNE .dontInitJump
	
	LDA buttons		; controls
	AND #A_BUTTON	; A button
	BEQ .doJump
	
	LDX #INITJUMPSPEED
	JSR incPlayerStp
	
	LDA jump_vector
	SEC
	SBC #$10
	STA jump_vector
	CMP #MAXJUMP
	BCC .doJump
	JMP .dontInitJump
	
.doJump
	LDA #$FF
	STA VectorY
	LDA jump_vector
	STA VectorDecY
	LDA #JUMP
	STA player_state
	;todo change sprite step
	LDA #$04
	STA player_stp
	JMP endStateMachine
.dontInitJump

	; JUMP STATE
	CMP #JUMP
	BNE .dontJump
	; todo ?
.dontJump

; JUMP RECEPTION
	; ne pas oublier de set le state_tics à zéro avant de set l'état
	CMP #RECEPTION
	BNE .dontReception
	LDA state_tics
	CMP #RECEPTIONTIME
	BEQ .changeStateReception
	LDX #INITJUMPSPEED
	JSR incPlayerStp
	INC state_tics
	JMP .dontReception
.changeStateReception
	LDA #RUN
	STA player_state
.dontReception
	
endStateMachine
	RTS
	
incPlayerStp:
	LDA player_tics
	CMP #$00
	BNE .noTicsUpdate
	
	INC player_stp
	LDA player_stp
	CMP #$0A
	BNE .noResetStp
	LDA #$00
	STA player_stp
.noResetStp:
	;LDA #RUNSPEED
	TXA
	STA player_tics
	
.noTicsUpdate
	DEC player_tics
	
	RTS