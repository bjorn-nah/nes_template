EnginePlaying

  LDA substate
  CMP #INITIALIZE
  BEQ GameInit
  JMP NoGameInit
  
GameInit:
  JSR disableNmi

  LDA #$6F
  STA PosX
  STA PosY
  
  LDA #$00
  STA player_stp
  STA player_tics
  

  lda #0
  sta PPUADDR
  sta PPUADDR

  ;ldx #LOW(mergez_party_data)	;initialize using the first song data, as it contains the DPCM sound effect
  ;ldy #HIGH(mergez_party_data)
  ;lda #$80	;PAL mode
  ;jsr FamiToneInit		;init FamiTone
  
  JSR enableNmi
  
  ;lda #0
  ;jsr FamiToneMusicPlay
  
  LDA #NORM
  STA substate
  
  JMP GameEngineDone

NoGameInit:

  LDY #$00
  JSR ReadController  ;;get the current button data for player 1
  LDA temp
  STA buttons

  ;JSR PStateMachine
  ;JSR PhysicsMachine
  
  ;JSR LoadPlayerSprite
  ;JSR setPosPlrSpr
  
  ;make a game there
  
  ;jsr FamiToneUpdate  


  JMP GameEngineDone

  
;includes
  .include "prg_rom/player_engine.asm"
  .include "prg_rom/physics_engine.asm"
;  .include "prg_rom/collision_engine.asm"