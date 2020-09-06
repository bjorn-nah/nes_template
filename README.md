Template for my nes asm projets
# uses :
- neasm3 : https://github.com/munshkr/nesasm
- famitone 2 : https://shiru.untergrund.net/code.shtml

# Structure :
- chrom :
	stuff to put in chr_rom. If you want to put other things here, you are mad.
	- chr_rom.asm : edit is file to adjust to your chr sources
	- *.chr : put you own graphics here
- global :
	globals of the project
	- famitone_contants.asm : you can edit this according to your famitone usage
	- game_constants.asm : custom this according to your needs
	- ines_header.asm : setup of the header
	- nes_constants.asm : system constants
	- variables.asm : custom this according to your needs
	- vectors.asm : vectors declaration, you usually don't have to touch that
- prg_rom :
	stuff to put in prg_rom.
	- lib
	librarys
		you have to add famitone2.asm in this folder
		- utils.asm : my own library + unrle tool by Shiru
	- sound
	put your *.asm songs / noises here
	- collision_engine.asm : todo !
	- data.asm : place to save your datas
	- game.asm : make a game here
	- init.asm : initialization of the game
	- interupts.asm : print screen buuffer durring the NMI
	- menu.asm : code your menu here
	- physics_engine.asm
	- player_engine.asm
	- prg_rom.asm : initialize the game and control the game states
	- title.asm : code your slash screen here
- res :
	a folder to put your ressources : images, songs, maps, etc.
- build.bat : windows exe to compile / launch the rom (adapt your emulator folder)
- main.asm : main imports of the project
you have to add NESASM3.exe in this folder