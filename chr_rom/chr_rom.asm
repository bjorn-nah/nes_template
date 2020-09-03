  .bank 2
  .org $0000
  .incbin "chr_rom/sprite.chr"   	;includes 8KB graphics file in bank A
  .incbin "chr_rom/background.chr"  ;includes 8KB graphics file in bank B