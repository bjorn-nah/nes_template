  .bank 0
  .org $C000
  
  .include "prg_rom/init.asm"
  
  LDA #%10010000
  STA igPPUCTRL
  LDA #$00
  STA cameraX
  STA cameraY
  
  JSR enableNmi
  
  LDA #STATEPLAYING
  STA gamestate
  LDA #INITIALIZE
  STA substate
  LDA #$00
  STA time
	
Forever:
  JSR waitNextFrame
  JSR clearBuffer
  
  INC time
  
GameEngine:  
  LDA gamestate
  CMP #STATEPLAYING
  BNE notEngPlaying
  JMP EnginePlaying		;game is playing
notEngPlaying:

  ; LDA gamestate
  ; CMP #STATETITLE
  ; BNE notEngTitle
  ; JMP EngineTitle		;game is displaying title screen
; notEngTitle:
    
  ; LDA gamestate
  ; CMP #STATEGAMEOVER
  ; BNE notEngineGO		;game is displaying ending screen
  ; JMP EngineGameOver
; notEngineGO:
  
  ; LDA gamestate
  ; CMP #STATEMENU
  ; BNE notEngMenu
  ; JMP EngineMenu   		;game is displaying menu screen
; notEngMenu:  

GameEngineDone:
  
  JMP Forever     ;jump back to Forever, infinite loop
  
  .include "prg_rom/game.asm"
  
  .include "prg_rom/interupts.asm"
  .include "prg_rom/lib/utils.asm"
  .include "prg_rom/lib/famitone2.asm"