; PPU registers
;  http://wiki.nesdev.com/w/index.php/PPU_registers

PPUCTRL		= $2000
PPUMASK 	= $2001
PPUSTATUS 	= $2002
OAMADDR 	= $2003
OAMDATA 	= $2004
PPUSCROLL 	= $2005
PPUADDR 	= $2006
PPUDATA 	= $2007
OAMDMA 		= $4014

; APU registers
;  http://wiki.nesdev.com/w/index.php/APU

APU_DMC_FLAGS 	= $4010

APU_FRAMECNT 	= $4017

; Controllers
CONTROLLER 		= $4016
A_BUTTON 		= %10000000
B_BUTTON		= %01000000
START_BUTTON	= %00100000
SELECT_BUTTON	= %00010000
UP_BUTTON		= %00001000
DOWN_BUTTON		= %00000100
LEFT_BUTTON		= %00000010
RIGHT_BUTTON	= %00000001

; sprite axis offset
XAXIS	= $03
YAXIS	= $00
