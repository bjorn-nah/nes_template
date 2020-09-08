;first 3bytes used by famitone
  .rsset $0003  ;;start variables at ram location 03

;unrle variables
RLE_LOW		.rs 1
RLE_HIGH	.rs 1
RLE_TAG		.rs 1
RLE_BYTE	.rs 1

time		.rs 1	;07
buttons		.rs 1	;0C
gamestate	.rs 1	;0D
substate	.rs 1	;0E

igPPUCTRL	.rs 1	;0F
cameraX		.rs 1
cameraY		.rs 1

PosX		.rs 1	;13
PosY		.rs 1	;14
VectorX		.rs 1	;15
VectorDecX	.rs 1	;16
VectorY		.rs 1	;15
VectorDecY	.rs 1	;16
jump_vector .rs 1	;18

player_state	.rs 1
player_stp	.rs 1
player_tics	.rs 1
state_tics	.rs 1

arg1		.rs 1
arg2		.rs 1

printLong	.rs 1	;
printStart	.rs 1
pointerLo	.rs 1	;1A
pointerHi	.rs 1	;1B
pointer1Lo	.rs 1	;1A
pointer1Hi	.rs 1	;1B
pointerPPULo	.rs 1
pointerPPUHi	.rs 1
pointerNMILo	.rs 1
pointerNMIHi	.rs 1
pointerBufferW	.rs 1
pointerBufferL	.rs 1
temp		.rs 1	;22
temp1		.rs 1	;23
temp2		.rs 1	;

nmiStatus	.rs 1