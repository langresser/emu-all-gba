# 1 "Cyclone2.s"
# 1 "Cyclone2.s" 1
# 1 "<built-in>" 1
# 1 "Cyclone2.s" 2

;

;
;

;
;

;

  .text
  .align 4

  .globl _CycloneInit
  .globl CycloneReset
  .globl _CycloneRun
  .globl CycloneSetSr
  .globl CycloneGetSr
  .globl CycloneFlushIrq
  .globl _CyclonePack
  .globl _CycloneUnpack
  .globl CycloneVer
  .globl CycloneSetRealTAS
  .globl CycloneDoInterrupt
  .globl CycloneDoTrace
  .globl CycloneJumpTab
  .globl Op____
  .globl Op6001
  .globl Op6601
  .globl Op6701

CycloneVer: .long 0x0099

;
_CycloneRun:
  stmdb sp!,{r4-r8,r10,r11,lr}
  mov r7,r0 ;
                     ;
  ldrb r10,[r7,#0x46] ;
   ldr r6, .Literal_0
  ldr r5,[r7,#0x5c] ;
  ldr r4,[r7,#0x40] ;
                     ;
  ldr r1,[r7,#0x44] ;
  mov r10,r10,lsl #28;
                     ;
  str r6,[r7,#0x54] ;

  mov r2,#0
  str r2,[r7,#0x98] ;
;
  movs r0,r1,lsr #24 ;
  beq NoInts0
  cmp r0,#6 ;
  andle r1,r1,#7 ;
  cmple r0,r1 ;
  bgt CycloneDoInterrupt
NoInts0:

;
;
  ldr r0,[r7,#0x58] ;
  ldrh r8,[r4],#2 ;
  tst r0,#0x03 ;
  ldreq pc,[r6,r8,asl #2] ;

CycloneSpecial:
  tst r0,#2 ;
  bne CycloneDoTrace
;
  mov r5,#0
  str r5,[r7,#0x5C] ;
  ldmia sp!,{r4-r8,r10,r11,pc} ;


;
CycloneEnd:
  sub r4,r4,#2
CycloneEndNoBack:
  ldr r1,[r7,#0x98]
  mov r10,r10,lsr #28
  tst r1,r1
  bxne r1 ;
  str r4,[r7,#0x40] ;
  str r5,[r7,#0x5c] ;
  strb r10,[r7,#0x46] ;
  ldmia sp!,{r4-r8,r10,r11,pc}
  @.ltorg
.Literal_0:
 .word CycloneJumpTab ;


_CycloneInit:
;
   ldr r12, .Literal_1
  add r0,r12,#0xe000*4 ;
  ldr r1,[r0,#-4]
  tst r1,r1
  movne pc,lr ;
  add r3,r12,#0xa000*4 ;
unc_loop:
  ldrh r1,[r0],#2
  and r2,r1,#0xf
  bic r1,r1,#0xf
  ldr r1,[r3,r1,lsr #2] ;
  cmp r2,#0xf
  addeq r2,r2,#1 ;
  tst r2,r2
  ldreqh r2,[r0],#2 ;
  tst r2,r2
  beq unc_finish ;
  tst r1,r1
  addeq r12,r12,r2,lsl #2 ;
  beq unc_loop
unc_loop_in:
  subs r2,r2,#1
  str r1,[r12],#4
  bgt unc_loop_in
  b unc_loop
unc_finish:
   ldr r12, .Literal_1
  ;
  add r0,r12,#0xa000*4
  ldr r1,[r0,#4] ;
  ldr r3,[r0,#8] ;
  mov r2,#0x1000
unc_fill3:
  subs r2,r2,#1
  str r1,[r0],#4
  bgt unc_fill3
  add r0,r12,#0xf000*4
  mov r2,#0x1000
unc_fill4:
  subs r2,r2,#1
  str r3,[r0],#4
  bgt unc_fill4
  bx lr
  @.ltorg
.Literal_1:
 .word CycloneJumpTab

CycloneReset:
  stmfd sp!,{r7,lr}
  mov r7,r0
  mov r0,#0
  str r0,[r7,#0x58] ;
  str r0,[r7,#0x48] ;
  mov r1,#0x27 ;
  strb r1,[r7,#0x44] ;
  strb r0,[r7,#0x47] ;
  mov lr,pc
  ldr pc,[r7,#0x70] ;
  str r0,[r7,#0x3c] ;
  mov r0,#0
  str r0,[r7,#0x60] ;
  mov r0,#4
  mov lr,pc
  ldr pc,[r7,#0x70] ;
  mov lr,pc
  ldr pc,[r7,#0x64] ;
  str r0,[r7,#0x40] ;
  ldmfd sp!,{r7,pc}

CycloneSetSr:
  mov r2,r1,lsr #8
  and r2,r2,#0xa7 ;
  strb r2,[r0,#0x44] ;
  mov r2,r1,lsl #25
  str r2,[r0,#0x4c] ;
  bic r2,r1,#0xf3
  tst r1,#1
  orrne r2,r2,#2
  tst r1,#2
  orrne r2,r2,#1
  strb r2,[r0,#0x46] ;
  bx lr

CycloneGetSr:
  ldrb r1,[r0,#0x46] ;
  bic r2,r1,#0xf3
  tst r1,#1
  orrne r2,r2,#2
  tst r1,#2
  orrne r2,r2,#1
  ldr r1,[r0,#0x4c] ;
  tst r1,#0x20000000
  orrne r2,r2,#0x10
  ldrb r1,[r0,#0x44] ;
  orr r0,r2,r1,lsl #8
  bx lr

_CyclonePack:
  stmfd sp!,{r4,r5,lr}
  mov r4,r0
  mov r5,r1
  mov r3,#16
;
c_pack_loop:
  ldr r1,[r0],#4
  subs r3,r3,#1
  str r1,[r5],#4
  bne c_pack_loop
;
  ldr r0,[r4,#0x40] ;
  ldr r1,[r4,#0x60] ;
  sub r0,r0,r1
  str r0,[r5],#4
;
  mov r0,r4
  bl CycloneGetSr
  strh r0,[r5],#2
;
  ldrb r0,[r4,#0x47]
  strb r0,[r5],#2
;
  ldr r0,[r4,#0x48]
  str r0,[r5],#4
;
  ldr r0,[r4,#0x58]
  str r0,[r5],#4
  ldmfd sp!,{r4,r5,pc}

_CycloneUnpack:
  stmfd sp!,{r5,r7,lr}
  mov r7,r0
  movs r5,r1
  beq c_unpack_do_pc
  mov r3,#16
;
c_unpack_loop:
  ldr r1,[r5],#4
  subs r3,r3,#1
  str r1,[r0],#4
  bne c_unpack_loop
;
  ldr r0,[r5],#4 ;
  str r0,[r7,#0x40] ;
;
  ldrh r1,[r5],#2
  mov r0,r7
  bl CycloneSetSr
;
  ldrb r0,[r5],#2
  strb r0,[r7,#0x47]
;
  ldr r0,[r5],#4
  str r0,[r7,#0x48]
;
  ldr r0,[r5],#4
  str r0,[r7,#0x58]
c_unpack_do_pc:
  ldr r0,[r7,#0x40] ;
  mov r1,#0
  str r1,[r7,#0x60] ;
  mov lr,pc
  ldr pc,[r7,#0x64] ;
  str r0,[r7,#0x40] ;
  ldmfd sp!,{r5,r7,pc}

CycloneFlushIrq:
  ldr r1,[r0,#0x44] ;
  mov r2,r1,lsr #24 ;
  cmp r2,#6 ;
  andle r1,r1,#7 ;
  cmple r2,r1 ;
  movle r0,#0
  bxle lr ;

  stmdb sp!,{r4,r5,r7,r8,r10,r11,lr}
  mov r7,r0
  mov r0,r2
  ldrb r10,[r7,#0x46] ;
  mov r5,#0
  ldr r4,[r7,#0x40] ;
  mov r10,r10,lsl #28 ;
  adr r2,CycloneFlushIrqEnd
  str r2,[r7,#0x98] ;
  b CycloneDoInterrupt

CycloneFlushIrqEnd:
  rsb r0,r5,#0
  str r4,[r7,#0x40] ;
  strb r10,[r7,#0x46] ;
  ldmia sp!,{r4,r5,r7,r8,r10,r11,lr}
  bx lr


CycloneSetRealTAS:
   ldr r12, .Literal_2
  tst r0,r0
  add r12,r12,#0x4a00*4
  add r12,r12,#0x00d0*4
  beq setrtas_off
   ldr r0, .Literal_3
  mov r1,#8
setrtas_loop10: ;
  subs r1,r1,#1
  str r0,[r12],#4
  bne setrtas_loop10
   ldr r0, .Literal_4
  mov r1,#7
setrtas_loop11: ;
  subs r1,r1,#1
  str r0,[r12],#4
  bne setrtas_loop11
   ldr r0, .Literal_5
  str r0,[r12],#4
   ldr r0, .Literal_6
  mov r1,#7
setrtas_loop12: ;
  subs r1,r1,#1
  str r0,[r12],#4
  bne setrtas_loop12
   ldr r0, .Literal_7
  str r0,[r12],#4
   ldr r0, .Literal_8
  mov r1,#8
setrtas_loop13: ;
  subs r1,r1,#1
  str r0,[r12],#4
  bne setrtas_loop13
   ldr r0, .Literal_9
  mov r1,#8
setrtas_loop14: ;
  subs r1,r1,#1
  str r0,[r12],#4
  bne setrtas_loop14
   ldr r0, .Literal_10
  str r0,[r12],#4
   ldr r0, .Literal_11
  str r0,[r12],#4
  bx lr
setrtas_off:
   ldr r0, .Literal_12
  mov r1,#8
setrtas_loop00: ;
  subs r1,r1,#1
  str r0,[r12],#4
  bne setrtas_loop00
   ldr r0, .Literal_13
  mov r1,#7
setrtas_loop01: ;
  subs r1,r1,#1
  str r0,[r12],#4
  bne setrtas_loop01
   ldr r0, .Literal_14
  str r0,[r12],#4
   ldr r0, .Literal_15
  mov r1,#7
setrtas_loop02: ;
  subs r1,r1,#1
  str r0,[r12],#4
  bne setrtas_loop02
   ldr r0, .Literal_16
  str r0,[r12],#4
   ldr r0, .Literal_17
  mov r1,#8
setrtas_loop03: ;
  subs r1,r1,#1
  str r0,[r12],#4
  bne setrtas_loop03
   ldr r0, .Literal_18
  mov r1,#8
setrtas_loop04: ;
  subs r1,r1,#1
  str r0,[r12],#4
  bne setrtas_loop04
   ldr r0, .Literal_19
  str r0,[r12],#4
   ldr r0, .Literal_20
  str r0,[r12],#4
  bx lr
  @.ltorg
.Literal_18:
 .word Op4af0
.Literal_8:
 .word Op4ae8_
.Literal_2:
 .word CycloneJumpTab
.Literal_20:
 .word Op4af9
.Literal_12:
 .word Op4ad0
.Literal_10:
 .word Op4af8_
.Literal_17:
 .word Op4ae8
.Literal_15:
 .word Op4ae0
.Literal_4:
 .word Op4ad8_
.Literal_14:
 .word Op4adf
.Literal_9:
 .word Op4af0_
.Literal_13:
 .word Op4ad8
.Literal_7:
 .word Op4ae7_
.Literal_5:
 .word Op4adf_
.Literal_19:
 .word Op4af8
.Literal_3:
 .word Op4ad0_
.Literal_16:
 .word Op4ae7
.Literal_11:
 .word Op4af9_
.Literal_6:
 .word Op4ae0_

;
CycloneDoInterruptGoBack:
  sub r4,r4,#2
CycloneDoInterrupt:
  bic r8,r8,#0xff000000
  orr r8,r8,r0,lsl #29 ;
  ldr r2,[r7,#0x58] ;
  and r0,r0,#7
  orr r3,r0,#0x20 ;
  bic r2,r2,#3 ;
  orr r2,r2,#4 ;
  str r2,[r7,#0x58]
  ldrb r6,[r7,#0x44] ;
  strb r3,[r7,#0x44] ;

  ldr r1,[r7,#0x60] ;
  ldr r11,[r7,#0x3c] ;
  tst r6,#0x20
;
  ldreq r2,[r7,#0x48] ;
  streq r11,[r7,#0x48]
  moveq r11,r2
;
  sub r0,r11,#4 ;
  sub r1,r4,r1 ;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;
;
  ldr r0,[r7,#0x4c] ;
  mov r1,r10,lsr #28 ;
  eor r2,r1,r1,ror #1 ;
  tst r2,#1 ;
  eorne r1,r1,#3 ;
  and r0,r0,#0x20000000
  orr r1,r1,r0,lsr #25 ;
  orr r1,r1,r6,lsl #8 ;
  sub r0,r11,#6 ;
  str r0,[r7,#0x3c] ;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  mov r11,r8,lsr #29
  mov r0,r11
;
  ldr r3,[r7,#0x8c] ;
  add lr,pc,#4*3
  tst r3,r3
  streqb r3,[r7,#0x47] ;
  mvneq r0,#0 ;
  bxne r3
;
  cmn r0,#1 ;
  addeq r0,r11,#0x18 ;
  cmn r0,#2 ;
  moveq r0,#0x18 ;
  mov r0,r0,lsl #2 ;

  ldr r11,[r7,#0x60] ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;
  tst r0,r0 ;
  moveq r0,#0x3c
  moveq lr,pc
  ldreq pc,[r7,#0x70] ;
  add lr,pc,#4
  add r0,r0,r11 ;
  ldr pc,[r7,#0x64] ;
  mov r4,r0

  tst r4,#1
  bne ExceptionAddressError_r_prg_r4
  ldr r6,[r7,#0x54]
  ldrh r8,[r4],#2 ;
  subs r5,r5,#44 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

Exception:
  ;
  mov r11,lr ;
  bic r8,r8,#0xff000000
  orr r8,r8,r0,lsl #24 ;
  ldr r6,[r7,#0x44] ;
  ldr r2,[r7,#0x58] ;
  and r3,r6,#0x27 ;
  orr r3,r3,#0x20 ;
  bic r2,r2,#3 ;
  str r2,[r7,#0x58]
  strb r3,[r7,#0x44] ;

  ldr r0,[r7,#0x3c] ;
  tst r6,#0x20
;
  ldreq r2,[r7,#0x48] ;
  streq r0,[r7,#0x48]
  moveq r0,r2
;
  ldr r1,[r7,#0x60] ;
  sub r0,r0,#4 ;
  str r0,[r7,#0x3c] ;
  sub r1,r4,r1 ;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;
;
  ldr r0,[r7,#0x4c] ;
  mov r1,r10,lsr #28 ;
  eor r2,r1,r1,ror #1 ;
  tst r2,#1 ;
  eorne r1,r1,#3 ;
  and r0,r0,#0x20000000
  orr r1,r1,r0,lsr #25 ;
  ldr r0,[r7,#0x3c] ;
  orr r1,r1,r6,lsl #8 ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

;
  mov r0,r8,lsr #24
  mov r0,r0,lsl #2
  mov lr,pc
  ldr pc,[r7,#0x70] ;
  ldr r3,[r7,#0x60] ;
  add lr,pc,#4
  add r0,r0,r3 ;
  ldr pc,[r7,#0x64] ;
  mov r4,r0

  tst r4,#1
  bne ExceptionAddressError_r_prg_r4
  ldr r6,[r7,#0x54]
  bx r11 ;

ExceptionAddressError_r_data:
  ldr r1,[r7,#0x44]
  mov r6,#0x11
  mov r11,r0
  tst r1,#0x20
  orrne r6,r6,#4
  b ExceptionAddressError

ExceptionAddressError_r_prg:
  ldr r1,[r7,#0x44]
  mov r6,#0x12
  mov r11,r0
  tst r1,#0x20
  orrne r6,r6,#4
  b ExceptionAddressError

ExceptionAddressError_w_data:
  ldr r1,[r7,#0x44]
  mov r6,#0x01
  mov r11,r0
  tst r1,#0x20
  orrne r6,r6,#4
  b ExceptionAddressError

ExceptionAddressError_r_prg_r4:
  ldr r1,[r7,#0x44]
  ldr r3,[r7,#0x60] ;
  mov r6,#0x12
  sub r11,r4,r3
  tst r1,#0x20
  orrne r6,r6,#4

ExceptionAddressError:
;
  ldrb r0,[r7,#0x44] ;
  ldr r2,[r7,#0x58] ;
  and r3,r0,#0x27 ;
  orr r3,r3,#0x20 ;
  strb r3,[r7,#0x44] ;
  bic r2,r2,#3 ;
  tst r2,#4
  orrne r6,r6,#8 ;
  orr r2,r2,#4 ;
  str r2,[r7,#0x58]
  and r10,r10,#0xf0000000
  orr r10,r10,r0,lsl #4 ;

  ldr r0,[r7,#0x3c] ;
  tst r10,#0x200
;
  ldreq r2,[r7,#0x48] ;
  streq r0,[r7,#0x48]
  moveq r0,r2
;
  ldr r1,[r7,#0x60] ;
  sub r0,r0,#4 ;
  sub r1,r4,r1 ;
  str r0,[r7,#0x3c] ;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;
;
  ldr r0,[r7,#0x4c] ;
  mov r1,r10,ror #28 ;
  eor r2,r1,r1,ror #1 ;
  tst r2,#1 ;
  eorne r1,r1,#3 ;
  and r0,r0,#0x20000000
  orr r1,r1,r0,lsr #25 ;
  ldr r0,[r7,#0x3c] ;
  and r10,r10,#0xf0000000
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
  mov lr,pc
  ldr pc,[r7,#0x78] ;
;
  ldr r0,[r7,#0x3c] ;
  mov r1,r8
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
  mov lr,pc
  ldr pc,[r7,#0x78] ;
;
  ldr r0,[r7,#0x3c] ;
  mov r1,r11
  sub r0,r0,#4 ;
  str r0,[r7,#0x3c] ;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;
;
  ldr r0,[r7,#0x3c] ;
  mov r1,r6
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

;
  mov r0,#0x0c
  mov lr,pc
  ldr pc,[r7,#0x70] ;
  ldr r3,[r7,#0x60] ;
  add lr,pc,#4
  add r0,r0,r3 ;
  ldr pc,[r7,#0x64] ;
  mov r4,r0

  bic r4,r4,#1
  ldr r6,[r7,#0x54]
  ldrh r8,[r4],#2 ;
  subs r5,r5,#50 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

CycloneDoTraceWithChecks:
  ldr r0,[r7,#0x58]
  cmp r5,#0
  orr r0,r0,#2 ;
  str r0,[r7,#0x58]
  blt CycloneEnd
;
  movs r0,r1,lsr #24 ;
  beq CycloneDoTrace
  cmp r0,#6 ;
  andle r1,r1,#7 ;
  cmple r0,r1 ;
  bgt CycloneDoInterruptGoBack

CycloneDoTrace:
  str r5,[r7,#0x9c] ;
  ldr r1,[r7,#0x98]
  mov r5,#0
  str r1,[r7,#0xa0]
  adr r0,TraceEnd
  str r0,[r7,#0x98] ;
  ldr pc,[r6,r8,asl #2] ;

TraceEnd:
  ldr r2,[r7,#0x58]
  ldr r0,[r7,#0x9c] ;
  ldr r1,[r7,#0xa0] ;
  mov r10,r10,lsl #28
  add r5,r0,r5
  str r1,[r7,#0x98]
;
  tst r2,#2
  beq TraceDisabled
;
  ldr r1,[r7,#0x58]
  mov r0,#9
  orr r1,r1,#4 ;
  str r1,[r7,#0x58]
  bl Exception
  ldrh r8,[r4],#2 ;
  subs r5,r5,#34 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

TraceDisabled:
  ldrh r8,[r4],#2 ;
  cmp r5,#0
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op____: ;
  ldr r1,[r7,#0x58]
  sub r4,r4,#2
  orr r1,r1,#4 ;
  str r1,[r7,#0x58]
  str r4,[r7,#0x40] ;
  mov r1,r10,lsr #28
  strb r1,[r7,#0x46] ;
  str r5,[r7,#0x5c] ;
  ldr r11,[r7,#0x94] ;
  tst r11,r11
  movne lr,pc
  movne pc,r11 ;
  ldrb r10,[r7,#0x46] ;
  ldr r5,[r7,#0x5c] ;
  ldr r4,[r7,#0x40] ;
  mov r10,r10,lsl #28
  tst r0,r0
  moveq r0,#4
  bleq Exception

  ldrh r8,[r4],#2 ;
  subs r5,r5,#34 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

Op__al: ;
  sub r4,r4,#2
  str r4,[r7,#0x40] ;
  mov r1,r10,lsr #28
  strb r1,[r7,#0x46] ;
  str r5,[r7,#0x5c] ;
  ldr r11,[r7,#0x94] ;
  tst r11,r11
  movne lr,pc
  movne pc,r11 ;
  ldrb r10,[r7,#0x46] ;
  ldr r5,[r7,#0x5c] ;
  ldr r4,[r7,#0x40] ;
  mov r10,r10,lsl #28
  tst r0,r0
  moveq r0,#0x0a
  bleq Exception

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

Op__fl: ;
  sub r4,r4,#2
  str r4,[r7,#0x40] ;
  mov r1,r10,lsr #28
  strb r1,[r7,#0x46] ;
  str r5,[r7,#0x5c] ;
  ldr r11,[r7,#0x94] ;
  tst r11,r11
  movne lr,pc
  movne pc,r11 ;
  ldrb r10,[r7,#0x46] ;
  ldr r5,[r7,#0x5c] ;
  ldr r4,[r7,#0x40] ;
  mov r10,r10,lsl #28
  tst r0,r0
  moveq r0,#0x0b
  bleq Exception

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op6701:
;
  msr cpsr_flg,r10 ;
  bne BccDontBranch8

  mov r11,r8,asl #24 ;

;
  add r0,r4,r11,asr #24 ;
  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

BccDontBranch8:
  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op6601:
;
  msr cpsr_flg,r10 ;
  beq BccDontBranch8

  mov r11,r8,asl #24 ;

;
  add r0,r4,r11,asr #24 ;
  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op51c8:
;
  and r1,r8,#0x0007
  mov r1,r1,lsl #2
  ldrsh r0,[r7,r1]
  sub r0,r0,#1
  strh r0,[r7,r1]

;
  cmn r0,#1
  beq DbraMin1

;
  ldrsh r0,[r4]
  add r0,r4,r0 ;
;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4
  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
DbraMin1:
  add r4,r4,#2 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4a38:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24

  adds r0,r0,#0 ;
  mrs r10,cpsr ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd040:
;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  adds r1,r0,r1,asl #16
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4a79:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

  adds r0,r0,#0 ;
  mrs r10,cpsr ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0240:
;
  ldrsh r10,[r4],#2 ;
;

;
  and r11,r8,#0x000f
  mov r11,r11,lsl #2
;
  ldr r0,[r7,r11]

  mov r10,r10,asl #16
;
  and r1,r10,r0,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2038:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r0,r8,#0x0e00
;
  str r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb0b8:
  str r5,[r7,#0x5c] ;

;
;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  rsbs r1,r0,r1
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op6001:
  mov r11,r8,asl #24 ;

;
  add r0,r4,r11,asr #24 ;
  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op30c0:
  str r5,[r7,#0x5c] ;

;
  and r0,r8,#0x000f
  mov r0,r0,lsl #2
;
  ldrsh r0,[r7,r0]

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  add r3,r0,#2 ;
  str r3,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3028:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r0,r8,#0x0e00
  mov r0,r0,lsr #7
;
  strh r1,[r7,r0]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0c40:
;
  ldrsh r10,[r4],#2 ;
;

;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

  mov r10,r10,asl #16
;
  rsbs r1,r10,r0,asl #16 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0c79:
  str r5,[r7,#0x5c] ;

;
  ldrsh r10,[r4],#2 ;
;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

  mov r10,r10,asl #16
;
  rsbs r1,r10,r0,asl #16 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4e75:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x3c]
  add r1,r0,#4 ;
  str r1,[r7,#0x3c] ;
  mov lr,pc
  ldr pc,[r7,#0x70] ;
  ldr r1,[r7,#0x60] ;
  add r0,r0,r1 ;

;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4
  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4e71:
  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3000:
;
  and r0,r8,#0x000f
  mov r0,r0,lsl #2
;
  ldrsh r0,[r7,r0]

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r0,r8,#0x0e00
  mov r0,r0,lsr #7
;
  strh r1,[r7,r0]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0839:
  str r5,[r7,#0x5c] ;


;
  ldrsb r0,[r4],#2 ;
;

  mov r11,#1
  bic r10,r10,#0x40000000 ;
  and r0,r0,#7 ;
  mov r11,r11,lsl r0 ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

  tst r0,r11 ;
  orreq r10,r10,#0x40000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op7000:
  movs r0,r8,asl #24
  and r1,r8,#0x0e00
  mov r0,r0,asr #24 ;
  mrs r10,cpsr ;
  str r0,[r7,r1,lsr #7] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3040:
;
  and r1,r8,#0x000f
  mov r1,r1,lsl #2
;
  ldrsh r1,[r7,r1]

;
  and r0,r8,#0x1e00
;
  str r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0838:
  str r5,[r7,#0x5c] ;


;
  ldrsb r0,[r4],#2 ;
;

  mov r11,#1
  bic r10,r10,#0x40000000 ;
  and r0,r0,#7 ;
  mov r11,r11,lsl r0 ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

  tst r0,r11 ;
  orreq r10,r10,#0x40000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4a39:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24

  adds r0,r0,#0 ;
  mrs r10,cpsr ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op33d8:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#2 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op6700:
  str r5,[r7,#0x5c] ;

;
  msr cpsr_flg,r10 ;
  bne BccDontBranch16

  ldrsh r11,[r4] ;
;
  add r0,r4,r11 ;
;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

BccDontBranch16:
  add r4,r4,#2
  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb038:
  str r5,[r7,#0x5c] ;

;
;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #24

;
  rsbs r1,r0,r1,asl #24
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3039:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r0,r8,#0x0e00
  mov r0,r0,lsr #7
;
  strh r1,[r7,r0]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4840:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]

  mov r1,r0,ror #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;
;
  str r1,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op6101:
  mov r11,r8,asl #24 ;

;
;
  ldr r12,[r7,#0x60] ;
  ldr r2,[r7,#0x3c]
  sub r1,r4,r12 ;

;
  sub r0,r2,#4 ;
  str r0,[r7,#0x3c] ;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  add r0,r4,r11,asr #24 ;
  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op6100:
  str r5,[r7,#0x5c] ;

  ldrsh r11,[r4] ;
;
;
  ldr r12,[r7,#0x60] ;
  ldr r2,[r7,#0x3c]
  sub r1,r4,r12 ;
  add r1,r1,#2

;
  sub r0,r2,#4 ;
  str r0,[r7,#0x3c] ;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  add r0,r4,r11 ;
;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5e40:
;
  and r11,r8,#0x000f
  mov r11,r11,lsl #2
;
  ldr r0,[r7,r11]

  and r2,r8,#0x0e00 ;

  mov r0,r0,asl #16

  adds r1,r0,r2,lsl #7
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1039:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r0,r8,#0x0e00
;
  strb r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op20c0:
  str r5,[r7,#0x5c] ;

;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  ldr r0,[r7,r2,lsr #7]
  add r3,r0,#4 ;
  str r3,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1018:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r0,r8,#0x0e00
;
  strb r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op30d0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  add r3,r0,#2 ;
  str r3,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3080:
  str r5,[r7,#0x5c] ;

;
  and r0,r8,#0x000f
  mov r0,r0,lsl #2
;
  ldrsh r0,[r7,r0]

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3018:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#2 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r0,r8,#0x0e00
  mov r0,r0,lsr #7
;
  strh r1,[r7,r0]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc040:
;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  and r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3180:
  str r5,[r7,#0x5c] ;

;
  and r0,r8,#0x000f
  mov r0,r0,lsl #2
;
  ldrsh r0,[r7,r0]

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x1e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1198:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x1e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op6501:
;
  msr cpsr_flg,r10 ;
  bcc BccDontBranch8

  mov r11,r8,asl #24 ;

;
  add r0,r4,r11,asr #24 ;
  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op6500:
  str r5,[r7,#0x5c] ;

;
  msr cpsr_flg,r10 ;
  bcc BccDontBranch16

  ldrsh r11,[r4] ;
;
  add r0,r4,r11 ;
;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op6401:
;
  msr cpsr_flg,r10 ;
  bcs BccDontBranch8

  mov r11,r8,asl #24 ;

;
  add r0,r4,r11,asr #24 ;
  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op6a01:
;
  msr cpsr_flg,r10 ;
  bmi BccDontBranch8

  mov r11,r8,asl #24 ;

;
  add r0,r4,r11,asr #24 ;
  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op41f0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r1,r2,r3 ;
;
  and r0,r8,#0x0e00
  orr r0,r0,#0x1000 ;
;
  str r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4a28:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24

  adds r0,r0,#0 ;
  mrs r10,cpsr ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0828:
  str r5,[r7,#0x5c] ;


;
  ldrsb r0,[r4],#2 ;
;

  mov r11,#1
  bic r10,r10,#0x40000000 ;
  and r0,r0,#7 ;
  mov r11,r11,lsl r0 ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

  tst r0,r11 ;
  orreq r10,r10,#0x40000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0640:
;
  ldrsh r10,[r4],#2 ;
;

;
  and r11,r8,#0x000f
  mov r11,r11,lsl #2
;
  ldr r0,[r7,r11]

  mov r10,r10,asl #16
;
  adds r1,r10,r0,asl #16 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op10c0:
  str r5,[r7,#0x5c] ;

;
  and r0,r8,#0x000f
  mov r0,r0,lsl #2
;
  ldrsb r0,[r7,r0]

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op10d8:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0000:
;
  ldrsb r10,[r4],#2 ;
;

;
  and r11,r8,#0x000f
;
  ldr r0,[r7,r11,lsl #2]

  mov r10,r10,asl #24
;
  orr r1,r10,r0,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
  strb r1,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0010:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  orr r1,r10,r0,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0018:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#1 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  orr r1,r10,r0,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op001f:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  ldr r11,[r7,#0x3c] ;
  add r3,r11,#2 ;
  str r3,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  orr r1,r10,r0,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0020:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#1 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  orr r1,r10,r0,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0027:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  ldr r11,[r7,#0x3c] ;
  sub r11,r11,#2 ;
  str r11,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  orr r1,r10,r0,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0028:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  orr r1,r10,r0,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0030:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  orr r1,r10,r0,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0038:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  orr r1,r10,r0,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0039:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  orr r1,r10,r0,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op003c:
;
  ldrsb r0,[r4],#2 ;
;

  eor r1,r0,r0,ror #1 ;
  tst r1,#1 ;
  eorne r0,r0,#3 ;
  ldr r2,[r7,#0x4c] ;
  orr r10,r10,r0,lsl #28
  orr r2,r2,r0,lsl #25 ;
  str r2,[r7,#0x4c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0040:
;
  ldrsh r10,[r4],#2 ;
;

;
  and r11,r8,#0x000f
  mov r11,r11,lsl #2
;
  ldr r0,[r7,r11]

  mov r10,r10,asl #16
;
  orr r1,r10,r0,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0050:
  str r5,[r7,#0x5c] ;

;
  ldrsh r10,[r4],#2 ;
;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r10,r10,asl #16
;
  orr r1,r10,r0,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0058:
  str r5,[r7,#0x5c] ;

;
  ldrsh r10,[r4],#2 ;
;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#2 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r10,r10,asl #16
;
  orr r1,r10,r0,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0060:
  str r5,[r7,#0x5c] ;

;
  ldrsh r10,[r4],#2 ;
;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#2 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r10,r10,asl #16
;
  orr r1,r10,r0,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0068:
  str r5,[r7,#0x5c] ;

;
  ldrsh r10,[r4],#2 ;
;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r10,r10,asl #16
;
  orr r1,r10,r0,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0070:
  str r5,[r7,#0x5c] ;

;
  ldrsh r10,[r4],#2 ;
;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r10,r10,asl #16
;
  orr r1,r10,r0,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0078:
  str r5,[r7,#0x5c] ;

;
  ldrsh r10,[r4],#2 ;
;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r10,r10,asl #16
;
  orr r1,r10,r0,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0079:
  str r5,[r7,#0x5c] ;

;
  ldrsh r10,[r4],#2 ;
;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r10,r10,asl #16
;
  orr r1,r10,r0,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op007c:
  ldr r11,[r7,#0x44] ;
  tst r11,#0x20 ;
  beq WrongPrivilegeMode ;

;
  ldrsh r0,[r4],#2 ;
;

  eor r1,r0,r0,ror #1 ;
  tst r1,#1 ;
  eorne r0,r0,#3 ;
  ldr r2,[r7,#0x4c] ;
  orr r10,r10,r0,lsl #28
  orr r2,r2,r0,lsl #25 ;
  orr r1,r11,r0,lsr #8
  and r1,r1,#0xa7 ;
  str r2,[r7,#0x4c] ;
  strb r1,[r7,#0x44]

  ldrh r8,[r4],#2 ;
  ldr r1,[r7,#0x44]
  subs r5,r5,#20 ;
;
  tst r1,#0x80
  bne CycloneDoTraceWithChecks
  cmp r5,#0
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0080:
;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
  and r11,r8,#0x000f
;
  ldr r0,[r7,r11,lsl #2]

;
  orr r1,r10,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  str r1,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0090:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  orr r1,r10,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#28 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0098:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#4 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  orr r1,r10,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#28 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op00a0:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#4 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  orr r1,r10,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#30 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op00a8:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  orr r1,r10,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#32 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op00b0:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  orr r1,r10,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#34 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op00b8:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  orr r1,r10,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#32 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op00b9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  orr r1,r10,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#36 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0100:
;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

  and r11,r11,#31 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0108:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r6,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x68] ;
  mov r11,r0,asl #24

  add r0,r6,#2
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r1,r0,asl #24

  orr r1,r11,r1,lsr #8 ;
;
  and r0,r8,#0x0e00
  mov r0,r0,lsr #7
;
  mov r1,r1,asr #16
  strh r1,[r7,r0]

  ldr r6,[r7,#0x54]
  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0110:
  str r5,[r7,#0x5c] ;

;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

  and r11,r11,#7 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0118:
  str r5,[r7,#0x5c] ;

;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

  and r11,r11,#7 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op011f:
  str r5,[r7,#0x5c] ;

;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

  and r11,r11,#7 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0120:
  str r5,[r7,#0x5c] ;

;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

  and r11,r11,#7 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0127:
  str r5,[r7,#0x5c] ;

;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

  and r11,r11,#7 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0128:
  str r5,[r7,#0x5c] ;

;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

  and r11,r11,#7 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0130:
  str r5,[r7,#0x5c] ;

;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

  and r11,r11,#7 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0138:
  str r5,[r7,#0x5c] ;

;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

  and r11,r11,#7 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0139:
  str r5,[r7,#0x5c] ;

;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

  and r11,r11,#7 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op013a:
  str r5,[r7,#0x5c] ;

;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x80] ;

  and r11,r11,#7 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op013b:
  str r5,[r7,#0x5c] ;

;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x80] ;

  and r11,r11,#7 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op013c:
;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
  ldrsb r0,[r4],#2 ;
;

  and r11,r11,#7 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0140:
;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
  and r8,r8,#0x000f
;
  ldr r0,[r7,r8,lsl #2]

  and r11,r11,#31 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  eor r1,r0,r1,lsl r11 ;

;
  str r1,[r7,r8,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0148:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r6,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x68] ;
  mov r11,r0,asl #24

  add r0,r6,#2
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r1,r0,asl #24

  orr r11,r11,r1,lsr #8 ;
  add r0,r6,#4
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r1,r0,asl #24

  orr r11,r11,r1,lsr #16 ;
  add r0,r6,#6
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r1,r0,asl #24

  orr r1,r11,r1,lsr #24 ;
;
  and r0,r8,#0x0e00
;
  str r1,[r7,r0,lsr #7]

  ldr r6,[r7,#0x54]
  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0150:
  str r5,[r7,#0x5c] ;

;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r8,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  and r11,r11,#7 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  eor r1,r0,r1,lsl r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0158:
  str r5,[r7,#0x5c] ;

;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
  and r2,r8,#0x000f
  ldr r8,[r7,r2,lsl #2]
  add r3,r8,#1 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  and r11,r11,#7 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  eor r1,r0,r1,lsl r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op015f:
  str r5,[r7,#0x5c] ;

;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
  ldr r8,[r7,#0x3c] ;
  add r3,r8,#2 ;
  str r3,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  and r11,r11,#7 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  eor r1,r0,r1,lsl r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0160:
  str r5,[r7,#0x5c] ;

;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r8,[r7,r2,lsl #2]
  sub r8,r8,#1 ;
  str r8,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  and r11,r11,#7 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  eor r1,r0,r1,lsl r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0167:
  str r5,[r7,#0x5c] ;

;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
  ldr r8,[r7,#0x3c] ;
  sub r8,r8,#2 ;
  str r8,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  and r11,r11,#7 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  eor r1,r0,r1,lsl r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0168:
  str r5,[r7,#0x5c] ;

;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r8,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  and r11,r11,#7 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  eor r1,r0,r1,lsl r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0170:
  str r5,[r7,#0x5c] ;

;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r8,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  and r11,r11,#7 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  eor r1,r0,r1,lsl r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0178:
  str r5,[r7,#0x5c] ;

;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
  ldrsh r8,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  and r11,r11,#7 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  eor r1,r0,r1,lsl r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0179:
  str r5,[r7,#0x5c] ;

;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r8,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  and r11,r11,#7 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  eor r1,r0,r1,lsl r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0180:
;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
  and r8,r8,#0x000f
;
  ldr r0,[r7,r8,lsl #2]

  and r11,r11,#31 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  bic r1,r0,r1,lsl r11 ;

;
  str r1,[r7,r8,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0188:
  str r5,[r7,#0x5c] ;

;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r8,r0,r2 ;
  mov r0,r8
  mov r1,r11,lsr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  add r0,r8,#2
  and r1,r11,#0xff
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0190:
  str r5,[r7,#0x5c] ;

;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r8,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  and r11,r11,#7 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  bic r1,r0,r1,lsl r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0198:
  str r5,[r7,#0x5c] ;

;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
  and r2,r8,#0x000f
  ldr r8,[r7,r2,lsl #2]
  add r3,r8,#1 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  and r11,r11,#7 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  bic r1,r0,r1,lsl r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op019f:
  str r5,[r7,#0x5c] ;

;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
  ldr r8,[r7,#0x3c] ;
  add r3,r8,#2 ;
  str r3,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  and r11,r11,#7 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  bic r1,r0,r1,lsl r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op01a0:
  str r5,[r7,#0x5c] ;

;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r8,[r7,r2,lsl #2]
  sub r8,r8,#1 ;
  str r8,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  and r11,r11,#7 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  bic r1,r0,r1,lsl r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op01a7:
  str r5,[r7,#0x5c] ;

;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
  ldr r8,[r7,#0x3c] ;
  sub r8,r8,#2 ;
  str r8,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  and r11,r11,#7 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  bic r1,r0,r1,lsl r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op01a8:
  str r5,[r7,#0x5c] ;

;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r8,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  and r11,r11,#7 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  bic r1,r0,r1,lsl r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op01b0:
  str r5,[r7,#0x5c] ;

;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r8,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  and r11,r11,#7 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  bic r1,r0,r1,lsl r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op01b8:
  str r5,[r7,#0x5c] ;

;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
  ldrsh r8,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  and r11,r11,#7 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  bic r1,r0,r1,lsl r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op01b9:
  str r5,[r7,#0x5c] ;

;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r8,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  and r11,r11,#7 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  bic r1,r0,r1,lsl r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op01c0:
;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
  and r8,r8,#0x000f
;
  ldr r0,[r7,r8,lsl #2]

  and r11,r11,#31 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  orr r1,r0,r1,lsl r11 ;

;
  str r1,[r7,r8,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op01c8:
  str r5,[r7,#0x5c] ;

;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r8,r0,r2 ;
  mov r1,r11,lsr #24 ;
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  add r0,r8,#2
  mov r1,r11,lsr #16 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  add r0,r8,#4
  mov r1,r11,lsr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  add r0,r8,#6
  and r1,r11,#0xff
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op01d0:
  str r5,[r7,#0x5c] ;

;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r8,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  and r11,r11,#7 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  orr r1,r0,r1,lsl r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op01d8:
  str r5,[r7,#0x5c] ;

;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
  and r2,r8,#0x000f
  ldr r8,[r7,r2,lsl #2]
  add r3,r8,#1 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  and r11,r11,#7 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  orr r1,r0,r1,lsl r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op01df:
  str r5,[r7,#0x5c] ;

;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
  ldr r8,[r7,#0x3c] ;
  add r3,r8,#2 ;
  str r3,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  and r11,r11,#7 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  orr r1,r0,r1,lsl r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op01e0:
  str r5,[r7,#0x5c] ;

;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r8,[r7,r2,lsl #2]
  sub r8,r8,#1 ;
  str r8,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  and r11,r11,#7 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  orr r1,r0,r1,lsl r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op01e7:
  str r5,[r7,#0x5c] ;

;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
  ldr r8,[r7,#0x3c] ;
  sub r8,r8,#2 ;
  str r8,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  and r11,r11,#7 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  orr r1,r0,r1,lsl r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op01e8:
  str r5,[r7,#0x5c] ;

;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r8,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  and r11,r11,#7 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  orr r1,r0,r1,lsl r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op01f0:
  str r5,[r7,#0x5c] ;

;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r8,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  and r11,r11,#7 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  orr r1,r0,r1,lsl r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op01f8:
  str r5,[r7,#0x5c] ;

;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
  ldrsh r8,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  and r11,r11,#7 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  orr r1,r0,r1,lsl r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op01f9:
  str r5,[r7,#0x5c] ;

;
  and r11,r8,#0x0e00
;
  ldr r11,[r7,r11,lsr #7]

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r8,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  and r11,r11,#7 ;

  mov r1,#1
  tst r0,r1,lsl r11 ;
  bicne r10,r10,#0x40000000
  orreq r10,r10,#0x40000000 ;

  orr r1,r0,r1,lsl r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0200:
;
  ldrsb r10,[r4],#2 ;
;

;
  and r11,r8,#0x000f
;
  ldr r0,[r7,r11,lsl #2]

  mov r10,r10,asl #24
;
  and r1,r10,r0,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
  strb r1,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0210:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  and r1,r10,r0,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0218:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#1 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  and r1,r10,r0,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op021f:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  ldr r11,[r7,#0x3c] ;
  add r3,r11,#2 ;
  str r3,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  and r1,r10,r0,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0220:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#1 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  and r1,r10,r0,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0227:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  ldr r11,[r7,#0x3c] ;
  sub r11,r11,#2 ;
  str r11,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  and r1,r10,r0,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0228:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  and r1,r10,r0,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0230:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  and r1,r10,r0,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0238:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  and r1,r10,r0,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0239:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  and r1,r10,r0,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op023c:
;
  ldrsb r0,[r4],#2 ;
;

  eor r1,r0,r0,ror #1 ;
  tst r1,#1 ;
  eorne r0,r0,#3 ;
  ldr r2,[r7,#0x4c] ;
  and r10,r10,r0,lsl #28
  and r2,r2,r0,lsl #25 ;
  str r2,[r7,#0x4c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0250:
  str r5,[r7,#0x5c] ;

;
  ldrsh r10,[r4],#2 ;
;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r10,r10,asl #16
;
  and r1,r10,r0,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0258:
  str r5,[r7,#0x5c] ;

;
  ldrsh r10,[r4],#2 ;
;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#2 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r10,r10,asl #16
;
  and r1,r10,r0,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0260:
  str r5,[r7,#0x5c] ;

;
  ldrsh r10,[r4],#2 ;
;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#2 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r10,r10,asl #16
;
  and r1,r10,r0,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0268:
  str r5,[r7,#0x5c] ;

;
  ldrsh r10,[r4],#2 ;
;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r10,r10,asl #16
;
  and r1,r10,r0,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0270:
  str r5,[r7,#0x5c] ;

;
  ldrsh r10,[r4],#2 ;
;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r10,r10,asl #16
;
  and r1,r10,r0,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0278:
  str r5,[r7,#0x5c] ;

;
  ldrsh r10,[r4],#2 ;
;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r10,r10,asl #16
;
  and r1,r10,r0,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0279:
  str r5,[r7,#0x5c] ;

;
  ldrsh r10,[r4],#2 ;
;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r10,r10,asl #16
;
  and r1,r10,r0,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op027c:
  ldr r11,[r7,#0x44] ;
  tst r11,#0x20 ;
  beq WrongPrivilegeMode ;

;
  ldrsh r0,[r4],#2 ;
;

  eor r1,r0,r0,ror #1 ;
  tst r1,#1 ;
  eorne r0,r0,#3 ;
  ldr r2,[r7,#0x4c] ;
  and r10,r10,r0,lsl #28
  and r2,r2,r0,lsl #25 ;
  and r1,r11,r0,lsr #8
  str r2,[r7,#0x4c] ;
  strb r1,[r7,#0x44]

;
  eor r0,r1,r11
  tst r0,#0x20
  beq no_sp_swap027c
 ;
  ldr r11,[r7,#0x3C] ;
  ldr r0, [r7,#0x48] ;
  str r11,[r7,#0x48]
  str r0, [r7,#0x3C]
no_sp_swap027c:

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  blt CycloneEnd
;
  ldr r1,[r7,#0x44]
  movs r0,r1,lsr #24 ;
  ldreq pc,[r6,r8,asl #2] ;
  cmp r0,#6 ;
  andle r1,r1,#7 ;
  cmple r0,r1 ;
  ldrle pc,[r6,r8,asl #2] ;
  b CycloneDoInterruptGoBack

;
Op0280:
;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
  and r11,r8,#0x000f
;
  ldr r0,[r7,r11,lsl #2]

;
  and r1,r10,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  str r1,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0290:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  and r1,r10,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#28 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0298:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#4 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  and r1,r10,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#28 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op02a0:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#4 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  and r1,r10,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#30 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op02a8:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  and r1,r10,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#32 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op02b0:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  and r1,r10,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#34 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op02b8:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  and r1,r10,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#32 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op02b9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  and r1,r10,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#36 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0400:
;
  ldrsb r10,[r4],#2 ;
;

;
  and r11,r8,#0x000f
;
  ldr r0,[r7,r11,lsl #2]

  mov r10,r10,asl #24
;
  rsbs r1,r10,r0,asl #24 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  strb r1,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0410:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  rsbs r1,r10,r0,asl #24 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0418:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#1 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  rsbs r1,r10,r0,asl #24 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op041f:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  ldr r11,[r7,#0x3c] ;
  add r3,r11,#2 ;
  str r3,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  rsbs r1,r10,r0,asl #24 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0420:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#1 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  rsbs r1,r10,r0,asl #24 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0427:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  ldr r11,[r7,#0x3c] ;
  sub r11,r11,#2 ;
  str r11,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  rsbs r1,r10,r0,asl #24 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0428:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  rsbs r1,r10,r0,asl #24 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0430:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  rsbs r1,r10,r0,asl #24 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0438:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  rsbs r1,r10,r0,asl #24 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0439:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  rsbs r1,r10,r0,asl #24 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0440:
;
  ldrsh r10,[r4],#2 ;
;

;
  and r11,r8,#0x000f
  mov r11,r11,lsl #2
;
  ldr r0,[r7,r11]

  mov r10,r10,asl #16
;
  rsbs r1,r10,r0,asl #16 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0450:
  str r5,[r7,#0x5c] ;

;
  ldrsh r10,[r4],#2 ;
;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r10,r10,asl #16
;
  rsbs r1,r10,r0,asl #16 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0458:
  str r5,[r7,#0x5c] ;

;
  ldrsh r10,[r4],#2 ;
;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#2 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r10,r10,asl #16
;
  rsbs r1,r10,r0,asl #16 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0460:
  str r5,[r7,#0x5c] ;

;
  ldrsh r10,[r4],#2 ;
;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#2 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r10,r10,asl #16
;
  rsbs r1,r10,r0,asl #16 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0468:
  str r5,[r7,#0x5c] ;

;
  ldrsh r10,[r4],#2 ;
;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r10,r10,asl #16
;
  rsbs r1,r10,r0,asl #16 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0470:
  str r5,[r7,#0x5c] ;

;
  ldrsh r10,[r4],#2 ;
;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r10,r10,asl #16
;
  rsbs r1,r10,r0,asl #16 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0478:
  str r5,[r7,#0x5c] ;

;
  ldrsh r10,[r4],#2 ;
;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r10,r10,asl #16
;
  rsbs r1,r10,r0,asl #16 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0479:
  str r5,[r7,#0x5c] ;

;
  ldrsh r10,[r4],#2 ;
;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r10,r10,asl #16
;
  rsbs r1,r10,r0,asl #16 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0480:
;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
  and r11,r8,#0x000f
;
  ldr r0,[r7,r11,lsl #2]

;
  rsbs r1,r10,r0 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  str r1,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0490:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  rsbs r1,r10,r0 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#28 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0498:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#4 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  rsbs r1,r10,r0 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#28 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op04a0:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#4 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  rsbs r1,r10,r0 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#30 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op04a8:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  rsbs r1,r10,r0 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#32 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op04b0:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  rsbs r1,r10,r0 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#34 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op04b8:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  rsbs r1,r10,r0 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#32 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op04b9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  rsbs r1,r10,r0 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#36 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0600:
;
  ldrsb r10,[r4],#2 ;
;

;
  and r11,r8,#0x000f
;
  ldr r0,[r7,r11,lsl #2]

  mov r10,r10,asl #24
;
  adds r1,r10,r0,asl #24 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  strb r1,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0610:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  adds r1,r10,r0,asl #24 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0618:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#1 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  adds r1,r10,r0,asl #24 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op061f:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  ldr r11,[r7,#0x3c] ;
  add r3,r11,#2 ;
  str r3,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  adds r1,r10,r0,asl #24 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0620:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#1 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  adds r1,r10,r0,asl #24 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0627:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  ldr r11,[r7,#0x3c] ;
  sub r11,r11,#2 ;
  str r11,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  adds r1,r10,r0,asl #24 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0628:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  adds r1,r10,r0,asl #24 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0630:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  adds r1,r10,r0,asl #24 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0638:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  adds r1,r10,r0,asl #24 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0639:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  adds r1,r10,r0,asl #24 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0650:
  str r5,[r7,#0x5c] ;

;
  ldrsh r10,[r4],#2 ;
;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r10,r10,asl #16
;
  adds r1,r10,r0,asl #16 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0658:
  str r5,[r7,#0x5c] ;

;
  ldrsh r10,[r4],#2 ;
;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#2 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r10,r10,asl #16
;
  adds r1,r10,r0,asl #16 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0660:
  str r5,[r7,#0x5c] ;

;
  ldrsh r10,[r4],#2 ;
;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#2 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r10,r10,asl #16
;
  adds r1,r10,r0,asl #16 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0668:
  str r5,[r7,#0x5c] ;

;
  ldrsh r10,[r4],#2 ;
;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r10,r10,asl #16
;
  adds r1,r10,r0,asl #16 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0670:
  str r5,[r7,#0x5c] ;

;
  ldrsh r10,[r4],#2 ;
;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r10,r10,asl #16
;
  adds r1,r10,r0,asl #16 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0678:
  str r5,[r7,#0x5c] ;

;
  ldrsh r10,[r4],#2 ;
;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r10,r10,asl #16
;
  adds r1,r10,r0,asl #16 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0679:
  str r5,[r7,#0x5c] ;

;
  ldrsh r10,[r4],#2 ;
;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r10,r10,asl #16
;
  adds r1,r10,r0,asl #16 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0680:
;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
  and r11,r8,#0x000f
;
  ldr r0,[r7,r11,lsl #2]

;
  adds r1,r10,r0 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  str r1,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0690:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  adds r1,r10,r0 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#28 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0698:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#4 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  adds r1,r10,r0 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#28 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op06a0:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#4 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  adds r1,r10,r0 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#30 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op06a8:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  adds r1,r10,r0 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#32 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op06b0:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  adds r1,r10,r0 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#34 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op06b8:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  adds r1,r10,r0 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#32 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op06b9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  adds r1,r10,r0 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#36 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0800:

;
  ldrsb r0,[r4],#2 ;
;

  mov r11,#1
  bic r10,r10,#0x40000000 ;
  and r0,r0,#0x1F ;
  mov r11,r11,lsl r0 ;

;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

  tst r0,r11 ;
  orreq r10,r10,#0x40000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0810:
  str r5,[r7,#0x5c] ;


;
  ldrsb r0,[r4],#2 ;
;

  mov r11,#1
  bic r10,r10,#0x40000000 ;
  and r0,r0,#7 ;
  mov r11,r11,lsl r0 ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

  tst r0,r11 ;
  orreq r10,r10,#0x40000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0818:
  str r5,[r7,#0x5c] ;


;
  ldrsb r0,[r4],#2 ;
;

  mov r11,#1
  bic r10,r10,#0x40000000 ;
  and r0,r0,#7 ;
  mov r11,r11,lsl r0 ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

  tst r0,r11 ;
  orreq r10,r10,#0x40000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op081f:
  str r5,[r7,#0x5c] ;


;
  ldrsb r0,[r4],#2 ;
;

  mov r11,#1
  bic r10,r10,#0x40000000 ;
  and r0,r0,#7 ;
  mov r11,r11,lsl r0 ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

  tst r0,r11 ;
  orreq r10,r10,#0x40000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0820:
  str r5,[r7,#0x5c] ;


;
  ldrsb r0,[r4],#2 ;
;

  mov r11,#1
  bic r10,r10,#0x40000000 ;
  and r0,r0,#7 ;
  mov r11,r11,lsl r0 ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

  tst r0,r11 ;
  orreq r10,r10,#0x40000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0827:
  str r5,[r7,#0x5c] ;


;
  ldrsb r0,[r4],#2 ;
;

  mov r11,#1
  bic r10,r10,#0x40000000 ;
  and r0,r0,#7 ;
  mov r11,r11,lsl r0 ;

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

  tst r0,r11 ;
  orreq r10,r10,#0x40000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0830:
  str r5,[r7,#0x5c] ;


;
  ldrsb r0,[r4],#2 ;
;

  mov r11,#1
  bic r10,r10,#0x40000000 ;
  and r0,r0,#7 ;
  mov r11,r11,lsl r0 ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

  tst r0,r11 ;
  orreq r10,r10,#0x40000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op083a:
  str r5,[r7,#0x5c] ;


;
  ldrsb r0,[r4],#2 ;
;

  mov r11,#1
  bic r10,r10,#0x40000000 ;
  and r0,r0,#7 ;
  mov r11,r11,lsl r0 ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x80] ;

  tst r0,r11 ;
  orreq r10,r10,#0x40000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op083b:
  str r5,[r7,#0x5c] ;


;
  ldrsb r0,[r4],#2 ;
;

  mov r11,#1
  bic r10,r10,#0x40000000 ;
  and r0,r0,#7 ;
  mov r11,r11,lsl r0 ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x80] ;

  tst r0,r11 ;
  orreq r10,r10,#0x40000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0840:

;
  ldrsb r0,[r4],#2 ;
;

  mov r11,#1
  bic r10,r10,#0x40000000 ;
  and r0,r0,#0x1F ;
  mov r11,r11,lsl r0 ;

;
  and r8,r8,#0x000f
;
  ldr r0,[r7,r8,lsl #2]

  tst r0,r11 ;
  orreq r10,r10,#0x40000000 ;

  eor r1,r0,r11 ;

;
  str r1,[r7,r8,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0850:
  str r5,[r7,#0x5c] ;


;
  ldrsb r0,[r4],#2 ;
;

  mov r11,#1
  bic r10,r10,#0x40000000 ;
  and r0,r0,#7 ;
  mov r11,r11,lsl r0 ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r8,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  tst r0,r11 ;
  orreq r10,r10,#0x40000000 ;

  eor r1,r0,r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0858:
  str r5,[r7,#0x5c] ;


;
  ldrsb r0,[r4],#2 ;
;

  mov r11,#1
  bic r10,r10,#0x40000000 ;
  and r0,r0,#7 ;
  mov r11,r11,lsl r0 ;

;
  and r2,r8,#0x000f
  ldr r8,[r7,r2,lsl #2]
  add r3,r8,#1 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  tst r0,r11 ;
  orreq r10,r10,#0x40000000 ;

  eor r1,r0,r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op085f:
  str r5,[r7,#0x5c] ;


;
  ldrsb r0,[r4],#2 ;
;

  mov r11,#1
  bic r10,r10,#0x40000000 ;
  and r0,r0,#7 ;
  mov r11,r11,lsl r0 ;

;
  ldr r8,[r7,#0x3c] ;
  add r3,r8,#2 ;
  str r3,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  tst r0,r11 ;
  orreq r10,r10,#0x40000000 ;

  eor r1,r0,r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0860:
  str r5,[r7,#0x5c] ;


;
  ldrsb r0,[r4],#2 ;
;

  mov r11,#1
  bic r10,r10,#0x40000000 ;
  and r0,r0,#7 ;
  mov r11,r11,lsl r0 ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r8,[r7,r2,lsl #2]
  sub r8,r8,#1 ;
  str r8,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  tst r0,r11 ;
  orreq r10,r10,#0x40000000 ;

  eor r1,r0,r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0867:
  str r5,[r7,#0x5c] ;


;
  ldrsb r0,[r4],#2 ;
;

  mov r11,#1
  bic r10,r10,#0x40000000 ;
  and r0,r0,#7 ;
  mov r11,r11,lsl r0 ;

;
  ldr r8,[r7,#0x3c] ;
  sub r8,r8,#2 ;
  str r8,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  tst r0,r11 ;
  orreq r10,r10,#0x40000000 ;

  eor r1,r0,r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0868:
  str r5,[r7,#0x5c] ;


;
  ldrsb r0,[r4],#2 ;
;

  mov r11,#1
  bic r10,r10,#0x40000000 ;
  and r0,r0,#7 ;
  mov r11,r11,lsl r0 ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r8,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  tst r0,r11 ;
  orreq r10,r10,#0x40000000 ;

  eor r1,r0,r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0870:
  str r5,[r7,#0x5c] ;


;
  ldrsb r0,[r4],#2 ;
;

  mov r11,#1
  bic r10,r10,#0x40000000 ;
  and r0,r0,#7 ;
  mov r11,r11,lsl r0 ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r8,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  tst r0,r11 ;
  orreq r10,r10,#0x40000000 ;

  eor r1,r0,r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0878:
  str r5,[r7,#0x5c] ;


;
  ldrsb r0,[r4],#2 ;
;

  mov r11,#1
  bic r10,r10,#0x40000000 ;
  and r0,r0,#7 ;
  mov r11,r11,lsl r0 ;

;
  ldrsh r8,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  tst r0,r11 ;
  orreq r10,r10,#0x40000000 ;

  eor r1,r0,r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0879:
  str r5,[r7,#0x5c] ;


;
  ldrsb r0,[r4],#2 ;
;

  mov r11,#1
  bic r10,r10,#0x40000000 ;
  and r0,r0,#7 ;
  mov r11,r11,lsl r0 ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r8,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  tst r0,r11 ;
  orreq r10,r10,#0x40000000 ;

  eor r1,r0,r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0880:

;
  ldrsb r0,[r4],#2 ;
;

  mov r11,#1
  bic r10,r10,#0x40000000 ;
  and r0,r0,#0x1F ;
  mov r11,r11,lsl r0 ;

;
  and r8,r8,#0x000f
;
  ldr r0,[r7,r8,lsl #2]

  tst r0,r11 ;
  orreq r10,r10,#0x40000000 ;

  bic r1,r0,r11 ;

;
  str r1,[r7,r8,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0890:
  str r5,[r7,#0x5c] ;


;
  ldrsb r0,[r4],#2 ;
;

  mov r11,#1
  bic r10,r10,#0x40000000 ;
  and r0,r0,#7 ;
  mov r11,r11,lsl r0 ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r8,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  tst r0,r11 ;
  orreq r10,r10,#0x40000000 ;

  bic r1,r0,r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0898:
  str r5,[r7,#0x5c] ;


;
  ldrsb r0,[r4],#2 ;
;

  mov r11,#1
  bic r10,r10,#0x40000000 ;
  and r0,r0,#7 ;
  mov r11,r11,lsl r0 ;

;
  and r2,r8,#0x000f
  ldr r8,[r7,r2,lsl #2]
  add r3,r8,#1 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  tst r0,r11 ;
  orreq r10,r10,#0x40000000 ;

  bic r1,r0,r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op089f:
  str r5,[r7,#0x5c] ;


;
  ldrsb r0,[r4],#2 ;
;

  mov r11,#1
  bic r10,r10,#0x40000000 ;
  and r0,r0,#7 ;
  mov r11,r11,lsl r0 ;

;
  ldr r8,[r7,#0x3c] ;
  add r3,r8,#2 ;
  str r3,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  tst r0,r11 ;
  orreq r10,r10,#0x40000000 ;

  bic r1,r0,r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op08a0:
  str r5,[r7,#0x5c] ;


;
  ldrsb r0,[r4],#2 ;
;

  mov r11,#1
  bic r10,r10,#0x40000000 ;
  and r0,r0,#7 ;
  mov r11,r11,lsl r0 ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r8,[r7,r2,lsl #2]
  sub r8,r8,#1 ;
  str r8,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  tst r0,r11 ;
  orreq r10,r10,#0x40000000 ;

  bic r1,r0,r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op08a7:
  str r5,[r7,#0x5c] ;


;
  ldrsb r0,[r4],#2 ;
;

  mov r11,#1
  bic r10,r10,#0x40000000 ;
  and r0,r0,#7 ;
  mov r11,r11,lsl r0 ;

;
  ldr r8,[r7,#0x3c] ;
  sub r8,r8,#2 ;
  str r8,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  tst r0,r11 ;
  orreq r10,r10,#0x40000000 ;

  bic r1,r0,r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op08a8:
  str r5,[r7,#0x5c] ;


;
  ldrsb r0,[r4],#2 ;
;

  mov r11,#1
  bic r10,r10,#0x40000000 ;
  and r0,r0,#7 ;
  mov r11,r11,lsl r0 ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r8,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  tst r0,r11 ;
  orreq r10,r10,#0x40000000 ;

  bic r1,r0,r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op08b0:
  str r5,[r7,#0x5c] ;


;
  ldrsb r0,[r4],#2 ;
;

  mov r11,#1
  bic r10,r10,#0x40000000 ;
  and r0,r0,#7 ;
  mov r11,r11,lsl r0 ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r8,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  tst r0,r11 ;
  orreq r10,r10,#0x40000000 ;

  bic r1,r0,r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op08b8:
  str r5,[r7,#0x5c] ;


;
  ldrsb r0,[r4],#2 ;
;

  mov r11,#1
  bic r10,r10,#0x40000000 ;
  and r0,r0,#7 ;
  mov r11,r11,lsl r0 ;

;
  ldrsh r8,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  tst r0,r11 ;
  orreq r10,r10,#0x40000000 ;

  bic r1,r0,r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op08b9:
  str r5,[r7,#0x5c] ;


;
  ldrsb r0,[r4],#2 ;
;

  mov r11,#1
  bic r10,r10,#0x40000000 ;
  and r0,r0,#7 ;
  mov r11,r11,lsl r0 ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r8,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  tst r0,r11 ;
  orreq r10,r10,#0x40000000 ;

  bic r1,r0,r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op08c0:

;
  ldrsb r0,[r4],#2 ;
;

  mov r11,#1
  bic r10,r10,#0x40000000 ;
  and r0,r0,#0x1F ;
  mov r11,r11,lsl r0 ;

;
  and r8,r8,#0x000f
;
  ldr r0,[r7,r8,lsl #2]

  tst r0,r11 ;
  orreq r10,r10,#0x40000000 ;

  orr r1,r0,r11 ;

;
  str r1,[r7,r8,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op08d0:
  str r5,[r7,#0x5c] ;


;
  ldrsb r0,[r4],#2 ;
;

  mov r11,#1
  bic r10,r10,#0x40000000 ;
  and r0,r0,#7 ;
  mov r11,r11,lsl r0 ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r8,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  tst r0,r11 ;
  orreq r10,r10,#0x40000000 ;

  orr r1,r0,r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op08d8:
  str r5,[r7,#0x5c] ;


;
  ldrsb r0,[r4],#2 ;
;

  mov r11,#1
  bic r10,r10,#0x40000000 ;
  and r0,r0,#7 ;
  mov r11,r11,lsl r0 ;

;
  and r2,r8,#0x000f
  ldr r8,[r7,r2,lsl #2]
  add r3,r8,#1 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  tst r0,r11 ;
  orreq r10,r10,#0x40000000 ;

  orr r1,r0,r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op08df:
  str r5,[r7,#0x5c] ;


;
  ldrsb r0,[r4],#2 ;
;

  mov r11,#1
  bic r10,r10,#0x40000000 ;
  and r0,r0,#7 ;
  mov r11,r11,lsl r0 ;

;
  ldr r8,[r7,#0x3c] ;
  add r3,r8,#2 ;
  str r3,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  tst r0,r11 ;
  orreq r10,r10,#0x40000000 ;

  orr r1,r0,r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op08e0:
  str r5,[r7,#0x5c] ;


;
  ldrsb r0,[r4],#2 ;
;

  mov r11,#1
  bic r10,r10,#0x40000000 ;
  and r0,r0,#7 ;
  mov r11,r11,lsl r0 ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r8,[r7,r2,lsl #2]
  sub r8,r8,#1 ;
  str r8,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  tst r0,r11 ;
  orreq r10,r10,#0x40000000 ;

  orr r1,r0,r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op08e7:
  str r5,[r7,#0x5c] ;


;
  ldrsb r0,[r4],#2 ;
;

  mov r11,#1
  bic r10,r10,#0x40000000 ;
  and r0,r0,#7 ;
  mov r11,r11,lsl r0 ;

;
  ldr r8,[r7,#0x3c] ;
  sub r8,r8,#2 ;
  str r8,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  tst r0,r11 ;
  orreq r10,r10,#0x40000000 ;

  orr r1,r0,r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op08e8:
  str r5,[r7,#0x5c] ;


;
  ldrsb r0,[r4],#2 ;
;

  mov r11,#1
  bic r10,r10,#0x40000000 ;
  and r0,r0,#7 ;
  mov r11,r11,lsl r0 ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r8,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  tst r0,r11 ;
  orreq r10,r10,#0x40000000 ;

  orr r1,r0,r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op08f0:
  str r5,[r7,#0x5c] ;


;
  ldrsb r0,[r4],#2 ;
;

  mov r11,#1
  bic r10,r10,#0x40000000 ;
  and r0,r0,#7 ;
  mov r11,r11,lsl r0 ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r8,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  tst r0,r11 ;
  orreq r10,r10,#0x40000000 ;

  orr r1,r0,r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op08f8:
  str r5,[r7,#0x5c] ;


;
  ldrsb r0,[r4],#2 ;
;

  mov r11,#1
  bic r10,r10,#0x40000000 ;
  and r0,r0,#7 ;
  mov r11,r11,lsl r0 ;

;
  ldrsh r8,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  tst r0,r11 ;
  orreq r10,r10,#0x40000000 ;

  orr r1,r0,r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op08f9:
  str r5,[r7,#0x5c] ;


;
  ldrsb r0,[r4],#2 ;
;

  mov r11,#1
  bic r10,r10,#0x40000000 ;
  and r0,r0,#7 ;
  mov r11,r11,lsl r0 ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r8,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x68] ;

  tst r0,r11 ;
  orreq r10,r10,#0x40000000 ;

  orr r1,r0,r11 ;

;
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x74] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0a00:
;
  ldrsb r10,[r4],#2 ;
;

;
  and r11,r8,#0x000f
;
  ldr r0,[r7,r11,lsl #2]

  mov r10,r10,asl #24
;
  eor r1,r10,r0,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
  strb r1,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0a10:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  eor r1,r10,r0,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0a18:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#1 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  eor r1,r10,r0,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0a1f:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  ldr r11,[r7,#0x3c] ;
  add r3,r11,#2 ;
  str r3,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  eor r1,r10,r0,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0a20:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#1 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  eor r1,r10,r0,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0a27:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  ldr r11,[r7,#0x3c] ;
  sub r11,r11,#2 ;
  str r11,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  eor r1,r10,r0,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0a28:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  eor r1,r10,r0,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0a30:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  eor r1,r10,r0,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0a38:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  eor r1,r10,r0,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0a39:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  eor r1,r10,r0,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0a3c:
;
  ldrsb r0,[r4],#2 ;
;

  eor r1,r0,r0,ror #1 ;
  tst r1,#1 ;
  eorne r0,r0,#3 ;
  ldr r2,[r7,#0x4c] ;
  eor r10,r10,r0,lsl #28
  eor r2,r2,r0,lsl #25 ;
  str r2,[r7,#0x4c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0a40:
;
  ldrsh r10,[r4],#2 ;
;

;
  and r11,r8,#0x000f
  mov r11,r11,lsl #2
;
  ldr r0,[r7,r11]

  mov r10,r10,asl #16
;
  eor r1,r10,r0,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0a50:
  str r5,[r7,#0x5c] ;

;
  ldrsh r10,[r4],#2 ;
;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r10,r10,asl #16
;
  eor r1,r10,r0,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0a58:
  str r5,[r7,#0x5c] ;

;
  ldrsh r10,[r4],#2 ;
;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#2 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r10,r10,asl #16
;
  eor r1,r10,r0,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0a60:
  str r5,[r7,#0x5c] ;

;
  ldrsh r10,[r4],#2 ;
;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#2 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r10,r10,asl #16
;
  eor r1,r10,r0,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0a68:
  str r5,[r7,#0x5c] ;

;
  ldrsh r10,[r4],#2 ;
;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r10,r10,asl #16
;
  eor r1,r10,r0,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0a70:
  str r5,[r7,#0x5c] ;

;
  ldrsh r10,[r4],#2 ;
;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r10,r10,asl #16
;
  eor r1,r10,r0,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0a78:
  str r5,[r7,#0x5c] ;

;
  ldrsh r10,[r4],#2 ;
;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r10,r10,asl #16
;
  eor r1,r10,r0,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0a79:
  str r5,[r7,#0x5c] ;

;
  ldrsh r10,[r4],#2 ;
;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r10,r10,asl #16
;
  eor r1,r10,r0,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0a7c:
  ldr r11,[r7,#0x44] ;
  tst r11,#0x20 ;
  beq WrongPrivilegeMode ;

;
  ldrsh r0,[r4],#2 ;
;

  eor r1,r0,r0,ror #1 ;
  tst r1,#1 ;
  eorne r0,r0,#3 ;
  ldr r2,[r7,#0x4c] ;
  eor r10,r10,r0,lsl #28
  eor r2,r2,r0,lsl #25 ;
  eor r1,r11,r0,lsr #8
  and r1,r1,#0xa7 ;
  str r2,[r7,#0x4c] ;
  strb r1,[r7,#0x44]

;
  eor r0,r1,r11
  tst r0,#0x20
  beq no_sp_swap0a7c
 ;
  ldr r11,[r7,#0x3C] ;
  ldr r0, [r7,#0x48] ;
  str r11,[r7,#0x48]
  str r0, [r7,#0x3C]
no_sp_swap0a7c:

  ldrh r8,[r4],#2 ;
  ldr r1,[r7,#0x44]
  subs r5,r5,#20 ;
;
  tst r1,#0x80
  bne CycloneDoTraceWithChecks
  cmp r5,#0
  blt CycloneEnd
;
  movs r0,r1,lsr #24 ;
  ldreq pc,[r6,r8,asl #2] ;
  cmp r0,#6 ;
  andle r1,r1,#7 ;
  cmple r0,r1 ;
  ldrle pc,[r6,r8,asl #2] ;
  b CycloneDoInterruptGoBack

;
Op0a80:
;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
  and r11,r8,#0x000f
;
  ldr r0,[r7,r11,lsl #2]

;
  eor r1,r10,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  str r1,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0a90:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  eor r1,r10,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#28 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0a98:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#4 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  eor r1,r10,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#28 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0aa0:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#4 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  eor r1,r10,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#30 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0aa8:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  eor r1,r10,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#32 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0ab0:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  eor r1,r10,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#34 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0ab8:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  eor r1,r10,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#32 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0ab9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  eor r1,r10,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#36 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0c00:
;
  ldrsb r10,[r4],#2 ;
;

;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

  mov r10,r10,asl #24
;
  rsbs r1,r10,r0,asl #24 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0c10:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  rsbs r1,r10,r0,asl #24 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0c18:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  rsbs r1,r10,r0,asl #24 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0c1f:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  rsbs r1,r10,r0,asl #24 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0c20:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  rsbs r1,r10,r0,asl #24 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0c27:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  rsbs r1,r10,r0,asl #24 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0c28:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  rsbs r1,r10,r0,asl #24 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0c30:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  rsbs r1,r10,r0,asl #24 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0c38:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  rsbs r1,r10,r0,asl #24 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0c39:
  str r5,[r7,#0x5c] ;

;
  ldrsb r10,[r4],#2 ;
;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

  mov r10,r10,asl #24
;
  rsbs r1,r10,r0,asl #24 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0c50:
  str r5,[r7,#0x5c] ;

;
  ldrsh r10,[r4],#2 ;
;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

  mov r10,r10,asl #16
;
  rsbs r1,r10,r0,asl #16 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0c58:
  str r5,[r7,#0x5c] ;

;
  ldrsh r10,[r4],#2 ;
;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#2 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

  mov r10,r10,asl #16
;
  rsbs r1,r10,r0,asl #16 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0c60:
  str r5,[r7,#0x5c] ;

;
  ldrsh r10,[r4],#2 ;
;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#2 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

  mov r10,r10,asl #16
;
  rsbs r1,r10,r0,asl #16 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0c68:
  str r5,[r7,#0x5c] ;

;
  ldrsh r10,[r4],#2 ;
;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

  mov r10,r10,asl #16
;
  rsbs r1,r10,r0,asl #16 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0c70:
  str r5,[r7,#0x5c] ;

;
  ldrsh r10,[r4],#2 ;
;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

  mov r10,r10,asl #16
;
  rsbs r1,r10,r0,asl #16 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0c78:
  str r5,[r7,#0x5c] ;

;
  ldrsh r10,[r4],#2 ;
;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

  mov r10,r10,asl #16
;
  rsbs r1,r10,r0,asl #16 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0c80:
;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

;
  rsbs r1,r10,r0 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0c90:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  rsbs r1,r10,r0 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0c98:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#4 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  rsbs r1,r10,r0 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0ca0:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#4 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  rsbs r1,r10,r0 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0ca8:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  rsbs r1,r10,r0 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0cb0:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  rsbs r1,r10,r0 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#26 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0cb8:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  rsbs r1,r10,r0 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op0cb9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r10,r3,r2,lsl #16
;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  rsbs r1,r10,r0 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#28 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1000:
;
  and r0,r8,#0x000f
  mov r0,r0,lsl #2
;
  ldrsb r0,[r7,r0]

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r0,r8,#0x0e00
;
  strb r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1010:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r0,r8,#0x0e00
;
  strb r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op101f:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r0,r8,#0x0e00
;
  strb r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1020:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r0,r8,#0x0e00
;
  strb r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1027:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r0,r8,#0x0e00
;
  strb r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1028:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r0,r8,#0x0e00
;
  strb r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1030:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r0,r8,#0x0e00
;
  strb r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1038:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r0,r8,#0x0e00
;
  strb r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op103a:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x80] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r0,r8,#0x0e00
;
  strb r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op103b:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x80] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r0,r8,#0x0e00
;
  strb r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op103c:
;
  ldrsb r0,[r4],#2 ;
;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r0,r8,#0x0e00
;
  strb r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1080:
  str r5,[r7,#0x5c] ;

;
  and r0,r8,#0x000f
  mov r0,r0,lsl #2
;
  ldrsb r0,[r7,r0]

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1090:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1098:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op109f:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op10a0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op10a7:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op10a8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op10b0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op10b8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op10b9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op10ba:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x80] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op10bb:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x80] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op10bc:
  str r5,[r7,#0x5c] ;

;
  ldrsb r0,[r4],#2 ;
;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op10d0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op10df:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op10e0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op10e7:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op10e8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op10f0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op10f8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op10f9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op10fa:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x80] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op10fb:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x80] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op10fc:
  str r5,[r7,#0x5c] ;

;
  ldrsb r0,[r4],#2 ;
;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1100:
  str r5,[r7,#0x5c] ;

;
  and r0,r8,#0x000f
  mov r0,r0,lsl #2
;
  ldrsb r0,[r7,r0]

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1110:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1118:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op111f:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1120:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1127:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1128:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1130:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1138:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1139:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op113a:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x80] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op113b:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x80] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op113c:
  str r5,[r7,#0x5c] ;

;
  ldrsb r0,[r4],#2 ;
;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1140:
  str r5,[r7,#0x5c] ;

;
  and r0,r8,#0x000f
  mov r0,r0,lsl #2
;
  ldrsb r0,[r7,r0]

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x1e00
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1150:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x1e00
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1158:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x1e00
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op115f:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x1e00
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1160:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x1e00
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1167:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x1e00
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1168:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x1e00
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1170:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x1e00
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1178:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x1e00
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1179:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x1e00
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op117a:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x80] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x1e00
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op117b:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x80] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x1e00
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op117c:
  str r5,[r7,#0x5c] ;

;
  ldrsb r0,[r4],#2 ;
;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x1e00
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1180:
  str r5,[r7,#0x5c] ;

;
  and r0,r8,#0x000f
  mov r0,r0,lsl #2
;
  ldrsb r0,[r7,r0]

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x1e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1190:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x1e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op119f:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x1e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op11a0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x1e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op11a7:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x1e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op11a8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x1e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op11b0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x1e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op11b8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x1e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op11b9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x1e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#26 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op11ba:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x80] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x1e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op11bb:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x80] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x1e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op11bc:
  str r5,[r7,#0x5c] ;

;
  ldrsb r0,[r4],#2 ;
;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x1e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op11c0:
  str r5,[r7,#0x5c] ;

;
  and r0,r8,#0x000f
  mov r0,r0,lsl #2
;
  ldrsb r0,[r7,r0]

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op11d0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op11d8:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op11df:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op11e0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op11e7:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op11e8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op11f0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op11f8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op11f9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op11fa:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x80] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op11fb:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x80] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op11fc:
  str r5,[r7,#0x5c] ;

;
  ldrsb r0,[r4],#2 ;
;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op13c0:
  str r5,[r7,#0x5c] ;

;
  and r0,r8,#0x000f
  mov r0,r0,lsl #2
;
  ldrsb r0,[r7,r0]

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op13d0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op13d8:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op13df:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op13e0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op13e7:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op13e8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op13f0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#26 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op13f8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op13f9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#28 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op13fa:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x80] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op13fb:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x80] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#26 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op13fc:
  str r5,[r7,#0x5c] ;

;
  ldrsb r0,[r4],#2 ;
;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1ec0:
  str r5,[r7,#0x5c] ;

;
  and r0,r8,#0x000f
  mov r0,r0,lsl #2
;
  ldrsb r0,[r7,r0]

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1ed0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1ed8:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1edf:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1ee0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1ee7:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1ee8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1ef0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1ef8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1ef9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1efa:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x80] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1efb:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x80] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1efc:
  str r5,[r7,#0x5c] ;

;
  ldrsb r0,[r4],#2 ;
;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1f00:
  str r5,[r7,#0x5c] ;

;
  and r0,r8,#0x000f
  mov r0,r0,lsl #2
;
  ldrsb r0,[r7,r0]

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1f10:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1f18:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1f1f:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1f20:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1f27:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1f28:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1f30:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1f38:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1f39:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1f3a:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x80] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1f3b:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x80] ;
  mov r0,r0,asl #24
  mov r0,r0,asr #24

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op1f3c:
  str r5,[r7,#0x5c] ;

;
  ldrsb r0,[r4],#2 ;
;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2000:
;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r0,r8,#0x0e00
;
  str r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2010:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r0,r8,#0x0e00
;
  str r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2018:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#4 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r0,r8,#0x0e00
;
  str r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2020:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#4 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r0,r8,#0x0e00
;
  str r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2028:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r0,r8,#0x0e00
;
  str r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2030:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r0,r8,#0x0e00
;
  str r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2039:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r0,r8,#0x0e00
;
  str r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op203a:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x88] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r0,r8,#0x0e00
;
  str r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op203b:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x88] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r0,r8,#0x0e00
;
  str r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op203c:
;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r0,r3,r2,lsl #16
;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r0,r8,#0x0e00
;
  str r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2040:
;
  and r1,r8,#0x000f
;
  ldr r1,[r7,r1,lsl #2]

;
  and r0,r8,#0x0e00
  orr r0,r0,#0x1000 ;
;
  str r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2050:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;
  mov r1,r0

;
  and r0,r8,#0x0e00
  orr r0,r0,#0x1000 ;
;
  str r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2058:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#4 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;
  mov r1,r0

;
  and r0,r8,#0x0e00
  orr r0,r0,#0x1000 ;
;
  str r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2060:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#4 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;
  mov r1,r0

;
  and r0,r8,#0x0e00
  orr r0,r0,#0x1000 ;
;
  str r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2068:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;
  mov r1,r0

;
  and r0,r8,#0x0e00
  orr r0,r0,#0x1000 ;
;
  str r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2070:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;
  mov r1,r0

;
  and r0,r8,#0x0e00
  orr r0,r0,#0x1000 ;
;
  str r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2078:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;
  mov r1,r0

;
  and r0,r8,#0x0e00
  orr r0,r0,#0x1000 ;
;
  str r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2079:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;
  mov r1,r0

;
  and r0,r8,#0x0e00
  orr r0,r0,#0x1000 ;
;
  str r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op207a:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x88] ;
  mov r1,r0

;
  and r0,r8,#0x0e00
  orr r0,r0,#0x1000 ;
;
  str r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op207b:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x88] ;
  mov r1,r0

;
  and r0,r8,#0x0e00
  orr r0,r0,#0x1000 ;
;
  str r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op207c:
;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r1,r3,r2,lsl #16
;

;
  and r0,r8,#0x0e00
  orr r0,r0,#0x1000 ;
;
  str r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2080:
  str r5,[r7,#0x5c] ;

;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  ldr r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2090:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  ldr r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2098:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#4 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  ldr r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op20a0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#4 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  ldr r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op20a8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  ldr r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op20b0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  ldr r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#26 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op20b8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  ldr r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op20b9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  ldr r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#28 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op20ba:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x88] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  ldr r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op20bb:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x88] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  ldr r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#26 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op20bc:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r0,r3,r2,lsl #16
;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  ldr r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op20d0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  ldr r0,[r7,r2,lsr #7]
  add r3,r0,#4 ;
  str r3,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op20d8:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#4 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  ldr r0,[r7,r2,lsr #7]
  add r3,r0,#4 ;
  str r3,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op20e0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#4 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  ldr r0,[r7,r2,lsr #7]
  add r3,r0,#4 ;
  str r3,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op20e8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  ldr r0,[r7,r2,lsr #7]
  add r3,r0,#4 ;
  str r3,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op20f0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  ldr r0,[r7,r2,lsr #7]
  add r3,r0,#4 ;
  str r3,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#26 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op20f8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  ldr r0,[r7,r2,lsr #7]
  add r3,r0,#4 ;
  str r3,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op20f9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  ldr r0,[r7,r2,lsr #7]
  add r3,r0,#4 ;
  str r3,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#28 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op20fa:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x88] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  ldr r0,[r7,r2,lsr #7]
  add r3,r0,#4 ;
  str r3,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op20fb:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x88] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  ldr r0,[r7,r2,lsr #7]
  add r3,r0,#4 ;
  str r3,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#26 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op20fc:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r0,r3,r2,lsl #16
;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  ldr r0,[r7,r2,lsr #7]
  add r3,r0,#4 ;
  str r3,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2100:
  str r5,[r7,#0x5c] ;

;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  ldr r8,[r7,r2,lsr #7]
  sub r8,r8,#4 ;
  str r8,[r7,r2,lsr #7]
  mov r11,r1
  add r0,r8,#2
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

;
  mov r1,r11,asr #16
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2110:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  ldr r8,[r7,r2,lsr #7]
  sub r8,r8,#4 ;
  str r8,[r7,r2,lsr #7]
  mov r11,r1
  add r0,r8,#2
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

;
  mov r1,r11,asr #16
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2118:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#4 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  ldr r8,[r7,r2,lsr #7]
  sub r8,r8,#4 ;
  str r8,[r7,r2,lsr #7]
  mov r11,r1
  add r0,r8,#2
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

;
  mov r1,r11,asr #16
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2120:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#4 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  ldr r8,[r7,r2,lsr #7]
  sub r8,r8,#4 ;
  str r8,[r7,r2,lsr #7]
  mov r11,r1
  add r0,r8,#2
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

;
  mov r1,r11,asr #16
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2128:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  ldr r8,[r7,r2,lsr #7]
  sub r8,r8,#4 ;
  str r8,[r7,r2,lsr #7]
  mov r11,r1
  add r0,r8,#2
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

;
  mov r1,r11,asr #16
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2130:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  ldr r8,[r7,r2,lsr #7]
  sub r8,r8,#4 ;
  str r8,[r7,r2,lsr #7]
  mov r11,r1
  add r0,r8,#2
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

;
  mov r1,r11,asr #16
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#26 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2138:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  ldr r8,[r7,r2,lsr #7]
  sub r8,r8,#4 ;
  str r8,[r7,r2,lsr #7]
  mov r11,r1
  add r0,r8,#2
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

;
  mov r1,r11,asr #16
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2139:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  ldr r8,[r7,r2,lsr #7]
  sub r8,r8,#4 ;
  str r8,[r7,r2,lsr #7]
  mov r11,r1
  add r0,r8,#2
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

;
  mov r1,r11,asr #16
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#28 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op213a:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x88] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  ldr r8,[r7,r2,lsr #7]
  sub r8,r8,#4 ;
  str r8,[r7,r2,lsr #7]
  mov r11,r1
  add r0,r8,#2
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

;
  mov r1,r11,asr #16
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op213b:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x88] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  ldr r8,[r7,r2,lsr #7]
  sub r8,r8,#4 ;
  str r8,[r7,r2,lsr #7]
  mov r11,r1
  add r0,r8,#2
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

;
  mov r1,r11,asr #16
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#26 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op213c:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r0,r3,r2,lsl #16
;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  ldr r8,[r7,r2,lsr #7]
  sub r8,r8,#4 ;
  str r8,[r7,r2,lsr #7]
  mov r11,r1
  add r0,r8,#2
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

;
  mov r1,r11,asr #16
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2140:
  str r5,[r7,#0x5c] ;

;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2150:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2158:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#4 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2160:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#4 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#26 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2168:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#28 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2170:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#30 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2178:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#28 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2179:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#32 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op217a:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x88] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#28 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op217b:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x88] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#30 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op217c:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r0,r3,r2,lsl #16
;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2180:
  str r5,[r7,#0x5c] ;

;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2190:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#26 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2198:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#4 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#26 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op21a0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#4 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#28 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op21a8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#30 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op21b0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#32 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op21b8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#30 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op21b9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#34 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op21ba:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x88] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#30 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op21bb:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x88] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#32 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op21bc:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r0,r3,r2,lsl #16
;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#26 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op21c0:
  str r5,[r7,#0x5c] ;

;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op21d0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op21d8:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#4 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op21e0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#4 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#26 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op21e8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#28 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op21f0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#30 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op21f8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#28 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op21f9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#32 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op21fa:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x88] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#28 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op21fb:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x88] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#30 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op21fc:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r0,r3,r2,lsl #16
;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op23c0:
  str r5,[r7,#0x5c] ;

;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op23d0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#28 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op23d8:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#4 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#28 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op23e0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#4 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#30 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op23e8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#32 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op23f0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#34 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op23f8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#32 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op23f9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#36 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op23fa:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x88] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#32 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op23fb:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x88] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#34 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op23fc:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r0,r3,r2,lsl #16
;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#28 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2ec0:
  str r5,[r7,#0x5c] ;

;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#4 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2ed0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#4 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2ed8:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#4 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#4 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2ee0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#4 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#4 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2ee8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#4 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2ef0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#4 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#26 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2ef8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#4 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2ef9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#4 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#28 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2efa:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x88] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#4 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2efb:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x88] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#4 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#26 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2efc:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r0,r3,r2,lsl #16
;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#4 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2f00:
  str r5,[r7,#0x5c] ;

;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r8,[r7,#0x3c] ;
  sub r8,r8,#4 ;
  str r8,[r7,#0x3c] ;
  mov r11,r1
  add r0,r8,#2
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

;
  mov r1,r11,asr #16
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2f10:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r8,[r7,#0x3c] ;
  sub r8,r8,#4 ;
  str r8,[r7,#0x3c] ;
  mov r11,r1
  add r0,r8,#2
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

;
  mov r1,r11,asr #16
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2f18:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#4 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r8,[r7,#0x3c] ;
  sub r8,r8,#4 ;
  str r8,[r7,#0x3c] ;
  mov r11,r1
  add r0,r8,#2
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

;
  mov r1,r11,asr #16
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2f20:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#4 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r8,[r7,#0x3c] ;
  sub r8,r8,#4 ;
  str r8,[r7,#0x3c] ;
  mov r11,r1
  add r0,r8,#2
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

;
  mov r1,r11,asr #16
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2f28:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r8,[r7,#0x3c] ;
  sub r8,r8,#4 ;
  str r8,[r7,#0x3c] ;
  mov r11,r1
  add r0,r8,#2
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

;
  mov r1,r11,asr #16
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2f30:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r8,[r7,#0x3c] ;
  sub r8,r8,#4 ;
  str r8,[r7,#0x3c] ;
  mov r11,r1
  add r0,r8,#2
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

;
  mov r1,r11,asr #16
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#26 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2f38:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r8,[r7,#0x3c] ;
  sub r8,r8,#4 ;
  str r8,[r7,#0x3c] ;
  mov r11,r1
  add r0,r8,#2
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

;
  mov r1,r11,asr #16
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2f39:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r8,[r7,#0x3c] ;
  sub r8,r8,#4 ;
  str r8,[r7,#0x3c] ;
  mov r11,r1
  add r0,r8,#2
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

;
  mov r1,r11,asr #16
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#28 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2f3a:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x88] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r8,[r7,#0x3c] ;
  sub r8,r8,#4 ;
  str r8,[r7,#0x3c] ;
  mov r11,r1
  add r0,r8,#2
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

;
  mov r1,r11,asr #16
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2f3b:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x88] ;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r8,[r7,#0x3c] ;
  sub r8,r8,#4 ;
  str r8,[r7,#0x3c] ;
  mov r11,r1
  add r0,r8,#2
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

;
  mov r1,r11,asr #16
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#26 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op2f3c:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r0,r3,r2,lsl #16
;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r8,[r7,#0x3c] ;
  sub r8,r8,#4 ;
  str r8,[r7,#0x3c] ;
  mov r11,r1
  add r0,r8,#2
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

;
  mov r1,r11,asr #16
  add lr,pc,#4
  mov r0,r8
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3010:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r0,r8,#0x0e00
  mov r0,r0,lsr #7
;
  strh r1,[r7,r0]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3020:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#2 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r0,r8,#0x0e00
  mov r0,r0,lsr #7
;
  strh r1,[r7,r0]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3030:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r0,r8,#0x0e00
  mov r0,r0,lsr #7
;
  strh r1,[r7,r0]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3038:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r0,r8,#0x0e00
  mov r0,r0,lsr #7
;
  strh r1,[r7,r0]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op303a:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r0,r8,#0x0e00
  mov r0,r0,lsr #7
;
  strh r1,[r7,r0]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op303b:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r0,r8,#0x0e00
  mov r0,r0,lsr #7
;
  strh r1,[r7,r0]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op303c:
;
  ldrsh r0,[r4],#2 ;
;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r0,r8,#0x0e00
  mov r0,r0,lsr #7
;
  strh r1,[r7,r0]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3050:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r1,r0,asl #16
  mov r1,r1,asr #16

;
  and r0,r8,#0x1e00
;
  str r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3058:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#2 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r1,r0,asl #16
  mov r1,r1,asr #16

;
  and r0,r8,#0x1e00
;
  str r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3060:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#2 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r1,r0,asl #16
  mov r1,r1,asr #16

;
  and r0,r8,#0x1e00
;
  str r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3068:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r1,r0,asl #16
  mov r1,r1,asr #16

;
  and r0,r8,#0x1e00
;
  str r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3070:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r1,r0,asl #16
  mov r1,r1,asr #16

;
  and r0,r8,#0x1e00
;
  str r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3078:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r1,r0,asl #16
  mov r1,r1,asr #16

;
  and r0,r8,#0x1e00
;
  str r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3079:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r1,r0,asl #16
  mov r1,r1,asr #16

;
  and r0,r8,#0x1e00
;
  str r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op307a:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;
  mov r1,r0,asl #16
  mov r1,r1,asr #16

;
  and r0,r8,#0x1e00
;
  str r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op307b:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;
  mov r1,r0,asl #16
  mov r1,r1,asr #16

;
  and r0,r8,#0x1e00
;
  str r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op307c:
;
  ldrsh r1,[r4],#2 ;
;

;
  and r0,r8,#0x1e00
;
  str r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3090:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3098:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#2 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op30a0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#2 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op30a8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op30b0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op30b8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op30b9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op30ba:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op30bb:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op30bc:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op30d8:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#2 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  add r3,r0,#2 ;
  str r3,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op30e0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#2 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  add r3,r0,#2 ;
  str r3,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op30e8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  add r3,r0,#2 ;
  str r3,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op30f0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  add r3,r0,#2 ;
  str r3,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op30f8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  add r3,r0,#2 ;
  str r3,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op30f9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  add r3,r0,#2 ;
  str r3,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op30fa:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  add r3,r0,#2 ;
  str r3,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op30fb:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  add r3,r0,#2 ;
  str r3,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op30fc:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  add r3,r0,#2 ;
  str r3,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3100:
  str r5,[r7,#0x5c] ;

;
  and r0,r8,#0x000f
  mov r0,r0,lsl #2
;
  ldrsh r0,[r7,r0]

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  sub r0,r0,#2 ;
  str r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3110:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  sub r0,r0,#2 ;
  str r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3118:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#2 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  sub r0,r0,#2 ;
  str r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3120:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#2 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  sub r0,r0,#2 ;
  str r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3128:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  sub r0,r0,#2 ;
  str r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3130:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  sub r0,r0,#2 ;
  str r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3138:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  sub r0,r0,#2 ;
  str r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3139:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  sub r0,r0,#2 ;
  str r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op313a:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  sub r0,r0,#2 ;
  str r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op313b:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  sub r0,r0,#2 ;
  str r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op313c:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  sub r0,r0,#2 ;
  str r0,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3140:
  str r5,[r7,#0x5c] ;

;
  and r0,r8,#0x000f
  mov r0,r0,lsl #2
;
  ldrsh r0,[r7,r0]

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x1e00
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3150:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x1e00
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3158:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#2 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x1e00
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3160:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#2 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x1e00
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3168:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x1e00
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3170:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x1e00
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3178:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x1e00
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3179:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x1e00
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op317a:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x1e00
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op317b:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x1e00
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op317c:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x1e00
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3190:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x1e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3198:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#2 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x1e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op31a0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#2 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x1e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op31a8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x1e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op31b0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x1e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op31b8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x1e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op31b9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x1e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#26 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op31ba:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x1e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op31bb:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x1e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op31bc:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x1e00
  orr r2,r2,#0x1000 ;
  mov r2,r2,lsr #9
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op31c0:
  str r5,[r7,#0x5c] ;

;
  and r0,r8,#0x000f
  mov r0,r0,lsl #2
;
  ldrsh r0,[r7,r0]

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op31d0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op31d8:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#2 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op31e0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#2 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op31e8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op31f0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op31f8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op31f9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op31fa:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op31fb:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op31fc:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op33c0:
  str r5,[r7,#0x5c] ;

;
  and r0,r8,#0x000f
  mov r0,r0,lsl #2
;
  ldrsh r0,[r7,r0]

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op33d0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op33e0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#2 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op33e8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op33f0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#26 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op33f8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op33f9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#28 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op33fa:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op33fb:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#26 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op33fc:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3ec0:
  str r5,[r7,#0x5c] ;

;
  and r0,r8,#0x000f
  mov r0,r0,lsl #2
;
  ldrsh r0,[r7,r0]

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3ed0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3ed8:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#2 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3ee0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#2 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3ee8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3ef0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3ef8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3ef9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3efa:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3efb:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3efc:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3f00:
  str r5,[r7,#0x5c] ;

;
  and r0,r8,#0x000f
  mov r0,r0,lsl #2
;
  ldrsh r0,[r7,r0]

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3f10:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3f18:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#2 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3f20:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#2 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3f28:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3f30:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3f38:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3f39:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3f3a:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3f3b:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op3f3c:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;

  adds r1,r0,#0 ;
  mrs r10,cpsr ;

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r5,[r7,#0x5c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4000:
;
  and r11,r8,#0x000f
;
  ldr r0,[r7,r11,lsl #2]

;
;
  ldr r2,[r7,#0x4c]
  mvn r2,r2 ;
  msr cpsr_flg,r2 ;

  mov r0,r0,asl #24
  rscs r1,r0,#0 ;
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  movs r1,r1,asr #24
  orreq r10,r10,#0x40000000 ;
  andeq r10,r10,r3 ;

;
  strb r1,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4010:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
;
  ldr r2,[r7,#0x4c]
  mvn r2,r2 ;
  msr cpsr_flg,r2 ;

  mov r0,r0,asl #24
  rscs r1,r0,#0 ;
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  movs r1,r1,asr #24
  orreq r10,r10,#0x40000000 ;
  andeq r10,r10,r3 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4018:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#1 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
;
  ldr r2,[r7,#0x4c]
  mvn r2,r2 ;
  msr cpsr_flg,r2 ;

  mov r0,r0,asl #24
  rscs r1,r0,#0 ;
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  movs r1,r1,asr #24
  orreq r10,r10,#0x40000000 ;
  andeq r10,r10,r3 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op401f:
  str r5,[r7,#0x5c] ;

;
  ldr r11,[r7,#0x3c] ;
  add r3,r11,#2 ;
  str r3,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
;
  ldr r2,[r7,#0x4c]
  mvn r2,r2 ;
  msr cpsr_flg,r2 ;

  mov r0,r0,asl #24
  rscs r1,r0,#0 ;
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  movs r1,r1,asr #24
  orreq r10,r10,#0x40000000 ;
  andeq r10,r10,r3 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4020:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#1 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
;
  ldr r2,[r7,#0x4c]
  mvn r2,r2 ;
  msr cpsr_flg,r2 ;

  mov r0,r0,asl #24
  rscs r1,r0,#0 ;
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  movs r1,r1,asr #24
  orreq r10,r10,#0x40000000 ;
  andeq r10,r10,r3 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4027:
  str r5,[r7,#0x5c] ;

;
  ldr r11,[r7,#0x3c] ;
  sub r11,r11,#2 ;
  str r11,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
;
  ldr r2,[r7,#0x4c]
  mvn r2,r2 ;
  msr cpsr_flg,r2 ;

  mov r0,r0,asl #24
  rscs r1,r0,#0 ;
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  movs r1,r1,asr #24
  orreq r10,r10,#0x40000000 ;
  andeq r10,r10,r3 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4028:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
;
  ldr r2,[r7,#0x4c]
  mvn r2,r2 ;
  msr cpsr_flg,r2 ;

  mov r0,r0,asl #24
  rscs r1,r0,#0 ;
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  movs r1,r1,asr #24
  orreq r10,r10,#0x40000000 ;
  andeq r10,r10,r3 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4030:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
;
  ldr r2,[r7,#0x4c]
  mvn r2,r2 ;
  msr cpsr_flg,r2 ;

  mov r0,r0,asl #24
  rscs r1,r0,#0 ;
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  movs r1,r1,asr #24
  orreq r10,r10,#0x40000000 ;
  andeq r10,r10,r3 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4038:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
;
  ldr r2,[r7,#0x4c]
  mvn r2,r2 ;
  msr cpsr_flg,r2 ;

  mov r0,r0,asl #24
  rscs r1,r0,#0 ;
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  movs r1,r1,asr #24
  orreq r10,r10,#0x40000000 ;
  andeq r10,r10,r3 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4039:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
;
  ldr r2,[r7,#0x4c]
  mvn r2,r2 ;
  msr cpsr_flg,r2 ;

  mov r0,r0,asl #24
  rscs r1,r0,#0 ;
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  movs r1,r1,asr #24
  orreq r10,r10,#0x40000000 ;
  andeq r10,r10,r3 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4040:
;
  and r11,r8,#0x000f
  mov r11,r11,lsl #2
;
  ldr r0,[r7,r11]

;
;
  ldr r2,[r7,#0x4c]
  mvn r2,r2 ;
  msr cpsr_flg,r2 ;

  mov r0,r0,asl #16
  rscs r1,r0,#0 ;
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  movs r1,r1,asr #16
  orreq r10,r10,#0x40000000 ;
  andeq r10,r10,r3 ;

;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4050:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
;
  ldr r2,[r7,#0x4c]
  mvn r2,r2 ;
  msr cpsr_flg,r2 ;

  mov r0,r0,asl #16
  rscs r1,r0,#0 ;
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  movs r1,r1,asr #16
  orreq r10,r10,#0x40000000 ;
  andeq r10,r10,r3 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4058:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#2 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
;
  ldr r2,[r7,#0x4c]
  mvn r2,r2 ;
  msr cpsr_flg,r2 ;

  mov r0,r0,asl #16
  rscs r1,r0,#0 ;
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  movs r1,r1,asr #16
  orreq r10,r10,#0x40000000 ;
  andeq r10,r10,r3 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4060:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#2 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
;
  ldr r2,[r7,#0x4c]
  mvn r2,r2 ;
  msr cpsr_flg,r2 ;

  mov r0,r0,asl #16
  rscs r1,r0,#0 ;
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  movs r1,r1,asr #16
  orreq r10,r10,#0x40000000 ;
  andeq r10,r10,r3 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4068:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
;
  ldr r2,[r7,#0x4c]
  mvn r2,r2 ;
  msr cpsr_flg,r2 ;

  mov r0,r0,asl #16
  rscs r1,r0,#0 ;
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  movs r1,r1,asr #16
  orreq r10,r10,#0x40000000 ;
  andeq r10,r10,r3 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4070:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
;
  ldr r2,[r7,#0x4c]
  mvn r2,r2 ;
  msr cpsr_flg,r2 ;

  mov r0,r0,asl #16
  rscs r1,r0,#0 ;
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  movs r1,r1,asr #16
  orreq r10,r10,#0x40000000 ;
  andeq r10,r10,r3 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4078:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
;
  ldr r2,[r7,#0x4c]
  mvn r2,r2 ;
  msr cpsr_flg,r2 ;

  mov r0,r0,asl #16
  rscs r1,r0,#0 ;
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  movs r1,r1,asr #16
  orreq r10,r10,#0x40000000 ;
  andeq r10,r10,r3 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4079:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
;
  ldr r2,[r7,#0x4c]
  mvn r2,r2 ;
  msr cpsr_flg,r2 ;

  mov r0,r0,asl #16
  rscs r1,r0,#0 ;
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  movs r1,r1,asr #16
  orreq r10,r10,#0x40000000 ;
  andeq r10,r10,r3 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4080:
;
  and r11,r8,#0x000f
;
  ldr r0,[r7,r11,lsl #2]

;
;
  ldr r2,[r7,#0x4c]
  mvn r2,r2 ;
  msr cpsr_flg,r2 ;

  rscs r1,r0,#0 ;
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  andeq r10,r10,r3 ;

;
  str r1,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4090:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
;
  ldr r2,[r7,#0x4c]
  mvn r2,r2 ;
  msr cpsr_flg,r2 ;

  rscs r1,r0,#0 ;
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  andeq r10,r10,r3 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4098:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#4 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
;
  ldr r2,[r7,#0x4c]
  mvn r2,r2 ;
  msr cpsr_flg,r2 ;

  rscs r1,r0,#0 ;
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  andeq r10,r10,r3 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op40a0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#4 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
;
  ldr r2,[r7,#0x4c]
  mvn r2,r2 ;
  msr cpsr_flg,r2 ;

  rscs r1,r0,#0 ;
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  andeq r10,r10,r3 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op40a8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
;
  ldr r2,[r7,#0x4c]
  mvn r2,r2 ;
  msr cpsr_flg,r2 ;

  rscs r1,r0,#0 ;
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  andeq r10,r10,r3 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op40b0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
;
  ldr r2,[r7,#0x4c]
  mvn r2,r2 ;
  msr cpsr_flg,r2 ;

  rscs r1,r0,#0 ;
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  andeq r10,r10,r3 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#26 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op40b8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
;
  ldr r2,[r7,#0x4c]
  mvn r2,r2 ;
  msr cpsr_flg,r2 ;

  rscs r1,r0,#0 ;
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  andeq r10,r10,r3 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op40b9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
;
  ldr r2,[r7,#0x4c]
  mvn r2,r2 ;
  msr cpsr_flg,r2 ;

  rscs r1,r0,#0 ;
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  andeq r10,r10,r3 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#28 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op40c0:
  ldr r0,[r7,#0x4c] ;
  mov r1,r10,lsr #28 ;
  eor r2,r1,r1,ror #1 ;
  tst r2,#1 ;
  eorne r1,r1,#3 ;

  ldrb r2,[r7,#0x44] ;
  and r0,r0,#0x20000000
  orr r1,r1,r0,lsr #25 ;
  orr r1,r1,r2,lsl #8

;
  and r0,r8,#0x000f
  mov r0,r0,lsl #2
;
  strh r1,[r7,r0]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op40d0:
  str r5,[r7,#0x5c] ;

  ldr r0,[r7,#0x4c] ;
  mov r1,r10,lsr #28 ;
  eor r2,r1,r1,ror #1 ;
  tst r2,#1 ;
  eorne r1,r1,#3 ;

  ldrb r2,[r7,#0x44] ;
  and r0,r0,#0x20000000
  orr r1,r1,r0,lsr #25 ;
  orr r1,r1,r2,lsl #8

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op40d8:
  str r5,[r7,#0x5c] ;

  ldr r0,[r7,#0x4c] ;
  mov r1,r10,lsr #28 ;
  eor r2,r1,r1,ror #1 ;
  tst r2,#1 ;
  eorne r1,r1,#3 ;

  ldrb r2,[r7,#0x44] ;
  and r0,r0,#0x20000000
  orr r1,r1,r0,lsr #25 ;
  orr r1,r1,r2,lsl #8

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#2 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op40e0:
  str r5,[r7,#0x5c] ;

  ldr r0,[r7,#0x4c] ;
  mov r1,r10,lsr #28 ;
  eor r2,r1,r1,ror #1 ;
  tst r2,#1 ;
  eorne r1,r1,#3 ;

  ldrb r2,[r7,#0x44] ;
  and r0,r0,#0x20000000
  orr r1,r1,r0,lsr #25 ;
  orr r1,r1,r2,lsl #8

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#2 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op40e8:
  str r5,[r7,#0x5c] ;

  ldr r0,[r7,#0x4c] ;
  mov r1,r10,lsr #28 ;
  eor r2,r1,r1,ror #1 ;
  tst r2,#1 ;
  eorne r1,r1,#3 ;

  ldrb r2,[r7,#0x44] ;
  and r0,r0,#0x20000000
  orr r1,r1,r0,lsr #25 ;
  orr r1,r1,r2,lsl #8

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op40f0:
  str r5,[r7,#0x5c] ;

  ldr r0,[r7,#0x4c] ;
  mov r1,r10,lsr #28 ;
  eor r2,r1,r1,ror #1 ;
  tst r2,#1 ;
  eorne r1,r1,#3 ;

  ldrb r2,[r7,#0x44] ;
  and r0,r0,#0x20000000
  orr r1,r1,r0,lsr #25 ;
  orr r1,r1,r2,lsl #8

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op40f8:
  str r5,[r7,#0x5c] ;

  ldr r0,[r7,#0x4c] ;
  mov r1,r10,lsr #28 ;
  eor r2,r1,r1,ror #1 ;
  tst r2,#1 ;
  eorne r1,r1,#3 ;

  ldrb r2,[r7,#0x44] ;
  and r0,r0,#0x20000000
  orr r1,r1,r0,lsr #25 ;
  orr r1,r1,r2,lsl #8

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op40f9:
  str r5,[r7,#0x5c] ;

  ldr r0,[r7,#0x4c] ;
  mov r1,r10,lsr #28 ;
  eor r2,r1,r1,ror #1 ;
  tst r2,#1 ;
  eorne r1,r1,#3 ;

  ldrb r2,[r7,#0x44] ;
  and r0,r0,#0x20000000
  orr r1,r1,r0,lsr #25 ;
  orr r1,r1,r2,lsl #8

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4180:
;
;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #16
  mov r1,r1,asl #16

;
  and r3,r10,#0x80000000
  adds r1,r1,#0 ;
  mrs r10,cpsr ;
;
  bmi chktrap4180
;
  bic r10,r10,#0x80000000 ;
  cmp r1,r0
  bgt chktrap4180
;
  orr r10,r10,r3
  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

chktrap4180: ;
  mov r0,#6
  bl Exception
  ldrh r8,[r4],#2 ;
  subs r5,r5,#50 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4190:
  str r5,[r7,#0x5c] ;

;
;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #16
  mov r1,r1,asl #16

;
  and r3,r10,#0x80000000
  adds r1,r1,#0 ;
  mrs r10,cpsr ;
;
  bmi chktrap4190
;
  bic r10,r10,#0x80000000 ;
  cmp r1,r0
  bgt chktrap4190
;
  orr r10,r10,r3
  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

chktrap4190: ;
  mov r0,#6
  bl Exception
  ldrh r8,[r4],#2 ;
  subs r5,r5,#54 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4198:
  str r5,[r7,#0x5c] ;

;
;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#2 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #16
  mov r1,r1,asl #16

;
  and r3,r10,#0x80000000
  adds r1,r1,#0 ;
  mrs r10,cpsr ;
;
  bmi chktrap4198
;
  bic r10,r10,#0x80000000 ;
  cmp r1,r0
  bgt chktrap4198
;
  orr r10,r10,r3
  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

chktrap4198: ;
  mov r0,#6
  bl Exception
  ldrh r8,[r4],#2 ;
  subs r5,r5,#54 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op41a0:
  str r5,[r7,#0x5c] ;

;
;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#2 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #16
  mov r1,r1,asl #16

;
  and r3,r10,#0x80000000
  adds r1,r1,#0 ;
  mrs r10,cpsr ;
;
  bmi chktrap41a0
;
  bic r10,r10,#0x80000000 ;
  cmp r1,r0
  bgt chktrap41a0
;
  orr r10,r10,r3
  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

chktrap41a0: ;
  mov r0,#6
  bl Exception
  ldrh r8,[r4],#2 ;
  subs r5,r5,#56 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op41a8:
  str r5,[r7,#0x5c] ;

;
;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #16
  mov r1,r1,asl #16

;
  and r3,r10,#0x80000000
  adds r1,r1,#0 ;
  mrs r10,cpsr ;
;
  bmi chktrap41a8
;
  bic r10,r10,#0x80000000 ;
  cmp r1,r0
  bgt chktrap41a8
;
  orr r10,r10,r3
  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

chktrap41a8: ;
  mov r0,#6
  bl Exception
  ldrh r8,[r4],#2 ;
  subs r5,r5,#58 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op41b0:
  str r5,[r7,#0x5c] ;

;
;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #16
  mov r1,r1,asl #16

;
  and r3,r10,#0x80000000
  adds r1,r1,#0 ;
  mrs r10,cpsr ;
;
  bmi chktrap41b0
;
  bic r10,r10,#0x80000000 ;
  cmp r1,r0
  bgt chktrap41b0
;
  orr r10,r10,r3
  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

chktrap41b0: ;
  mov r0,#6
  bl Exception
  ldrh r8,[r4],#2 ;
  subs r5,r5,#60 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op41b8:
  str r5,[r7,#0x5c] ;

;
;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #16
  mov r1,r1,asl #16

;
  and r3,r10,#0x80000000
  adds r1,r1,#0 ;
  mrs r10,cpsr ;
;
  bmi chktrap41b8
;
  bic r10,r10,#0x80000000 ;
  cmp r1,r0
  bgt chktrap41b8
;
  orr r10,r10,r3
  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

chktrap41b8: ;
  mov r0,#6
  bl Exception
  ldrh r8,[r4],#2 ;
  subs r5,r5,#58 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op41b9:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #16
  mov r1,r1,asl #16

;
  and r3,r10,#0x80000000
  adds r1,r1,#0 ;
  mrs r10,cpsr ;
;
  bmi chktrap41b9
;
  bic r10,r10,#0x80000000 ;
  cmp r1,r0
  bgt chktrap41b9
;
  orr r10,r10,r3
  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

chktrap41b9: ;
  mov r0,#6
  bl Exception
  ldrh r8,[r4],#2 ;
  subs r5,r5,#62 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op41ba:
  str r5,[r7,#0x5c] ;

;
;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #16
  mov r1,r1,asl #16

;
  and r3,r10,#0x80000000
  adds r1,r1,#0 ;
  mrs r10,cpsr ;
;
  bmi chktrap41ba
;
  bic r10,r10,#0x80000000 ;
  cmp r1,r0
  bgt chktrap41ba
;
  orr r10,r10,r3
  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

chktrap41ba: ;
  mov r0,#6
  bl Exception
  ldrh r8,[r4],#2 ;
  subs r5,r5,#58 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op41bb:
  str r5,[r7,#0x5c] ;

;
;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #16
  mov r1,r1,asl #16

;
  and r3,r10,#0x80000000
  adds r1,r1,#0 ;
  mrs r10,cpsr ;
;
  bmi chktrap41bb
;
  bic r10,r10,#0x80000000 ;
  cmp r1,r0
  bgt chktrap41bb
;
  orr r10,r10,r3
  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

chktrap41bb: ;
  mov r0,#6
  bl Exception
  ldrh r8,[r4],#2 ;
  subs r5,r5,#60 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op41bc:
;
;
  ldrsh r0,[r4],#2 ;
;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #16
  mov r1,r1,asl #16

;
  and r3,r10,#0x80000000
  adds r1,r1,#0 ;
  mrs r10,cpsr ;
;
  bmi chktrap41bc
;
  bic r10,r10,#0x80000000 ;
  cmp r1,r0
  bgt chktrap41bc
;
  orr r10,r10,r3
  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

chktrap41bc: ;
  mov r0,#6
  bl Exception
  ldrh r8,[r4],#2 ;
  subs r5,r5,#54 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op41d0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r1,[r7,r2,lsl #2]
;
  and r0,r8,#0x0e00
  orr r0,r0,#0x1000 ;
;
  str r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op41e8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r1,r0,r2 ;
;
  and r0,r8,#0x0e00
  orr r0,r0,#0x1000 ;
;
  str r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op41f8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r1,[r4],#2 ;
;
  and r0,r8,#0x0e00
  orr r0,r0,#0x1000 ;
;
  str r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op41f9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r1,r0,r2,lsl #16
;
  and r0,r8,#0x0e00
  orr r0,r0,#0x1000 ;
;
  str r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op41fa:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r1,r2,r0,asr #8 ;
;
  and r0,r8,#0x0e00
  orr r0,r0,#0x1000 ;
;
  str r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op41fb:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r1,r2,r0,asr #8 ;
;
  and r0,r8,#0x0e00
  orr r0,r0,#0x1000 ;
;
  str r1,[r7,r0,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4200:
;
  and r11,r8,#0x000f

;
  mov r1,#0
  mov r10,#0x40000000 ;

;
  strb r1,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4210:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]

;
  mov r1,#0
  mov r10,#0x40000000 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4218:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#1 ;
  str r3,[r7,r2,lsl #2]

;
  mov r1,#0
  mov r10,#0x40000000 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op421f:
  str r5,[r7,#0x5c] ;

;
  ldr r11,[r7,#0x3c] ;
  add r3,r11,#2 ;
  str r3,[r7,#0x3c] ;

;
  mov r1,#0
  mov r10,#0x40000000 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4220:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#1 ;
  str r11,[r7,r2,lsl #2]

;
  mov r1,#0
  mov r10,#0x40000000 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4227:
  str r5,[r7,#0x5c] ;

;
  ldr r11,[r7,#0x3c] ;
  sub r11,r11,#2 ;
  str r11,[r7,#0x3c] ;

;
  mov r1,#0
  mov r10,#0x40000000 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4228:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;

;
  mov r1,#0
  mov r10,#0x40000000 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4230:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;

;
  mov r1,#0
  mov r10,#0x40000000 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4238:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;

;
  mov r1,#0
  mov r10,#0x40000000 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4239:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16

;
  mov r1,#0
  mov r10,#0x40000000 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4240:
;
  and r11,r8,#0x000f
  mov r11,r11,lsl #2

;
  mov r1,#0
  mov r10,#0x40000000 ;

;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4250:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]

;
  mov r1,#0
  mov r10,#0x40000000 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4258:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#2 ;
  str r3,[r7,r2,lsl #2]

;
  mov r1,#0
  mov r10,#0x40000000 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4260:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#2 ;
  str r11,[r7,r2,lsl #2]

;
  mov r1,#0
  mov r10,#0x40000000 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4268:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;

;
  mov r1,#0
  mov r10,#0x40000000 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4270:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;

;
  mov r1,#0
  mov r10,#0x40000000 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4278:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;

;
  mov r1,#0
  mov r10,#0x40000000 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4279:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16

;
  mov r1,#0
  mov r10,#0x40000000 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4280:
;
  and r11,r8,#0x000f

;
  mov r1,#0
  mov r10,#0x40000000 ;

;
  str r1,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4290:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]

;
  mov r1,#0
  mov r10,#0x40000000 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4298:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#4 ;
  str r3,[r7,r2,lsl #2]

;
  mov r1,#0
  mov r10,#0x40000000 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op42a0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#4 ;
  str r11,[r7,r2,lsl #2]

;
  mov r1,#0
  mov r10,#0x40000000 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op42a8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;

;
  mov r1,#0
  mov r10,#0x40000000 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op42b0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;

;
  mov r1,#0
  mov r10,#0x40000000 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#26 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op42b8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;

;
  mov r1,#0
  mov r10,#0x40000000 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op42b9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16

;
  mov r1,#0
  mov r10,#0x40000000 ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#28 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4400:
;
  and r11,r8,#0x000f
;
  ldr r0,[r7,r11,lsl #2]

;
  mov r0,r0,asl #24
  rsbs r1,r0,#0
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  mov r1,r1,asr #24

;
  strb r1,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4410:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  mov r0,r0,asl #24
  rsbs r1,r0,#0
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  mov r1,r1,asr #24

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4418:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#1 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  mov r0,r0,asl #24
  rsbs r1,r0,#0
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  mov r1,r1,asr #24

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op441f:
  str r5,[r7,#0x5c] ;

;
  ldr r11,[r7,#0x3c] ;
  add r3,r11,#2 ;
  str r3,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  mov r0,r0,asl #24
  rsbs r1,r0,#0
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  mov r1,r1,asr #24

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4420:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#1 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  mov r0,r0,asl #24
  rsbs r1,r0,#0
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  mov r1,r1,asr #24

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4427:
  str r5,[r7,#0x5c] ;

;
  ldr r11,[r7,#0x3c] ;
  sub r11,r11,#2 ;
  str r11,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  mov r0,r0,asl #24
  rsbs r1,r0,#0
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  mov r1,r1,asr #24

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4428:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  mov r0,r0,asl #24
  rsbs r1,r0,#0
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  mov r1,r1,asr #24

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4430:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  mov r0,r0,asl #24
  rsbs r1,r0,#0
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  mov r1,r1,asr #24

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4438:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  mov r0,r0,asl #24
  rsbs r1,r0,#0
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  mov r1,r1,asr #24

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4439:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  mov r0,r0,asl #24
  rsbs r1,r0,#0
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  mov r1,r1,asr #24

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4440:
;
  and r11,r8,#0x000f
  mov r11,r11,lsl #2
;
  ldr r0,[r7,r11]

;
  mov r0,r0,asl #16
  rsbs r1,r0,#0
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  mov r1,r1,asr #16

;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4450:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
  mov r0,r0,asl #16
  rsbs r1,r0,#0
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  mov r1,r1,asr #16

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4458:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#2 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
  mov r0,r0,asl #16
  rsbs r1,r0,#0
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  mov r1,r1,asr #16

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4460:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#2 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
  mov r0,r0,asl #16
  rsbs r1,r0,#0
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  mov r1,r1,asr #16

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4468:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
  mov r0,r0,asl #16
  rsbs r1,r0,#0
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  mov r1,r1,asr #16

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4470:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
  mov r0,r0,asl #16
  rsbs r1,r0,#0
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  mov r1,r1,asr #16

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4478:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
  mov r0,r0,asl #16
  rsbs r1,r0,#0
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  mov r1,r1,asr #16

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4479:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
  mov r0,r0,asl #16
  rsbs r1,r0,#0
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  mov r1,r1,asr #16

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4480:
;
  and r11,r8,#0x000f
;
  ldr r0,[r7,r11,lsl #2]

;
  rsbs r1,r0,#0
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  str r1,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4490:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  rsbs r1,r0,#0
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4498:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#4 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  rsbs r1,r0,#0
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op44a0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#4 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  rsbs r1,r0,#0
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op44a8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  rsbs r1,r0,#0
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op44b0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  rsbs r1,r0,#0
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#26 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op44b8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  rsbs r1,r0,#0
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op44b9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  rsbs r1,r0,#0
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#28 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op44c0:
;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

  eor r1,r0,r0,ror #1 ;
  mov r2,r0,lsl #25
  tst r1,#1 ;
  eorne r0,r0,#3 ;
  str r2,[r7,#0x4c] ;
  mov r10,r0,lsl #28 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op44d0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

  eor r1,r0,r0,ror #1 ;
  mov r2,r0,lsl #25
  tst r1,#1 ;
  eorne r0,r0,#3 ;
  str r2,[r7,#0x4c] ;
  mov r10,r0,lsl #28 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op44d8:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#2 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

  eor r1,r0,r0,ror #1 ;
  mov r2,r0,lsl #25
  tst r1,#1 ;
  eorne r0,r0,#3 ;
  str r2,[r7,#0x4c] ;
  mov r10,r0,lsl #28 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op44e0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#2 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

  eor r1,r0,r0,ror #1 ;
  mov r2,r0,lsl #25
  tst r1,#1 ;
  eorne r0,r0,#3 ;
  str r2,[r7,#0x4c] ;
  mov r10,r0,lsl #28 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op44e8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

  eor r1,r0,r0,ror #1 ;
  mov r2,r0,lsl #25
  tst r1,#1 ;
  eorne r0,r0,#3 ;
  str r2,[r7,#0x4c] ;
  mov r10,r0,lsl #28 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op44f0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

  eor r1,r0,r0,ror #1 ;
  mov r2,r0,lsl #25
  tst r1,#1 ;
  eorne r0,r0,#3 ;
  str r2,[r7,#0x4c] ;
  mov r10,r0,lsl #28 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op44f8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

  eor r1,r0,r0,ror #1 ;
  mov r2,r0,lsl #25
  tst r1,#1 ;
  eorne r0,r0,#3 ;
  str r2,[r7,#0x4c] ;
  mov r10,r0,lsl #28 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op44f9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

  eor r1,r0,r0,ror #1 ;
  mov r2,r0,lsl #25
  tst r1,#1 ;
  eorne r0,r0,#3 ;
  str r2,[r7,#0x4c] ;
  mov r10,r0,lsl #28 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op44fa:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;

  eor r1,r0,r0,ror #1 ;
  mov r2,r0,lsl #25
  tst r1,#1 ;
  eorne r0,r0,#3 ;
  str r2,[r7,#0x4c] ;
  mov r10,r0,lsl #28 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op44fb:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;

  eor r1,r0,r0,ror #1 ;
  mov r2,r0,lsl #25
  tst r1,#1 ;
  eorne r0,r0,#3 ;
  str r2,[r7,#0x4c] ;
  mov r10,r0,lsl #28 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op44fc:
;
  ldrsh r0,[r4],#2 ;
;

  eor r1,r0,r0,ror #1 ;
  mov r2,r0,lsl #25
  tst r1,#1 ;
  eorne r0,r0,#3 ;
  str r2,[r7,#0x4c] ;
  mov r10,r0,lsl #28 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4600:
;
  and r11,r8,#0x000f
;
  ldr r0,[r7,r11,lsl #2]

;
  mov r0,r0,asl #24
  mvn r1,r0,asr #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  strb r1,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4610:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  mov r0,r0,asl #24
  mvn r1,r0,asr #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4618:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#1 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  mov r0,r0,asl #24
  mvn r1,r0,asr #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op461f:
  str r5,[r7,#0x5c] ;

;
  ldr r11,[r7,#0x3c] ;
  add r3,r11,#2 ;
  str r3,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  mov r0,r0,asl #24
  mvn r1,r0,asr #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4620:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#1 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  mov r0,r0,asl #24
  mvn r1,r0,asr #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4627:
  str r5,[r7,#0x5c] ;

;
  ldr r11,[r7,#0x3c] ;
  sub r11,r11,#2 ;
  str r11,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  mov r0,r0,asl #24
  mvn r1,r0,asr #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4628:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  mov r0,r0,asl #24
  mvn r1,r0,asr #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4630:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  mov r0,r0,asl #24
  mvn r1,r0,asr #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4638:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  mov r0,r0,asl #24
  mvn r1,r0,asr #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4639:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  mov r0,r0,asl #24
  mvn r1,r0,asr #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4640:
;
  and r11,r8,#0x000f
  mov r11,r11,lsl #2
;
  ldr r0,[r7,r11]

;
  mov r0,r0,asl #16
  mvn r1,r0,asr #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4650:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
  mov r0,r0,asl #16
  mvn r1,r0,asr #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4658:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#2 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
  mov r0,r0,asl #16
  mvn r1,r0,asr #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4660:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#2 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
  mov r0,r0,asl #16
  mvn r1,r0,asr #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4668:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
  mov r0,r0,asl #16
  mvn r1,r0,asr #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4670:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
  mov r0,r0,asl #16
  mvn r1,r0,asr #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4678:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
  mov r0,r0,asl #16
  mvn r1,r0,asr #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4679:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
  mov r0,r0,asl #16
  mvn r1,r0,asr #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4680:
;
  and r11,r8,#0x000f
;
  ldr r0,[r7,r11,lsl #2]

;
  mvn r1,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  str r1,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4690:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  mvn r1,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4698:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#4 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  mvn r1,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op46a0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#4 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  mvn r1,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op46a8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  mvn r1,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op46b0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  mvn r1,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#26 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op46b8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  mvn r1,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op46b9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  mvn r1,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#28 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op46c0:
  ldr r11,[r7,#0x44] ;
  tst r11,#0x20 ;
  beq WrongPrivilegeMode ;

;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

  eor r1,r0,r0,ror #1 ;
  mov r2,r0,lsl #25
  tst r1,#1 ;
  eorne r0,r0,#3 ;
  str r2,[r7,#0x4c] ;
  mov r10,r0,lsl #28 ;
  mov r1,r0,ror #8
  and r1,r1,#0xa7 ;
  strb r1,[r7,#0x44] ;

;
  eor r0,r1,r11
  tst r0,#0x20
  beq no_sp_swap46c0
 ;
  ldr r11,[r7,#0x3C] ;
  ldr r0, [r7,#0x48] ;
  str r11,[r7,#0x48]
  str r0, [r7,#0x3C]
no_sp_swap46c0:
  ldrh r8,[r4],#2 ;
  ldr r1,[r7,#0x44]
  subs r5,r5,#12 ;
;
  tst r1,#0x80
  bne CycloneDoTraceWithChecks
  cmp r5,#0
  blt CycloneEnd
;
  movs r0,r1,lsr #24 ;
  ldreq pc,[r6,r8,asl #2] ;
  cmp r0,#6 ;
  andle r1,r1,#7 ;
  cmple r0,r1 ;
  ldrle pc,[r6,r8,asl #2] ;
  b CycloneDoInterruptGoBack

;
Op46d0:
  ldr r11,[r7,#0x44] ;
  str r5,[r7,#0x5c] ;
  tst r11,#0x20 ;
  beq WrongPrivilegeMode ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

  eor r1,r0,r0,ror #1 ;
  mov r2,r0,lsl #25
  tst r1,#1 ;
  eorne r0,r0,#3 ;
  str r2,[r7,#0x4c] ;
  mov r10,r0,lsl #28 ;
  mov r1,r0,ror #8
  and r1,r1,#0xa7 ;
  strb r1,[r7,#0x44] ;

;
  eor r0,r1,r11
  tst r0,#0x20
  beq no_sp_swap46d0
 ;
  ldr r11,[r7,#0x3C] ;
  ldr r0, [r7,#0x48] ;
  str r11,[r7,#0x48]
  str r0, [r7,#0x3C]
no_sp_swap46d0:
  ldrh r8,[r4],#2 ;
  ldr r1,[r7,#0x44]
  subs r5,r5,#16 ;
;
  tst r1,#0x80
  bne CycloneDoTraceWithChecks
  cmp r5,#0
  blt CycloneEnd
;
  movs r0,r1,lsr #24 ;
  ldreq pc,[r6,r8,asl #2] ;
  cmp r0,#6 ;
  andle r1,r1,#7 ;
  cmple r0,r1 ;
  ldrle pc,[r6,r8,asl #2] ;
  b CycloneDoInterruptGoBack

;
Op46d8:
  ldr r11,[r7,#0x44] ;
  str r5,[r7,#0x5c] ;
  tst r11,#0x20 ;
  beq WrongPrivilegeMode ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#2 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

  eor r1,r0,r0,ror #1 ;
  mov r2,r0,lsl #25
  tst r1,#1 ;
  eorne r0,r0,#3 ;
  str r2,[r7,#0x4c] ;
  mov r10,r0,lsl #28 ;
  mov r1,r0,ror #8
  and r1,r1,#0xa7 ;
  strb r1,[r7,#0x44] ;

;
  eor r0,r1,r11
  tst r0,#0x20
  beq no_sp_swap46d8
 ;
  ldr r11,[r7,#0x3C] ;
  ldr r0, [r7,#0x48] ;
  str r11,[r7,#0x48]
  str r0, [r7,#0x3C]
no_sp_swap46d8:
  ldrh r8,[r4],#2 ;
  ldr r1,[r7,#0x44]
  subs r5,r5,#16 ;
;
  tst r1,#0x80
  bne CycloneDoTraceWithChecks
  cmp r5,#0
  blt CycloneEnd
;
  movs r0,r1,lsr #24 ;
  ldreq pc,[r6,r8,asl #2] ;
  cmp r0,#6 ;
  andle r1,r1,#7 ;
  cmple r0,r1 ;
  ldrle pc,[r6,r8,asl #2] ;
  b CycloneDoInterruptGoBack

;
Op46e0:
  ldr r11,[r7,#0x44] ;
  str r5,[r7,#0x5c] ;
  tst r11,#0x20 ;
  beq WrongPrivilegeMode ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#2 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

  eor r1,r0,r0,ror #1 ;
  mov r2,r0,lsl #25
  tst r1,#1 ;
  eorne r0,r0,#3 ;
  str r2,[r7,#0x4c] ;
  mov r10,r0,lsl #28 ;
  mov r1,r0,ror #8
  and r1,r1,#0xa7 ;
  strb r1,[r7,#0x44] ;

;
  eor r0,r1,r11
  tst r0,#0x20
  beq no_sp_swap46e0
 ;
  ldr r11,[r7,#0x3C] ;
  ldr r0, [r7,#0x48] ;
  str r11,[r7,#0x48]
  str r0, [r7,#0x3C]
no_sp_swap46e0:
  ldrh r8,[r4],#2 ;
  ldr r1,[r7,#0x44]
  subs r5,r5,#18 ;
;
  tst r1,#0x80
  bne CycloneDoTraceWithChecks
  cmp r5,#0
  blt CycloneEnd
;
  movs r0,r1,lsr #24 ;
  ldreq pc,[r6,r8,asl #2] ;
  cmp r0,#6 ;
  andle r1,r1,#7 ;
  cmple r0,r1 ;
  ldrle pc,[r6,r8,asl #2] ;
  b CycloneDoInterruptGoBack

;
Op46e8:
  ldr r11,[r7,#0x44] ;
  str r5,[r7,#0x5c] ;
  tst r11,#0x20 ;
  beq WrongPrivilegeMode ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

  eor r1,r0,r0,ror #1 ;
  mov r2,r0,lsl #25
  tst r1,#1 ;
  eorne r0,r0,#3 ;
  str r2,[r7,#0x4c] ;
  mov r10,r0,lsl #28 ;
  mov r1,r0,ror #8
  and r1,r1,#0xa7 ;
  strb r1,[r7,#0x44] ;

;
  eor r0,r1,r11
  tst r0,#0x20
  beq no_sp_swap46e8
 ;
  ldr r11,[r7,#0x3C] ;
  ldr r0, [r7,#0x48] ;
  str r11,[r7,#0x48]
  str r0, [r7,#0x3C]
no_sp_swap46e8:
  ldrh r8,[r4],#2 ;
  ldr r1,[r7,#0x44]
  subs r5,r5,#20 ;
;
  tst r1,#0x80
  bne CycloneDoTraceWithChecks
  cmp r5,#0
  blt CycloneEnd
;
  movs r0,r1,lsr #24 ;
  ldreq pc,[r6,r8,asl #2] ;
  cmp r0,#6 ;
  andle r1,r1,#7 ;
  cmple r0,r1 ;
  ldrle pc,[r6,r8,asl #2] ;
  b CycloneDoInterruptGoBack

;
Op46f0:
  ldr r11,[r7,#0x44] ;
  str r5,[r7,#0x5c] ;
  tst r11,#0x20 ;
  beq WrongPrivilegeMode ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

  eor r1,r0,r0,ror #1 ;
  mov r2,r0,lsl #25
  tst r1,#1 ;
  eorne r0,r0,#3 ;
  str r2,[r7,#0x4c] ;
  mov r10,r0,lsl #28 ;
  mov r1,r0,ror #8
  and r1,r1,#0xa7 ;
  strb r1,[r7,#0x44] ;

;
  eor r0,r1,r11
  tst r0,#0x20
  beq no_sp_swap46f0
 ;
  ldr r11,[r7,#0x3C] ;
  ldr r0, [r7,#0x48] ;
  str r11,[r7,#0x48]
  str r0, [r7,#0x3C]
no_sp_swap46f0:
  ldrh r8,[r4],#2 ;
  ldr r1,[r7,#0x44]
  subs r5,r5,#22 ;
;
  tst r1,#0x80
  bne CycloneDoTraceWithChecks
  cmp r5,#0
  blt CycloneEnd
;
  movs r0,r1,lsr #24 ;
  ldreq pc,[r6,r8,asl #2] ;
  cmp r0,#6 ;
  andle r1,r1,#7 ;
  cmple r0,r1 ;
  ldrle pc,[r6,r8,asl #2] ;
  b CycloneDoInterruptGoBack

;
Op46f8:
  ldr r11,[r7,#0x44] ;
  str r5,[r7,#0x5c] ;
  tst r11,#0x20 ;
  beq WrongPrivilegeMode ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

  eor r1,r0,r0,ror #1 ;
  mov r2,r0,lsl #25
  tst r1,#1 ;
  eorne r0,r0,#3 ;
  str r2,[r7,#0x4c] ;
  mov r10,r0,lsl #28 ;
  mov r1,r0,ror #8
  and r1,r1,#0xa7 ;
  strb r1,[r7,#0x44] ;

;
  eor r0,r1,r11
  tst r0,#0x20
  beq no_sp_swap46f8
 ;
  ldr r11,[r7,#0x3C] ;
  ldr r0, [r7,#0x48] ;
  str r11,[r7,#0x48]
  str r0, [r7,#0x3C]
no_sp_swap46f8:
  ldrh r8,[r4],#2 ;
  ldr r1,[r7,#0x44]
  subs r5,r5,#20 ;
;
  tst r1,#0x80
  bne CycloneDoTraceWithChecks
  cmp r5,#0
  blt CycloneEnd
;
  movs r0,r1,lsr #24 ;
  ldreq pc,[r6,r8,asl #2] ;
  cmp r0,#6 ;
  andle r1,r1,#7 ;
  cmple r0,r1 ;
  ldrle pc,[r6,r8,asl #2] ;
  b CycloneDoInterruptGoBack

;
Op46f9:
  ldr r11,[r7,#0x44] ;
  str r5,[r7,#0x5c] ;
  tst r11,#0x20 ;
  beq WrongPrivilegeMode ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

  eor r1,r0,r0,ror #1 ;
  mov r2,r0,lsl #25
  tst r1,#1 ;
  eorne r0,r0,#3 ;
  str r2,[r7,#0x4c] ;
  mov r10,r0,lsl #28 ;
  mov r1,r0,ror #8
  and r1,r1,#0xa7 ;
  strb r1,[r7,#0x44] ;

;
  eor r0,r1,r11
  tst r0,#0x20
  beq no_sp_swap46f9
 ;
  ldr r11,[r7,#0x3C] ;
  ldr r0, [r7,#0x48] ;
  str r11,[r7,#0x48]
  str r0, [r7,#0x3C]
no_sp_swap46f9:
  ldrh r8,[r4],#2 ;
  ldr r1,[r7,#0x44]
  subs r5,r5,#24 ;
;
  tst r1,#0x80
  bne CycloneDoTraceWithChecks
  cmp r5,#0
  blt CycloneEnd
;
  movs r0,r1,lsr #24 ;
  ldreq pc,[r6,r8,asl #2] ;
  cmp r0,#6 ;
  andle r1,r1,#7 ;
  cmple r0,r1 ;
  ldrle pc,[r6,r8,asl #2] ;
  b CycloneDoInterruptGoBack

;
Op46fa:
  ldr r11,[r7,#0x44] ;
  str r5,[r7,#0x5c] ;
  tst r11,#0x20 ;
  beq WrongPrivilegeMode ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;

  eor r1,r0,r0,ror #1 ;
  mov r2,r0,lsl #25
  tst r1,#1 ;
  eorne r0,r0,#3 ;
  str r2,[r7,#0x4c] ;
  mov r10,r0,lsl #28 ;
  mov r1,r0,ror #8
  and r1,r1,#0xa7 ;
  strb r1,[r7,#0x44] ;

;
  eor r0,r1,r11
  tst r0,#0x20
  beq no_sp_swap46fa
 ;
  ldr r11,[r7,#0x3C] ;
  ldr r0, [r7,#0x48] ;
  str r11,[r7,#0x48]
  str r0, [r7,#0x3C]
no_sp_swap46fa:
  ldrh r8,[r4],#2 ;
  ldr r1,[r7,#0x44]
  subs r5,r5,#20 ;
;
  tst r1,#0x80
  bne CycloneDoTraceWithChecks
  cmp r5,#0
  blt CycloneEnd
;
  movs r0,r1,lsr #24 ;
  ldreq pc,[r6,r8,asl #2] ;
  cmp r0,#6 ;
  andle r1,r1,#7 ;
  cmple r0,r1 ;
  ldrle pc,[r6,r8,asl #2] ;
  b CycloneDoInterruptGoBack

;
Op46fb:
  ldr r11,[r7,#0x44] ;
  str r5,[r7,#0x5c] ;
  tst r11,#0x20 ;
  beq WrongPrivilegeMode ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;

  eor r1,r0,r0,ror #1 ;
  mov r2,r0,lsl #25
  tst r1,#1 ;
  eorne r0,r0,#3 ;
  str r2,[r7,#0x4c] ;
  mov r10,r0,lsl #28 ;
  mov r1,r0,ror #8
  and r1,r1,#0xa7 ;
  strb r1,[r7,#0x44] ;

;
  eor r0,r1,r11
  tst r0,#0x20
  beq no_sp_swap46fb
 ;
  ldr r11,[r7,#0x3C] ;
  ldr r0, [r7,#0x48] ;
  str r11,[r7,#0x48]
  str r0, [r7,#0x3C]
no_sp_swap46fb:
  ldrh r8,[r4],#2 ;
  ldr r1,[r7,#0x44]
  subs r5,r5,#22 ;
;
  tst r1,#0x80
  bne CycloneDoTraceWithChecks
  cmp r5,#0
  blt CycloneEnd
;
  movs r0,r1,lsr #24 ;
  ldreq pc,[r6,r8,asl #2] ;
  cmp r0,#6 ;
  andle r1,r1,#7 ;
  cmple r0,r1 ;
  ldrle pc,[r6,r8,asl #2] ;
  b CycloneDoInterruptGoBack

;
Op46fc:
  ldr r11,[r7,#0x44] ;
  tst r11,#0x20 ;
  beq WrongPrivilegeMode ;

;
  ldrsh r0,[r4],#2 ;
;

  eor r1,r0,r0,ror #1 ;
  mov r2,r0,lsl #25
  tst r1,#1 ;
  eorne r0,r0,#3 ;
  str r2,[r7,#0x4c] ;
  mov r10,r0,lsl #28 ;
  mov r1,r0,ror #8
  and r1,r1,#0xa7 ;
  strb r1,[r7,#0x44] ;

;
  eor r0,r1,r11
  tst r0,#0x20
  beq no_sp_swap46fc
 ;
  ldr r11,[r7,#0x3C] ;
  ldr r0, [r7,#0x48] ;
  str r11,[r7,#0x48]
  str r0, [r7,#0x3C]
no_sp_swap46fc:
  ldrh r8,[r4],#2 ;
  ldr r1,[r7,#0x44]
  subs r5,r5,#16 ;
;
  tst r1,#0x80
  bne CycloneDoTraceWithChecks
  cmp r5,#0
  blt CycloneEnd
;
  movs r0,r1,lsr #24 ;
  ldreq pc,[r6,r8,asl #2] ;
  cmp r0,#6 ;
  andle r1,r1,#7 ;
  cmple r0,r1 ;
  ldrle pc,[r6,r8,asl #2] ;
  b CycloneDoInterruptGoBack

;
Op4800:
;
  and r6,r8,#0x000f
;
  ldr r0,[r7,r6,lsl #2]

  ldr r2,[r7,#0x4c]
  bic r10,r10,#0xb0000000 ;
  mov r0,r0,asl #24
  and r2,r2,#0x20000000
  add r2,r0,r2,lsr #5 ;
  rsb r11,r2,#0x9a000000 ;
  cmp r11,#0x9a000000
  beq finish4800

  mvn r3,r11,lsr #31 ;
  and r2,r11,#0x0f000000
  cmp r2,#0x0a000000
  andeq r11,r11,#0xf0000000
  addeq r11,r11,#0x10000000
  and r3,r3,r11,lsr #31 ;
  movs r1,r11,asr #24
  bicne r10,r10,#0x40000000 ;
  orr r10,r10,r3,lsl #28 ;
  orr r10,r10,#0x20000000 ;

;
  strb r1,[r7,r6,lsl #2]

finish4800:
  tst r11,r11
  orrmi r10,r10,#0x80000000 ;
  str r10,[r7,#0x4c] ;

  ldr r6,[r7,#0x54]
  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4810:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r6,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x68] ;

  ldr r2,[r7,#0x4c]
  bic r10,r10,#0xb0000000 ;
  mov r0,r0,asl #24
  and r2,r2,#0x20000000
  add r2,r0,r2,lsr #5 ;
  rsb r11,r2,#0x9a000000 ;
  cmp r11,#0x9a000000
  beq finish4810

  mvn r3,r11,lsr #31 ;
  and r2,r11,#0x0f000000
  cmp r2,#0x0a000000
  andeq r11,r11,#0xf0000000
  addeq r11,r11,#0x10000000
  and r3,r3,r11,lsr #31 ;
  movs r1,r11,asr #24
  bicne r10,r10,#0x40000000 ;
  orr r10,r10,r3,lsl #28 ;
  orr r10,r10,#0x20000000 ;

;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x74] ;

finish4810:
  tst r11,r11
  orrmi r10,r10,#0x80000000 ;
  str r10,[r7,#0x4c] ;

  ldr r6,[r7,#0x54]
  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4818:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r6,[r7,r2,lsl #2]
  add r3,r6,#1 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x68] ;

  ldr r2,[r7,#0x4c]
  bic r10,r10,#0xb0000000 ;
  mov r0,r0,asl #24
  and r2,r2,#0x20000000
  add r2,r0,r2,lsr #5 ;
  rsb r11,r2,#0x9a000000 ;
  cmp r11,#0x9a000000
  beq finish4818

  mvn r3,r11,lsr #31 ;
  and r2,r11,#0x0f000000
  cmp r2,#0x0a000000
  andeq r11,r11,#0xf0000000
  addeq r11,r11,#0x10000000
  and r3,r3,r11,lsr #31 ;
  movs r1,r11,asr #24
  bicne r10,r10,#0x40000000 ;
  orr r10,r10,r3,lsl #28 ;
  orr r10,r10,#0x20000000 ;

;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x74] ;

finish4818:
  tst r11,r11
  orrmi r10,r10,#0x80000000 ;
  str r10,[r7,#0x4c] ;

  ldr r6,[r7,#0x54]
  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op481f:
  str r5,[r7,#0x5c] ;

;
  ldr r6,[r7,#0x3c] ;
  add r3,r6,#2 ;
  str r3,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x68] ;

  ldr r2,[r7,#0x4c]
  bic r10,r10,#0xb0000000 ;
  mov r0,r0,asl #24
  and r2,r2,#0x20000000
  add r2,r0,r2,lsr #5 ;
  rsb r11,r2,#0x9a000000 ;
  cmp r11,#0x9a000000
  beq finish481f

  mvn r3,r11,lsr #31 ;
  and r2,r11,#0x0f000000
  cmp r2,#0x0a000000
  andeq r11,r11,#0xf0000000
  addeq r11,r11,#0x10000000
  and r3,r3,r11,lsr #31 ;
  movs r1,r11,asr #24
  bicne r10,r10,#0x40000000 ;
  orr r10,r10,r3,lsl #28 ;
  orr r10,r10,#0x20000000 ;

;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x74] ;

finish481f:
  tst r11,r11
  orrmi r10,r10,#0x80000000 ;
  str r10,[r7,#0x4c] ;

  ldr r6,[r7,#0x54]
  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4820:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r6,[r7,r2,lsl #2]
  sub r6,r6,#1 ;
  str r6,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x68] ;

  ldr r2,[r7,#0x4c]
  bic r10,r10,#0xb0000000 ;
  mov r0,r0,asl #24
  and r2,r2,#0x20000000
  add r2,r0,r2,lsr #5 ;
  rsb r11,r2,#0x9a000000 ;
  cmp r11,#0x9a000000
  beq finish4820

  mvn r3,r11,lsr #31 ;
  and r2,r11,#0x0f000000
  cmp r2,#0x0a000000
  andeq r11,r11,#0xf0000000
  addeq r11,r11,#0x10000000
  and r3,r3,r11,lsr #31 ;
  movs r1,r11,asr #24
  bicne r10,r10,#0x40000000 ;
  orr r10,r10,r3,lsl #28 ;
  orr r10,r10,#0x20000000 ;

;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x74] ;

finish4820:
  tst r11,r11
  orrmi r10,r10,#0x80000000 ;
  str r10,[r7,#0x4c] ;

  ldr r6,[r7,#0x54]
  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4827:
  str r5,[r7,#0x5c] ;

;
  ldr r6,[r7,#0x3c] ;
  sub r6,r6,#2 ;
  str r6,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x68] ;

  ldr r2,[r7,#0x4c]
  bic r10,r10,#0xb0000000 ;
  mov r0,r0,asl #24
  and r2,r2,#0x20000000
  add r2,r0,r2,lsr #5 ;
  rsb r11,r2,#0x9a000000 ;
  cmp r11,#0x9a000000
  beq finish4827

  mvn r3,r11,lsr #31 ;
  and r2,r11,#0x0f000000
  cmp r2,#0x0a000000
  andeq r11,r11,#0xf0000000
  addeq r11,r11,#0x10000000
  and r3,r3,r11,lsr #31 ;
  movs r1,r11,asr #24
  bicne r10,r10,#0x40000000 ;
  orr r10,r10,r3,lsl #28 ;
  orr r10,r10,#0x20000000 ;

;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x74] ;

finish4827:
  tst r11,r11
  orrmi r10,r10,#0x80000000 ;
  str r10,[r7,#0x4c] ;

  ldr r6,[r7,#0x54]
  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4828:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r6,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x68] ;

  ldr r2,[r7,#0x4c]
  bic r10,r10,#0xb0000000 ;
  mov r0,r0,asl #24
  and r2,r2,#0x20000000
  add r2,r0,r2,lsr #5 ;
  rsb r11,r2,#0x9a000000 ;
  cmp r11,#0x9a000000
  beq finish4828

  mvn r3,r11,lsr #31 ;
  and r2,r11,#0x0f000000
  cmp r2,#0x0a000000
  andeq r11,r11,#0xf0000000
  addeq r11,r11,#0x10000000
  and r3,r3,r11,lsr #31 ;
  movs r1,r11,asr #24
  bicne r10,r10,#0x40000000 ;
  orr r10,r10,r3,lsl #28 ;
  orr r10,r10,#0x20000000 ;

;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x74] ;

finish4828:
  tst r11,r11
  orrmi r10,r10,#0x80000000 ;
  str r10,[r7,#0x4c] ;

  ldr r6,[r7,#0x54]
  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4830:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r6,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x68] ;

  ldr r2,[r7,#0x4c]
  bic r10,r10,#0xb0000000 ;
  mov r0,r0,asl #24
  and r2,r2,#0x20000000
  add r2,r0,r2,lsr #5 ;
  rsb r11,r2,#0x9a000000 ;
  cmp r11,#0x9a000000
  beq finish4830

  mvn r3,r11,lsr #31 ;
  and r2,r11,#0x0f000000
  cmp r2,#0x0a000000
  andeq r11,r11,#0xf0000000
  addeq r11,r11,#0x10000000
  and r3,r3,r11,lsr #31 ;
  movs r1,r11,asr #24
  bicne r10,r10,#0x40000000 ;
  orr r10,r10,r3,lsl #28 ;
  orr r10,r10,#0x20000000 ;

;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x74] ;

finish4830:
  tst r11,r11
  orrmi r10,r10,#0x80000000 ;
  str r10,[r7,#0x4c] ;

  ldr r6,[r7,#0x54]
  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4838:
  str r5,[r7,#0x5c] ;

;
  ldrsh r6,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x68] ;

  ldr r2,[r7,#0x4c]
  bic r10,r10,#0xb0000000 ;
  mov r0,r0,asl #24
  and r2,r2,#0x20000000
  add r2,r0,r2,lsr #5 ;
  rsb r11,r2,#0x9a000000 ;
  cmp r11,#0x9a000000
  beq finish4838

  mvn r3,r11,lsr #31 ;
  and r2,r11,#0x0f000000
  cmp r2,#0x0a000000
  andeq r11,r11,#0xf0000000
  addeq r11,r11,#0x10000000
  and r3,r3,r11,lsr #31 ;
  movs r1,r11,asr #24
  bicne r10,r10,#0x40000000 ;
  orr r10,r10,r3,lsl #28 ;
  orr r10,r10,#0x20000000 ;

;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x74] ;

finish4838:
  tst r11,r11
  orrmi r10,r10,#0x80000000 ;
  str r10,[r7,#0x4c] ;

  ldr r6,[r7,#0x54]
  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4839:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r6,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x68] ;

  ldr r2,[r7,#0x4c]
  bic r10,r10,#0xb0000000 ;
  mov r0,r0,asl #24
  and r2,r2,#0x20000000
  add r2,r0,r2,lsr #5 ;
  rsb r11,r2,#0x9a000000 ;
  cmp r11,#0x9a000000
  beq finish4839

  mvn r3,r11,lsr #31 ;
  and r2,r11,#0x0f000000
  cmp r2,#0x0a000000
  andeq r11,r11,#0xf0000000
  addeq r11,r11,#0x10000000
  and r3,r3,r11,lsr #31 ;
  movs r1,r11,asr #24
  bicne r10,r10,#0x40000000 ;
  orr r10,r10,r3,lsl #28 ;
  orr r10,r10,#0x20000000 ;

;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x74] ;

finish4839:
  tst r11,r11
  orrmi r10,r10,#0x80000000 ;
  str r10,[r7,#0x4c] ;

  ldr r6,[r7,#0x54]
  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4850:
  str r5,[r7,#0x5c] ;

  ldr r11,[r7,#0x3c]
;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r1,[r7,r2,lsl #2]

  sub r0,r11,#4 ;
  str r0,[r7,#0x3c] ;

  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4868:
  str r5,[r7,#0x5c] ;

  ldr r11,[r7,#0x3c]
;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r1,r0,r2 ;

  sub r0,r11,#4 ;
  str r0,[r7,#0x3c] ;

  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4870:
  str r5,[r7,#0x5c] ;

  ldr r11,[r7,#0x3c]
;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r1,r2,r3 ;

  sub r0,r11,#4 ;
  str r0,[r7,#0x3c] ;

  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4878:
  str r5,[r7,#0x5c] ;

  ldr r11,[r7,#0x3c]
;
  ldrsh r1,[r4],#2 ;

  sub r0,r11,#4 ;
  str r0,[r7,#0x3c] ;

  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4879:
  str r5,[r7,#0x5c] ;

  ldr r11,[r7,#0x3c]
;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r1,r0,r2,lsl #16

  sub r0,r11,#4 ;
  str r0,[r7,#0x3c] ;

  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op487a:
  str r5,[r7,#0x5c] ;

  ldr r11,[r7,#0x3c]
;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r1,r2,r0,asr #8 ;

  sub r0,r11,#4 ;
  str r0,[r7,#0x3c] ;

  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op487b:
  str r5,[r7,#0x5c] ;

  ldr r11,[r7,#0x3c]
;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r1,r2,r0,asr #8 ;

  sub r0,r11,#4 ;
  str r0,[r7,#0x3c] ;

  mov lr,pc
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4880:
;
  and r11,r8,#0x0007
  mov r11,r11,lsl #2
;
  ldr r0,[r7,r11]

  mov r0,r0,asl #24
  adds r0,r0,#0 ;
  mrs r10,cpsr ;
  mov r1,r0,asr #24

;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4890:
  str r5,[r7,#0x5c] ;

  ldrh r11,[r4],#2 ;

;
;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r6,[r7,r2,lsl #2]
  str r4,[r7,#0x40] ;
;
  mov r4,#-4

  tst r11,r11
  beq NoRegs4890

Movemloop4890:
  add r4,r4,#4 ;
  movs r11,r11,lsr #1
  bcc Movemloop4890

  ;
  ldr r1,[r7,r4] ;
;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x78] ;

  add r6,r6,#2 ;
  sub r5,r5,#4 ;
  tst r11,r11
  bne Movemloop4890

NoRegs4890:
  ldr r4,[r7,#0x40]
  ldr r6,[r7,#0x54] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op48a0:
  str r5,[r7,#0x5c] ;

  ldrh r11,[r4],#2 ;

;
;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r6,[r7,r2,lsl #2]
  str r4,[r7,#0x40] ;
;
  mov r4,#0x40 ;

  tst r11,r11
  beq NoRegs48a0

Movemloop48a0:
  add r4,r4,#-4 ;
  movs r11,r11,lsr #1
  bcc Movemloop48a0

  sub r6,r6,#2 ;
  ;
  ldr r1,[r7,r4] ;
;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x78] ;

  sub r5,r5,#4 ;
  tst r11,r11
  bne Movemloop48a0

;
;
  and r0,r8,#0x0007
  orr r0,r0,#0x8 ;
;
  str r6,[r7,r0,lsl #2]

NoRegs48a0:
  ldr r4,[r7,#0x40]
  ldr r6,[r7,#0x54] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op48a8:
  str r5,[r7,#0x5c] ;

  ldrh r11,[r4],#2 ;

;
;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r6,r0,r2 ;
  str r4,[r7,#0x40] ;
;
  mov r4,#-4

  tst r11,r11
  beq NoRegs48a8

Movemloop48a8:
  add r4,r4,#4 ;
  movs r11,r11,lsr #1
  bcc Movemloop48a8

  ;
  ldr r1,[r7,r4] ;
;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x78] ;

  add r6,r6,#2 ;
  sub r5,r5,#4 ;
  tst r11,r11
  bne Movemloop48a8

NoRegs48a8:
  ldr r4,[r7,#0x40]
  ldr r6,[r7,#0x54] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op48b0:
  str r5,[r7,#0x5c] ;

  ldrh r11,[r4],#2 ;

;
;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r6,r2,r3 ;
  str r4,[r7,#0x40] ;
;
  mov r4,#-4

  tst r11,r11
  beq NoRegs48b0

Movemloop48b0:
  add r4,r4,#4 ;
  movs r11,r11,lsr #1
  bcc Movemloop48b0

  ;
  ldr r1,[r7,r4] ;
;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x78] ;

  add r6,r6,#2 ;
  sub r5,r5,#4 ;
  tst r11,r11
  bne Movemloop48b0

NoRegs48b0:
  ldr r4,[r7,#0x40]
  ldr r6,[r7,#0x54] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op48b8:
  str r5,[r7,#0x5c] ;

  ldrh r11,[r4],#2 ;

;
;
  ldrsh r6,[r4],#2 ;
  str r4,[r7,#0x40] ;
;
  mov r4,#-4

  tst r11,r11
  beq NoRegs48b8

Movemloop48b8:
  add r4,r4,#4 ;
  movs r11,r11,lsr #1
  bcc Movemloop48b8

  ;
  ldr r1,[r7,r4] ;
;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x78] ;

  add r6,r6,#2 ;
  sub r5,r5,#4 ;
  tst r11,r11
  bne Movemloop48b8

NoRegs48b8:
  ldr r4,[r7,#0x40]
  ldr r6,[r7,#0x54] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op48b9:
  str r5,[r7,#0x5c] ;

  ldrh r11,[r4],#2 ;

;
;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r6,r0,r2,lsl #16
  str r4,[r7,#0x40] ;
;
  mov r4,#-4

  tst r11,r11
  beq NoRegs48b9

Movemloop48b9:
  add r4,r4,#4 ;
  movs r11,r11,lsr #1
  bcc Movemloop48b9

  ;
  ldr r1,[r7,r4] ;
;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x78] ;

  add r6,r6,#2 ;
  sub r5,r5,#4 ;
  tst r11,r11
  bne Movemloop48b9

NoRegs48b9:
  ldr r4,[r7,#0x40]
  ldr r6,[r7,#0x54] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op48c0:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]

  mov r0,r0,asl #16
  adds r0,r0,#0 ;
  mrs r10,cpsr ;
  mov r1,r0,asr #16

;
  str r1,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op48d0:
  str r5,[r7,#0x5c] ;

  ldrh r11,[r4],#2 ;

;
;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r6,[r7,r2,lsl #2]
  str r4,[r7,#0x40] ;
;
  mov r4,#-4

  tst r11,r11
  beq NoRegs48d0

Movemloop48d0:
  add r4,r4,#4 ;
  movs r11,r11,lsr #1
  bcc Movemloop48d0

  ;
  ldr r1,[r7,r4] ;
;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x7c] ;

  add r6,r6,#4 ;
  sub r5,r5,#8 ;
  tst r11,r11
  bne Movemloop48d0

NoRegs48d0:
  ldr r4,[r7,#0x40]
  ldr r6,[r7,#0x54] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op48e0:
  str r5,[r7,#0x5c] ;

  ldrh r11,[r4],#2 ;

;
;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r6,[r7,r2,lsl #2]
  str r4,[r7,#0x40] ;
;
  mov r4,#0x40 ;

  tst r11,r11
  beq NoRegs48e0

Movemloop48e0:
  add r4,r4,#-4 ;
  movs r11,r11,lsr #1
  bcc Movemloop48e0

  sub r6,r6,#4 ;
  ;
  ldr r1,[r7,r4] ;
  add r0,r6,#2
;
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  ldr r1,[r7,r4] ;
  mov r0,r6
;
  mov r1,r1,asr #16
  mov lr,pc
  ldr pc,[r7,#0x78] ;

  sub r5,r5,#8 ;
  tst r11,r11
  bne Movemloop48e0

;
;
  and r0,r8,#0x0007
  orr r0,r0,#0x8 ;
;
  str r6,[r7,r0,lsl #2]

NoRegs48e0:
  ldr r4,[r7,#0x40]
  ldr r6,[r7,#0x54] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op48e8:
  str r5,[r7,#0x5c] ;

  ldrh r11,[r4],#2 ;

;
;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r6,r0,r2 ;
  str r4,[r7,#0x40] ;
;
  mov r4,#-4

  tst r11,r11
  beq NoRegs48e8

Movemloop48e8:
  add r4,r4,#4 ;
  movs r11,r11,lsr #1
  bcc Movemloop48e8

  ;
  ldr r1,[r7,r4] ;
;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x7c] ;

  add r6,r6,#4 ;
  sub r5,r5,#8 ;
  tst r11,r11
  bne Movemloop48e8

NoRegs48e8:
  ldr r4,[r7,#0x40]
  ldr r6,[r7,#0x54] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op48f0:
  str r5,[r7,#0x5c] ;

  ldrh r11,[r4],#2 ;

;
;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r6,r2,r3 ;
  str r4,[r7,#0x40] ;
;
  mov r4,#-4

  tst r11,r11
  beq NoRegs48f0

Movemloop48f0:
  add r4,r4,#4 ;
  movs r11,r11,lsr #1
  bcc Movemloop48f0

  ;
  ldr r1,[r7,r4] ;
;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x7c] ;

  add r6,r6,#4 ;
  sub r5,r5,#8 ;
  tst r11,r11
  bne Movemloop48f0

NoRegs48f0:
  ldr r4,[r7,#0x40]
  ldr r6,[r7,#0x54] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op48f8:
  str r5,[r7,#0x5c] ;

  ldrh r11,[r4],#2 ;

;
;
  ldrsh r6,[r4],#2 ;
  str r4,[r7,#0x40] ;
;
  mov r4,#-4

  tst r11,r11
  beq NoRegs48f8

Movemloop48f8:
  add r4,r4,#4 ;
  movs r11,r11,lsr #1
  bcc Movemloop48f8

  ;
  ldr r1,[r7,r4] ;
;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x7c] ;

  add r6,r6,#4 ;
  sub r5,r5,#8 ;
  tst r11,r11
  bne Movemloop48f8

NoRegs48f8:
  ldr r4,[r7,#0x40]
  ldr r6,[r7,#0x54] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op48f9:
  str r5,[r7,#0x5c] ;

  ldrh r11,[r4],#2 ;

;
;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r6,r0,r2,lsl #16
  str r4,[r7,#0x40] ;
;
  mov r4,#-4

  tst r11,r11
  beq NoRegs48f9

Movemloop48f9:
  add r4,r4,#4 ;
  movs r11,r11,lsr #1
  bcc Movemloop48f9

  ;
  ldr r1,[r7,r4] ;
;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x7c] ;

  add r6,r6,#4 ;
  sub r5,r5,#8 ;
  tst r11,r11
  bne Movemloop48f9

NoRegs48f9:
  ldr r4,[r7,#0x40]
  ldr r6,[r7,#0x54] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op4a00:
;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]
  mov r0,r0,asl #24

  adds r0,r0,#0 ;
  mrs r10,cpsr ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4a10:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24

  adds r0,r0,#0 ;
  mrs r10,cpsr ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4a18:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24

  adds r0,r0,#0 ;
  mrs r10,cpsr ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4a1f:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24

  adds r0,r0,#0 ;
  mrs r10,cpsr ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4a20:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24

  adds r0,r0,#0 ;
  mrs r10,cpsr ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4a27:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24

  adds r0,r0,#0 ;
  mrs r10,cpsr ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4a30:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r0,r0,asl #24

  adds r0,r0,#0 ;
  mrs r10,cpsr ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4a40:
;
  and r0,r8,#0x000f
  mov r0,r0,lsl #2
;
  ldr r0,[r7,r0]
  mov r0,r0,asl #16

  adds r0,r0,#0 ;
  mrs r10,cpsr ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4a50:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

  adds r0,r0,#0 ;
  mrs r10,cpsr ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4a58:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#2 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

  adds r0,r0,#0 ;
  mrs r10,cpsr ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4a60:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#2 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

  adds r0,r0,#0 ;
  mrs r10,cpsr ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4a68:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

  adds r0,r0,#0 ;
  mrs r10,cpsr ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4a70:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

  adds r0,r0,#0 ;
  mrs r10,cpsr ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4a78:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

  adds r0,r0,#0 ;
  mrs r10,cpsr ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4a80:
;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

  adds r0,r0,#0 ;
  mrs r10,cpsr ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4a90:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r0,r0,#0 ;
  mrs r10,cpsr ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4a98:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#4 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r0,r0,#0 ;
  mrs r10,cpsr ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4aa0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#4 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r0,r0,#0 ;
  mrs r10,cpsr ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4aa8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r0,r0,#0 ;
  mrs r10,cpsr ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4ab0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r0,r0,#0 ;
  mrs r10,cpsr ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4ab8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r0,r0,#0 ;
  mrs r10,cpsr ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4ab9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  adds r0,r0,#0 ;
  mrs r10,cpsr ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4ac0:
;
  and r11,r8,#0x000f
;
  ldr r1,[r7,r11,lsl #2]
  mov r1,r1,asl #24

  adds r1,r1,#0 ;
  mrs r10,cpsr ;

  orr r1,r1,#0x80000000 ;
;
  mov r1,r1,asr #24
  strb r1,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4ad0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;
  mov r1,r0,asl #24

  adds r1,r1,#0 ;
  mrs r10,cpsr ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

Op4ad0_:
;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;
  mov r1,r0,asl #24

  adds r1,r1,#0 ;
  mrs r10,cpsr ;

  orr r1,r1,#0x80000000 ;
;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4ad8:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#1 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;
  mov r1,r0,asl #24

  adds r1,r1,#0 ;
  mrs r10,cpsr ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

Op4ad8_:
;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#1 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;
  mov r1,r0,asl #24

  adds r1,r1,#0 ;
  mrs r10,cpsr ;

  orr r1,r1,#0x80000000 ;
;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4adf:
  str r5,[r7,#0x5c] ;

;
  ldr r11,[r7,#0x3c] ;
  add r3,r11,#2 ;
  str r3,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;
  mov r1,r0,asl #24

  adds r1,r1,#0 ;
  mrs r10,cpsr ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

Op4adf_:
;
  ldr r11,[r7,#0x3c] ;
  add r3,r11,#2 ;
  str r3,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;
  mov r1,r0,asl #24

  adds r1,r1,#0 ;
  mrs r10,cpsr ;

  orr r1,r1,#0x80000000 ;
;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4ae0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#1 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;
  mov r1,r0,asl #24

  adds r1,r1,#0 ;
  mrs r10,cpsr ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

Op4ae0_:
;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#1 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;
  mov r1,r0,asl #24

  adds r1,r1,#0 ;
  mrs r10,cpsr ;

  orr r1,r1,#0x80000000 ;
;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4ae7:
  str r5,[r7,#0x5c] ;

;
  ldr r11,[r7,#0x3c] ;
  sub r11,r11,#2 ;
  str r11,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;
  mov r1,r0,asl #24

  adds r1,r1,#0 ;
  mrs r10,cpsr ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

Op4ae7_:
;
  ldr r11,[r7,#0x3c] ;
  sub r11,r11,#2 ;
  str r11,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;
  mov r1,r0,asl #24

  adds r1,r1,#0 ;
  mrs r10,cpsr ;

  orr r1,r1,#0x80000000 ;
;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4ae8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;
  mov r1,r0,asl #24

  adds r1,r1,#0 ;
  mrs r10,cpsr ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

Op4ae8_:
;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;
  mov r1,r0,asl #24

  adds r1,r1,#0 ;
  mrs r10,cpsr ;

  orr r1,r1,#0x80000000 ;
;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4af0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;
  mov r1,r0,asl #24

  adds r1,r1,#0 ;
  mrs r10,cpsr ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

Op4af0_:
;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;
  mov r1,r0,asl #24

  adds r1,r1,#0 ;
  mrs r10,cpsr ;

  orr r1,r1,#0x80000000 ;
;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4af8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;
  mov r1,r0,asl #24

  adds r1,r1,#0 ;
  mrs r10,cpsr ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

Op4af8_:
;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;
  mov r1,r0,asl #24

  adds r1,r1,#0 ;
  mrs r10,cpsr ;

  orr r1,r1,#0x80000000 ;
;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4af9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;
  mov r1,r0,asl #24

  adds r1,r1,#0 ;
  mrs r10,cpsr ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#26 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

Op4af9_:
;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;
  mov r1,r0,asl #24

  adds r1,r1,#0 ;
  mrs r10,cpsr ;

  orr r1,r1,#0x80000000 ;
;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#26 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4c90:
  str r5,[r7,#0x5c] ;

  ldrh r11,[r4],#2 ;

;
;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r6,[r7,r2,lsl #2]
  str r4,[r7,#0x40] ;
;
  mov r4,#-4

  tst r11,r11
  beq NoRegs4c90

Movemloop4c90:
  add r4,r4,#4 ;
  movs r11,r11,lsr #1
  bcc Movemloop4c90

  ;
;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  str r0,[r7,r4] ;
  add r6,r6,#2 ;
  sub r5,r5,#4 ;
  tst r11,r11
  bne Movemloop4c90

NoRegs4c90:
  ldr r4,[r7,#0x40]
  ldr r6,[r7,#0x54] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op4c98:
  str r5,[r7,#0x5c] ;

  ldrh r11,[r4],#2 ;

;
;
  and r2,r8,#0x000f
  ldr r6,[r7,r2,lsl #2]
  str r4,[r7,#0x40] ;
;
  mov r4,#-4

  tst r11,r11
  beq NoRegs4c98

Movemloop4c98:
  add r4,r4,#4 ;
  movs r11,r11,lsr #1
  bcc Movemloop4c98

  ;
;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  str r0,[r7,r4] ;
  add r6,r6,#2 ;
  sub r5,r5,#4 ;
  tst r11,r11
  bne Movemloop4c98

;
;
  and r0,r8,#0x000f
;
  str r6,[r7,r0,lsl #2]

NoRegs4c98:
  ldr r4,[r7,#0x40]
  ldr r6,[r7,#0x54] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op4ca8:
  str r5,[r7,#0x5c] ;

  ldrh r11,[r4],#2 ;

;
;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r6,r0,r2 ;
  str r4,[r7,#0x40] ;
;
  mov r4,#-4

  tst r11,r11
  beq NoRegs4ca8

Movemloop4ca8:
  add r4,r4,#4 ;
  movs r11,r11,lsr #1
  bcc Movemloop4ca8

  ;
;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  str r0,[r7,r4] ;
  add r6,r6,#2 ;
  sub r5,r5,#4 ;
  tst r11,r11
  bne Movemloop4ca8

NoRegs4ca8:
  ldr r4,[r7,#0x40]
  ldr r6,[r7,#0x54] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op4cb0:
  str r5,[r7,#0x5c] ;

  ldrh r11,[r4],#2 ;

;
;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r6,r2,r3 ;
  str r4,[r7,#0x40] ;
;
  mov r4,#-4

  tst r11,r11
  beq NoRegs4cb0

Movemloop4cb0:
  add r4,r4,#4 ;
  movs r11,r11,lsr #1
  bcc Movemloop4cb0

  ;
;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  str r0,[r7,r4] ;
  add r6,r6,#2 ;
  sub r5,r5,#4 ;
  tst r11,r11
  bne Movemloop4cb0

NoRegs4cb0:
  ldr r4,[r7,#0x40]
  ldr r6,[r7,#0x54] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op4cb8:
  str r5,[r7,#0x5c] ;

  ldrh r11,[r4],#2 ;

;
;
  ldrsh r6,[r4],#2 ;
  str r4,[r7,#0x40] ;
;
  mov r4,#-4

  tst r11,r11
  beq NoRegs4cb8

Movemloop4cb8:
  add r4,r4,#4 ;
  movs r11,r11,lsr #1
  bcc Movemloop4cb8

  ;
;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  str r0,[r7,r4] ;
  add r6,r6,#2 ;
  sub r5,r5,#4 ;
  tst r11,r11
  bne Movemloop4cb8

NoRegs4cb8:
  ldr r4,[r7,#0x40]
  ldr r6,[r7,#0x54] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op4cb9:
  str r5,[r7,#0x5c] ;

  ldrh r11,[r4],#2 ;

;
;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r6,r0,r2,lsl #16
  str r4,[r7,#0x40] ;
;
  mov r4,#-4

  tst r11,r11
  beq NoRegs4cb9

Movemloop4cb9:
  add r4,r4,#4 ;
  movs r11,r11,lsr #1
  bcc Movemloop4cb9

  ;
;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  str r0,[r7,r4] ;
  add r6,r6,#2 ;
  sub r5,r5,#4 ;
  tst r11,r11
  bne Movemloop4cb9

NoRegs4cb9:
  ldr r4,[r7,#0x40]
  ldr r6,[r7,#0x54] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op4cba:
  str r5,[r7,#0x5c] ;

  ldrh r11,[r4],#2 ;

;
;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r6,r2,r0,asr #8 ;
  str r4,[r7,#0x40] ;
;
  mov r4,#-4

  tst r11,r11
  beq NoRegs4cba

Movemloop4cba:
  add r4,r4,#4 ;
  movs r11,r11,lsr #1
  bcc Movemloop4cba

  ;
;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x84] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  str r0,[r7,r4] ;
  add r6,r6,#2 ;
  sub r5,r5,#4 ;
  tst r11,r11
  bne Movemloop4cba

NoRegs4cba:
  ldr r4,[r7,#0x40]
  ldr r6,[r7,#0x54] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op4cbb:
  str r5,[r7,#0x5c] ;

  ldrh r11,[r4],#2 ;

;
;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r6,r2,r0,asr #8 ;
  str r4,[r7,#0x40] ;
;
  mov r4,#-4

  tst r11,r11
  beq NoRegs4cbb

Movemloop4cbb:
  add r4,r4,#4 ;
  movs r11,r11,lsr #1
  bcc Movemloop4cbb

  ;
;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x84] ;
  mov r0,r0,asl #16
  mov r0,r0,asr #16

  str r0,[r7,r4] ;
  add r6,r6,#2 ;
  sub r5,r5,#4 ;
  tst r11,r11
  bne Movemloop4cbb

NoRegs4cbb:
  ldr r4,[r7,#0x40]
  ldr r6,[r7,#0x54] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op4cd0:
  str r5,[r7,#0x5c] ;

  ldrh r11,[r4],#2 ;

;
;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r6,[r7,r2,lsl #2]
  str r4,[r7,#0x40] ;
;
  mov r4,#-4

  tst r11,r11
  beq NoRegs4cd0

Movemloop4cd0:
  add r4,r4,#4 ;
  movs r11,r11,lsr #1
  bcc Movemloop4cd0

  ;
;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x70] ;

  str r0,[r7,r4] ;
  add r6,r6,#4 ;
  sub r5,r5,#8 ;
  tst r11,r11
  bne Movemloop4cd0

NoRegs4cd0:
  ldr r4,[r7,#0x40]
  ldr r6,[r7,#0x54] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op4cd8:
  str r5,[r7,#0x5c] ;

  ldrh r11,[r4],#2 ;

;
;
  and r2,r8,#0x000f
  ldr r6,[r7,r2,lsl #2]
  str r4,[r7,#0x40] ;
;
  mov r4,#-4

  tst r11,r11
  beq NoRegs4cd8

Movemloop4cd8:
  add r4,r4,#4 ;
  movs r11,r11,lsr #1
  bcc Movemloop4cd8

  ;
;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x70] ;

  str r0,[r7,r4] ;
  add r6,r6,#4 ;
  sub r5,r5,#8 ;
  tst r11,r11
  bne Movemloop4cd8

;
;
  and r0,r8,#0x000f
;
  str r6,[r7,r0,lsl #2]

NoRegs4cd8:
  ldr r4,[r7,#0x40]
  ldr r6,[r7,#0x54] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op4ce8:
  str r5,[r7,#0x5c] ;

  ldrh r11,[r4],#2 ;

;
;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r6,r0,r2 ;
  str r4,[r7,#0x40] ;
;
  mov r4,#-4

  tst r11,r11
  beq NoRegs4ce8

Movemloop4ce8:
  add r4,r4,#4 ;
  movs r11,r11,lsr #1
  bcc Movemloop4ce8

  ;
;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x70] ;

  str r0,[r7,r4] ;
  add r6,r6,#4 ;
  sub r5,r5,#8 ;
  tst r11,r11
  bne Movemloop4ce8

NoRegs4ce8:
  ldr r4,[r7,#0x40]
  ldr r6,[r7,#0x54] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op4cf0:
  str r5,[r7,#0x5c] ;

  ldrh r11,[r4],#2 ;

;
;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r6,r2,r3 ;
  str r4,[r7,#0x40] ;
;
  mov r4,#-4

  tst r11,r11
  beq NoRegs4cf0

Movemloop4cf0:
  add r4,r4,#4 ;
  movs r11,r11,lsr #1
  bcc Movemloop4cf0

  ;
;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x70] ;

  str r0,[r7,r4] ;
  add r6,r6,#4 ;
  sub r5,r5,#8 ;
  tst r11,r11
  bne Movemloop4cf0

NoRegs4cf0:
  ldr r4,[r7,#0x40]
  ldr r6,[r7,#0x54] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op4cf8:
  str r5,[r7,#0x5c] ;

  ldrh r11,[r4],#2 ;

;
;
  ldrsh r6,[r4],#2 ;
  str r4,[r7,#0x40] ;
;
  mov r4,#-4

  tst r11,r11
  beq NoRegs4cf8

Movemloop4cf8:
  add r4,r4,#4 ;
  movs r11,r11,lsr #1
  bcc Movemloop4cf8

  ;
;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x70] ;

  str r0,[r7,r4] ;
  add r6,r6,#4 ;
  sub r5,r5,#8 ;
  tst r11,r11
  bne Movemloop4cf8

NoRegs4cf8:
  ldr r4,[r7,#0x40]
  ldr r6,[r7,#0x54] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op4cf9:
  str r5,[r7,#0x5c] ;

  ldrh r11,[r4],#2 ;

;
;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r6,r0,r2,lsl #16
  str r4,[r7,#0x40] ;
;
  mov r4,#-4

  tst r11,r11
  beq NoRegs4cf9

Movemloop4cf9:
  add r4,r4,#4 ;
  movs r11,r11,lsr #1
  bcc Movemloop4cf9

  ;
;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x70] ;

  str r0,[r7,r4] ;
  add r6,r6,#4 ;
  sub r5,r5,#8 ;
  tst r11,r11
  bne Movemloop4cf9

NoRegs4cf9:
  ldr r4,[r7,#0x40]
  ldr r6,[r7,#0x54] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op4cfa:
  str r5,[r7,#0x5c] ;

  ldrh r11,[r4],#2 ;

;
;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r6,r2,r0,asr #8 ;
  str r4,[r7,#0x40] ;
;
  mov r4,#-4

  tst r11,r11
  beq NoRegs4cfa

Movemloop4cfa:
  add r4,r4,#4 ;
  movs r11,r11,lsr #1
  bcc Movemloop4cfa

  ;
;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x88] ;

  str r0,[r7,r4] ;
  add r6,r6,#4 ;
  sub r5,r5,#8 ;
  tst r11,r11
  bne Movemloop4cfa

NoRegs4cfa:
  ldr r4,[r7,#0x40]
  ldr r6,[r7,#0x54] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op4cfb:
  str r5,[r7,#0x5c] ;

  ldrh r11,[r4],#2 ;

;
;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r6,r2,r0,asr #8 ;
  str r4,[r7,#0x40] ;
;
  mov r4,#-4

  tst r11,r11
  beq NoRegs4cfb

Movemloop4cfb:
  add r4,r4,#4 ;
  movs r11,r11,lsr #1
  bcc Movemloop4cfb

  ;
;
  add lr,pc,#4
  mov r0,r6
  ldr pc,[r7,#0x88] ;

  str r0,[r7,r4] ;
  add r6,r6,#4 ;
  sub r5,r5,#8 ;
  tst r11,r11
  bne Movemloop4cfb

NoRegs4cfb:
  ldr r4,[r7,#0x40]
  ldr r6,[r7,#0x54] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op4e40:
  str r5,[r7,#0x5c] ;

  and r0,r8,#0xf ;
  orr r0,r0,#0x20 ;
  bl Exception

  ldrh r8,[r4],#2 ;
  subs r5,r5,#38 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4e50:
  str r5,[r7,#0x5c] ;

;
;
  and r11,r8,#0x0007
  orr r11,r11,#0x8 ;
;
  ldr r1,[r7,r11,lsl #2]

  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#4 ;
  mov r8,r0 ;

;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;
;
;
  str r8,[r7,r11,lsl #2]

;
;
  ldrsh r0,[r4],#2 ;
;

  add r8,r8,r0 ;
  str r8,[r7,#0x3c]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4e57:
  str r5,[r7,#0x5c] ;

  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#4 ;
  mov r8,r0 ;
  mov r1,r0

;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;
;
;
;
  ldrsh r0,[r4],#2 ;
;

  add r8,r8,r0 ;
  str r8,[r7,#0x3c]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4e58:
  str r5,[r7,#0x5c] ;

;
;
  and r11,r8,#0x000f
;
  ldr r0,[r7,r11,lsl #2]

  add r8,r0,#4 ;

;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  str r8,[r7,#0x3c] ;

;
;
  str r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4e60:
  ldr r11,[r7,#0x44] ;
  tst r11,#0x20 ;
  beq WrongPrivilegeMode ;

;
  and r0,r8,#0x000f
  orr r0,r0,#0x8 ;
;
  ldr r0,[r7,r0,lsl #2]

  str r0,[r7,#0x48] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4e68:
  ldr r11,[r7,#0x44] ;
  tst r11,#0x20 ;
  beq WrongPrivilegeMode ;

  ldr r1,[r7,#0x48] ;

;
  and r0,r8,#0x000f
;
  str r1,[r7,r0,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4e70:
  ldr r11,[r7,#0x44] ;
  tst r11,#0x20 ;
  beq WrongPrivilegeMode ;

  str r4,[r7,#0x40] ;
  mov r1,r10,lsr #28
  strb r1,[r7,#0x46] ;
  str r5,[r7,#0x5c] ;
  ldr r11,[r7,#0x90] ;
  tst r11,r11
  movne lr,pc
  bxne r11 ;
  ldrb r10,[r7,#0x46] ;
  ldr r5,[r7,#0x5c] ;
  ldr r4,[r7,#0x40] ;
  mov r10,r10,lsl #28

  ldrh r8,[r4],#2 ;
  subs r5,r5,#132 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4e72:
  ldr r11,[r7,#0x44] ;
  tst r11,#0x20 ;
  beq WrongPrivilegeMode ;

  ldrh r0,[r4],#2 ;
  eor r1,r0,r0,ror #1 ;
  mov r2,r0,lsl #25
  tst r1,#1 ;
  eorne r0,r0,#3 ;
  str r2,[r7,#0x4c] ;
  mov r10,r0,lsl #28 ;
  mov r0,r0,ror #8
  and r0,r0,#0xa7 ;
  strb r0,[r7,#0x44] ;

;
  eor r0,r0,r11
  tst r0,#0x20
  beq no_sp_swap4e72
 ;
  ldr r11,[r7,#0x3C] ;
  ldr r0, [r7,#0x48] ;
  str r11,[r7,#0x48]
  str r0, [r7,#0x3C]
no_sp_swap4e72:

  ldr r0,[r7,#0x58]
  mov r5,#0 ;
  orr r0,r0,#1 ;
  str r0,[r7,#0x58]


  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4e73:
  ldr r11,[r7,#0x44] ;
  str r5,[r7,#0x5c] ;
  tst r11,#0x20 ;
  beq WrongPrivilegeMode ;

;
  ldr r0,[r7,#0x3c]
  add r1,r0,#2 ;
  str r1,[r7,#0x3c] ;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

  eor r1,r0,r0,ror #1 ;
  mov r2,r0,lsl #25
  tst r1,#1 ;
  eorne r0,r0,#3 ;
  str r2,[r7,#0x4c] ;
  mov r10,r0,lsl #28 ;
  mov r0,r0,ror #8
  and r0,r0,#0xa7 ;
  strb r0,[r7,#0x44] ;

;
  ldr r0,[r7,#0x3c]
  add r1,r0,#4 ;
  str r1,[r7,#0x3c] ;
  mov lr,pc
  ldr pc,[r7,#0x70] ;
  ldr r1,[r7,#0x60] ;
  add r0,r0,r1 ;

;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  mov r4,r0
  ldr r1,[r7,#0x44] ;
;
  eor r0,r1,r11
  tst r0,#0x20
  beq no_sp_swap4e73
 ;
  ldr r11,[r7,#0x3C] ;
  ldr r0, [r7,#0x48] ;
  str r11,[r7,#0x48]
  str r0, [r7,#0x3C]
no_sp_swap4e73:
  ldr r1,[r7,#0x58]
  bic r1,r1,#0x0c ;
  str r1,[r7,#0x58]
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4
  ldrh r8,[r4],#2 ;
  ldr r1,[r7,#0x44]
  subs r5,r5,#20 ;
;
  tst r1,#0x80
  bne CycloneDoTraceWithChecks
  cmp r5,#0
  blt CycloneEnd
;
  movs r0,r1,lsr #24 ;
  ldreq pc,[r6,r8,asl #2] ;
  cmp r0,#6 ;
  andle r1,r1,#7 ;
  cmple r0,r1 ;
  ldrle pc,[r6,r8,asl #2] ;
  b CycloneDoInterruptGoBack

;
Op4e76:
  str r5,[r7,#0x5c] ;

  tst r10,#0x10000000
  subne r5,r5,#34
  movne r0,#7 ;
  blne Exception
  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4e77:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x3c]
  add r1,r0,#2 ;
  str r1,[r7,#0x3c] ;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

  eor r1,r0,r0,ror #1 ;
  mov r2,r0,lsl #25
  tst r1,#1 ;
  eorne r0,r0,#3 ;
  str r2,[r7,#0x4c] ;
  mov r10,r0,lsl #28 ;

;
  ldr r0,[r7,#0x3c]
  add r1,r0,#4 ;
  str r1,[r7,#0x3c] ;
  mov lr,pc
  ldr pc,[r7,#0x70] ;
  ldr r1,[r7,#0x60] ;
  add r0,r0,r1 ;

;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4
  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4e90:
  str r5,[r7,#0x5c] ;

  ldr r11,[r7,#0x60] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r12,[r7,r2,lsl #2]
;
  add r0,r12,r11 ;

;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  ldr r2,[r7,#0x3c]
  sub r1,r4,r11 ;
  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4
;
  sub r0,r2,#4 ;
  str r0,[r7,#0x3c] ;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4ea8:
  str r5,[r7,#0x5c] ;

  ldr r11,[r7,#0x60] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r12,r0,r2 ;
;
  add r0,r12,r11 ;

;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  ldr r2,[r7,#0x3c]
  sub r1,r4,r11 ;
  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4
;
  sub r0,r2,#4 ;
  str r0,[r7,#0x3c] ;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4eb0:
  str r5,[r7,#0x5c] ;

  ldr r11,[r7,#0x60] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r12,r2,r3 ;
;
  add r0,r12,r11 ;

;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  ldr r2,[r7,#0x3c]
  sub r1,r4,r11 ;
  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4
;
  sub r0,r2,#4 ;
  str r0,[r7,#0x3c] ;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4eb8:
  str r5,[r7,#0x5c] ;

  ldr r11,[r7,#0x60] ;

;
  ldrsh r12,[r4],#2 ;
;
  add r0,r12,r11 ;

;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  ldr r2,[r7,#0x3c]
  sub r1,r4,r11 ;
  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4
;
  sub r0,r2,#4 ;
  str r0,[r7,#0x3c] ;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4eb9:
  str r5,[r7,#0x5c] ;

  ldr r11,[r7,#0x60] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r12,r0,r2,lsl #16
;
  add r0,r12,r11 ;

;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  ldr r2,[r7,#0x3c]
  sub r1,r4,r11 ;
  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4
;
  sub r0,r2,#4 ;
  str r0,[r7,#0x3c] ;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4eba:
  str r5,[r7,#0x5c] ;

  ldr r11,[r7,#0x60] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r12,r2,r0,asr #8 ;
;
  add r0,r12,r11 ;

;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  ldr r2,[r7,#0x3c]
  sub r1,r4,r11 ;
  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4
;
  sub r0,r2,#4 ;
  str r0,[r7,#0x3c] ;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4ebb:
  str r5,[r7,#0x5c] ;

  ldr r11,[r7,#0x60] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r12,r2,r0,asr #8 ;
;
  add r0,r12,r11 ;

;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  ldr r2,[r7,#0x3c]
  sub r1,r4,r11 ;
  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4
;
  sub r0,r2,#4 ;
  str r0,[r7,#0x3c] ;
  mov lr,pc
  ldr pc,[r7,#0x7c] ;
  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4ed0:
  ldr r11,[r7,#0x60] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r12,[r7,r2,lsl #2]
;
  add r0,r12,r11 ;

;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4
  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4ee8:
  ldr r11,[r7,#0x60] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r12,r0,r2 ;
;
  add r0,r12,r11 ;

;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4
  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4ef0:
  ldr r11,[r7,#0x60] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r12,r2,r3 ;
;
  add r0,r12,r11 ;

;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4
  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4ef8:
  ldr r11,[r7,#0x60] ;

;
  ldrsh r12,[r4],#2 ;
;
  add r0,r12,r11 ;

;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4
  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4ef9:
  ldr r11,[r7,#0x60] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r12,r0,r2,lsl #16
;
  add r0,r12,r11 ;

;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4
  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4efa:
  ldr r11,[r7,#0x60] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r12,r2,r0,asr #8 ;
;
  add r0,r12,r11 ;

;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4
  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op4efb:
  ldr r11,[r7,#0x60] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r12,r2,r0,asr #8 ;
;
  add r0,r12,r11 ;

;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4
  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5000:
;
  and r11,r8,#0x000f
;
  ldr r0,[r7,r11,lsl #2]

  mov r0,r0,asl #24

  adds r1,r0,#0x8000000
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  strb r1,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5010:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r0,r0,asl #24

  adds r1,r0,#0x8000000
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5018:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#1 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r0,r0,asl #24

  adds r1,r0,#0x8000000
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op501f:
  str r5,[r7,#0x5c] ;

;
  ldr r11,[r7,#0x3c] ;
  add r3,r11,#2 ;
  str r3,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r0,r0,asl #24

  adds r1,r0,#0x8000000
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5020:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#1 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r0,r0,asl #24

  adds r1,r0,#0x8000000
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5027:
  str r5,[r7,#0x5c] ;

;
  ldr r11,[r7,#0x3c] ;
  sub r11,r11,#2 ;
  str r11,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r0,r0,asl #24

  adds r1,r0,#0x8000000
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5028:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r0,r0,asl #24

  adds r1,r0,#0x8000000
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5030:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r0,r0,asl #24

  adds r1,r0,#0x8000000
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5038:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r0,r0,asl #24

  adds r1,r0,#0x8000000
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5039:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r0,r0,asl #24

  adds r1,r0,#0x8000000
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5040:
;
  and r11,r8,#0x000f
  mov r11,r11,lsl #2
;
  ldr r0,[r7,r11]

  mov r0,r0,asl #16

  adds r1,r0,#0x80000
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5048:
;
  and r11,r8,#0x000f
;
  ldr r0,[r7,r11,lsl #2]

  adds r1,r0,#0x0008

;
  str r1,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5050:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r0,r0,asl #16

  adds r1,r0,#0x80000
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5058:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#2 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r0,r0,asl #16

  adds r1,r0,#0x80000
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5060:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#2 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r0,r0,asl #16

  adds r1,r0,#0x80000
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5068:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r0,r0,asl #16

  adds r1,r0,#0x80000
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5070:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r0,r0,asl #16

  adds r1,r0,#0x80000
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5078:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r0,r0,asl #16

  adds r1,r0,#0x80000
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5079:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r0,r0,asl #16

  adds r1,r0,#0x80000
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5080:
;
  and r11,r8,#0x000f
;
  ldr r0,[r7,r11,lsl #2]

  adds r1,r0,#0x0008
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  str r1,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5088:
;
  and r11,r8,#0x000f
;
  ldr r0,[r7,r11,lsl #2]

  adds r1,r0,#0x0008

;
  str r1,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5090:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0x0008
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5098:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#4 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0x0008
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op50a0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#4 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0x0008
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op50a8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0x0008
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op50b0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0x0008
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#26 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op50b8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0x0008
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op50b9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

  adds r1,r0,#0x0008
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#28 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op50c0:
  mvn r1,#0

;
  and r0,r8,#0x000f
;
  strb r1,[r7,r0,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op50c8:
;
DbraTrue:
  add r4,r4,#2 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op50d0:
  str r5,[r7,#0x5c] ;

  mvn r1,#0

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op50d8:
  str r5,[r7,#0x5c] ;

  mvn r1,#0

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op50df:
  str r5,[r7,#0x5c] ;

  mvn r1,#0

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op50e0:
  str r5,[r7,#0x5c] ;

  mvn r1,#0

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op50e7:
  str r5,[r7,#0x5c] ;

  mvn r1,#0

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op50e8:
  str r5,[r7,#0x5c] ;

  mvn r1,#0

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op50f0:
  str r5,[r7,#0x5c] ;

  mvn r1,#0

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op50f8:
  str r5,[r7,#0x5c] ;

  mvn r1,#0

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op50f9:
  str r5,[r7,#0x5c] ;

  mvn r1,#0

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5100:
;
  and r11,r8,#0x000f
;
  ldr r0,[r7,r11,lsl #2]

  mov r0,r0,asl #24

  subs r1,r0,#0x8000000
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  strb r1,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5110:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r0,r0,asl #24

  subs r1,r0,#0x8000000
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5118:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#1 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r0,r0,asl #24

  subs r1,r0,#0x8000000
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op511f:
  str r5,[r7,#0x5c] ;

;
  ldr r11,[r7,#0x3c] ;
  add r3,r11,#2 ;
  str r3,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r0,r0,asl #24

  subs r1,r0,#0x8000000
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5120:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#1 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r0,r0,asl #24

  subs r1,r0,#0x8000000
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5127:
  str r5,[r7,#0x5c] ;

;
  ldr r11,[r7,#0x3c] ;
  sub r11,r11,#2 ;
  str r11,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r0,r0,asl #24

  subs r1,r0,#0x8000000
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5128:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r0,r0,asl #24

  subs r1,r0,#0x8000000
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5130:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r0,r0,asl #24

  subs r1,r0,#0x8000000
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5138:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r0,r0,asl #24

  subs r1,r0,#0x8000000
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5139:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r0,r0,asl #24

  subs r1,r0,#0x8000000
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5140:
;
  and r11,r8,#0x000f
  mov r11,r11,lsl #2
;
  ldr r0,[r7,r11]

  mov r0,r0,asl #16

  subs r1,r0,#0x80000
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5148:
;
  and r11,r8,#0x000f
;
  ldr r0,[r7,r11,lsl #2]

  subs r1,r0,#0x0008

;
  str r1,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5150:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r0,r0,asl #16

  subs r1,r0,#0x80000
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5158:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#2 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r0,r0,asl #16

  subs r1,r0,#0x80000
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5160:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#2 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r0,r0,asl #16

  subs r1,r0,#0x80000
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5168:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r0,r0,asl #16

  subs r1,r0,#0x80000
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5170:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r0,r0,asl #16

  subs r1,r0,#0x80000
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5178:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r0,r0,asl #16

  subs r1,r0,#0x80000
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5179:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  mov r0,r0,asl #16

  subs r1,r0,#0x80000
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5180:
;
  and r11,r8,#0x000f
;
  ldr r0,[r7,r11,lsl #2]

  subs r1,r0,#0x0008
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  str r1,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5188:
;
  and r11,r8,#0x000f
;
  ldr r0,[r7,r11,lsl #2]

  subs r1,r0,#0x0008

;
  str r1,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5190:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

  subs r1,r0,#0x0008
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5198:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#4 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

  subs r1,r0,#0x0008
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op51a0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#4 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

  subs r1,r0,#0x0008
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op51a8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

  subs r1,r0,#0x0008
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op51b0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

  subs r1,r0,#0x0008
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#26 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op51b8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

  subs r1,r0,#0x0008
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op51b9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

  subs r1,r0,#0x0008
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#28 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op51c0:
  mov r1,#0

;
  and r0,r8,#0x000f
;
  strb r1,[r7,r0,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op51d0:
  str r5,[r7,#0x5c] ;

  mov r1,#0

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op51d8:
  str r5,[r7,#0x5c] ;

  mov r1,#0

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op51df:
  str r5,[r7,#0x5c] ;

  mov r1,#0

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op51e0:
  str r5,[r7,#0x5c] ;

  mov r1,#0

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op51e7:
  str r5,[r7,#0x5c] ;

  mov r1,#0

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op51e8:
  str r5,[r7,#0x5c] ;

  mov r1,#0

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op51f0:
  str r5,[r7,#0x5c] ;

  mov r1,#0

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op51f8:
  str r5,[r7,#0x5c] ;

  mov r1,#0

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op51f9:
  str r5,[r7,#0x5c] ;

  mov r1,#0

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op52c0:
  mov r1,#0
  tst r10,#0x60000000 ;
  mvneq r1,r1
  subeq r5,r5,#2 ;

;
  and r0,r8,#0x000f
;
  strb r1,[r7,r0,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op52c8:
  tst r10,#0x60000000 ;
  beq DbraTrue

;
  and r1,r8,#0x0007
  mov r1,r1,lsl #2
  ldrsh r0,[r7,r1]
  sub r0,r0,#1
  strh r0,[r7,r1]

;
  cmn r0,#1
  beq DbraMin1

;
  ldrsh r0,[r4]
  add r0,r4,r0 ;
;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4
  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op52d0:
  str r5,[r7,#0x5c] ;

  mov r1,#0
  tst r10,#0x60000000 ;
  mvneq r1,r1

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op52d8:
  str r5,[r7,#0x5c] ;

  mov r1,#0
  tst r10,#0x60000000 ;
  mvneq r1,r1

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op52df:
  str r5,[r7,#0x5c] ;

  mov r1,#0
  tst r10,#0x60000000 ;
  mvneq r1,r1

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op52e0:
  str r5,[r7,#0x5c] ;

  mov r1,#0
  tst r10,#0x60000000 ;
  mvneq r1,r1

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op52e7:
  str r5,[r7,#0x5c] ;

  mov r1,#0
  tst r10,#0x60000000 ;
  mvneq r1,r1

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op52e8:
  str r5,[r7,#0x5c] ;

  mov r1,#0
  tst r10,#0x60000000 ;
  mvneq r1,r1

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op52f0:
  str r5,[r7,#0x5c] ;

  mov r1,#0
  tst r10,#0x60000000 ;
  mvneq r1,r1

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op52f8:
  str r5,[r7,#0x5c] ;

  mov r1,#0
  tst r10,#0x60000000 ;
  mvneq r1,r1

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op52f9:
  str r5,[r7,#0x5c] ;

  mov r1,#0
  tst r10,#0x60000000 ;
  mvneq r1,r1

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op53c0:
  mov r1,#0
  tst r10,#0x60000000 ;
  mvnne r1,r1
  subne r5,r5,#2 ;

;
  and r0,r8,#0x000f
;
  strb r1,[r7,r0,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op53c8:
  tst r10,#0x60000000 ;
  bne DbraTrue

;
  and r1,r8,#0x0007
  mov r1,r1,lsl #2
  ldrsh r0,[r7,r1]
  sub r0,r0,#1
  strh r0,[r7,r1]

;
  cmn r0,#1
  beq DbraMin1

;
  ldrsh r0,[r4]
  add r0,r4,r0 ;
;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4
  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op53d0:
  str r5,[r7,#0x5c] ;

  mov r1,#0
  tst r10,#0x60000000 ;
  mvnne r1,r1

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op53d8:
  str r5,[r7,#0x5c] ;

  mov r1,#0
  tst r10,#0x60000000 ;
  mvnne r1,r1

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op53df:
  str r5,[r7,#0x5c] ;

  mov r1,#0
  tst r10,#0x60000000 ;
  mvnne r1,r1

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op53e0:
  str r5,[r7,#0x5c] ;

  mov r1,#0
  tst r10,#0x60000000 ;
  mvnne r1,r1

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op53e7:
  str r5,[r7,#0x5c] ;

  mov r1,#0
  tst r10,#0x60000000 ;
  mvnne r1,r1

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op53e8:
  str r5,[r7,#0x5c] ;

  mov r1,#0
  tst r10,#0x60000000 ;
  mvnne r1,r1

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op53f0:
  str r5,[r7,#0x5c] ;

  mov r1,#0
  tst r10,#0x60000000 ;
  mvnne r1,r1

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op53f8:
  str r5,[r7,#0x5c] ;

  mov r1,#0
  tst r10,#0x60000000 ;
  mvnne r1,r1

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op53f9:
  str r5,[r7,#0x5c] ;

  mov r1,#0
  tst r10,#0x60000000 ;
  mvnne r1,r1

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op54c0:
  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvncc r1,r1
  subcc r5,r5,#2 ;

;
  and r0,r8,#0x000f
;
  strb r1,[r7,r0,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op54c8:
;
  msr cpsr_flg,r10 ;
;
  bcc DbraTrue

;
  and r1,r8,#0x0007
  mov r1,r1,lsl #2
  ldrsh r0,[r7,r1]
  sub r0,r0,#1
  strh r0,[r7,r1]

;
  cmn r0,#1
  beq DbraMin1

;
  ldrsh r0,[r4]
  add r0,r4,r0 ;
;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4
  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op54d0:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvncc r1,r1

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op54d8:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvncc r1,r1

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op54df:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvncc r1,r1

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op54e0:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvncc r1,r1

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op54e7:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvncc r1,r1

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op54e8:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvncc r1,r1

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op54f0:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvncc r1,r1

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op54f8:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvncc r1,r1

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op54f9:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvncc r1,r1

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op55c0:
  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvncs r1,r1
  subcs r5,r5,#2 ;

;
  and r0,r8,#0x000f
;
  strb r1,[r7,r0,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op55c8:
;
  msr cpsr_flg,r10 ;
;
  bcs DbraTrue

;
  and r1,r8,#0x0007
  mov r1,r1,lsl #2
  ldrsh r0,[r7,r1]
  sub r0,r0,#1
  strh r0,[r7,r1]

;
  cmn r0,#1
  beq DbraMin1

;
  ldrsh r0,[r4]
  add r0,r4,r0 ;
;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4
  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op55d0:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvncs r1,r1

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op55d8:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvncs r1,r1

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op55df:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvncs r1,r1

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op55e0:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvncs r1,r1

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op55e7:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvncs r1,r1

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op55e8:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvncs r1,r1

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op55f0:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvncs r1,r1

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op55f8:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvncs r1,r1

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op55f9:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvncs r1,r1

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op56c0:
  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnne r1,r1
  subne r5,r5,#2 ;

;
  and r0,r8,#0x000f
;
  strb r1,[r7,r0,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op56c8:
;
  msr cpsr_flg,r10 ;
;
  bne DbraTrue

;
  and r1,r8,#0x0007
  mov r1,r1,lsl #2
  ldrsh r0,[r7,r1]
  sub r0,r0,#1
  strh r0,[r7,r1]

;
  cmn r0,#1
  beq DbraMin1

;
  ldrsh r0,[r4]
  add r0,r4,r0 ;
;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4
  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op56d0:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnne r1,r1

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op56d8:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnne r1,r1

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op56df:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnne r1,r1

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op56e0:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnne r1,r1

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op56e7:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnne r1,r1

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op56e8:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnne r1,r1

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op56f0:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnne r1,r1

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op56f8:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnne r1,r1

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op56f9:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnne r1,r1

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op57c0:
  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvneq r1,r1
  subeq r5,r5,#2 ;

;
  and r0,r8,#0x000f
;
  strb r1,[r7,r0,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op57c8:
;
  msr cpsr_flg,r10 ;
;
  beq DbraTrue

;
  and r1,r8,#0x0007
  mov r1,r1,lsl #2
  ldrsh r0,[r7,r1]
  sub r0,r0,#1
  strh r0,[r7,r1]

;
  cmn r0,#1
  beq DbraMin1

;
  ldrsh r0,[r4]
  add r0,r4,r0 ;
;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4
  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op57d0:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvneq r1,r1

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op57d8:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvneq r1,r1

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op57df:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvneq r1,r1

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op57e0:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvneq r1,r1

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op57e7:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvneq r1,r1

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op57e8:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvneq r1,r1

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op57f0:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvneq r1,r1

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op57f8:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvneq r1,r1

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op57f9:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvneq r1,r1

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op58c0:
  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnvc r1,r1
  subvc r5,r5,#2 ;

;
  and r0,r8,#0x000f
;
  strb r1,[r7,r0,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op58c8:
;
  msr cpsr_flg,r10 ;
;
  bvc DbraTrue

;
  and r1,r8,#0x0007
  mov r1,r1,lsl #2
  ldrsh r0,[r7,r1]
  sub r0,r0,#1
  strh r0,[r7,r1]

;
  cmn r0,#1
  beq DbraMin1

;
  ldrsh r0,[r4]
  add r0,r4,r0 ;
;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4
  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op58d0:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnvc r1,r1

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op58d8:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnvc r1,r1

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op58df:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnvc r1,r1

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op58e0:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnvc r1,r1

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op58e7:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnvc r1,r1

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op58e8:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnvc r1,r1

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op58f0:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnvc r1,r1

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op58f8:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnvc r1,r1

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op58f9:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnvc r1,r1

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op59c0:
  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnvs r1,r1
  subvs r5,r5,#2 ;

;
  and r0,r8,#0x000f
;
  strb r1,[r7,r0,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op59c8:
;
  msr cpsr_flg,r10 ;
;
  bvs DbraTrue

;
  and r1,r8,#0x0007
  mov r1,r1,lsl #2
  ldrsh r0,[r7,r1]
  sub r0,r0,#1
  strh r0,[r7,r1]

;
  cmn r0,#1
  beq DbraMin1

;
  ldrsh r0,[r4]
  add r0,r4,r0 ;
;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4
  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op59d0:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnvs r1,r1

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op59d8:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnvs r1,r1

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op59df:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnvs r1,r1

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op59e0:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnvs r1,r1

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op59e7:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnvs r1,r1

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op59e8:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnvs r1,r1

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op59f0:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnvs r1,r1

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op59f8:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnvs r1,r1

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op59f9:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnvs r1,r1

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5ac0:
  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnpl r1,r1
  subpl r5,r5,#2 ;

;
  and r0,r8,#0x000f
;
  strb r1,[r7,r0,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5ac8:
;
  msr cpsr_flg,r10 ;
;
  bpl DbraTrue

;
  and r1,r8,#0x0007
  mov r1,r1,lsl #2
  ldrsh r0,[r7,r1]
  sub r0,r0,#1
  strh r0,[r7,r1]

;
  cmn r0,#1
  beq DbraMin1

;
  ldrsh r0,[r4]
  add r0,r4,r0 ;
;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4
  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5ad0:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnpl r1,r1

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5ad8:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnpl r1,r1

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5adf:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnpl r1,r1

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5ae0:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnpl r1,r1

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5ae7:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnpl r1,r1

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5ae8:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnpl r1,r1

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5af0:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnpl r1,r1

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5af8:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnpl r1,r1

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5af9:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnpl r1,r1

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5bc0:
  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnmi r1,r1
  submi r5,r5,#2 ;

;
  and r0,r8,#0x000f
;
  strb r1,[r7,r0,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5bc8:
;
  msr cpsr_flg,r10 ;
;
  bmi DbraTrue

;
  and r1,r8,#0x0007
  mov r1,r1,lsl #2
  ldrsh r0,[r7,r1]
  sub r0,r0,#1
  strh r0,[r7,r1]

;
  cmn r0,#1
  beq DbraMin1

;
  ldrsh r0,[r4]
  add r0,r4,r0 ;
;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4
  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5bd0:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnmi r1,r1

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5bd8:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnmi r1,r1

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5bdf:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnmi r1,r1

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5be0:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnmi r1,r1

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5be7:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnmi r1,r1

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5be8:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnmi r1,r1

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5bf0:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnmi r1,r1

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5bf8:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnmi r1,r1

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5bf9:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnmi r1,r1

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5cc0:
  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnge r1,r1
  subge r5,r5,#2 ;

;
  and r0,r8,#0x000f
;
  strb r1,[r7,r0,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5cc8:
;
  msr cpsr_flg,r10 ;
;
  bge DbraTrue

;
  and r1,r8,#0x0007
  mov r1,r1,lsl #2
  ldrsh r0,[r7,r1]
  sub r0,r0,#1
  strh r0,[r7,r1]

;
  cmn r0,#1
  beq DbraMin1

;
  ldrsh r0,[r4]
  add r0,r4,r0 ;
;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4
  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5cd0:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnge r1,r1

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5cd8:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnge r1,r1

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5cdf:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnge r1,r1

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5ce0:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnge r1,r1

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5ce7:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnge r1,r1

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5ce8:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnge r1,r1

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5cf0:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnge r1,r1

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5cf8:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnge r1,r1

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5cf9:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnge r1,r1

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5dc0:
  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnlt r1,r1
  sublt r5,r5,#2 ;

;
  and r0,r8,#0x000f
;
  strb r1,[r7,r0,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5dc8:
;
  msr cpsr_flg,r10 ;
;
  blt DbraTrue

;
  and r1,r8,#0x0007
  mov r1,r1,lsl #2
  ldrsh r0,[r7,r1]
  sub r0,r0,#1
  strh r0,[r7,r1]

;
  cmn r0,#1
  beq DbraMin1

;
  ldrsh r0,[r4]
  add r0,r4,r0 ;
;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4
  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5dd0:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnlt r1,r1

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5dd8:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnlt r1,r1

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5ddf:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnlt r1,r1

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5de0:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnlt r1,r1

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5de7:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnlt r1,r1

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5de8:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnlt r1,r1

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5df0:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnlt r1,r1

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5df8:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnlt r1,r1

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5df9:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnlt r1,r1

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5e00:
;
  and r11,r8,#0x000f
;
  ldr r0,[r7,r11,lsl #2]

  and r2,r8,#0x0e00 ;

  mov r0,r0,asl #24

  adds r1,r0,r2,lsl #15
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  strb r1,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5e10:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  and r2,r8,#0x0e00 ;

  mov r0,r0,asl #24

  adds r1,r0,r2,lsl #15
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5e18:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#1 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  and r2,r8,#0x0e00 ;

  mov r0,r0,asl #24

  adds r1,r0,r2,lsl #15
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5e1f:
  str r5,[r7,#0x5c] ;

;
  ldr r11,[r7,#0x3c] ;
  add r3,r11,#2 ;
  str r3,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  and r2,r8,#0x0e00 ;

  mov r0,r0,asl #24

  adds r1,r0,r2,lsl #15
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5e20:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#1 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  and r2,r8,#0x0e00 ;

  mov r0,r0,asl #24

  adds r1,r0,r2,lsl #15
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5e27:
  str r5,[r7,#0x5c] ;

;
  ldr r11,[r7,#0x3c] ;
  sub r11,r11,#2 ;
  str r11,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  and r2,r8,#0x0e00 ;

  mov r0,r0,asl #24

  adds r1,r0,r2,lsl #15
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5e28:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  and r2,r8,#0x0e00 ;

  mov r0,r0,asl #24

  adds r1,r0,r2,lsl #15
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5e30:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  and r2,r8,#0x0e00 ;

  mov r0,r0,asl #24

  adds r1,r0,r2,lsl #15
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5e38:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  and r2,r8,#0x0e00 ;

  mov r0,r0,asl #24

  adds r1,r0,r2,lsl #15
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5e39:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  and r2,r8,#0x0e00 ;

  mov r0,r0,asl #24

  adds r1,r0,r2,lsl #15
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5e48:
;
  and r11,r8,#0x000f
;
  ldr r0,[r7,r11,lsl #2]

  and r2,r8,#0x0e00 ;

  adds r1,r0,r2,lsr #9

;
  str r1,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5e50:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  and r2,r8,#0x0e00 ;

  mov r0,r0,asl #16

  adds r1,r0,r2,lsl #7
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5e58:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#2 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  and r2,r8,#0x0e00 ;

  mov r0,r0,asl #16

  adds r1,r0,r2,lsl #7
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5e60:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#2 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  and r2,r8,#0x0e00 ;

  mov r0,r0,asl #16

  adds r1,r0,r2,lsl #7
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5e68:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  and r2,r8,#0x0e00 ;

  mov r0,r0,asl #16

  adds r1,r0,r2,lsl #7
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5e70:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  and r2,r8,#0x0e00 ;

  mov r0,r0,asl #16

  adds r1,r0,r2,lsl #7
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5e78:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  and r2,r8,#0x0e00 ;

  mov r0,r0,asl #16

  adds r1,r0,r2,lsl #7
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5e79:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  and r2,r8,#0x0e00 ;

  mov r0,r0,asl #16

  adds r1,r0,r2,lsl #7
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5e80:
;
  and r11,r8,#0x000f
;
  ldr r0,[r7,r11,lsl #2]

  and r2,r8,#0x0e00 ;

  adds r1,r0,r2,lsr #9
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  str r1,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5e88:
;
  and r11,r8,#0x000f
;
  ldr r0,[r7,r11,lsl #2]

  and r2,r8,#0x0e00 ;

  adds r1,r0,r2,lsr #9

;
  str r1,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5e90:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

  and r2,r8,#0x0e00 ;

  adds r1,r0,r2,lsr #9
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5e98:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#4 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

  and r2,r8,#0x0e00 ;

  adds r1,r0,r2,lsr #9
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5ea0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#4 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

  and r2,r8,#0x0e00 ;

  adds r1,r0,r2,lsr #9
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5ea8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

  and r2,r8,#0x0e00 ;

  adds r1,r0,r2,lsr #9
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5eb0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

  and r2,r8,#0x0e00 ;

  adds r1,r0,r2,lsr #9
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#26 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5eb8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

  and r2,r8,#0x0e00 ;

  adds r1,r0,r2,lsr #9
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5eb9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

  and r2,r8,#0x0e00 ;

  adds r1,r0,r2,lsr #9
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#28 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5ec0:
  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvngt r1,r1
  subgt r5,r5,#2 ;

;
  and r0,r8,#0x000f
;
  strb r1,[r7,r0,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5ec8:
;
  msr cpsr_flg,r10 ;
;
  bgt DbraTrue

;
  and r1,r8,#0x0007
  mov r1,r1,lsl #2
  ldrsh r0,[r7,r1]
  sub r0,r0,#1
  strh r0,[r7,r1]

;
  cmn r0,#1
  beq DbraMin1

;
  ldrsh r0,[r4]
  add r0,r4,r0 ;
;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4
  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5ed0:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvngt r1,r1

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5ed8:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvngt r1,r1

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5edf:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvngt r1,r1

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5ee0:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvngt r1,r1

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5ee7:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvngt r1,r1

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5ee8:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvngt r1,r1

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5ef0:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvngt r1,r1

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5ef8:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvngt r1,r1

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5ef9:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvngt r1,r1

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5f00:
;
  and r11,r8,#0x000f
;
  ldr r0,[r7,r11,lsl #2]

  and r2,r8,#0x0e00 ;

  mov r0,r0,asl #24

  subs r1,r0,r2,lsl #15
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  strb r1,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5f10:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  and r2,r8,#0x0e00 ;

  mov r0,r0,asl #24

  subs r1,r0,r2,lsl #15
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5f18:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#1 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  and r2,r8,#0x0e00 ;

  mov r0,r0,asl #24

  subs r1,r0,r2,lsl #15
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5f1f:
  str r5,[r7,#0x5c] ;

;
  ldr r11,[r7,#0x3c] ;
  add r3,r11,#2 ;
  str r3,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  and r2,r8,#0x0e00 ;

  mov r0,r0,asl #24

  subs r1,r0,r2,lsl #15
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5f20:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#1 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  and r2,r8,#0x0e00 ;

  mov r0,r0,asl #24

  subs r1,r0,r2,lsl #15
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5f27:
  str r5,[r7,#0x5c] ;

;
  ldr r11,[r7,#0x3c] ;
  sub r11,r11,#2 ;
  str r11,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  and r2,r8,#0x0e00 ;

  mov r0,r0,asl #24

  subs r1,r0,r2,lsl #15
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5f28:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  and r2,r8,#0x0e00 ;

  mov r0,r0,asl #24

  subs r1,r0,r2,lsl #15
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5f30:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  and r2,r8,#0x0e00 ;

  mov r0,r0,asl #24

  subs r1,r0,r2,lsl #15
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5f38:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  and r2,r8,#0x0e00 ;

  mov r0,r0,asl #24

  subs r1,r0,r2,lsl #15
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5f39:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  and r2,r8,#0x0e00 ;

  mov r0,r0,asl #24

  subs r1,r0,r2,lsl #15
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5f40:
;
  and r11,r8,#0x000f
  mov r11,r11,lsl #2
;
  ldr r0,[r7,r11]

  and r2,r8,#0x0e00 ;

  mov r0,r0,asl #16

  subs r1,r0,r2,lsl #7
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5f48:
;
  and r11,r8,#0x000f
;
  ldr r0,[r7,r11,lsl #2]

  and r2,r8,#0x0e00 ;

  subs r1,r0,r2,lsr #9

;
  str r1,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5f50:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  and r2,r8,#0x0e00 ;

  mov r0,r0,asl #16

  subs r1,r0,r2,lsl #7
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5f58:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#2 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  and r2,r8,#0x0e00 ;

  mov r0,r0,asl #16

  subs r1,r0,r2,lsl #7
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5f60:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#2 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  and r2,r8,#0x0e00 ;

  mov r0,r0,asl #16

  subs r1,r0,r2,lsl #7
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5f68:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  and r2,r8,#0x0e00 ;

  mov r0,r0,asl #16

  subs r1,r0,r2,lsl #7
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5f70:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  and r2,r8,#0x0e00 ;

  mov r0,r0,asl #16

  subs r1,r0,r2,lsl #7
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5f78:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  and r2,r8,#0x0e00 ;

  mov r0,r0,asl #16

  subs r1,r0,r2,lsl #7
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5f79:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

  and r2,r8,#0x0e00 ;

  mov r0,r0,asl #16

  subs r1,r0,r2,lsl #7
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5f80:
;
  and r11,r8,#0x000f
;
  ldr r0,[r7,r11,lsl #2]

  and r2,r8,#0x0e00 ;

  subs r1,r0,r2,lsr #9
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  str r1,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5f88:
;
  and r11,r8,#0x000f
;
  ldr r0,[r7,r11,lsl #2]

  and r2,r8,#0x0e00 ;

  subs r1,r0,r2,lsr #9

;
  str r1,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5f90:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

  and r2,r8,#0x0e00 ;

  subs r1,r0,r2,lsr #9
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5f98:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#4 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

  and r2,r8,#0x0e00 ;

  subs r1,r0,r2,lsr #9
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5fa0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#4 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

  and r2,r8,#0x0e00 ;

  subs r1,r0,r2,lsr #9
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5fa8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

  and r2,r8,#0x0e00 ;

  subs r1,r0,r2,lsr #9
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5fb0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

  and r2,r8,#0x0e00 ;

  subs r1,r0,r2,lsr #9
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#26 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5fb8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

  and r2,r8,#0x0e00 ;

  subs r1,r0,r2,lsr #9
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5fb9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

  and r2,r8,#0x0e00 ;

  subs r1,r0,r2,lsr #9
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#28 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5fc0:
  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnle r1,r1
  suble r5,r5,#2 ;

;
  and r0,r8,#0x000f
;
  strb r1,[r7,r0,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5fc8:
;
  msr cpsr_flg,r10 ;
;
  ble DbraTrue

;
  and r1,r8,#0x0007
  mov r1,r1,lsl #2
  ldrsh r0,[r7,r1]
  sub r0,r0,#1
  strh r0,[r7,r1]

;
  cmn r0,#1
  beq DbraMin1

;
  ldrsh r0,[r4]
  add r0,r4,r0 ;
;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4
  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5fd0:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnle r1,r1

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5fd8:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnle r1,r1

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5fdf:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnle r1,r1

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5fe0:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnle r1,r1

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5fe7:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnle r1,r1

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5fe8:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnle r1,r1

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5ff0:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnle r1,r1

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5ff8:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnle r1,r1

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op5ff9:
  str r5,[r7,#0x5c] ;

  mov r1,#0
;
  msr cpsr_flg,r10 ;
  mvnle r1,r1

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op6000:
  str r5,[r7,#0x5c] ;

  ldrsh r11,[r4] ;
;
  add r0,r4,r11 ;
;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op6200:
  str r5,[r7,#0x5c] ;

  tst r10,#0x60000000 ;
  bne BccDontBranch16

  ldrsh r11,[r4] ;
;
  add r0,r4,r11 ;
;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op6201:
  tst r10,#0x60000000 ;
  bne BccDontBranch8

  mov r11,r8,asl #24 ;

;
  add r0,r4,r11,asr #24 ;
  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op6300:
  str r5,[r7,#0x5c] ;

  tst r10,#0x60000000 ;
  beq BccDontBranch16

  ldrsh r11,[r4] ;
;
  add r0,r4,r11 ;
;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op6301:
  tst r10,#0x60000000 ;
  beq BccDontBranch8

  mov r11,r8,asl #24 ;

;
  add r0,r4,r11,asr #24 ;
  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op6400:
  str r5,[r7,#0x5c] ;

;
  msr cpsr_flg,r10 ;
  bcs BccDontBranch16

  ldrsh r11,[r4] ;
;
  add r0,r4,r11 ;
;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op6600:
  str r5,[r7,#0x5c] ;

;
  msr cpsr_flg,r10 ;
  beq BccDontBranch16

  ldrsh r11,[r4] ;
;
  add r0,r4,r11 ;
;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op6800:
  str r5,[r7,#0x5c] ;

;
  msr cpsr_flg,r10 ;
  bvs BccDontBranch16

  ldrsh r11,[r4] ;
;
  add r0,r4,r11 ;
;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op6801:
;
  msr cpsr_flg,r10 ;
  bvs BccDontBranch8

  mov r11,r8,asl #24 ;

;
  add r0,r4,r11,asr #24 ;
  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op6900:
  str r5,[r7,#0x5c] ;

;
  msr cpsr_flg,r10 ;
  bvc BccDontBranch16

  ldrsh r11,[r4] ;
;
  add r0,r4,r11 ;
;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op6901:
;
  msr cpsr_flg,r10 ;
  bvc BccDontBranch8

  mov r11,r8,asl #24 ;

;
  add r0,r4,r11,asr #24 ;
  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op6a00:
  str r5,[r7,#0x5c] ;

;
  msr cpsr_flg,r10 ;
  bmi BccDontBranch16

  ldrsh r11,[r4] ;
;
  add r0,r4,r11 ;
;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op6b00:
  str r5,[r7,#0x5c] ;

;
  msr cpsr_flg,r10 ;
  bpl BccDontBranch16

  ldrsh r11,[r4] ;
;
  add r0,r4,r11 ;
;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op6b01:
;
  msr cpsr_flg,r10 ;
  bpl BccDontBranch8

  mov r11,r8,asl #24 ;

;
  add r0,r4,r11,asr #24 ;
  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op6c00:
  str r5,[r7,#0x5c] ;

;
  msr cpsr_flg,r10 ;
  blt BccDontBranch16

  ldrsh r11,[r4] ;
;
  add r0,r4,r11 ;
;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op6c01:
;
  msr cpsr_flg,r10 ;
  blt BccDontBranch8

  mov r11,r8,asl #24 ;

;
  add r0,r4,r11,asr #24 ;
  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op6d00:
  str r5,[r7,#0x5c] ;

;
  msr cpsr_flg,r10 ;
  bge BccDontBranch16

  ldrsh r11,[r4] ;
;
  add r0,r4,r11 ;
;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op6d01:
;
  msr cpsr_flg,r10 ;
  bge BccDontBranch8

  mov r11,r8,asl #24 ;

;
  add r0,r4,r11,asr #24 ;
  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op6e00:
  str r5,[r7,#0x5c] ;

;
  msr cpsr_flg,r10 ;
  ble BccDontBranch16

  ldrsh r11,[r4] ;
;
  add r0,r4,r11 ;
;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op6e01:
;
  msr cpsr_flg,r10 ;
  ble BccDontBranch8

  mov r11,r8,asl #24 ;

;
  add r0,r4,r11,asr #24 ;
  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op6f00:
  str r5,[r7,#0x5c] ;

;
  msr cpsr_flg,r10 ;
  bgt BccDontBranch16

  ldrsh r11,[r4] ;
;
  add r0,r4,r11 ;
;
  mov lr,pc
  ldr pc,[r7,#0x64] ;

  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op6f01:
;
  msr cpsr_flg,r10 ;
  bgt BccDontBranch8

  mov r11,r8,asl #24 ;

;
  add r0,r4,r11,asr #24 ;
  mov r4,r0
  tst r4,#1 ;
  bne ExceptionAddressError_r_prg_r4

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op8000:
;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  orr r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op8010:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  orr r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op8018:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  orr r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op801f:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  orr r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op8020:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  orr r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op8027:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  orr r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op8028:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  orr r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op8030:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  orr r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op8038:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  orr r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op8039:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  orr r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op803a:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x80] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  orr r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op803b:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x80] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  orr r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op803c:
;
  ldrsb r0,[r4],#2 ;
;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  orr r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op8040:
;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  orr r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op8050:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  orr r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op8058:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#2 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  orr r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op8060:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#2 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  orr r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op8068:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  orr r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op8070:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  orr r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op8078:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  orr r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op8079:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  orr r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op807a:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  orr r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op807b:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  orr r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op807c:
;
  ldrsh r0,[r4],#2 ;
;

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  orr r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op8080:
;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  orr r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op8090:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  orr r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op8098:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#4 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  orr r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op80a0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#4 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  orr r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op80a8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  orr r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op80b0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  orr r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op80b8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  orr r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op80b9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  orr r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op80ba:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x88] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  orr r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op80bb:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x88] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  orr r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op80bc:
;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r0,r3,r2,lsl #16
;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  orr r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op80c0:
;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
  beq divzero80c0 ;

  mov r0,r1,lsr #16 ;

;
  mov r3,#0
  mov r1,r0

;
Shift80c0:
  cmp r1,r2,lsr #1
  movls r1,r1,lsl #1
  bcc Shift80c0

Divide80c0:
  cmp r2,r1
  adc r3,r3,r3 ;
  subcs r2,r2,r1
  teq r1,r0
  movne r1,r1,lsr #1
  bne Divide80c0

;
  movs r1,r3,lsr #16 ;
  orrne r10,r10,#0x10000000 ;
  bne endofop80c0 ;

  mov r1,r3,lsl #16 ;
  adds r1,r1,#0 ;
  mrs r10,cpsr ;
  mov r1,r1,lsr #16
  orr r1,r1,r2,lsl #16 ;

;
  str r1,[r7,r11,lsr #7]

endofop80c0:
  ldrh r8,[r4],#2 ;
  subs r5,r5,#140 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

divzero80c0:
  mov r0,#5 ;
  bl Exception
  ldrh r8,[r4],#2 ;
  subs r5,r5,#178 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op80d0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
  beq divzero80d0 ;

  mov r0,r1,lsr #16 ;

;
  mov r3,#0
  mov r1,r0

;
Shift80d0:
  cmp r1,r2,lsr #1
  movls r1,r1,lsl #1
  bcc Shift80d0

Divide80d0:
  cmp r2,r1
  adc r3,r3,r3 ;
  subcs r2,r2,r1
  teq r1,r0
  movne r1,r1,lsr #1
  bne Divide80d0

;
  movs r1,r3,lsr #16 ;
  orrne r10,r10,#0x10000000 ;
  bne endofop80d0 ;

  mov r1,r3,lsl #16 ;
  adds r1,r1,#0 ;
  mrs r10,cpsr ;
  mov r1,r1,lsr #16
  orr r1,r1,r2,lsl #16 ;

;
  str r1,[r7,r11,lsr #7]

endofop80d0:
  ldrh r8,[r4],#2 ;
  subs r5,r5,#144 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

divzero80d0:
  mov r0,#5 ;
  bl Exception
  ldrh r8,[r4],#2 ;
  subs r5,r5,#182 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op80d8:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#2 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
  beq divzero80d8 ;

  mov r0,r1,lsr #16 ;

;
  mov r3,#0
  mov r1,r0

;
Shift80d8:
  cmp r1,r2,lsr #1
  movls r1,r1,lsl #1
  bcc Shift80d8

Divide80d8:
  cmp r2,r1
  adc r3,r3,r3 ;
  subcs r2,r2,r1
  teq r1,r0
  movne r1,r1,lsr #1
  bne Divide80d8

;
  movs r1,r3,lsr #16 ;
  orrne r10,r10,#0x10000000 ;
  bne endofop80d8 ;

  mov r1,r3,lsl #16 ;
  adds r1,r1,#0 ;
  mrs r10,cpsr ;
  mov r1,r1,lsr #16
  orr r1,r1,r2,lsl #16 ;

;
  str r1,[r7,r11,lsr #7]

endofop80d8:
  ldrh r8,[r4],#2 ;
  subs r5,r5,#144 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

divzero80d8:
  mov r0,#5 ;
  bl Exception
  ldrh r8,[r4],#2 ;
  subs r5,r5,#182 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op80e0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#2 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
  beq divzero80e0 ;

  mov r0,r1,lsr #16 ;

;
  mov r3,#0
  mov r1,r0

;
Shift80e0:
  cmp r1,r2,lsr #1
  movls r1,r1,lsl #1
  bcc Shift80e0

Divide80e0:
  cmp r2,r1
  adc r3,r3,r3 ;
  subcs r2,r2,r1
  teq r1,r0
  movne r1,r1,lsr #1
  bne Divide80e0

;
  movs r1,r3,lsr #16 ;
  orrne r10,r10,#0x10000000 ;
  bne endofop80e0 ;

  mov r1,r3,lsl #16 ;
  adds r1,r1,#0 ;
  mrs r10,cpsr ;
  mov r1,r1,lsr #16
  orr r1,r1,r2,lsl #16 ;

;
  str r1,[r7,r11,lsr #7]

endofop80e0:
  ldrh r8,[r4],#2 ;
  subs r5,r5,#146 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

divzero80e0:
  mov r0,#5 ;
  bl Exception
  ldrh r8,[r4],#2 ;
  subs r5,r5,#184 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op80e8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
  beq divzero80e8 ;

  mov r0,r1,lsr #16 ;

;
  mov r3,#0
  mov r1,r0

;
Shift80e8:
  cmp r1,r2,lsr #1
  movls r1,r1,lsl #1
  bcc Shift80e8

Divide80e8:
  cmp r2,r1
  adc r3,r3,r3 ;
  subcs r2,r2,r1
  teq r1,r0
  movne r1,r1,lsr #1
  bne Divide80e8

;
  movs r1,r3,lsr #16 ;
  orrne r10,r10,#0x10000000 ;
  bne endofop80e8 ;

  mov r1,r3,lsl #16 ;
  adds r1,r1,#0 ;
  mrs r10,cpsr ;
  mov r1,r1,lsr #16
  orr r1,r1,r2,lsl #16 ;

;
  str r1,[r7,r11,lsr #7]

endofop80e8:
  ldrh r8,[r4],#2 ;
  subs r5,r5,#148 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

divzero80e8:
  mov r0,#5 ;
  bl Exception
  ldrh r8,[r4],#2 ;
  subs r5,r5,#186 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op80f0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
  beq divzero80f0 ;

  mov r0,r1,lsr #16 ;

;
  mov r3,#0
  mov r1,r0

;
Shift80f0:
  cmp r1,r2,lsr #1
  movls r1,r1,lsl #1
  bcc Shift80f0

Divide80f0:
  cmp r2,r1
  adc r3,r3,r3 ;
  subcs r2,r2,r1
  teq r1,r0
  movne r1,r1,lsr #1
  bne Divide80f0

;
  movs r1,r3,lsr #16 ;
  orrne r10,r10,#0x10000000 ;
  bne endofop80f0 ;

  mov r1,r3,lsl #16 ;
  adds r1,r1,#0 ;
  mrs r10,cpsr ;
  mov r1,r1,lsr #16
  orr r1,r1,r2,lsl #16 ;

;
  str r1,[r7,r11,lsr #7]

endofop80f0:
  ldrh r8,[r4],#2 ;
  subs r5,r5,#150 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

divzero80f0:
  mov r0,#5 ;
  bl Exception
  ldrh r8,[r4],#2 ;
  subs r5,r5,#188 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op80f8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
  beq divzero80f8 ;

  mov r0,r1,lsr #16 ;

;
  mov r3,#0
  mov r1,r0

;
Shift80f8:
  cmp r1,r2,lsr #1
  movls r1,r1,lsl #1
  bcc Shift80f8

Divide80f8:
  cmp r2,r1
  adc r3,r3,r3 ;
  subcs r2,r2,r1
  teq r1,r0
  movne r1,r1,lsr #1
  bne Divide80f8

;
  movs r1,r3,lsr #16 ;
  orrne r10,r10,#0x10000000 ;
  bne endofop80f8 ;

  mov r1,r3,lsl #16 ;
  adds r1,r1,#0 ;
  mrs r10,cpsr ;
  mov r1,r1,lsr #16
  orr r1,r1,r2,lsl #16 ;

;
  str r1,[r7,r11,lsr #7]

endofop80f8:
  ldrh r8,[r4],#2 ;
  subs r5,r5,#148 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

divzero80f8:
  mov r0,#5 ;
  bl Exception
  ldrh r8,[r4],#2 ;
  subs r5,r5,#186 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op80f9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
  beq divzero80f9 ;

  mov r0,r1,lsr #16 ;

;
  mov r3,#0
  mov r1,r0

;
Shift80f9:
  cmp r1,r2,lsr #1
  movls r1,r1,lsl #1
  bcc Shift80f9

Divide80f9:
  cmp r2,r1
  adc r3,r3,r3 ;
  subcs r2,r2,r1
  teq r1,r0
  movne r1,r1,lsr #1
  bne Divide80f9

;
  movs r1,r3,lsr #16 ;
  orrne r10,r10,#0x10000000 ;
  bne endofop80f9 ;

  mov r1,r3,lsl #16 ;
  adds r1,r1,#0 ;
  mrs r10,cpsr ;
  mov r1,r1,lsr #16
  orr r1,r1,r2,lsl #16 ;

;
  str r1,[r7,r11,lsr #7]

endofop80f9:
  ldrh r8,[r4],#2 ;
  subs r5,r5,#152 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

divzero80f9:
  mov r0,#5 ;
  bl Exception
  ldrh r8,[r4],#2 ;
  subs r5,r5,#190 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op80fa:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
  beq divzero80fa ;

  mov r0,r1,lsr #16 ;

;
  mov r3,#0
  mov r1,r0

;
Shift80fa:
  cmp r1,r2,lsr #1
  movls r1,r1,lsl #1
  bcc Shift80fa

Divide80fa:
  cmp r2,r1
  adc r3,r3,r3 ;
  subcs r2,r2,r1
  teq r1,r0
  movne r1,r1,lsr #1
  bne Divide80fa

;
  movs r1,r3,lsr #16 ;
  orrne r10,r10,#0x10000000 ;
  bne endofop80fa ;

  mov r1,r3,lsl #16 ;
  adds r1,r1,#0 ;
  mrs r10,cpsr ;
  mov r1,r1,lsr #16
  orr r1,r1,r2,lsl #16 ;

;
  str r1,[r7,r11,lsr #7]

endofop80fa:
  ldrh r8,[r4],#2 ;
  subs r5,r5,#148 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

divzero80fa:
  mov r0,#5 ;
  bl Exception
  ldrh r8,[r4],#2 ;
  subs r5,r5,#186 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op80fb:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
  beq divzero80fb ;

  mov r0,r1,lsr #16 ;

;
  mov r3,#0
  mov r1,r0

;
Shift80fb:
  cmp r1,r2,lsr #1
  movls r1,r1,lsl #1
  bcc Shift80fb

Divide80fb:
  cmp r2,r1
  adc r3,r3,r3 ;
  subcs r2,r2,r1
  teq r1,r0
  movne r1,r1,lsr #1
  bne Divide80fb

;
  movs r1,r3,lsr #16 ;
  orrne r10,r10,#0x10000000 ;
  bne endofop80fb ;

  mov r1,r3,lsl #16 ;
  adds r1,r1,#0 ;
  mrs r10,cpsr ;
  mov r1,r1,lsr #16
  orr r1,r1,r2,lsl #16 ;

;
  str r1,[r7,r11,lsr #7]

endofop80fb:
  ldrh r8,[r4],#2 ;
  subs r5,r5,#150 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

divzero80fb:
  mov r0,#5 ;
  bl Exception
  ldrh r8,[r4],#2 ;
  subs r5,r5,#188 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op80fc:
;
  ldrsh r0,[r4],#2 ;
;

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
  beq divzero80fc ;

  mov r0,r1,lsr #16 ;

;
  mov r3,#0
  mov r1,r0

;
Shift80fc:
  cmp r1,r2,lsr #1
  movls r1,r1,lsl #1
  bcc Shift80fc

Divide80fc:
  cmp r2,r1
  adc r3,r3,r3 ;
  subcs r2,r2,r1
  teq r1,r0
  movne r1,r1,lsr #1
  bne Divide80fc

;
  movs r1,r3,lsr #16 ;
  orrne r10,r10,#0x10000000 ;
  bne endofop80fc ;

  mov r1,r3,lsl #16 ;
  adds r1,r1,#0 ;
  mrs r10,cpsr ;
  mov r1,r1,lsr #16
  orr r1,r1,r2,lsl #16 ;

;
  str r1,[r7,r11,lsr #7]

endofop80fc:
  ldrh r8,[r4],#2 ;
  subs r5,r5,#144 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

divzero80fc:
  mov r0,#5 ;
  bl Exception
  ldrh r8,[r4],#2 ;
  subs r5,r5,#182 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op8100:
;
;
  and r6,r8,#0x0007
;
  ldr r6,[r7,r6,lsl #2]

;
  and r11,r8,#0x0e00
;
  ldr r0,[r7,r11,lsr #7]

  mov r6,r6,asl #24
  mov r1,r0,asl #24

  bic r10,r10,#0xb1000000 ;
  ldr r0,[r7,#0x4c] ;
  mov r3,#0x00f00000
  and r2,r3,r6,lsr #4
  tst r0,#0x20000000
  and r0,r3,r1,lsr #4
  sub r0,r0,r2
  subne r0,r0,#0x00100000
  cmp r0,#0x00900000
  subhi r0,r0,#0x00600000 ;
  mov r2,r1,lsr #28
  add r0,r0,r2,lsl #24
  mov r2,r6,lsr #28
  sub r0,r0,r2,lsl #24
  cmp r0,#0x09900000
  orrhi r10,r10,#0xa0000000 ;
  addhi r0,r0,#0x0a000000
  movs r0,r0,lsl #4
  bicne r10,r10,#0x40000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r0,r0,asr #24
  strb r0,[r7,r11,lsr #7]

  ldr r6,[r7,#0x54]
  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op8108:
  str r5,[r7,#0x5c] ;

;
;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r6,r0,asl #24

;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  ldr r11,[r7,r2,lsr #7]
  sub r11,r11,#1 ;
  str r11,[r7,r2,lsr #7]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r1,r0,asl #24

  bic r10,r10,#0xb1000000 ;
  ldr r0,[r7,#0x4c] ;
  mov r3,#0x00f00000
  and r2,r3,r6,lsr #4
  tst r0,#0x20000000
  and r0,r3,r1,lsr #4
  sub r0,r0,r2
  subne r0,r0,#0x00100000
  cmp r0,#0x00900000
  subhi r0,r0,#0x00600000 ;
  mov r2,r1,lsr #28
  add r0,r0,r2,lsl #24
  mov r2,r6,lsr #28
  sub r0,r0,r2,lsl #24
  cmp r0,#0x09900000
  orrhi r10,r10,#0xa0000000 ;
  addhi r0,r0,#0x0a000000
  movs r0,r0,lsl #4
  bicne r10,r10,#0x40000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r0,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldr r6,[r7,#0x54]
  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op810f:
  str r5,[r7,#0x5c] ;

;
;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r6,r0,asl #24

;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  ldr r11,[r7,r2,lsr #7]
  sub r11,r11,#1 ;
  str r11,[r7,r2,lsr #7]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r1,r0,asl #24

  bic r10,r10,#0xb1000000 ;
  ldr r0,[r7,#0x4c] ;
  mov r3,#0x00f00000
  and r2,r3,r6,lsr #4
  tst r0,#0x20000000
  and r0,r3,r1,lsr #4
  sub r0,r0,r2
  subne r0,r0,#0x00100000
  cmp r0,#0x00900000
  subhi r0,r0,#0x00600000 ;
  mov r2,r1,lsr #28
  add r0,r0,r2,lsl #24
  mov r2,r6,lsr #28
  sub r0,r0,r2,lsl #24
  cmp r0,#0x09900000
  orrhi r10,r10,#0xa0000000 ;
  addhi r0,r0,#0x0a000000
  movs r0,r0,lsl #4
  bicne r10,r10,#0x40000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r0,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldr r6,[r7,#0x54]
  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op8110:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #24
  orr r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op8118:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#1 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #24
  orr r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op811f:
  str r5,[r7,#0x5c] ;

;
  ldr r11,[r7,#0x3c] ;
  add r3,r11,#2 ;
  str r3,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #24
  orr r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op8120:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#1 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #24
  orr r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op8127:
  str r5,[r7,#0x5c] ;

;
  ldr r11,[r7,#0x3c] ;
  sub r11,r11,#2 ;
  str r11,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #24
  orr r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op8128:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #24
  orr r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op8130:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #24
  orr r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op8138:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #24
  orr r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op8139:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #24
  orr r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op8150:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #16
  orr r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op8158:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#2 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #16
  orr r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op8160:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#2 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #16
  orr r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op8168:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #16
  orr r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op8170:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #16
  orr r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op8178:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #16
  orr r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op8179:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #16
  orr r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op8190:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  orr r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op8198:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#4 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  orr r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op81a0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#4 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  orr r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op81a8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  orr r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op81b0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  orr r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#26 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op81b8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  orr r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op81b9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  orr r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#28 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op81c0:
;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
  beq divzero81c0 ;

  mov r12,#0 ;
  tst r2,r2
  orrmi r12,r12,#2
  rsbmi r2,r2,#0 ;

  movs r0,r1,asr #16
  orrmi r12,r12,#1
  rsbmi r0,r0,#0 ;

;
  mov r3,r2,asr #31
  eors r3,r3,r1,asr #16
  beq wrendofop81c0

;
  mov r3,#0
  mov r1,r0

;
Shift81c0:
  cmp r1,r2,lsr #1
  movls r1,r1,lsl #1
  bcc Shift81c0

Divide81c0:
  cmp r2,r1
  adc r3,r3,r3 ;
  subcs r2,r2,r1
  teq r1,r0
  movne r1,r1,lsr #1
  bne Divide81c0

;
  and r1,r12,#1
  teq r1,r12,lsr #1
  rsbne r3,r3,#0 ;
  tst r12,#2
  rsbne r2,r2,#0 ;

  mov r1,r3,asl #16
  cmp r3,r1,asr #16 ;
  orrne r10,r10,#0x10000000 ;
  bne endofop81c0 ;

wrendofop81c0:
  mov r1,r3,lsl #16 ;
  adds r1,r1,#0 ;
  mrs r10,cpsr ;
  mov r1,r1,lsr #16
  orr r1,r1,r2,lsl #16 ;

;
  str r1,[r7,r11,lsr #7]

endofop81c0:
  ldrh r8,[r4],#2 ;
  subs r5,r5,#158 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

divzero81c0:
  mov r0,#5 ;
  bl Exception
  ldrh r8,[r4],#2 ;
  subs r5,r5,#196 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op81d0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
  beq divzero81d0 ;

  mov r12,#0 ;
  tst r2,r2
  orrmi r12,r12,#2
  rsbmi r2,r2,#0 ;

  movs r0,r1,asr #16
  orrmi r12,r12,#1
  rsbmi r0,r0,#0 ;

;
  mov r3,r2,asr #31
  eors r3,r3,r1,asr #16
  beq wrendofop81d0

;
  mov r3,#0
  mov r1,r0

;
Shift81d0:
  cmp r1,r2,lsr #1
  movls r1,r1,lsl #1
  bcc Shift81d0

Divide81d0:
  cmp r2,r1
  adc r3,r3,r3 ;
  subcs r2,r2,r1
  teq r1,r0
  movne r1,r1,lsr #1
  bne Divide81d0

;
  and r1,r12,#1
  teq r1,r12,lsr #1
  rsbne r3,r3,#0 ;
  tst r12,#2
  rsbne r2,r2,#0 ;

  mov r1,r3,asl #16
  cmp r3,r1,asr #16 ;
  orrne r10,r10,#0x10000000 ;
  bne endofop81d0 ;

wrendofop81d0:
  mov r1,r3,lsl #16 ;
  adds r1,r1,#0 ;
  mrs r10,cpsr ;
  mov r1,r1,lsr #16
  orr r1,r1,r2,lsl #16 ;

;
  str r1,[r7,r11,lsr #7]

endofop81d0:
  ldrh r8,[r4],#2 ;
  subs r5,r5,#162 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

divzero81d0:
  mov r0,#5 ;
  bl Exception
  ldrh r8,[r4],#2 ;
  subs r5,r5,#200 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op81d8:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#2 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
  beq divzero81d8 ;

  mov r12,#0 ;
  tst r2,r2
  orrmi r12,r12,#2
  rsbmi r2,r2,#0 ;

  movs r0,r1,asr #16
  orrmi r12,r12,#1
  rsbmi r0,r0,#0 ;

;
  mov r3,r2,asr #31
  eors r3,r3,r1,asr #16
  beq wrendofop81d8

;
  mov r3,#0
  mov r1,r0

;
Shift81d8:
  cmp r1,r2,lsr #1
  movls r1,r1,lsl #1
  bcc Shift81d8

Divide81d8:
  cmp r2,r1
  adc r3,r3,r3 ;
  subcs r2,r2,r1
  teq r1,r0
  movne r1,r1,lsr #1
  bne Divide81d8

;
  and r1,r12,#1
  teq r1,r12,lsr #1
  rsbne r3,r3,#0 ;
  tst r12,#2
  rsbne r2,r2,#0 ;

  mov r1,r3,asl #16
  cmp r3,r1,asr #16 ;
  orrne r10,r10,#0x10000000 ;
  bne endofop81d8 ;

wrendofop81d8:
  mov r1,r3,lsl #16 ;
  adds r1,r1,#0 ;
  mrs r10,cpsr ;
  mov r1,r1,lsr #16
  orr r1,r1,r2,lsl #16 ;

;
  str r1,[r7,r11,lsr #7]

endofop81d8:
  ldrh r8,[r4],#2 ;
  subs r5,r5,#162 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

divzero81d8:
  mov r0,#5 ;
  bl Exception
  ldrh r8,[r4],#2 ;
  subs r5,r5,#200 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op81e0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#2 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
  beq divzero81e0 ;

  mov r12,#0 ;
  tst r2,r2
  orrmi r12,r12,#2
  rsbmi r2,r2,#0 ;

  movs r0,r1,asr #16
  orrmi r12,r12,#1
  rsbmi r0,r0,#0 ;

;
  mov r3,r2,asr #31
  eors r3,r3,r1,asr #16
  beq wrendofop81e0

;
  mov r3,#0
  mov r1,r0

;
Shift81e0:
  cmp r1,r2,lsr #1
  movls r1,r1,lsl #1
  bcc Shift81e0

Divide81e0:
  cmp r2,r1
  adc r3,r3,r3 ;
  subcs r2,r2,r1
  teq r1,r0
  movne r1,r1,lsr #1
  bne Divide81e0

;
  and r1,r12,#1
  teq r1,r12,lsr #1
  rsbne r3,r3,#0 ;
  tst r12,#2
  rsbne r2,r2,#0 ;

  mov r1,r3,asl #16
  cmp r3,r1,asr #16 ;
  orrne r10,r10,#0x10000000 ;
  bne endofop81e0 ;

wrendofop81e0:
  mov r1,r3,lsl #16 ;
  adds r1,r1,#0 ;
  mrs r10,cpsr ;
  mov r1,r1,lsr #16
  orr r1,r1,r2,lsl #16 ;

;
  str r1,[r7,r11,lsr #7]

endofop81e0:
  ldrh r8,[r4],#2 ;
  subs r5,r5,#164 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

divzero81e0:
  mov r0,#5 ;
  bl Exception
  ldrh r8,[r4],#2 ;
  subs r5,r5,#202 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op81e8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
  beq divzero81e8 ;

  mov r12,#0 ;
  tst r2,r2
  orrmi r12,r12,#2
  rsbmi r2,r2,#0 ;

  movs r0,r1,asr #16
  orrmi r12,r12,#1
  rsbmi r0,r0,#0 ;

;
  mov r3,r2,asr #31
  eors r3,r3,r1,asr #16
  beq wrendofop81e8

;
  mov r3,#0
  mov r1,r0

;
Shift81e8:
  cmp r1,r2,lsr #1
  movls r1,r1,lsl #1
  bcc Shift81e8

Divide81e8:
  cmp r2,r1
  adc r3,r3,r3 ;
  subcs r2,r2,r1
  teq r1,r0
  movne r1,r1,lsr #1
  bne Divide81e8

;
  and r1,r12,#1
  teq r1,r12,lsr #1
  rsbne r3,r3,#0 ;
  tst r12,#2
  rsbne r2,r2,#0 ;

  mov r1,r3,asl #16
  cmp r3,r1,asr #16 ;
  orrne r10,r10,#0x10000000 ;
  bne endofop81e8 ;

wrendofop81e8:
  mov r1,r3,lsl #16 ;
  adds r1,r1,#0 ;
  mrs r10,cpsr ;
  mov r1,r1,lsr #16
  orr r1,r1,r2,lsl #16 ;

;
  str r1,[r7,r11,lsr #7]

endofop81e8:
  ldrh r8,[r4],#2 ;
  subs r5,r5,#166 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

divzero81e8:
  mov r0,#5 ;
  bl Exception
  ldrh r8,[r4],#2 ;
  subs r5,r5,#204 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op81f0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
  beq divzero81f0 ;

  mov r12,#0 ;
  tst r2,r2
  orrmi r12,r12,#2
  rsbmi r2,r2,#0 ;

  movs r0,r1,asr #16
  orrmi r12,r12,#1
  rsbmi r0,r0,#0 ;

;
  mov r3,r2,asr #31
  eors r3,r3,r1,asr #16
  beq wrendofop81f0

;
  mov r3,#0
  mov r1,r0

;
Shift81f0:
  cmp r1,r2,lsr #1
  movls r1,r1,lsl #1
  bcc Shift81f0

Divide81f0:
  cmp r2,r1
  adc r3,r3,r3 ;
  subcs r2,r2,r1
  teq r1,r0
  movne r1,r1,lsr #1
  bne Divide81f0

;
  and r1,r12,#1
  teq r1,r12,lsr #1
  rsbne r3,r3,#0 ;
  tst r12,#2
  rsbne r2,r2,#0 ;

  mov r1,r3,asl #16
  cmp r3,r1,asr #16 ;
  orrne r10,r10,#0x10000000 ;
  bne endofop81f0 ;

wrendofop81f0:
  mov r1,r3,lsl #16 ;
  adds r1,r1,#0 ;
  mrs r10,cpsr ;
  mov r1,r1,lsr #16
  orr r1,r1,r2,lsl #16 ;

;
  str r1,[r7,r11,lsr #7]

endofop81f0:
  ldrh r8,[r4],#2 ;
  subs r5,r5,#168 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

divzero81f0:
  mov r0,#5 ;
  bl Exception
  ldrh r8,[r4],#2 ;
  subs r5,r5,#206 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op81f8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
  beq divzero81f8 ;

  mov r12,#0 ;
  tst r2,r2
  orrmi r12,r12,#2
  rsbmi r2,r2,#0 ;

  movs r0,r1,asr #16
  orrmi r12,r12,#1
  rsbmi r0,r0,#0 ;

;
  mov r3,r2,asr #31
  eors r3,r3,r1,asr #16
  beq wrendofop81f8

;
  mov r3,#0
  mov r1,r0

;
Shift81f8:
  cmp r1,r2,lsr #1
  movls r1,r1,lsl #1
  bcc Shift81f8

Divide81f8:
  cmp r2,r1
  adc r3,r3,r3 ;
  subcs r2,r2,r1
  teq r1,r0
  movne r1,r1,lsr #1
  bne Divide81f8

;
  and r1,r12,#1
  teq r1,r12,lsr #1
  rsbne r3,r3,#0 ;
  tst r12,#2
  rsbne r2,r2,#0 ;

  mov r1,r3,asl #16
  cmp r3,r1,asr #16 ;
  orrne r10,r10,#0x10000000 ;
  bne endofop81f8 ;

wrendofop81f8:
  mov r1,r3,lsl #16 ;
  adds r1,r1,#0 ;
  mrs r10,cpsr ;
  mov r1,r1,lsr #16
  orr r1,r1,r2,lsl #16 ;

;
  str r1,[r7,r11,lsr #7]

endofop81f8:
  ldrh r8,[r4],#2 ;
  subs r5,r5,#166 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

divzero81f8:
  mov r0,#5 ;
  bl Exception
  ldrh r8,[r4],#2 ;
  subs r5,r5,#204 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op81f9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
  beq divzero81f9 ;

  mov r12,#0 ;
  tst r2,r2
  orrmi r12,r12,#2
  rsbmi r2,r2,#0 ;

  movs r0,r1,asr #16
  orrmi r12,r12,#1
  rsbmi r0,r0,#0 ;

;
  mov r3,r2,asr #31
  eors r3,r3,r1,asr #16
  beq wrendofop81f9

;
  mov r3,#0
  mov r1,r0

;
Shift81f9:
  cmp r1,r2,lsr #1
  movls r1,r1,lsl #1
  bcc Shift81f9

Divide81f9:
  cmp r2,r1
  adc r3,r3,r3 ;
  subcs r2,r2,r1
  teq r1,r0
  movne r1,r1,lsr #1
  bne Divide81f9

;
  and r1,r12,#1
  teq r1,r12,lsr #1
  rsbne r3,r3,#0 ;
  tst r12,#2
  rsbne r2,r2,#0 ;

  mov r1,r3,asl #16
  cmp r3,r1,asr #16 ;
  orrne r10,r10,#0x10000000 ;
  bne endofop81f9 ;

wrendofop81f9:
  mov r1,r3,lsl #16 ;
  adds r1,r1,#0 ;
  mrs r10,cpsr ;
  mov r1,r1,lsr #16
  orr r1,r1,r2,lsl #16 ;

;
  str r1,[r7,r11,lsr #7]

endofop81f9:
  ldrh r8,[r4],#2 ;
  subs r5,r5,#170 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

divzero81f9:
  mov r0,#5 ;
  bl Exception
  ldrh r8,[r4],#2 ;
  subs r5,r5,#208 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op81fa:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
  beq divzero81fa ;

  mov r12,#0 ;
  tst r2,r2
  orrmi r12,r12,#2
  rsbmi r2,r2,#0 ;

  movs r0,r1,asr #16
  orrmi r12,r12,#1
  rsbmi r0,r0,#0 ;

;
  mov r3,r2,asr #31
  eors r3,r3,r1,asr #16
  beq wrendofop81fa

;
  mov r3,#0
  mov r1,r0

;
Shift81fa:
  cmp r1,r2,lsr #1
  movls r1,r1,lsl #1
  bcc Shift81fa

Divide81fa:
  cmp r2,r1
  adc r3,r3,r3 ;
  subcs r2,r2,r1
  teq r1,r0
  movne r1,r1,lsr #1
  bne Divide81fa

;
  and r1,r12,#1
  teq r1,r12,lsr #1
  rsbne r3,r3,#0 ;
  tst r12,#2
  rsbne r2,r2,#0 ;

  mov r1,r3,asl #16
  cmp r3,r1,asr #16 ;
  orrne r10,r10,#0x10000000 ;
  bne endofop81fa ;

wrendofop81fa:
  mov r1,r3,lsl #16 ;
  adds r1,r1,#0 ;
  mrs r10,cpsr ;
  mov r1,r1,lsr #16
  orr r1,r1,r2,lsl #16 ;

;
  str r1,[r7,r11,lsr #7]

endofop81fa:
  ldrh r8,[r4],#2 ;
  subs r5,r5,#166 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

divzero81fa:
  mov r0,#5 ;
  bl Exception
  ldrh r8,[r4],#2 ;
  subs r5,r5,#204 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op81fb:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
  beq divzero81fb ;

  mov r12,#0 ;
  tst r2,r2
  orrmi r12,r12,#2
  rsbmi r2,r2,#0 ;

  movs r0,r1,asr #16
  orrmi r12,r12,#1
  rsbmi r0,r0,#0 ;

;
  mov r3,r2,asr #31
  eors r3,r3,r1,asr #16
  beq wrendofop81fb

;
  mov r3,#0
  mov r1,r0

;
Shift81fb:
  cmp r1,r2,lsr #1
  movls r1,r1,lsl #1
  bcc Shift81fb

Divide81fb:
  cmp r2,r1
  adc r3,r3,r3 ;
  subcs r2,r2,r1
  teq r1,r0
  movne r1,r1,lsr #1
  bne Divide81fb

;
  and r1,r12,#1
  teq r1,r12,lsr #1
  rsbne r3,r3,#0 ;
  tst r12,#2
  rsbne r2,r2,#0 ;

  mov r1,r3,asl #16
  cmp r3,r1,asr #16 ;
  orrne r10,r10,#0x10000000 ;
  bne endofop81fb ;

wrendofop81fb:
  mov r1,r3,lsl #16 ;
  adds r1,r1,#0 ;
  mrs r10,cpsr ;
  mov r1,r1,lsr #16
  orr r1,r1,r2,lsl #16 ;

;
  str r1,[r7,r11,lsr #7]

endofop81fb:
  ldrh r8,[r4],#2 ;
  subs r5,r5,#168 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

divzero81fb:
  mov r0,#5 ;
  bl Exception
  ldrh r8,[r4],#2 ;
  subs r5,r5,#206 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op81fc:
;
  ldrsh r0,[r4],#2 ;
;

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
  beq divzero81fc ;

  mov r12,#0 ;
  tst r2,r2
  orrmi r12,r12,#2
  rsbmi r2,r2,#0 ;

  movs r0,r1,asr #16
  orrmi r12,r12,#1
  rsbmi r0,r0,#0 ;

;
  mov r3,r2,asr #31
  eors r3,r3,r1,asr #16
  beq wrendofop81fc

;
  mov r3,#0
  mov r1,r0

;
Shift81fc:
  cmp r1,r2,lsr #1
  movls r1,r1,lsl #1
  bcc Shift81fc

Divide81fc:
  cmp r2,r1
  adc r3,r3,r3 ;
  subcs r2,r2,r1
  teq r1,r0
  movne r1,r1,lsr #1
  bne Divide81fc

;
  and r1,r12,#1
  teq r1,r12,lsr #1
  rsbne r3,r3,#0 ;
  tst r12,#2
  rsbne r2,r2,#0 ;

  mov r1,r3,asl #16
  cmp r3,r1,asr #16 ;
  orrne r10,r10,#0x10000000 ;
  bne endofop81fc ;

wrendofop81fc:
  mov r1,r3,lsl #16 ;
  adds r1,r1,#0 ;
  mrs r10,cpsr ;
  mov r1,r1,lsr #16
  orr r1,r1,r2,lsl #16 ;

;
  str r1,[r7,r11,lsr #7]

endofop81fc:
  ldrh r8,[r4],#2 ;
  subs r5,r5,#162 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

divzero81fc:
  mov r0,#5 ;
  bl Exception
  ldrh r8,[r4],#2 ;
  subs r5,r5,#200 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
Op8f08:
  str r5,[r7,#0x5c] ;

;
;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r6,r0,asl #24

;
  ldr r11,[r7,#0x3c] ;
  sub r11,r11,#2 ;
  str r11,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r1,r0,asl #24

  bic r10,r10,#0xb1000000 ;
  ldr r0,[r7,#0x4c] ;
  mov r3,#0x00f00000
  and r2,r3,r6,lsr #4
  tst r0,#0x20000000
  and r0,r3,r1,lsr #4
  sub r0,r0,r2
  subne r0,r0,#0x00100000
  cmp r0,#0x00900000
  subhi r0,r0,#0x00600000 ;
  mov r2,r1,lsr #28
  add r0,r0,r2,lsl #24
  mov r2,r6,lsr #28
  sub r0,r0,r2,lsl #24
  cmp r0,#0x09900000
  orrhi r10,r10,#0xa0000000 ;
  addhi r0,r0,#0x0a000000
  movs r0,r0,lsl #4
  bicne r10,r10,#0x40000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r0,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldr r6,[r7,#0x54]
  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op8f0f:
  str r5,[r7,#0x5c] ;

;
;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r6,r0,asl #24

;
  ldr r11,[r7,#0x3c] ;
  sub r11,r11,#2 ;
  str r11,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r1,r0,asl #24

  bic r10,r10,#0xb1000000 ;
  ldr r0,[r7,#0x4c] ;
  mov r3,#0x00f00000
  and r2,r3,r6,lsr #4
  tst r0,#0x20000000
  and r0,r3,r1,lsr #4
  sub r0,r0,r2
  subne r0,r0,#0x00100000
  cmp r0,#0x00900000
  subhi r0,r0,#0x00600000 ;
  mov r2,r1,lsr #28
  add r0,r0,r2,lsl #24
  mov r2,r6,lsr #28
  sub r0,r0,r2,lsl #24
  cmp r0,#0x09900000
  orrhi r10,r10,#0xa0000000 ;
  addhi r0,r0,#0x0a000000
  movs r0,r0,lsl #4
  bicne r10,r10,#0x40000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r0,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldr r6,[r7,#0x54]
  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9000:
;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  rsbs r1,r0,r1,asl #24
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9010:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  rsbs r1,r0,r1,asl #24
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9018:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  rsbs r1,r0,r1,asl #24
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op901f:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  rsbs r1,r0,r1,asl #24
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9020:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  rsbs r1,r0,r1,asl #24
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9027:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  rsbs r1,r0,r1,asl #24
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9028:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  rsbs r1,r0,r1,asl #24
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9030:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  rsbs r1,r0,r1,asl #24
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9038:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  rsbs r1,r0,r1,asl #24
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9039:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  rsbs r1,r0,r1,asl #24
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op903a:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x80] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  rsbs r1,r0,r1,asl #24
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op903b:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x80] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  rsbs r1,r0,r1,asl #24
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op903c:
;
  ldrsb r0,[r4],#2 ;
;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  rsbs r1,r0,r1,asl #24
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9040:
;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  rsbs r1,r0,r1,asl #16
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9050:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  rsbs r1,r0,r1,asl #16
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9058:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#2 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  rsbs r1,r0,r1,asl #16
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9060:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#2 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  rsbs r1,r0,r1,asl #16
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9068:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  rsbs r1,r0,r1,asl #16
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9070:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  rsbs r1,r0,r1,asl #16
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9078:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  rsbs r1,r0,r1,asl #16
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9079:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  rsbs r1,r0,r1,asl #16
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op907a:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  rsbs r1,r0,r1,asl #16
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op907b:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  rsbs r1,r0,r1,asl #16
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op907c:
;
  ldrsh r0,[r4],#2 ;
;

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  rsbs r1,r0,r1,asl #16
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9080:
;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  rsbs r1,r0,r1
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9090:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  rsbs r1,r0,r1
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9098:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#4 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  rsbs r1,r0,r1
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op90a0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#4 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  rsbs r1,r0,r1
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op90a8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  rsbs r1,r0,r1
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op90b0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  rsbs r1,r0,r1
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op90b8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  rsbs r1,r0,r1
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op90b9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  rsbs r1,r0,r1
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op90ba:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x88] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  rsbs r1,r0,r1
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op90bb:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x88] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  rsbs r1,r0,r1
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op90bc:
;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r0,r3,r2,lsl #16
;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  rsbs r1,r0,r1
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op90c0:
;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  mov r0,r0,asl #16

  sub r1,r1,r0,asr #16

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op90d0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  mov r0,r0,asl #16

  sub r1,r1,r0,asr #16

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op90d8:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#2 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  mov r0,r0,asl #16

  sub r1,r1,r0,asr #16

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op90e0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#2 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  mov r0,r0,asl #16

  sub r1,r1,r0,asr #16

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op90e8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  mov r0,r0,asl #16

  sub r1,r1,r0,asr #16

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op90f0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  mov r0,r0,asl #16

  sub r1,r1,r0,asr #16

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op90f8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  mov r0,r0,asl #16

  sub r1,r1,r0,asr #16

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op90f9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  mov r0,r0,asl #16

  sub r1,r1,r0,asr #16

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op90fa:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  mov r0,r0,asl #16

  sub r1,r1,r0,asr #16

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op90fb:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  mov r0,r0,asl #16

  sub r1,r1,r0,asr #16

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op90fc:
;
  ldrsh r0,[r4],#2 ;
;

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  mov r0,r0,asl #16

  sub r1,r1,r0,asr #16

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9100:
;
;
  and r6,r8,#0x0007
;
  ldr r6,[r7,r6,lsl #2]

;
  and r11,r8,#0x0e00
;
  ldr r0,[r7,r11,lsr #7]

  mov r6,r6,asl #24

;
;
  ldr r2,[r7,#0x4c]
  mvn r2,r2 ;
  msr cpsr_flg,r2 ;

  rscs r1,r6,r0,asl #24
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  movs r2,r1,lsr #24
  orreq r10,r10,#0x40000000 ;
  andeq r10,r10,r3 ;

;
;
  mov r1,r1,asr #24
  strb r1,[r7,r11,lsr #7]

  ldr r6,[r7,#0x54]
  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9108:
  str r5,[r7,#0x5c] ;

;
;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r6,r0,asl #24

;
  and r2,r8,#0x1e00
  ldr r11,[r7,r2,lsr #7]
  sub r11,r11,#1 ;
  str r11,[r7,r2,lsr #7]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
;
  ldr r2,[r7,#0x4c]
  mvn r2,r2 ;
  msr cpsr_flg,r2 ;

  rscs r1,r6,r0,asl #24
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  movs r2,r1,lsr #24
  orreq r10,r10,#0x40000000 ;
  andeq r10,r10,r3 ;

;
;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldr r6,[r7,#0x54]
  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op910f:
  str r5,[r7,#0x5c] ;

;
;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r6,r0,asl #24

;
  and r2,r8,#0x1e00
  ldr r11,[r7,r2,lsr #7]
  sub r11,r11,#1 ;
  str r11,[r7,r2,lsr #7]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
;
  ldr r2,[r7,#0x4c]
  mvn r2,r2 ;
  msr cpsr_flg,r2 ;

  rscs r1,r6,r0,asl #24
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  movs r2,r1,lsr #24
  orreq r10,r10,#0x40000000 ;
  andeq r10,r10,r3 ;

;
;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldr r6,[r7,#0x54]
  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9110:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #24
  subs r1,r0,r1,asl #24
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9118:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#1 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #24
  subs r1,r0,r1,asl #24
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op911f:
  str r5,[r7,#0x5c] ;

;
  ldr r11,[r7,#0x3c] ;
  add r3,r11,#2 ;
  str r3,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #24
  subs r1,r0,r1,asl #24
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9120:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#1 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #24
  subs r1,r0,r1,asl #24
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9127:
  str r5,[r7,#0x5c] ;

;
  ldr r11,[r7,#0x3c] ;
  sub r11,r11,#2 ;
  str r11,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #24
  subs r1,r0,r1,asl #24
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9128:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #24
  subs r1,r0,r1,asl #24
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9130:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #24
  subs r1,r0,r1,asl #24
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9138:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #24
  subs r1,r0,r1,asl #24
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9139:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #24
  subs r1,r0,r1,asl #24
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9140:
;
;
  and r6,r8,#0x0007
;
  ldr r6,[r7,r6,lsl #2]

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r0,[r7,r11]

  mov r6,r6,asl #16

;
;
  ldr r2,[r7,#0x4c]
  mvn r2,r2 ;
  msr cpsr_flg,r2 ;

  rscs r1,r6,r0,asl #16
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  movs r2,r1,lsr #16
  orreq r10,r10,#0x40000000 ;
  andeq r10,r10,r3 ;

;
;
  mov r1,r1,asr #16
  strh r1,[r7,r11]

  ldr r6,[r7,#0x54]
  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9148:
  str r5,[r7,#0x5c] ;

;
;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#2 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r6,r0,asl #16

;
  and r2,r8,#0x1e00
  ldr r11,[r7,r2,lsr #7]
  sub r11,r11,#2 ;
  str r11,[r7,r2,lsr #7]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
;
  ldr r2,[r7,#0x4c]
  mvn r2,r2 ;
  msr cpsr_flg,r2 ;

  rscs r1,r6,r0,asl #16
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  movs r2,r1,lsr #16
  orreq r10,r10,#0x40000000 ;
  andeq r10,r10,r3 ;

;
;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldr r6,[r7,#0x54]
  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9150:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #16
  subs r1,r0,r1,asl #16
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9158:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#2 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #16
  subs r1,r0,r1,asl #16
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9160:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#2 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #16
  subs r1,r0,r1,asl #16
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9168:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #16
  subs r1,r0,r1,asl #16
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9170:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #16
  subs r1,r0,r1,asl #16
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9178:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #16
  subs r1,r0,r1,asl #16
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9179:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #16
  subs r1,r0,r1,asl #16
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9180:
;
;
  and r6,r8,#0x0007
;
  ldr r6,[r7,r6,lsl #2]

;
  and r11,r8,#0x0e00
;
  ldr r0,[r7,r11,lsr #7]

;
;
  ldr r2,[r7,#0x4c]
  mvn r2,r2 ;
  msr cpsr_flg,r2 ;

  rscs r1,r6,r0
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  andeq r10,r10,r3 ;

;
;
  str r1,[r7,r11,lsr #7]

  ldr r6,[r7,#0x54]
  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9188:
  str r5,[r7,#0x5c] ;

;
;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#4 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;
  mov r6,r0

;
  and r2,r8,#0x1e00
  ldr r11,[r7,r2,lsr #7]
  sub r11,r11,#4 ;
  str r11,[r7,r2,lsr #7]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
;
  ldr r2,[r7,#0x4c]
  mvn r2,r2 ;
  msr cpsr_flg,r2 ;

  rscs r1,r6,r0
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  andeq r10,r10,r3 ;

;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldr r6,[r7,#0x54]
  ldrh r8,[r4],#2 ;
  subs r5,r5,#30 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9190:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  subs r1,r0,r1
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9198:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#4 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  subs r1,r0,r1
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op91a0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#4 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  subs r1,r0,r1
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op91a8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  subs r1,r0,r1
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op91b0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  subs r1,r0,r1
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#26 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op91b8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  subs r1,r0,r1
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op91b9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  subs r1,r0,r1
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;

;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#28 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op91c0:
;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  sub r1,r1,r0

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op91d0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  sub r1,r1,r0

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op91d8:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#4 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  sub r1,r1,r0

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op91e0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#4 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  sub r1,r1,r0

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op91e8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  sub r1,r1,r0

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op91f0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  sub r1,r1,r0

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op91f8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  sub r1,r1,r0

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op91f9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  sub r1,r1,r0

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op91fa:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x88] ;

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  sub r1,r1,r0

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op91fb:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x88] ;

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  sub r1,r1,r0

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op91fc:
;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r0,r3,r2,lsl #16
;

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  sub r1,r1,r0

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9f08:
  str r5,[r7,#0x5c] ;

;
;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r6,r0,asl #24

;
  ldr r11,[r7,#0x3c] ;
  sub r11,r11,#2 ;
  str r11,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
;
  ldr r2,[r7,#0x4c]
  mvn r2,r2 ;
  msr cpsr_flg,r2 ;

  rscs r1,r6,r0,asl #24
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  movs r2,r1,lsr #24
  orreq r10,r10,#0x40000000 ;
  andeq r10,r10,r3 ;

;
;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldr r6,[r7,#0x54]
  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Op9f0f:
  str r5,[r7,#0x5c] ;

;
;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r6,r0,asl #24

;
  ldr r11,[r7,#0x3c] ;
  sub r11,r11,#2 ;
  str r11,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
;
  ldr r2,[r7,#0x4c]
  mvn r2,r2 ;
  msr cpsr_flg,r2 ;

  rscs r1,r6,r0,asl #24
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;
  str r10,[r7,#0x4c] ;
  movs r2,r1,lsr #24
  orreq r10,r10,#0x40000000 ;
  andeq r10,r10,r3 ;

;
;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldr r6,[r7,#0x54]
  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb000:
;
;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #24

;
  rsbs r1,r0,r1,asl #24
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb010:
  str r5,[r7,#0x5c] ;

;
;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #24

;
  rsbs r1,r0,r1,asl #24
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb018:
  str r5,[r7,#0x5c] ;

;
;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #24

;
  rsbs r1,r0,r1,asl #24
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb01f:
  str r5,[r7,#0x5c] ;

;
;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #24

;
  rsbs r1,r0,r1,asl #24
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb020:
  str r5,[r7,#0x5c] ;

;
;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #24

;
  rsbs r1,r0,r1,asl #24
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb027:
  str r5,[r7,#0x5c] ;

;
;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #24

;
  rsbs r1,r0,r1,asl #24
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb028:
  str r5,[r7,#0x5c] ;

;
;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #24

;
  rsbs r1,r0,r1,asl #24
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb030:
  str r5,[r7,#0x5c] ;

;
;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #24

;
  rsbs r1,r0,r1,asl #24
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb039:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #24

;
  rsbs r1,r0,r1,asl #24
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb03a:
  str r5,[r7,#0x5c] ;

;
;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x80] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #24

;
  rsbs r1,r0,r1,asl #24
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb03b:
  str r5,[r7,#0x5c] ;

;
;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x80] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #24

;
  rsbs r1,r0,r1,asl #24
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb03c:
;
;
  ldrsb r0,[r4],#2 ;
;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #24

;
  rsbs r1,r0,r1,asl #24
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb040:
;
;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #16

;
  rsbs r1,r0,r1,asl #16
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb050:
  str r5,[r7,#0x5c] ;

;
;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #16

;
  rsbs r1,r0,r1,asl #16
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb058:
  str r5,[r7,#0x5c] ;

;
;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#2 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #16

;
  rsbs r1,r0,r1,asl #16
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb060:
  str r5,[r7,#0x5c] ;

;
;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#2 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #16

;
  rsbs r1,r0,r1,asl #16
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb068:
  str r5,[r7,#0x5c] ;

;
;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #16

;
  rsbs r1,r0,r1,asl #16
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb070:
  str r5,[r7,#0x5c] ;

;
;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #16

;
  rsbs r1,r0,r1,asl #16
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb078:
  str r5,[r7,#0x5c] ;

;
;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #16

;
  rsbs r1,r0,r1,asl #16
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb079:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #16

;
  rsbs r1,r0,r1,asl #16
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb07a:
  str r5,[r7,#0x5c] ;

;
;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #16

;
  rsbs r1,r0,r1,asl #16
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb07b:
  str r5,[r7,#0x5c] ;

;
;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #16

;
  rsbs r1,r0,r1,asl #16
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb07c:
;
;
  ldrsh r0,[r4],#2 ;
;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #16

;
  rsbs r1,r0,r1,asl #16
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb080:
;
;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  rsbs r1,r0,r1
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb090:
  str r5,[r7,#0x5c] ;

;
;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  rsbs r1,r0,r1
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb098:
  str r5,[r7,#0x5c] ;

;
;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#4 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  rsbs r1,r0,r1
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb0a0:
  str r5,[r7,#0x5c] ;

;
;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#4 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  rsbs r1,r0,r1
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb0a8:
  str r5,[r7,#0x5c] ;

;
;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  rsbs r1,r0,r1
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb0b0:
  str r5,[r7,#0x5c] ;

;
;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  rsbs r1,r0,r1
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb0b9:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  rsbs r1,r0,r1
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb0ba:
  str r5,[r7,#0x5c] ;

;
;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x88] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  rsbs r1,r0,r1
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb0bb:
  str r5,[r7,#0x5c] ;

;
;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x88] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  rsbs r1,r0,r1
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb0bc:
;
;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r0,r3,r2,lsl #16
;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  rsbs r1,r0,r1
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb0c0:
;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

;
  and r1,r8,#0x1e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #16

  cmp r1,r0,asr #16 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb0d0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r1,r8,#0x1e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #16

  cmp r1,r0,asr #16 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb0d8:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#2 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r1,r8,#0x1e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #16

  cmp r1,r0,asr #16 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb0e0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#2 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r1,r8,#0x1e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #16

  cmp r1,r0,asr #16 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb0e8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r1,r8,#0x1e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #16

  cmp r1,r0,asr #16 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb0f0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r1,r8,#0x1e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #16

  cmp r1,r0,asr #16 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb0f8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r1,r8,#0x1e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #16

  cmp r1,r0,asr #16 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb0f9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r1,r8,#0x1e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #16

  cmp r1,r0,asr #16 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb0fa:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;

;
  and r1,r8,#0x1e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #16

  cmp r1,r0,asr #16 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb0fb:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;

;
  and r1,r8,#0x1e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #16

  cmp r1,r0,asr #16 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb0fc:
;
  ldrsh r0,[r4],#2 ;
;

;
  and r1,r8,#0x1e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #16

  cmp r1,r0,asr #16 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb100:
;
;
  and r11,r8,#0x000f
;
  ldr r0,[r7,r11,lsl #2]

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #24

;
  eor r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
  strb r1,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb108:
  str r5,[r7,#0x5c] ;

;
;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r11,r0,asl #24

;
;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

  rsbs r0,r11,r0,asl #24
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb10f:
  str r5,[r7,#0x5c] ;

;
;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r11,r0,asl #24

;
;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

  rsbs r0,r11,r0,asl #24
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb110:
  str r5,[r7,#0x5c] ;

;
;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #24

;
  eor r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb118:
  str r5,[r7,#0x5c] ;

;
;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#1 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #24

;
  eor r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb11f:
  str r5,[r7,#0x5c] ;

;
;
  ldr r11,[r7,#0x3c] ;
  add r3,r11,#2 ;
  str r3,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #24

;
  eor r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb120:
  str r5,[r7,#0x5c] ;

;
;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#1 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #24

;
  eor r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb127:
  str r5,[r7,#0x5c] ;

;
;
  ldr r11,[r7,#0x3c] ;
  sub r11,r11,#2 ;
  str r11,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #24

;
  eor r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb128:
  str r5,[r7,#0x5c] ;

;
;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #24

;
  eor r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb130:
  str r5,[r7,#0x5c] ;

;
;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #24

;
  eor r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb138:
  str r5,[r7,#0x5c] ;

;
;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #24

;
  eor r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb139:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #24

;
  eor r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb140:
;
;
  and r11,r8,#0x000f
  mov r11,r11,lsl #2
;
  ldr r0,[r7,r11]

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #16

;
  eor r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb148:
  str r5,[r7,#0x5c] ;

;
;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#2 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r11,r0,asl #16

;
;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  add r3,r0,#2 ;
  str r3,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

  rsbs r0,r11,r0,asl #16
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb150:
  str r5,[r7,#0x5c] ;

;
;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #16

;
  eor r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb158:
  str r5,[r7,#0x5c] ;

;
;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#2 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #16

;
  eor r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb160:
  str r5,[r7,#0x5c] ;

;
;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#2 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #16

;
  eor r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb168:
  str r5,[r7,#0x5c] ;

;
;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #16

;
  eor r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb170:
  str r5,[r7,#0x5c] ;

;
;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #16

;
  eor r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb178:
  str r5,[r7,#0x5c] ;

;
;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #16

;
  eor r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb179:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

  mov r0,r0,asl #16

;
  eor r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb180:
;
;
  and r11,r8,#0x000f
;
  ldr r0,[r7,r11,lsl #2]

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  eor r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  str r1,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb188:
  str r5,[r7,#0x5c] ;

;
;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#4 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;
  mov r11,r0

;
;
  and r2,r8,#0x1e00
  ldr r0,[r7,r2,lsr #7]
  add r3,r0,#4 ;
  str r3,[r7,r2,lsr #7]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

  rsbs r0,r11,r0
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb190:
  str r5,[r7,#0x5c] ;

;
;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  eor r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb198:
  str r5,[r7,#0x5c] ;

;
;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#4 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  eor r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb1a0:
  str r5,[r7,#0x5c] ;

;
;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#4 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  eor r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb1a8:
  str r5,[r7,#0x5c] ;

;
;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  eor r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb1b0:
  str r5,[r7,#0x5c] ;

;
;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  eor r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#26 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb1b8:
  str r5,[r7,#0x5c] ;

;
;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  eor r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb1b9:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  eor r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#28 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb1c0:
;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

;
  and r1,r8,#0x1e00
;
  ldr r1,[r7,r1,lsr #7]

  cmp r1,r0 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb1d0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r1,r8,#0x1e00
;
  ldr r1,[r7,r1,lsr #7]

  cmp r1,r0 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb1d8:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#4 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r1,r8,#0x1e00
;
  ldr r1,[r7,r1,lsr #7]

  cmp r1,r0 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb1e0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#4 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r1,r8,#0x1e00
;
  ldr r1,[r7,r1,lsr #7]

  cmp r1,r0 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb1e8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r1,r8,#0x1e00
;
  ldr r1,[r7,r1,lsr #7]

  cmp r1,r0 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb1f0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r1,r8,#0x1e00
;
  ldr r1,[r7,r1,lsr #7]

  cmp r1,r0 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb1f8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r1,r8,#0x1e00
;
  ldr r1,[r7,r1,lsr #7]

  cmp r1,r0 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb1f9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r1,r8,#0x1e00
;
  ldr r1,[r7,r1,lsr #7]

  cmp r1,r0 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb1fa:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x88] ;

;
  and r1,r8,#0x1e00
;
  ldr r1,[r7,r1,lsr #7]

  cmp r1,r0 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb1fb:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x88] ;

;
  and r1,r8,#0x1e00
;
  ldr r1,[r7,r1,lsr #7]

  cmp r1,r0 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opb1fc:
;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r0,r3,r2,lsl #16
;

;
  and r1,r8,#0x1e00
;
  ldr r1,[r7,r1,lsr #7]

  cmp r1,r0 ;
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opbf08:
  str r5,[r7,#0x5c] ;

;
;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r11,r0,asl #24

;
;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

  rsbs r0,r11,r0,asl #24
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opbf0f:
  str r5,[r7,#0x5c] ;

;
;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r11,r0,asl #24

;
;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

  rsbs r0,r11,r0,asl #24
  mrs r10,cpsr ;
  eor r10,r10,#0x20000000 ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc000:
;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  and r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc010:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  and r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc018:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  and r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc01f:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  and r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc020:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  and r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc027:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  and r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc028:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  and r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc030:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  and r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc038:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  and r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc039:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  and r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc03a:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x80] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  and r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc03b:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x80] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  and r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc03c:
;
  ldrsb r0,[r4],#2 ;
;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  and r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc050:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  and r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc058:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#2 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  and r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc060:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#2 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  and r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc068:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  and r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc070:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  and r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc078:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  and r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc079:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  and r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc07a:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  and r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc07b:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  and r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc07c:
;
  ldrsh r0,[r4],#2 ;
;

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  and r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc080:
;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  and r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc090:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  and r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc098:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#4 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  and r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc0a0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#4 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  and r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc0a8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  and r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc0b0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  and r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc0b8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  and r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc0b9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  and r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc0ba:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x88] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  and r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc0bb:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x88] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  and r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc0bc:
;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r0,r3,r2,lsl #16
;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  and r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc0c0:
;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
;
  mov r0,r1,lsr #16
  mov r2,r2,lsl #16
  mov r2,r2,lsr #16

  mul r1,r2,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#54 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc0d0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
;
  mov r0,r1,lsr #16
  mov r2,r2,lsl #16
  mov r2,r2,lsr #16

  mul r1,r2,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#58 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc0d8:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#2 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
;
  mov r0,r1,lsr #16
  mov r2,r2,lsl #16
  mov r2,r2,lsr #16

  mul r1,r2,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#58 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc0e0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#2 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
;
  mov r0,r1,lsr #16
  mov r2,r2,lsl #16
  mov r2,r2,lsr #16

  mul r1,r2,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#60 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc0e8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
;
  mov r0,r1,lsr #16
  mov r2,r2,lsl #16
  mov r2,r2,lsr #16

  mul r1,r2,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#62 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc0f0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
;
  mov r0,r1,lsr #16
  mov r2,r2,lsl #16
  mov r2,r2,lsr #16

  mul r1,r2,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#64 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc0f8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
;
  mov r0,r1,lsr #16
  mov r2,r2,lsl #16
  mov r2,r2,lsr #16

  mul r1,r2,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#62 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc0f9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
;
  mov r0,r1,lsr #16
  mov r2,r2,lsl #16
  mov r2,r2,lsr #16

  mul r1,r2,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#66 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc0fa:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
;
  mov r0,r1,lsr #16
  mov r2,r2,lsl #16
  mov r2,r2,lsr #16

  mul r1,r2,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#62 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc0fb:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
;
  mov r0,r1,lsr #16
  mov r2,r2,lsl #16
  mov r2,r2,lsr #16

  mul r1,r2,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#64 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc0fc:
;
  ldrsh r0,[r4],#2 ;
;

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
;
  mov r0,r1,lsr #16
  mov r2,r2,lsl #16
  mov r2,r2,lsr #16

  mul r1,r2,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#58 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc100:
;
;
  and r6,r8,#0x0007
;
  ldr r6,[r7,r6,lsl #2]

;
  and r11,r8,#0x0e00
;
  ldr r0,[r7,r11,lsr #7]

  mov r6,r6,asl #24
  mov r1,r0,asl #24

  bic r10,r10,#0xb1000000 ;
  ldr r0,[r7,#0x4c] ;
  mov r3,#0x00f00000
  and r2,r3,r1,lsr #4
  tst r0,#0x20000000
  and r0,r3,r6,lsr #4
  add r0,r0,r2
  addne r0,r0,#0x00100000
  cmp r0,#0x00900000
  addhi r0,r0,#0x00600000 ;
  mov r2,r1,lsr #28
  add r0,r0,r2,lsl #24
  mov r2,r6,lsr #28
  add r0,r0,r2,lsl #24
  cmp r0,#0x09900000
  orrhi r10,r10,#0x20000000 ;
  subhi r0,r0,#0x0a000000
  movs r0,r0,lsl #4
  orrmi r10,r10,#0x90000000 ;
  bicne r10,r10,#0x40000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r0,r0,asr #24
  strb r0,[r7,r11,lsr #7]

  ldr r6,[r7,#0x54]
  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc108:
  str r5,[r7,#0x5c] ;

;
;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r6,r0,asl #24

;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  ldr r11,[r7,r2,lsr #7]
  sub r11,r11,#1 ;
  str r11,[r7,r2,lsr #7]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r1,r0,asl #24

  bic r10,r10,#0xb1000000 ;
  ldr r0,[r7,#0x4c] ;
  mov r3,#0x00f00000
  and r2,r3,r1,lsr #4
  tst r0,#0x20000000
  and r0,r3,r6,lsr #4
  add r0,r0,r2
  addne r0,r0,#0x00100000
  cmp r0,#0x00900000
  addhi r0,r0,#0x00600000 ;
  mov r2,r1,lsr #28
  add r0,r0,r2,lsl #24
  mov r2,r6,lsr #28
  add r0,r0,r2,lsl #24
  cmp r0,#0x09900000
  orrhi r10,r10,#0x20000000 ;
  subhi r0,r0,#0x0a000000
  movs r0,r0,lsl #4
  orrmi r10,r10,#0x90000000 ;
  bicne r10,r10,#0x40000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r0,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldr r6,[r7,#0x54]
  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc10f:
  str r5,[r7,#0x5c] ;

;
;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r6,r0,asl #24

;
  and r2,r8,#0x0e00
  orr r2,r2,#0x1000 ;
  ldr r11,[r7,r2,lsr #7]
  sub r11,r11,#1 ;
  str r11,[r7,r2,lsr #7]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r1,r0,asl #24

  bic r10,r10,#0xb1000000 ;
  ldr r0,[r7,#0x4c] ;
  mov r3,#0x00f00000
  and r2,r3,r1,lsr #4
  tst r0,#0x20000000
  and r0,r3,r6,lsr #4
  add r0,r0,r2
  addne r0,r0,#0x00100000
  cmp r0,#0x00900000
  addhi r0,r0,#0x00600000 ;
  mov r2,r1,lsr #28
  add r0,r0,r2,lsl #24
  mov r2,r6,lsr #28
  add r0,r0,r2,lsl #24
  cmp r0,#0x09900000
  orrhi r10,r10,#0x20000000 ;
  subhi r0,r0,#0x0a000000
  movs r0,r0,lsl #4
  orrmi r10,r10,#0x90000000 ;
  bicne r10,r10,#0x40000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r0,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldr r6,[r7,#0x54]
  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc110:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #24
  and r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc118:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#1 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #24
  and r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc11f:
  str r5,[r7,#0x5c] ;

;
  ldr r11,[r7,#0x3c] ;
  add r3,r11,#2 ;
  str r3,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #24
  and r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc120:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#1 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #24
  and r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc127:
  str r5,[r7,#0x5c] ;

;
  ldr r11,[r7,#0x3c] ;
  sub r11,r11,#2 ;
  str r11,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #24
  and r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc128:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #24
  and r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc130:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #24
  and r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc138:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #24
  and r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc139:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #24
  and r1,r0,r1,asl #24
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #24
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc140:
  and r2,r8,#0x0e00 ;
  and r3,r8,#0x000f ;

  ldr r0,[r7,r2,lsr #7] ;
  ldr r1,[r7,r3,lsl #2] ;

  str r0,[r7,r3,lsl #2] ;
  str r1,[r7,r2,lsr #7] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc148:
  and r2,r8,#0x0e00 ;
  and r3,r8,#0x000f ;
  orr r2,r2,#0x1000 ;

  ldr r0,[r7,r2,lsr #7] ;
  ldr r1,[r7,r3,lsl #2] ;

  str r0,[r7,r3,lsl #2] ;
  str r1,[r7,r2,lsr #7] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc150:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #16
  and r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc158:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#2 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #16
  and r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc160:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#2 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #16
  and r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc168:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #16
  and r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc170:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #16
  and r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc178:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #16
  and r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc179:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #16
  and r1,r0,r1,asl #16
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  mov r1,r1,asr #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc188:
  and r2,r8,#0x0e00 ;
  and r3,r8,#0x000f ;

  ldr r0,[r7,r2,lsr #7] ;
  ldr r1,[r7,r3,lsl #2] ;

  str r0,[r7,r3,lsl #2] ;
  str r1,[r7,r2,lsr #7] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc190:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  and r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc198:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#4 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  and r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc1a0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#4 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  and r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc1a8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  and r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc1b0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  and r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#26 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc1b8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  and r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc1b9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  and r1,r0,r1
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#28 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc1c0:
;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
;
  mov r0,r1,asr #16
  mov r2,r2,lsl #16
  mov r2,r2,asr #16

  mul r1,r2,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#54 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc1d0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
;
  mov r0,r1,asr #16
  mov r2,r2,lsl #16
  mov r2,r2,asr #16

  mul r1,r2,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#58 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc1d8:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#2 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
;
  mov r0,r1,asr #16
  mov r2,r2,lsl #16
  mov r2,r2,asr #16

  mul r1,r2,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#58 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc1e0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#2 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
;
  mov r0,r1,asr #16
  mov r2,r2,lsl #16
  mov r2,r2,asr #16

  mul r1,r2,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#60 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc1e8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
;
  mov r0,r1,asr #16
  mov r2,r2,lsl #16
  mov r2,r2,asr #16

  mul r1,r2,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#62 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc1f0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
;
  mov r0,r1,asr #16
  mov r2,r2,lsl #16
  mov r2,r2,asr #16

  mul r1,r2,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#64 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc1f8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
;
  mov r0,r1,asr #16
  mov r2,r2,lsl #16
  mov r2,r2,asr #16

  mul r1,r2,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#62 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc1f9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
;
  mov r0,r1,asr #16
  mov r2,r2,lsl #16
  mov r2,r2,asr #16

  mul r1,r2,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#66 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc1fa:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
;
  mov r0,r1,asr #16
  mov r2,r2,lsl #16
  mov r2,r2,asr #16

  mul r1,r2,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#62 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc1fb:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
;
  mov r0,r1,asr #16
  mov r2,r2,lsl #16
  mov r2,r2,asr #16

  mul r1,r2,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#64 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opc1fc:
;
  ldrsh r0,[r4],#2 ;
;

;
  and r11,r8,#0x0e00
;
  ldr r2,[r7,r11,lsr #7]

  movs r1,r0,asl #16
;
  mov r0,r1,asr #16
  mov r2,r2,lsl #16
  mov r2,r2,asr #16

  mul r1,r2,r0
  adds r1,r1,#0 ;
  mrs r10,cpsr ;

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#58 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opcf08:
  str r5,[r7,#0x5c] ;

;
;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r6,r0,asl #24

;
  ldr r11,[r7,#0x3c] ;
  sub r11,r11,#2 ;
  str r11,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r1,r0,asl #24

  bic r10,r10,#0xb1000000 ;
  ldr r0,[r7,#0x4c] ;
  mov r3,#0x00f00000
  and r2,r3,r1,lsr #4
  tst r0,#0x20000000
  and r0,r3,r6,lsr #4
  add r0,r0,r2
  addne r0,r0,#0x00100000
  cmp r0,#0x00900000
  addhi r0,r0,#0x00600000 ;
  mov r2,r1,lsr #28
  add r0,r0,r2,lsl #24
  mov r2,r6,lsr #28
  add r0,r0,r2,lsl #24
  cmp r0,#0x09900000
  orrhi r10,r10,#0x20000000 ;
  subhi r0,r0,#0x0a000000
  movs r0,r0,lsl #4
  orrmi r10,r10,#0x90000000 ;
  bicne r10,r10,#0x40000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r0,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldr r6,[r7,#0x54]
  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opcf0f:
  str r5,[r7,#0x5c] ;

;
;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r6,r0,asl #24

;
  ldr r11,[r7,#0x3c] ;
  sub r11,r11,#2 ;
  str r11,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

  mov r1,r0,asl #24

  bic r10,r10,#0xb1000000 ;
  ldr r0,[r7,#0x4c] ;
  mov r3,#0x00f00000
  and r2,r3,r1,lsr #4
  tst r0,#0x20000000
  and r0,r3,r6,lsr #4
  add r0,r0,r2
  addne r0,r0,#0x00100000
  cmp r0,#0x00900000
  addhi r0,r0,#0x00600000 ;
  mov r2,r1,lsr #28
  add r0,r0,r2,lsl #24
  mov r2,r6,lsr #28
  add r0,r0,r2,lsl #24
  cmp r0,#0x09900000
  orrhi r10,r10,#0x20000000 ;
  subhi r0,r0,#0x0a000000
  movs r0,r0,lsl #4
  orrmi r10,r10,#0x90000000 ;
  bicne r10,r10,#0x40000000 ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r0,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldr r6,[r7,#0x54]
  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd000:
;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  adds r1,r0,r1,asl #24
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd010:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  adds r1,r0,r1,asl #24
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd018:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#1 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  adds r1,r0,r1,asl #24
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd01f:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x3c] ;
  add r3,r0,#2 ;
  str r3,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  adds r1,r0,r1,asl #24
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd020:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  adds r1,r0,r1,asl #24
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd027:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  adds r1,r0,r1,asl #24
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd028:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  adds r1,r0,r1,asl #24
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd030:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  adds r1,r0,r1,asl #24
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd038:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  adds r1,r0,r1,asl #24
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd039:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  adds r1,r0,r1,asl #24
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd03a:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x80] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  adds r1,r0,r1,asl #24
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd03b:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x80] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  adds r1,r0,r1,asl #24
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd03c:
;
  ldrsb r0,[r4],#2 ;
;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  mov r0,r0,asl #24
  adds r1,r0,r1,asl #24
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  strb r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd050:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  adds r1,r0,r1,asl #16
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd058:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#2 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  adds r1,r0,r1,asl #16
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd060:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#2 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  adds r1,r0,r1,asl #16
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd068:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  adds r1,r0,r1,asl #16
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd070:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  adds r1,r0,r1,asl #16
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd078:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  adds r1,r0,r1,asl #16
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd079:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  adds r1,r0,r1,asl #16
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd07a:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  adds r1,r0,r1,asl #16
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd07b:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  adds r1,r0,r1,asl #16
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd07c:
;
  ldrsh r0,[r4],#2 ;
;

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r1,[r7,r11]

;
  mov r0,r0,asl #16
  adds r1,r0,r1,asl #16
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
;
  strh r1,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd080:
;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  adds r1,r0,r1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd090:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  adds r1,r0,r1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd098:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#4 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  adds r1,r0,r1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd0a0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#4 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  adds r1,r0,r1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd0a8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  adds r1,r0,r1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd0b0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  adds r1,r0,r1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd0b8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  adds r1,r0,r1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd0b9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  adds r1,r0,r1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd0ba:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x88] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  adds r1,r0,r1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd0bb:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x88] ;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  adds r1,r0,r1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd0bc:
;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r0,r3,r2,lsl #16
;

;
  and r11,r8,#0x0e00
;
  ldr r1,[r7,r11,lsr #7]

;
  adds r1,r0,r1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd0c0:
;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  mov r0,r0,asl #16

  add r1,r1,r0,asr #16

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd0d0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  mov r0,r0,asl #16

  add r1,r1,r0,asr #16

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd0d8:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#2 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  mov r0,r0,asl #16

  add r1,r1,r0,asr #16

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd0e0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#2 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  mov r0,r0,asl #16

  add r1,r1,r0,asr #16

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd0e8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  mov r0,r0,asl #16

  add r1,r1,r0,asr #16

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd0f0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  mov r0,r0,asl #16

  add r1,r1,r0,asr #16

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd0f8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  mov r0,r0,asl #16

  add r1,r1,r0,asr #16

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd0f9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  mov r0,r0,asl #16

  add r1,r1,r0,asr #16

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd0fa:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  mov r0,r0,asl #16

  add r1,r1,r0,asr #16

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd0fb:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x84] ;

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  mov r0,r0,asl #16

  add r1,r1,r0,asr #16

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd0fc:
;
  ldrsh r0,[r4],#2 ;
;

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  mov r0,r0,asl #16

  add r1,r1,r0,asr #16

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd100:
;
;
  and r6,r8,#0x0007
;
  ldr r6,[r7,r6,lsl #2]

;
  and r11,r8,#0x0e00
;
  ldr r0,[r7,r11,lsr #7]

  mov r6,r6,asl #24

;
;
  ldr r2,[r7,#0x4c]
  msr cpsr_flg,r2 ;

;
  mvn r2,#0
  orr r6,r6,r2,lsr #8

  adcs r1,r6,r0,asl #24
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;
  movs r2,r1,lsr #24
  orreq r10,r10,#0x40000000 ;
  andeq r10,r10,r3 ;

;
;
  mov r1,r1,asr #24
  strb r1,[r7,r11,lsr #7]

  ldr r6,[r7,#0x54]
  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd108:
  str r5,[r7,#0x5c] ;

;
;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r6,r0,asl #24

;
  and r2,r8,#0x1e00
  ldr r11,[r7,r2,lsr #7]
  sub r11,r11,#1 ;
  str r11,[r7,r2,lsr #7]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
;
  ldr r2,[r7,#0x4c]
  msr cpsr_flg,r2 ;

;
  mvn r2,#0
  orr r6,r6,r2,lsr #8

  adcs r1,r6,r0,asl #24
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;
  movs r2,r1,lsr #24
  orreq r10,r10,#0x40000000 ;
  andeq r10,r10,r3 ;

;
;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldr r6,[r7,#0x54]
  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd10f:
  str r5,[r7,#0x5c] ;

;
;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r6,r0,asl #24

;
  and r2,r8,#0x1e00
  ldr r11,[r7,r2,lsr #7]
  sub r11,r11,#1 ;
  str r11,[r7,r2,lsr #7]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
;
  ldr r2,[r7,#0x4c]
  msr cpsr_flg,r2 ;

;
  mvn r2,#0
  orr r6,r6,r2,lsr #8

  adcs r1,r6,r0,asl #24
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;
  movs r2,r1,lsr #24
  orreq r10,r10,#0x40000000 ;
  andeq r10,r10,r3 ;

;
;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldr r6,[r7,#0x54]
  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd110:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #24
  adds r1,r0,r1,asl #24
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd118:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#1 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #24
  adds r1,r0,r1,asl #24
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd11f:
  str r5,[r7,#0x5c] ;

;
  ldr r11,[r7,#0x3c] ;
  add r3,r11,#2 ;
  str r3,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #24
  adds r1,r0,r1,asl #24
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd120:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#1 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #24
  adds r1,r0,r1,asl #24
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd127:
  str r5,[r7,#0x5c] ;

;
  ldr r11,[r7,#0x3c] ;
  sub r11,r11,#2 ;
  str r11,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #24
  adds r1,r0,r1,asl #24
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd128:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #24
  adds r1,r0,r1,asl #24
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd130:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #24
  adds r1,r0,r1,asl #24
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd138:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #24
  adds r1,r0,r1,asl #24
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd139:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #24
  adds r1,r0,r1,asl #24
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #24
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd140:
;
;
  and r6,r8,#0x0007
;
  ldr r6,[r7,r6,lsl #2]

;
  and r11,r8,#0x0e00
  mov r11,r11,lsr #7
;
  ldr r0,[r7,r11]

  mov r6,r6,asl #16

;
;
  ldr r2,[r7,#0x4c]
  msr cpsr_flg,r2 ;

;
  mvn r2,#0
  orr r6,r6,r2,lsr #16

  adcs r1,r6,r0,asl #16
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;
  movs r2,r1,lsr #16
  orreq r10,r10,#0x40000000 ;
  andeq r10,r10,r3 ;

;
;
  mov r1,r1,asr #16
  strh r1,[r7,r11]

  ldr r6,[r7,#0x54]
  ldrh r8,[r4],#2 ;
  subs r5,r5,#4 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd148:
  str r5,[r7,#0x5c] ;

;
;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#2 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x6c] ;
  mov r6,r0,asl #16

;
  and r2,r8,#0x1e00
  ldr r11,[r7,r2,lsr #7]
  sub r11,r11,#2 ;
  str r11,[r7,r2,lsr #7]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
;
  ldr r2,[r7,#0x4c]
  msr cpsr_flg,r2 ;

;
  mvn r2,#0
  orr r6,r6,r2,lsr #16

  adcs r1,r6,r0,asl #16
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;
  movs r2,r1,lsr #16
  orreq r10,r10,#0x40000000 ;
  andeq r10,r10,r3 ;

;
;
  mov r1,r1,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldr r6,[r7,#0x54]
  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd150:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #16
  adds r1,r0,r1,asl #16
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd158:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#2 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #16
  adds r1,r0,r1,asl #16
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd160:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#2 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #16
  adds r1,r0,r1,asl #16
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd168:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #16
  adds r1,r0,r1,asl #16
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd170:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #16
  adds r1,r0,r1,asl #16
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd178:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #16
  adds r1,r0,r1,asl #16
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd179:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  mov r0,r0,asl #16
  adds r1,r0,r1,asl #16
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r1,asr #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd180:
;
;
  and r6,r8,#0x0007
;
  ldr r6,[r7,r6,lsl #2]

;
  and r11,r8,#0x0e00
;
  ldr r0,[r7,r11,lsr #7]

;
;
  ldr r2,[r7,#0x4c]
  msr cpsr_flg,r2 ;

  adcs r1,r6,r0
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;
  andeq r10,r10,r3 ;

;
;
  str r1,[r7,r11,lsr #7]

  ldr r6,[r7,#0x54]
  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd188:
  str r5,[r7,#0x5c] ;

;
;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#4 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;
  mov r6,r0

;
  and r2,r8,#0x1e00
  ldr r11,[r7,r2,lsr #7]
  sub r11,r11,#4 ;
  str r11,[r7,r2,lsr #7]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
;
  ldr r2,[r7,#0x4c]
  msr cpsr_flg,r2 ;

  adcs r1,r6,r0
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;
  andeq r10,r10,r3 ;

;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldr r6,[r7,#0x54]
  ldrh r8,[r4],#2 ;
  subs r5,r5,#30 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd190:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  adds r1,r0,r1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd198:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#4 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  adds r1,r0,r1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd1a0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#4 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  adds r1,r0,r1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd1a8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  adds r1,r0,r1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd1b0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  adds r1,r0,r1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#26 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd1b8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  adds r1,r0,r1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd1b9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x70] ;

;
  and r1,r8,#0x0e00
;
  ldr r1,[r7,r1,lsr #7]

;
  adds r1,r0,r1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x7c] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#28 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd1c0:
;
  and r0,r8,#0x000f
;
  ldr r0,[r7,r0,lsl #2]

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  add r1,r1,r0

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd1d0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  add r1,r1,r0

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd1d8:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  add r3,r0,#4 ;
  str r3,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  add r1,r1,r0

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd1e0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#4 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  add r1,r1,r0

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd1e8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r0,r0,r2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  add r1,r1,r0

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd1f0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r0,r2,r3 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  add r1,r1,r0

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd1f8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  add r1,r1,r0

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd1f9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r0,r0,r2,lsl #16
;
  mov lr,pc
  ldr pc,[r7,#0x70] ;

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  add r1,r1,r0

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd1fa:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  sub r0,r4,r0 ;
  ldrsh r2,[r4],#2 ;
  mov r0,r0,lsl #8
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x88] ;

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  add r1,r1,r0

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd1fb:
  str r5,[r7,#0x5c] ;

;
  ldr r0,[r7,#0x60] ;
  ldrh r3,[r4] ;
  sub r0,r4,r0 ;
  add r4,r4,#2
  mov r0,r0,asl #8 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r3,r3,asl #24 ;
  add r2,r2,r3,asr #24 ;
  add r0,r2,r0,asr #8 ;
;
  mov lr,pc
  ldr pc,[r7,#0x88] ;

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  add r1,r1,r0

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opd1fc:
;
  ldrh r2,[r4],#2 ;
  ldrh r3,[r4],#2
  orr r0,r3,r2,lsl #16
;

;
  and r11,r8,#0x1e00
;
  ldr r1,[r7,r11,lsr #7]

  add r1,r1,r0

;
  str r1,[r7,r11,lsr #7]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opdf08:
  str r5,[r7,#0x5c] ;

;
;
  and r2,r8,#0x000f
  ldr r0,[r7,r2,lsl #2]
  sub r0,r0,#1 ;
  str r0,[r7,r2,lsl #2]
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r6,r0,asl #24

;
  ldr r11,[r7,#0x3c] ;
  sub r11,r11,#2 ;
  str r11,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
;
  ldr r2,[r7,#0x4c]
  msr cpsr_flg,r2 ;

;
  mvn r2,#0
  orr r6,r6,r2,lsr #8

  adcs r1,r6,r0,asl #24
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;
  movs r2,r1,lsr #24
  orreq r10,r10,#0x40000000 ;
  andeq r10,r10,r3 ;

;
;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldr r6,[r7,#0x54]
  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opdf0f:
  str r5,[r7,#0x5c] ;

;
;
  ldr r0,[r7,#0x3c] ;
  sub r0,r0,#2 ;
  str r0,[r7,#0x3c] ;
;
  mov lr,pc
  ldr pc,[r7,#0x68] ;
  mov r6,r0,asl #24

;
  ldr r11,[r7,#0x3c] ;
  sub r11,r11,#2 ;
  str r11,[r7,#0x3c] ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x68] ;

;
;
  ldr r2,[r7,#0x4c]
  msr cpsr_flg,r2 ;

;
  mvn r2,#0
  orr r6,r6,r2,lsr #8

  adcs r1,r6,r0,asl #24
  orr r3,r10,#0xb0000000 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;
  movs r2,r1,lsr #24
  orreq r10,r10,#0x40000000 ;
  andeq r10,r10,r3 ;

;
;
  mov r1,r1,asr #24
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x74] ;

  ldr r6,[r7,#0x54]
  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope000:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]
  mov r0,r0,asl #24

;
  mov r0,r0,asr #24

;
  movs r0,r0,asr #8
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  movs r0,r0,lsl #24

;
  mov r0,r0,asr #24
  strb r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope008:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]
  mov r0,r0,asl #24

;
  mov r0,r0,lsr #24

;
  movs r0,r0,lsr #8
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  movs r0,r0,lsl #24
  orrmi r10,r10,#0x80000000 ;

;
  mov r0,r0,asr #24
  strb r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope010:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]
  mov r0,r0,asl #24

  mov r2,#8
  mov r0,r0,lsr #24 ;

;
  ldr r3,[r7,#0x4c]
  rsb r1,r2,#8
  and r3,r3,#0x20000000
  mov r3,r3,lsr #29
  mov r3,r3,lsl r1
;
  orr r3,r3,r0,lsr r2 ;
  rsbs r2,r2,#9 ;
  orrs r0,r3,r0,lsl r2 ;

  movs r0,r0,lsl #24 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r0,r0,asr #24
  strb r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope018:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]
  mov r0,r0,asl #24

;
  orr r0,r0,r0,lsr #8
  orr r0,r0,r0,lsr #16

;
  adds r0,r0,#0 ;
  movs r0,r0,ror #8
  mrs r10,cpsr ;

;
  mov r0,r0,asr #24
  strb r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope020:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]
  mov r0,r0,asl #24

;
  and r2,r8,#0x0e00
  ldr r2,[r7,r2,lsr #7]
  and r2,r2,#63

  sub r5,r5,r2,asl #1 ;

;
  mov r0,r0,asr #24

;
  movs r0,r0,asr r2
  mrs r10,cpsr ;
  cmp r2,#0 ;
  biceq r10,r10,#0x20000000 ;
  strne r10,[r7,#0x4c] ;

;
  movs r0,r0,lsl #24

;
  mov r0,r0,asr #24
  strb r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope028:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]
  mov r0,r0,asl #24

;
  and r2,r8,#0x0e00
  ldr r2,[r7,r2,lsr #7]
  and r2,r2,#63

  sub r5,r5,r2,asl #1 ;

;
  mov r0,r0,lsr #24

;
  movs r0,r0,lsr r2
  mrs r10,cpsr ;
  cmp r2,#0 ;
  biceq r10,r10,#0x20000000 ;
  strne r10,[r7,#0x4c] ;

;
  movs r0,r0,lsl #24
  orrmi r10,r10,#0x80000000 ;

;
  mov r0,r0,asr #24
  strb r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope030:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]
  mov r0,r0,asl #24

;
  and r2,r8,#0x0e00
  ldr r2,[r7,r2,lsr #7]
  and r2,r2,#63

  sub r5,r5,r2,asl #1 ;

;
Reduce_e030:
  subs r2,r2,#9
  bpl Reduce_e030
  adds r2,r2,#9 ;
  beq norotx_e030

  mov r0,r0,lsr #24 ;

;
  ldr r3,[r7,#0x4c]
  rsb r1,r2,#8
  and r3,r3,#0x20000000
  mov r3,r3,lsr #29
  mov r3,r3,lsl r1
;
  orr r3,r3,r0,lsr r2 ;
  rsbs r2,r2,#9 ;
  orrs r0,r3,r0,lsl r2 ;

  movs r0,r0,lsl #24 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;
  b nozeroxe030
norotx_e030:
  ldr r2,[r7,#0x4c]
  adds r0,r0,#0 ;
  mrs r10,cpsr ;
  and r2,r2,#0x20000000
  orr r10,r10,r2 ;
nozeroxe030:

;
  mov r0,r0,asr #24
  strb r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope038:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]
  mov r0,r0,asl #24

;
  and r2,r8,#0x0e00
  ldr r2,[r7,r2,lsr #7]
  and r2,r2,#63

  sub r5,r5,r2,asl #1 ;

;
  orr r0,r0,r0,lsr #8
  orr r0,r0,r0,lsr #16

;
  adds r0,r0,#0 ;
  movs r0,r0,ror r2
  mrs r10,cpsr ;

;
  mov r0,r0,asr #24
  strb r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope040:
;
  and r11,r8,#0x0007
  mov r11,r11,lsl #2
;
  ldr r0,[r7,r11]
  mov r0,r0,asl #16

;
  mov r0,r0,asr #16

;
  movs r0,r0,asr #8
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  movs r0,r0,lsl #16

;
  mov r0,r0,asr #16
  strh r0,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope048:
;
  and r11,r8,#0x0007
  mov r11,r11,lsl #2
;
  ldr r0,[r7,r11]
  mov r0,r0,asl #16

;
  mov r0,r0,lsr #16

;
  movs r0,r0,lsr #8
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  movs r0,r0,lsl #16
  orrmi r10,r10,#0x80000000 ;

;
  mov r0,r0,asr #16
  strh r0,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope050:
;
  and r11,r8,#0x0007
  mov r11,r11,lsl #2
;
  ldr r0,[r7,r11]
  mov r0,r0,asl #16

  mov r2,#8
  mov r0,r0,lsr #16 ;

;
  ldr r3,[r7,#0x4c]
  rsb r1,r2,#16
  and r3,r3,#0x20000000
  mov r3,r3,lsr #29
  mov r3,r3,lsl r1
;
  orr r3,r3,r0,lsr r2 ;
  rsbs r2,r2,#17 ;
  orrs r0,r3,r0,lsl r2 ;

  movs r0,r0,lsl #16 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r0,r0,asr #16
  strh r0,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope058:
;
  and r11,r8,#0x0007
  mov r11,r11,lsl #2
;
  ldr r0,[r7,r11]
  mov r0,r0,asl #16

;
  orr r0,r0,r0,lsr #16

;
  adds r0,r0,#0 ;
  movs r0,r0,ror #8
  mrs r10,cpsr ;

;
  mov r0,r0,asr #16
  strh r0,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope060:
;
  and r11,r8,#0x0007
  mov r11,r11,lsl #2
;
  ldr r0,[r7,r11]
  mov r0,r0,asl #16

;
  and r2,r8,#0x0e00
  ldr r2,[r7,r2,lsr #7]
  and r2,r2,#63

  sub r5,r5,r2,asl #1 ;

;
  mov r0,r0,asr #16

;
  movs r0,r0,asr r2
  mrs r10,cpsr ;
  cmp r2,#0 ;
  biceq r10,r10,#0x20000000 ;
  strne r10,[r7,#0x4c] ;

;
  movs r0,r0,lsl #16

;
  mov r0,r0,asr #16
  strh r0,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope068:
;
  and r11,r8,#0x0007
  mov r11,r11,lsl #2
;
  ldr r0,[r7,r11]
  mov r0,r0,asl #16

;
  and r2,r8,#0x0e00
  ldr r2,[r7,r2,lsr #7]
  and r2,r2,#63

  sub r5,r5,r2,asl #1 ;

;
  mov r0,r0,lsr #16

;
  movs r0,r0,lsr r2
  mrs r10,cpsr ;
  cmp r2,#0 ;
  biceq r10,r10,#0x20000000 ;
  strne r10,[r7,#0x4c] ;

;
  movs r0,r0,lsl #16
  orrmi r10,r10,#0x80000000 ;

;
  mov r0,r0,asr #16
  strh r0,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope070:
;
  and r11,r8,#0x0007
  mov r11,r11,lsl #2
;
  ldr r0,[r7,r11]
  mov r0,r0,asl #16

;
  and r2,r8,#0x0e00
  ldr r2,[r7,r2,lsr #7]
  and r2,r2,#63

  sub r5,r5,r2,asl #1 ;

;
Reduce_e070:
  subs r2,r2,#17
  bpl Reduce_e070
  adds r2,r2,#17 ;
  beq norotx_e070

  mov r0,r0,lsr #16 ;

;
  ldr r3,[r7,#0x4c]
  rsb r1,r2,#16
  and r3,r3,#0x20000000
  mov r3,r3,lsr #29
  mov r3,r3,lsl r1
;
  orr r3,r3,r0,lsr r2 ;
  rsbs r2,r2,#17 ;
  orrs r0,r3,r0,lsl r2 ;

  movs r0,r0,lsl #16 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;
  b nozeroxe070
norotx_e070:
  ldr r2,[r7,#0x4c]
  adds r0,r0,#0 ;
  mrs r10,cpsr ;
  and r2,r2,#0x20000000
  orr r10,r10,r2 ;
nozeroxe070:

;
  mov r0,r0,asr #16
  strh r0,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope078:
;
  and r11,r8,#0x0007
  mov r11,r11,lsl #2
;
  ldr r0,[r7,r11]
  mov r0,r0,asl #16

;
  and r2,r8,#0x0e00
  ldr r2,[r7,r2,lsr #7]
  and r2,r2,#63

  sub r5,r5,r2,asl #1 ;

;
  orr r0,r0,r0,lsr #16

;
  adds r0,r0,#0 ;
  movs r0,r0,ror r2
  mrs r10,cpsr ;

;
  mov r0,r0,asr #16
  strh r0,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope080:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]

;
  movs r0,r0,asr #8
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  str r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope088:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]

;
  movs r0,r0,lsr #8
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  str r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope090:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]

  mov r2,#8

;
  ldr r3,[r7,#0x4c]
  rsb r1,r2,#32
  and r3,r3,#0x20000000
  mov r3,r3,lsr #29
  mov r3,r3,lsl r1
;
  orr r3,r3,r0,lsr r2 ;
  rsbs r2,r2,#33 ;
  orrs r0,r3,r0,lsl r2 ;

  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  str r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope098:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]

;
  adds r0,r0,#0 ;
  movs r0,r0,ror #8
  mrs r10,cpsr ;

;
  str r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope0a0:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]

;
  and r2,r8,#0x0e00
  ldr r2,[r7,r2,lsr #7]
  and r2,r2,#63

  sub r5,r5,r2,asl #1 ;

;
  movs r0,r0,asr r2
  mrs r10,cpsr ;
  cmp r2,#0 ;
  biceq r10,r10,#0x20000000 ;
  strne r10,[r7,#0x4c] ;

;
  str r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope0a8:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]

;
  and r2,r8,#0x0e00
  ldr r2,[r7,r2,lsr #7]
  and r2,r2,#63

  sub r5,r5,r2,asl #1 ;

;
  movs r0,r0,lsr r2
  mrs r10,cpsr ;
  cmp r2,#0 ;
  biceq r10,r10,#0x20000000 ;
  strne r10,[r7,#0x4c] ;

;
  str r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope0b0:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]

;
  and r2,r8,#0x0e00
  ldr r2,[r7,r2,lsr #7]
  and r2,r2,#63

  sub r5,r5,r2,asl #1 ;

  subs r2,r2,#33
  addmis r2,r2,#33 ;
  beq norotx_e0b0


;
  ldr r3,[r7,#0x4c]
  rsb r1,r2,#32
  and r3,r3,#0x20000000
  mov r3,r3,lsr #29
  mov r3,r3,lsl r1
;
  orr r3,r3,r0,lsr r2 ;
  rsbs r2,r2,#33 ;
  orrs r0,r3,r0,lsl r2 ;

  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;
  b nozeroxe0b0
norotx_e0b0:
  ldr r2,[r7,#0x4c]
  adds r0,r0,#0 ;
  mrs r10,cpsr ;
  and r2,r2,#0x20000000
  orr r10,r10,r2 ;
nozeroxe0b0:

;
  str r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope0b8:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]

;
  and r2,r8,#0x0e00
  ldr r2,[r7,r2,lsr #7]
  and r2,r2,#63

  sub r5,r5,r2,asl #1 ;

;
  adds r0,r0,#0 ;
  movs r0,r0,ror r2
  mrs r10,cpsr ;

;
  str r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope0d0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

;
  mov r0,r0,asr #16

;
  movs r0,r0,asr #1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  movs r0,r0,lsl #16

;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope0d8:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#2 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

;
  mov r0,r0,asr #16

;
  movs r0,r0,asr #1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  movs r0,r0,lsl #16

;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope0e0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#2 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

;
  mov r0,r0,asr #16

;
  movs r0,r0,asr #1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  movs r0,r0,lsl #16

;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope0e8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

;
  mov r0,r0,asr #16

;
  movs r0,r0,asr #1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  movs r0,r0,lsl #16

;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope0f0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

;
  mov r0,r0,asr #16

;
  movs r0,r0,asr #1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  movs r0,r0,lsl #16

;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope0f8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

;
  mov r0,r0,asr #16

;
  movs r0,r0,asr #1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  movs r0,r0,lsl #16

;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope0f9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

;
  mov r0,r0,asr #16

;
  movs r0,r0,asr #1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  movs r0,r0,lsl #16

;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope100:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]
  mov r0,r0,asl #24

  adds r3,r0,#0 ;
;
  movs r0,r0,asl #8
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,#0x80000000
  ands r3,r3,r1,asr #8
  cmpne r3,r1,asr #8
  eoreq r1,r0,r3
  tsteq r1,#0x80000000
  orrne r10,r10,#0x10000000

;
  mov r0,r0,asr #24
  strb r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope108:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]
  mov r0,r0,asl #24

;
  movs r0,r0,lsl #8
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r0,r0,asr #24
  strb r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope110:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]
  mov r0,r0,asl #24

  mov r2,#1 ;
  mov r0,r0,lsr #24 ;

;
  ldr r3,[r7,#0x4c]
  rsb r1,r2,#8
  and r3,r3,#0x20000000
  mov r3,r3,lsr #29
  mov r3,r3,lsl r1
;
  orr r3,r3,r0,lsr r2 ;
  rsbs r2,r2,#9 ;
  orrs r0,r3,r0,lsl r2 ;

  movs r0,r0,lsl #24 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r0,r0,asr #24
  strb r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope118:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]
  mov r0,r0,asl #24

;
  orr r0,r0,r0,lsr #8
  orr r0,r0,r0,lsr #16

;
  movs r0,r0,ror #24
  mrs r10,cpsr ;
  bic r10,r10,#0x30000000 ;
;
  tst r0,#1
  orrne r10,r10,#0x20000000

;
  mov r0,r0,asr #24
  strb r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope120:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]
  mov r0,r0,asl #24

;
  and r2,r8,#0x0e00
  ldr r2,[r7,r2,lsr #7]
  and r2,r2,#63

  sub r5,r5,r2,asl #1 ;

  adds r3,r0,#0 ;
;
  movs r0,r0,asl r2
  mrs r10,cpsr ;
  cmp r2,#0 ;
  biceq r10,r10,#0x20000000 ;
  strne r10,[r7,#0x4c] ;

;
  mov r1,#0x80000000
  ands r3,r3,r1,asr r2
  cmpne r3,r1,asr r2
  eoreq r1,r0,r3
  tsteq r1,#0x80000000
  orrne r10,r10,#0x10000000

;
  mov r0,r0,asr #24
  strb r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope128:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]
  mov r0,r0,asl #24

;
  and r2,r8,#0x0e00
  ldr r2,[r7,r2,lsr #7]
  and r2,r2,#63

  sub r5,r5,r2,asl #1 ;

;
  movs r0,r0,lsl r2
  mrs r10,cpsr ;
  cmp r2,#0 ;
  biceq r10,r10,#0x20000000 ;
  strne r10,[r7,#0x4c] ;

;
  mov r0,r0,asr #24
  strb r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope130:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]
  mov r0,r0,asl #24

;
  and r2,r8,#0x0e00
  ldr r2,[r7,r2,lsr #7]
  and r2,r2,#63

  sub r5,r5,r2,asl #1 ;

;
Reduce_e130:
  subs r2,r2,#9
  bpl Reduce_e130
  adds r2,r2,#9 ;
  beq norotx_e130

  rsb r2,r2,#9 ;
  mov r0,r0,lsr #24 ;

;
  ldr r3,[r7,#0x4c]
  rsb r1,r2,#8
  and r3,r3,#0x20000000
  mov r3,r3,lsr #29
  mov r3,r3,lsl r1
;
  orr r3,r3,r0,lsr r2 ;
  rsbs r2,r2,#9 ;
  orrs r0,r3,r0,lsl r2 ;

  movs r0,r0,lsl #24 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;
  b nozeroxe130
norotx_e130:
  ldr r2,[r7,#0x4c]
  adds r0,r0,#0 ;
  mrs r10,cpsr ;
  and r2,r2,#0x20000000
  orr r10,r10,r2 ;
nozeroxe130:

;
  mov r0,r0,asr #24
  strb r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope138:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]
  mov r0,r0,asl #24

;
  and r2,r8,#0x0e00
  ldr r2,[r7,r2,lsr #7]
  and r2,r2,#63

  sub r5,r5,r2,asl #1 ;

;
  orr r0,r0,r0,lsr #8
  orr r0,r0,r0,lsr #16

;
  rsb r2,r2,#32
  movs r0,r0,ror r2
  mrs r10,cpsr ;
  bic r10,r10,#0x30000000 ;
;
  cmp r2,#32 ;
  tstne r0,#1 ;
  orrne r10,r10,#0x20000000

;
  mov r0,r0,asr #24
  strb r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope140:
;
  and r11,r8,#0x0007
  mov r11,r11,lsl #2
;
  ldr r0,[r7,r11]
  mov r0,r0,asl #16

  adds r3,r0,#0 ;
;
  movs r0,r0,asl #8
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,#0x80000000
  ands r3,r3,r1,asr #8
  cmpne r3,r1,asr #8
  eoreq r1,r0,r3
  tsteq r1,#0x80000000
  orrne r10,r10,#0x10000000

;
  mov r0,r0,asr #16
  strh r0,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope148:
;
  and r11,r8,#0x0007
  mov r11,r11,lsl #2
;
  ldr r0,[r7,r11]
  mov r0,r0,asl #16

;
  movs r0,r0,lsl #8
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r0,r0,asr #16
  strh r0,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope150:
;
  and r11,r8,#0x0007
  mov r11,r11,lsl #2
;
  ldr r0,[r7,r11]
  mov r0,r0,asl #16

  mov r2,#9 ;
  mov r0,r0,lsr #16 ;

;
  ldr r3,[r7,#0x4c]
  rsb r1,r2,#16
  and r3,r3,#0x20000000
  mov r3,r3,lsr #29
  mov r3,r3,lsl r1
;
  orr r3,r3,r0,lsr r2 ;
  rsbs r2,r2,#17 ;
  orrs r0,r3,r0,lsl r2 ;

  movs r0,r0,lsl #16 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r0,r0,asr #16
  strh r0,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope158:
;
  and r11,r8,#0x0007
  mov r11,r11,lsl #2
;
  ldr r0,[r7,r11]
  mov r0,r0,asl #16

;
  orr r0,r0,r0,lsr #16

;
  movs r0,r0,ror #24
  mrs r10,cpsr ;
  bic r10,r10,#0x30000000 ;
;
  tst r0,#1
  orrne r10,r10,#0x20000000

;
  mov r0,r0,asr #16
  strh r0,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#22 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope160:
;
  and r11,r8,#0x0007
  mov r11,r11,lsl #2
;
  ldr r0,[r7,r11]
  mov r0,r0,asl #16

;
  and r2,r8,#0x0e00
  ldr r2,[r7,r2,lsr #7]
  and r2,r2,#63

  sub r5,r5,r2,asl #1 ;

  adds r3,r0,#0 ;
;
  movs r0,r0,asl r2
  mrs r10,cpsr ;
  cmp r2,#0 ;
  biceq r10,r10,#0x20000000 ;
  strne r10,[r7,#0x4c] ;

;
  mov r1,#0x80000000
  ands r3,r3,r1,asr r2
  cmpne r3,r1,asr r2
  eoreq r1,r0,r3
  tsteq r1,#0x80000000
  orrne r10,r10,#0x10000000

;
  mov r0,r0,asr #16
  strh r0,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope168:
;
  and r11,r8,#0x0007
  mov r11,r11,lsl #2
;
  ldr r0,[r7,r11]
  mov r0,r0,asl #16

;
  and r2,r8,#0x0e00
  ldr r2,[r7,r2,lsr #7]
  and r2,r2,#63

  sub r5,r5,r2,asl #1 ;

;
  movs r0,r0,lsl r2
  mrs r10,cpsr ;
  cmp r2,#0 ;
  biceq r10,r10,#0x20000000 ;
  strne r10,[r7,#0x4c] ;

;
  mov r0,r0,asr #16
  strh r0,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope170:
;
  and r11,r8,#0x0007
  mov r11,r11,lsl #2
;
  ldr r0,[r7,r11]
  mov r0,r0,asl #16

;
  and r2,r8,#0x0e00
  ldr r2,[r7,r2,lsr #7]
  and r2,r2,#63

  sub r5,r5,r2,asl #1 ;

;
Reduce_e170:
  subs r2,r2,#17
  bpl Reduce_e170
  adds r2,r2,#17 ;
  beq norotx_e170

  rsb r2,r2,#17 ;
  mov r0,r0,lsr #16 ;

;
  ldr r3,[r7,#0x4c]
  rsb r1,r2,#16
  and r3,r3,#0x20000000
  mov r3,r3,lsr #29
  mov r3,r3,lsl r1
;
  orr r3,r3,r0,lsr r2 ;
  rsbs r2,r2,#17 ;
  orrs r0,r3,r0,lsl r2 ;

  movs r0,r0,lsl #16 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;
  b nozeroxe170
norotx_e170:
  ldr r2,[r7,#0x4c]
  adds r0,r0,#0 ;
  mrs r10,cpsr ;
  and r2,r2,#0x20000000
  orr r10,r10,r2 ;
nozeroxe170:

;
  mov r0,r0,asr #16
  strh r0,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope178:
;
  and r11,r8,#0x0007
  mov r11,r11,lsl #2
;
  ldr r0,[r7,r11]
  mov r0,r0,asl #16

;
  and r2,r8,#0x0e00
  ldr r2,[r7,r2,lsr #7]
  and r2,r2,#63

  sub r5,r5,r2,asl #1 ;

;
  orr r0,r0,r0,lsr #16

;
  rsb r2,r2,#32
  movs r0,r0,ror r2
  mrs r10,cpsr ;
  bic r10,r10,#0x30000000 ;
;
  cmp r2,#32 ;
  tstne r0,#1 ;
  orrne r10,r10,#0x20000000

;
  mov r0,r0,asr #16
  strh r0,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope180:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]

  adds r3,r0,#0 ;
;
  movs r0,r0,asl #8
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,#0x80000000
  ands r3,r3,r1,asr #8
  cmpne r3,r1,asr #8
  eoreq r1,r0,r3
  tsteq r1,#0x80000000
  orrne r10,r10,#0x10000000

;
  str r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope188:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]

;
  movs r0,r0,lsl #8
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  str r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope190:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]

  mov r2,#25 ;

;
  ldr r3,[r7,#0x4c]
  rsb r1,r2,#32
  and r3,r3,#0x20000000
  mov r3,r3,lsr #29
  mov r3,r3,lsl r1
;
  orr r3,r3,r0,lsr r2 ;
  rsbs r2,r2,#33 ;
  orrs r0,r3,r0,lsl r2 ;

  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  str r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope198:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]

;
  movs r0,r0,ror #24
  mrs r10,cpsr ;
  bic r10,r10,#0x30000000 ;
;
  tst r0,#1
  orrne r10,r10,#0x20000000

;
  str r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#24 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope1a0:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]

;
  and r2,r8,#0x0e00
  ldr r2,[r7,r2,lsr #7]
  and r2,r2,#63

  sub r5,r5,r2,asl #1 ;

  adds r3,r0,#0 ;
;
  movs r0,r0,asl r2
  mrs r10,cpsr ;
  cmp r2,#0 ;
  biceq r10,r10,#0x20000000 ;
  strne r10,[r7,#0x4c] ;

;
  mov r1,#0x80000000
  ands r3,r3,r1,asr r2
  cmpne r3,r1,asr r2
  eoreq r1,r0,r3
  tsteq r1,#0x80000000
  orrne r10,r10,#0x10000000

;
  str r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope1a8:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]

;
  and r2,r8,#0x0e00
  ldr r2,[r7,r2,lsr #7]
  and r2,r2,#63

  sub r5,r5,r2,asl #1 ;

;
  movs r0,r0,lsl r2
  mrs r10,cpsr ;
  cmp r2,#0 ;
  biceq r10,r10,#0x20000000 ;
  strne r10,[r7,#0x4c] ;

;
  str r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope1b0:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]

;
  and r2,r8,#0x0e00
  ldr r2,[r7,r2,lsr #7]
  and r2,r2,#63

  sub r5,r5,r2,asl #1 ;

  subs r2,r2,#33
  addmis r2,r2,#33 ;
  beq norotx_e1b0

  rsb r2,r2,#33 ;

;
  ldr r3,[r7,#0x4c]
  rsb r1,r2,#32
  and r3,r3,#0x20000000
  mov r3,r3,lsr #29
  mov r3,r3,lsl r1
;
  orr r3,r3,r0,lsr r2 ;
  rsbs r2,r2,#33 ;
  orrs r0,r3,r0,lsl r2 ;

  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;
  b nozeroxe1b0
norotx_e1b0:
  ldr r2,[r7,#0x4c]
  adds r0,r0,#0 ;
  mrs r10,cpsr ;
  and r2,r2,#0x20000000
  orr r10,r10,r2 ;
nozeroxe1b0:

;
  str r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope1b8:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]

;
  and r2,r8,#0x0e00
  ldr r2,[r7,r2,lsr #7]
  and r2,r2,#63

  sub r5,r5,r2,asl #1 ;

;
  rsb r2,r2,#32
  movs r0,r0,ror r2
  mrs r10,cpsr ;
  bic r10,r10,#0x30000000 ;
;
  cmp r2,#32 ;
  tstne r0,#1 ;
  orrne r10,r10,#0x20000000

;
  str r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope1d0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

  adds r3,r0,#0 ;
;
  movs r0,r0,asl #1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,#0x80000000
  ands r3,r3,r1,asr #1
  cmpne r3,r1,asr #1
  eoreq r1,r0,r3
  tsteq r1,#0x80000000
  orrne r10,r10,#0x10000000

;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope1d8:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#2 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

  adds r3,r0,#0 ;
;
  movs r0,r0,asl #1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,#0x80000000
  ands r3,r3,r1,asr #1
  cmpne r3,r1,asr #1
  eoreq r1,r0,r3
  tsteq r1,#0x80000000
  orrne r10,r10,#0x10000000

;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope1e0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#2 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

  adds r3,r0,#0 ;
;
  movs r0,r0,asl #1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,#0x80000000
  ands r3,r3,r1,asr #1
  cmpne r3,r1,asr #1
  eoreq r1,r0,r3
  tsteq r1,#0x80000000
  orrne r10,r10,#0x10000000

;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope1e8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

  adds r3,r0,#0 ;
;
  movs r0,r0,asl #1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,#0x80000000
  ands r3,r3,r1,asr #1
  cmpne r3,r1,asr #1
  eoreq r1,r0,r3
  tsteq r1,#0x80000000
  orrne r10,r10,#0x10000000

;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope1f0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

  adds r3,r0,#0 ;
;
  movs r0,r0,asl #1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,#0x80000000
  ands r3,r3,r1,asr #1
  cmpne r3,r1,asr #1
  eoreq r1,r0,r3
  tsteq r1,#0x80000000
  orrne r10,r10,#0x10000000

;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope1f8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

  adds r3,r0,#0 ;
;
  movs r0,r0,asl #1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,#0x80000000
  ands r3,r3,r1,asr #1
  cmpne r3,r1,asr #1
  eoreq r1,r0,r3
  tsteq r1,#0x80000000
  orrne r10,r10,#0x10000000

;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope1f9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

  adds r3,r0,#0 ;
;
  movs r0,r0,asl #1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,#0x80000000
  ands r3,r3,r1,asr #1
  cmpne r3,r1,asr #1
  eoreq r1,r0,r3
  tsteq r1,#0x80000000
  orrne r10,r10,#0x10000000

;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope210:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]
  mov r0,r0,asl #24

  orr r0,r0,r0,lsr #24
  bic r0,r0,#0x1000000
;
  ldr r2,[r7,#0x4c]
  msr cpsr_flg,r2 ;

  movs r0,r0,rrx
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;
  bic r10,r10,#0x10000000 ;
;
  mov r0,r0,asr #24
  strb r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope250:
;
  and r11,r8,#0x0007
  mov r11,r11,lsl #2
;
  ldr r0,[r7,r11]
  mov r0,r0,asl #16

  orr r0,r0,r0,lsr #16
  bic r0,r0,#0x10000
;
  ldr r2,[r7,#0x4c]
  msr cpsr_flg,r2 ;

  movs r0,r0,rrx
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;
  bic r10,r10,#0x10000000 ;
;
  mov r0,r0,asr #16
  strh r0,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope290:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]

;
  ldr r2,[r7,#0x4c]
  msr cpsr_flg,r2 ;

  movs r0,r0,rrx
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;
  bic r10,r10,#0x10000000 ;
;
  str r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope2d0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

;
  mov r0,r0,lsr #16

;
  movs r0,r0,lsr #1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  movs r0,r0,lsl #16
  orrmi r10,r10,#0x80000000 ;

;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope2d8:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#2 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

;
  mov r0,r0,lsr #16

;
  movs r0,r0,lsr #1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  movs r0,r0,lsl #16
  orrmi r10,r10,#0x80000000 ;

;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope2e0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#2 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

;
  mov r0,r0,lsr #16

;
  movs r0,r0,lsr #1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  movs r0,r0,lsl #16
  orrmi r10,r10,#0x80000000 ;

;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope2e8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

;
  mov r0,r0,lsr #16

;
  movs r0,r0,lsr #1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  movs r0,r0,lsl #16
  orrmi r10,r10,#0x80000000 ;

;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope2f0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

;
  mov r0,r0,lsr #16

;
  movs r0,r0,lsr #1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  movs r0,r0,lsl #16
  orrmi r10,r10,#0x80000000 ;

;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope2f8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

;
  mov r0,r0,lsr #16

;
  movs r0,r0,lsr #1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  movs r0,r0,lsl #16
  orrmi r10,r10,#0x80000000 ;

;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope2f9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

;
  mov r0,r0,lsr #16

;
  movs r0,r0,lsr #1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  movs r0,r0,lsl #16
  orrmi r10,r10,#0x80000000 ;

;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope310:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]
  mov r0,r0,asl #24

  ldr r3,[r7,#0x4c]
  movs r0,r0,lsl #1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;
  tst r3,#0x20000000
  orrne r0,r0,#0x1000000
  bicne r10,r10,#0x40000000 ;
  bic r10,r10,#0x10000000 ;
;
  mov r0,r0,asr #24
  strb r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope350:
;
  and r11,r8,#0x0007
  mov r11,r11,lsl #2
;
  ldr r0,[r7,r11]
  mov r0,r0,asl #16

  ldr r3,[r7,#0x4c]
  movs r0,r0,lsl #1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;
  tst r3,#0x20000000
  orrne r0,r0,#0x10000
  bicne r10,r10,#0x40000000 ;
  bic r10,r10,#0x10000000 ;
;
  mov r0,r0,asr #16
  strh r0,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope390:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]

  ldr r3,[r7,#0x4c]
  movs r0,r0,lsl #1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;
  tst r3,#0x20000000
  orrne r0,r0,#0x1
  bicne r10,r10,#0x40000000 ;
  bic r10,r10,#0x10000000 ;
;
  str r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#10 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope3d0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

;
  movs r0,r0,lsl #1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope3d8:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#2 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

;
  movs r0,r0,lsl #1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope3e0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#2 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

;
  movs r0,r0,lsl #1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope3e8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

;
  movs r0,r0,lsl #1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope3f0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

;
  movs r0,r0,lsl #1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope3f8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

;
  movs r0,r0,lsl #1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope3f9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

;
  movs r0,r0,lsl #1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope4d0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

  orr r0,r0,r0,lsr #16
  bic r0,r0,#0x10000
;
  ldr r2,[r7,#0x4c]
  msr cpsr_flg,r2 ;

  movs r0,r0,rrx
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;
  bic r10,r10,#0x10000000 ;
;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope4d8:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#2 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

  orr r0,r0,r0,lsr #16
  bic r0,r0,#0x10000
;
  ldr r2,[r7,#0x4c]
  msr cpsr_flg,r2 ;

  movs r0,r0,rrx
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;
  bic r10,r10,#0x10000000 ;
;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope4e0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#2 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

  orr r0,r0,r0,lsr #16
  bic r0,r0,#0x10000
;
  ldr r2,[r7,#0x4c]
  msr cpsr_flg,r2 ;

  movs r0,r0,rrx
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;
  bic r10,r10,#0x10000000 ;
;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope4e8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

  orr r0,r0,r0,lsr #16
  bic r0,r0,#0x10000
;
  ldr r2,[r7,#0x4c]
  msr cpsr_flg,r2 ;

  movs r0,r0,rrx
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;
  bic r10,r10,#0x10000000 ;
;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope4f0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

  orr r0,r0,r0,lsr #16
  bic r0,r0,#0x10000
;
  ldr r2,[r7,#0x4c]
  msr cpsr_flg,r2 ;

  movs r0,r0,rrx
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;
  bic r10,r10,#0x10000000 ;
;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope4f8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

  orr r0,r0,r0,lsr #16
  bic r0,r0,#0x10000
;
  ldr r2,[r7,#0x4c]
  msr cpsr_flg,r2 ;

  movs r0,r0,rrx
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;
  bic r10,r10,#0x10000000 ;
;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope4f9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

  orr r0,r0,r0,lsr #16
  bic r0,r0,#0x10000
;
  ldr r2,[r7,#0x4c]
  msr cpsr_flg,r2 ;

  movs r0,r0,rrx
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;
  bic r10,r10,#0x10000000 ;
;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope5d0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

  ldr r3,[r7,#0x4c]
  movs r0,r0,lsl #1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;
  tst r3,#0x20000000
  orrne r0,r0,#0x10000
  bicne r10,r10,#0x40000000 ;
  bic r10,r10,#0x10000000 ;
;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope5d8:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#2 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

  ldr r3,[r7,#0x4c]
  movs r0,r0,lsl #1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;
  tst r3,#0x20000000
  orrne r0,r0,#0x10000
  bicne r10,r10,#0x40000000 ;
  bic r10,r10,#0x10000000 ;
;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope5e0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#2 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

  ldr r3,[r7,#0x4c]
  movs r0,r0,lsl #1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;
  tst r3,#0x20000000
  orrne r0,r0,#0x10000
  bicne r10,r10,#0x40000000 ;
  bic r10,r10,#0x10000000 ;
;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope5e8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

  ldr r3,[r7,#0x4c]
  movs r0,r0,lsl #1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;
  tst r3,#0x20000000
  orrne r0,r0,#0x10000
  bicne r10,r10,#0x40000000 ;
  bic r10,r10,#0x10000000 ;
;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope5f0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

  ldr r3,[r7,#0x4c]
  movs r0,r0,lsl #1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;
  tst r3,#0x20000000
  orrne r0,r0,#0x10000
  bicne r10,r10,#0x40000000 ;
  bic r10,r10,#0x10000000 ;
;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope5f8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

  ldr r3,[r7,#0x4c]
  movs r0,r0,lsl #1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;
  tst r3,#0x20000000
  orrne r0,r0,#0x10000
  bicne r10,r10,#0x40000000 ;
  bic r10,r10,#0x10000000 ;
;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope5f9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

  ldr r3,[r7,#0x4c]
  movs r0,r0,lsl #1
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;
  tst r3,#0x20000000
  orrne r0,r0,#0x10000
  bicne r10,r10,#0x40000000 ;
  bic r10,r10,#0x10000000 ;
;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope6d0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

;
  orr r0,r0,r0,lsr #16

;
  adds r0,r0,#0 ;
  movs r0,r0,ror #1
  mrs r10,cpsr ;

;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope6d8:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#2 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

;
  orr r0,r0,r0,lsr #16

;
  adds r0,r0,#0 ;
  movs r0,r0,ror #1
  mrs r10,cpsr ;

;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope6e0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#2 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

;
  orr r0,r0,r0,lsr #16

;
  adds r0,r0,#0 ;
  movs r0,r0,ror #1
  mrs r10,cpsr ;

;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope6e8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

;
  orr r0,r0,r0,lsr #16

;
  adds r0,r0,#0 ;
  movs r0,r0,ror #1
  mrs r10,cpsr ;

;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope6f0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

;
  orr r0,r0,r0,lsr #16

;
  adds r0,r0,#0 ;
  movs r0,r0,ror #1
  mrs r10,cpsr ;

;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope6f8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

;
  orr r0,r0,r0,lsr #16

;
  adds r0,r0,#0 ;
  movs r0,r0,ror #1
  mrs r10,cpsr ;

;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope6f9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

;
  orr r0,r0,r0,lsr #16

;
  adds r0,r0,#0 ;
  movs r0,r0,ror #1
  mrs r10,cpsr ;

;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope7d0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

;
  orr r0,r0,r0,lsr #16

;
  movs r0,r0,ror #31
  mrs r10,cpsr ;
  bic r10,r10,#0x30000000 ;
;
  tst r0,#1
  orrne r10,r10,#0x20000000

;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope7d8:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  ldr r11,[r7,r2,lsl #2]
  add r3,r11,#2 ;
  str r3,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

;
  orr r0,r0,r0,lsr #16

;
  movs r0,r0,ror #31
  mrs r10,cpsr ;
  bic r10,r10,#0x30000000 ;
;
  tst r0,#1
  orrne r10,r10,#0x20000000

;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#12 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope7e0:
  str r5,[r7,#0x5c] ;

;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r11,[r7,r2,lsl #2]
  sub r11,r11,#2 ;
  str r11,[r7,r2,lsl #2]
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

;
  orr r0,r0,r0,lsr #16

;
  movs r0,r0,ror #31
  mrs r10,cpsr ;
  bic r10,r10,#0x30000000 ;
;
  tst r0,#1
  orrne r10,r10,#0x20000000

;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#14 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope7e8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r0,[r4],#2 ;
  and r2,r8,#0x000f
  ldr r2,[r7,r2,lsl #2]
  add r11,r0,r2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

;
  orr r0,r0,r0,lsr #16

;
  movs r0,r0,ror #31
  mrs r10,cpsr ;
  bic r10,r10,#0x30000000 ;
;
  tst r0,#1
  orrne r10,r10,#0x20000000

;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope7f0:
  str r5,[r7,#0x5c] ;

;
;
  ldrh r3,[r4],#2 ;
  mov r2,r3,lsr #10
  tst r3,#0x0800 ;
  and r2,r2,#0x3c ;
  ldreqsh r2,[r7,r2] ;
  ldrne r2,[r7,r2] ;
  mov r0,r3,asl #24 ;
  add r3,r2,r0,asr #24 ;
  and r2,r8,#0x000f
  orr r2,r2,#0x8 ;
  ldr r2,[r7,r2,lsl #2]
  add r11,r2,r3 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

;
  orr r0,r0,r0,lsr #16

;
  movs r0,r0,ror #31
  mrs r10,cpsr ;
  bic r10,r10,#0x30000000 ;
;
  tst r0,#1
  orrne r10,r10,#0x20000000

;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#18 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope7f8:
  str r5,[r7,#0x5c] ;

;
  ldrsh r11,[r4],#2 ;
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

;
  orr r0,r0,r0,lsr #16

;
  movs r0,r0,ror #31
  mrs r10,cpsr ;
  bic r10,r10,#0x30000000 ;
;
  tst r0,#1
  orrne r10,r10,#0x20000000

;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#16 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Ope7f9:
  str r5,[r7,#0x5c] ;

;
  ldrh r2,[r4],#2 ;
  ldrh r0,[r4],#2
  orr r11,r0,r2,lsl #16
;
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x6c] ;
  mov r0,r0,asl #16

;
  orr r0,r0,r0,lsr #16

;
  movs r0,r0,ror #31
  mrs r10,cpsr ;
  bic r10,r10,#0x30000000 ;
;
  tst r0,#1
  orrne r10,r10,#0x20000000

;
  mov r1,r0,asr #16
  add lr,pc,#4
  mov r0,r11
  ldr pc,[r7,#0x78] ;

  ldrh r8,[r4],#2 ;
  subs r5,r5,#20 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opee00:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]
  mov r0,r0,asl #24

  mov r2,r8,lsr #9 ;
  and r2,r2,#7

  sub r5,r5,r2,asl #1 ;

;
  mov r0,r0,asr #24

;
  movs r0,r0,asr r2
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  movs r0,r0,lsl #24

;
  mov r0,r0,asr #24
  strb r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opee08:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]
  mov r0,r0,asl #24

  mov r2,r8,lsr #9 ;
  and r2,r2,#7

  sub r5,r5,r2,asl #1 ;

;
  mov r0,r0,lsr #24

;
  movs r0,r0,lsr r2
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  movs r0,r0,lsl #24
  orrmi r10,r10,#0x80000000 ;

;
  mov r0,r0,asr #24
  strb r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opee10:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]
  mov r0,r0,asl #24

  mov r2,r8,lsr #9 ;
  and r2,r2,#7

  sub r5,r5,r2,asl #1 ;

  mov r0,r0,lsr #24 ;

;
  ldr r3,[r7,#0x4c]
  rsb r1,r2,#8
  and r3,r3,#0x20000000
  mov r3,r3,lsr #29
  mov r3,r3,lsl r1
;
  orr r3,r3,r0,lsr r2 ;
  rsbs r2,r2,#9 ;
  orrs r0,r3,r0,lsl r2 ;

  movs r0,r0,lsl #24 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r0,r0,asr #24
  strb r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opee18:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]
  mov r0,r0,asl #24

  mov r2,r8,lsr #9 ;
  and r2,r2,#7

  sub r5,r5,r2,asl #1 ;

;
  orr r0,r0,r0,lsr #8
  orr r0,r0,r0,lsr #16

;
  adds r0,r0,#0 ;
  movs r0,r0,ror r2
  mrs r10,cpsr ;

;
  mov r0,r0,asr #24
  strb r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opee40:
;
  and r11,r8,#0x0007
  mov r11,r11,lsl #2
;
  ldr r0,[r7,r11]
  mov r0,r0,asl #16

  mov r2,r8,lsr #9 ;
  and r2,r2,#7

  sub r5,r5,r2,asl #1 ;

;
  mov r0,r0,asr #16

;
  movs r0,r0,asr r2
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  movs r0,r0,lsl #16

;
  mov r0,r0,asr #16
  strh r0,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opee48:
;
  and r11,r8,#0x0007
  mov r11,r11,lsl #2
;
  ldr r0,[r7,r11]
  mov r0,r0,asl #16

  mov r2,r8,lsr #9 ;
  and r2,r2,#7

  sub r5,r5,r2,asl #1 ;

;
  mov r0,r0,lsr #16

;
  movs r0,r0,lsr r2
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  movs r0,r0,lsl #16
  orrmi r10,r10,#0x80000000 ;

;
  mov r0,r0,asr #16
  strh r0,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opee50:
;
  and r11,r8,#0x0007
  mov r11,r11,lsl #2
;
  ldr r0,[r7,r11]
  mov r0,r0,asl #16

  mov r2,r8,lsr #9 ;
  and r2,r2,#7

  sub r5,r5,r2,asl #1 ;

  mov r0,r0,lsr #16 ;

;
  ldr r3,[r7,#0x4c]
  rsb r1,r2,#16
  and r3,r3,#0x20000000
  mov r3,r3,lsr #29
  mov r3,r3,lsl r1
;
  orr r3,r3,r0,lsr r2 ;
  rsbs r2,r2,#17 ;
  orrs r0,r3,r0,lsl r2 ;

  movs r0,r0,lsl #16 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r0,r0,asr #16
  strh r0,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opee58:
;
  and r11,r8,#0x0007
  mov r11,r11,lsl #2
;
  ldr r0,[r7,r11]
  mov r0,r0,asl #16

  mov r2,r8,lsr #9 ;
  and r2,r2,#7

  sub r5,r5,r2,asl #1 ;

;
  orr r0,r0,r0,lsr #16

;
  adds r0,r0,#0 ;
  movs r0,r0,ror r2
  mrs r10,cpsr ;

;
  mov r0,r0,asr #16
  strh r0,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opee80:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]

  mov r2,r8,lsr #9 ;
  and r2,r2,#7

  sub r5,r5,r2,asl #1 ;

;
  movs r0,r0,asr r2
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  str r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opee88:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]

  mov r2,r8,lsr #9 ;
  and r2,r2,#7

  sub r5,r5,r2,asl #1 ;

;
  movs r0,r0,lsr r2
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  str r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opee90:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]

  mov r2,r8,lsr #9 ;
  and r2,r2,#7

  sub r5,r5,r2,asl #1 ;


;
  ldr r3,[r7,#0x4c]
  rsb r1,r2,#32
  and r3,r3,#0x20000000
  mov r3,r3,lsr #29
  mov r3,r3,lsl r1
;
  orr r3,r3,r0,lsr r2 ;
  rsbs r2,r2,#33 ;
  orrs r0,r3,r0,lsl r2 ;

  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  str r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opee98:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]

  mov r2,r8,lsr #9 ;
  and r2,r2,#7

  sub r5,r5,r2,asl #1 ;

;
  adds r0,r0,#0 ;
  movs r0,r0,ror r2
  mrs r10,cpsr ;

;
  str r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opef00:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]
  mov r0,r0,asl #24

  mov r2,r8,lsr #9 ;
  and r2,r2,#7

  sub r5,r5,r2,asl #1 ;

  adds r3,r0,#0 ;
;
  movs r0,r0,asl r2
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,#0x80000000
  ands r3,r3,r1,asr r2
  cmpne r3,r1,asr r2
  eoreq r1,r0,r3
  tsteq r1,#0x80000000
  orrne r10,r10,#0x10000000

;
  mov r0,r0,asr #24
  strb r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opef08:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]
  mov r0,r0,asl #24

  mov r2,r8,lsr #9 ;
  and r2,r2,#7

  sub r5,r5,r2,asl #1 ;

;
  movs r0,r0,lsl r2
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r0,r0,asr #24
  strb r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opef10:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]
  mov r0,r0,asl #24

  mov r2,r8,lsr #9 ;
  and r2,r2,#7

  sub r5,r5,r2,asl #1 ;

  rsb r2,r2,#9 ;
  mov r0,r0,lsr #24 ;

;
  ldr r3,[r7,#0x4c]
  rsb r1,r2,#8
  and r3,r3,#0x20000000
  mov r3,r3,lsr #29
  mov r3,r3,lsl r1
;
  orr r3,r3,r0,lsr r2 ;
  rsbs r2,r2,#9 ;
  orrs r0,r3,r0,lsl r2 ;

  movs r0,r0,lsl #24 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r0,r0,asr #24
  strb r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opef18:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]
  mov r0,r0,asl #24

  mov r2,r8,lsr #9 ;
  and r2,r2,#7

  sub r5,r5,r2,asl #1 ;

;
  orr r0,r0,r0,lsr #8
  orr r0,r0,r0,lsr #16

;
  rsb r2,r2,#32
  movs r0,r0,ror r2
  mrs r10,cpsr ;
  bic r10,r10,#0x30000000 ;
;
  tst r0,#1
  orrne r10,r10,#0x20000000

;
  mov r0,r0,asr #24
  strb r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opef40:
;
  and r11,r8,#0x0007
  mov r11,r11,lsl #2
;
  ldr r0,[r7,r11]
  mov r0,r0,asl #16

  mov r2,r8,lsr #9 ;
  and r2,r2,#7

  sub r5,r5,r2,asl #1 ;

  adds r3,r0,#0 ;
;
  movs r0,r0,asl r2
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,#0x80000000
  ands r3,r3,r1,asr r2
  cmpne r3,r1,asr r2
  eoreq r1,r0,r3
  tsteq r1,#0x80000000
  orrne r10,r10,#0x10000000

;
  mov r0,r0,asr #16
  strh r0,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opef48:
;
  and r11,r8,#0x0007
  mov r11,r11,lsl #2
;
  ldr r0,[r7,r11]
  mov r0,r0,asl #16

  mov r2,r8,lsr #9 ;
  and r2,r2,#7

  sub r5,r5,r2,asl #1 ;

;
  movs r0,r0,lsl r2
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r0,r0,asr #16
  strh r0,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opef50:
;
  and r11,r8,#0x0007
  mov r11,r11,lsl #2
;
  ldr r0,[r7,r11]
  mov r0,r0,asl #16

  mov r2,r8,lsr #9 ;
  and r2,r2,#7

  sub r5,r5,r2,asl #1 ;

  rsb r2,r2,#17 ;
  mov r0,r0,lsr #16 ;

;
  ldr r3,[r7,#0x4c]
  rsb r1,r2,#16
  and r3,r3,#0x20000000
  mov r3,r3,lsr #29
  mov r3,r3,lsl r1
;
  orr r3,r3,r0,lsr r2 ;
  rsbs r2,r2,#17 ;
  orrs r0,r3,r0,lsl r2 ;

  movs r0,r0,lsl #16 ;
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r0,r0,asr #16
  strh r0,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opef58:
;
  and r11,r8,#0x0007
  mov r11,r11,lsl #2
;
  ldr r0,[r7,r11]
  mov r0,r0,asl #16

  mov r2,r8,lsr #9 ;
  and r2,r2,#7

  sub r5,r5,r2,asl #1 ;

;
  orr r0,r0,r0,lsr #16

;
  rsb r2,r2,#32
  movs r0,r0,ror r2
  mrs r10,cpsr ;
  bic r10,r10,#0x30000000 ;
;
  tst r0,#1
  orrne r10,r10,#0x20000000

;
  mov r0,r0,asr #16
  strh r0,[r7,r11]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#6 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opef80:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]

  mov r2,r8,lsr #9 ;
  and r2,r2,#7

  sub r5,r5,r2,asl #1 ;

  adds r3,r0,#0 ;
;
  movs r0,r0,asl r2
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  mov r1,#0x80000000
  ands r3,r3,r1,asr r2
  cmpne r3,r1,asr r2
  eoreq r1,r0,r3
  tsteq r1,#0x80000000
  orrne r10,r10,#0x10000000

;
  str r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opef88:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]

  mov r2,r8,lsr #9 ;
  and r2,r2,#7

  sub r5,r5,r2,asl #1 ;

;
  movs r0,r0,lsl r2
  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  str r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opef90:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]

  mov r2,r8,lsr #9 ;
  and r2,r2,#7

  sub r5,r5,r2,asl #1 ;

  rsb r2,r2,#33 ;

;
  ldr r3,[r7,#0x4c]
  rsb r1,r2,#32
  and r3,r3,#0x20000000
  mov r3,r3,lsr #29
  mov r3,r3,lsl r1
;
  orr r3,r3,r0,lsr r2 ;
  rsbs r2,r2,#33 ;
  orrs r0,r3,r0,lsl r2 ;

  mrs r10,cpsr ;
  str r10,[r7,#0x4c] ;

;
  str r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
Opef98:
;
  and r11,r8,#0x0007
;
  ldr r0,[r7,r11,lsl #2]

  mov r2,r8,lsr #9 ;
  and r2,r2,#7

  sub r5,r5,r2,asl #1 ;

;
  rsb r2,r2,#32
  movs r0,r0,ror r2
  mrs r10,cpsr ;
  bic r10,r10,#0x30000000 ;
;
  tst r0,#1
  orrne r10,r10,#0x20000000

;
  str r0,[r7,r11,lsl #2]

  ldrh r8,[r4],#2 ;
  subs r5,r5,#8 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd

;
;
WrongPrivilegeMode:
  ldr r1,[r7,#0x58]
  sub r4,r4,#2 ;
  orr r1,r1,#4 ;
  str r1,[r7,#0x58]
  mov r0,#8 ;
  bl Exception
  ldrh r8,[r4],#2 ;
  subs r5,r5,#34 ;
  ldrge pc,[r6,r8,asl #2] ;
  b CycloneEnd


;
  .data
  .align 4

CycloneJumpTab:

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0
  .long Op____,Op__al,Op__fl,Op0000,Op0010,Op0018,Op001f,Op0020 ;
  .long Op0027,Op0028,Op0030,Op0038,Op0039,Op003c,Op0040,Op0050 ;
  .long Op0058,Op0060,Op0068,Op0070,Op0078,Op0079,Op007c,Op0080 ;
  .long Op0090,Op0098,Op00a0,Op00a8,Op00b0,Op00b8,Op00b9,Op0100 ;
  .long Op0108,Op0110,Op0118,Op011f,Op0120,Op0127,Op0128,Op0130 ;
  .long Op0138,Op0139,Op013a,Op013b,Op013c,Op0140,Op0148,Op0150 ;
  .long Op0158,Op015f,Op0160,Op0167,Op0168,Op0170,Op0178,Op0179 ;
  .long Op0180,Op0188,Op0190,Op0198,Op019f,Op01a0,Op01a7,Op01a8 ;
  .long Op01b0,Op01b8,Op01b9,Op01c0,Op01c8,Op01d0,Op01d8,Op01df ;
  .long Op01e0,Op01e7,Op01e8,Op01f0,Op01f8,Op01f9,Op0200,Op0210 ;
  .long Op0218,Op021f,Op0220,Op0227,Op0228,Op0230,Op0238,Op0239 ;
  .long Op023c,Op0240,Op0250,Op0258,Op0260,Op0268,Op0270,Op0278 ;
  .long Op0279,Op027c,Op0280,Op0290,Op0298,Op02a0,Op02a8,Op02b0 ;
  .long Op02b8,Op02b9,Op0400,Op0410,Op0418,Op041f,Op0420,Op0427 ;
  .long Op0428,Op0430,Op0438,Op0439,Op0440,Op0450,Op0458,Op0460 ;
  .long Op0468,Op0470,Op0478,Op0479,Op0480,Op0490,Op0498,Op04a0 ;
  .long Op04a8,Op04b0,Op04b8,Op04b9,Op0600,Op0610,Op0618,Op061f ;
  .long Op0620,Op0627,Op0628,Op0630,Op0638,Op0639,Op0640,Op0650 ;
  .long Op0658,Op0660,Op0668,Op0670,Op0678,Op0679,Op0680,Op0690 ;
  .long Op0698,Op06a0,Op06a8,Op06b0,Op06b8,Op06b9,Op0800,Op0810 ;
  .long Op0818,Op081f,Op0820,Op0827,Op0828,Op0830,Op0838,Op0839 ;
  .long Op083a,Op083b,Op0840,Op0850,Op0858,Op085f,Op0860,Op0867 ;
  .long Op0868,Op0870,Op0878,Op0879,Op0880,Op0890,Op0898,Op089f ;
  .long Op08a0,Op08a7,Op08a8,Op08b0,Op08b8,Op08b9,Op08c0,Op08d0 ;
  .long Op08d8,Op08df,Op08e0,Op08e7,Op08e8,Op08f0,Op08f8,Op08f9 ;
  .long Op0a00,Op0a10,Op0a18,Op0a1f,Op0a20,Op0a27,Op0a28,Op0a30 ;
  .long Op0a38,Op0a39,Op0a3c,Op0a40,Op0a50,Op0a58,Op0a60,Op0a68 ;
  .long Op0a70,Op0a78,Op0a79,Op0a7c,Op0a80,Op0a90,Op0a98,Op0aa0 ;
  .long Op0aa8,Op0ab0,Op0ab8,Op0ab9,Op0c00,Op0c10,Op0c18,Op0c1f ;
  .long Op0c20,Op0c27,Op0c28,Op0c30,Op0c38,Op0c39,Op0c40,Op0c50 ;
  .long Op0c58,Op0c60,Op0c68,Op0c70,Op0c78,Op0c79,Op0c80,Op0c90 ;
  .long Op0c98,Op0ca0,Op0ca8,Op0cb0,Op0cb8,Op0cb9,Op1000,Op1010 ;
  .long Op1018,Op101f,Op1020,Op1027,Op1028,Op1030,Op1038,Op1039 ;
  .long Op103a,Op103b,Op103c,Op1080,Op1090,Op1098,Op109f,Op10a0 ;
  .long Op10a7,Op10a8,Op10b0,Op10b8,Op10b9,Op10ba,Op10bb,Op10bc ;
  .long Op10c0,Op10d0,Op10d8,Op10df,Op10e0,Op10e7,Op10e8,Op10f0 ;
  .long Op10f8,Op10f9,Op10fa,Op10fb,Op10fc,Op1100,Op1110,Op1118 ;
  .long Op111f,Op1120,Op1127,Op1128,Op1130,Op1138,Op1139,Op113a ;
  .long Op113b,Op113c,Op1140,Op1150,Op1158,Op115f,Op1160,Op1167 ;
  .long Op1168,Op1170,Op1178,Op1179,Op117a,Op117b,Op117c,Op1180 ;
  .long Op1190,Op1198,Op119f,Op11a0,Op11a7,Op11a8,Op11b0,Op11b8 ;
  .long Op11b9,Op11ba,Op11bb,Op11bc,Op11c0,Op11d0,Op11d8,Op11df ;
  .long Op11e0,Op11e7,Op11e8,Op11f0,Op11f8,Op11f9,Op11fa,Op11fb ;
  .long Op11fc,Op13c0,Op13d0,Op13d8,Op13df,Op13e0,Op13e7,Op13e8 ;
  .long Op13f0,Op13f8,Op13f9,Op13fa,Op13fb,Op13fc,Op1ec0,Op1ed0 ;
  .long Op1ed8,Op1edf,Op1ee0,Op1ee7,Op1ee8,Op1ef0,Op1ef8,Op1ef9 ;
  .long Op1efa,Op1efb,Op1efc,Op1f00,Op1f10,Op1f18,Op1f1f,Op1f20 ;
  .long Op1f27,Op1f28,Op1f30,Op1f38,Op1f39,Op1f3a,Op1f3b,Op1f3c ;
  .long Op2000,Op2010,Op2018,Op2020,Op2028,Op2030,Op2038,Op2039 ;
  .long Op203a,Op203b,Op203c,Op2040,Op2050,Op2058,Op2060,Op2068 ;
  .long Op2070,Op2078,Op2079,Op207a,Op207b,Op207c,Op2080,Op2090 ;
  .long Op2098,Op20a0,Op20a8,Op20b0,Op20b8,Op20b9,Op20ba,Op20bb ;
  .long Op20bc,Op20c0,Op20d0,Op20d8,Op20e0,Op20e8,Op20f0,Op20f8 ;
  .long Op20f9,Op20fa,Op20fb,Op20fc,Op2100,Op2110,Op2118,Op2120 ;
  .long Op2128,Op2130,Op2138,Op2139,Op213a,Op213b,Op213c,Op2140 ;
  .long Op2150,Op2158,Op2160,Op2168,Op2170,Op2178,Op2179,Op217a ;
  .long Op217b,Op217c,Op2180,Op2190,Op2198,Op21a0,Op21a8,Op21b0 ;
  .long Op21b8,Op21b9,Op21ba,Op21bb,Op21bc,Op21c0,Op21d0,Op21d8 ;
  .long Op21e0,Op21e8,Op21f0,Op21f8,Op21f9,Op21fa,Op21fb,Op21fc ;
  .long Op23c0,Op23d0,Op23d8,Op23e0,Op23e8,Op23f0,Op23f8,Op23f9 ;
  .long Op23fa,Op23fb,Op23fc,Op2ec0,Op2ed0,Op2ed8,Op2ee0,Op2ee8 ;
  .long Op2ef0,Op2ef8,Op2ef9,Op2efa,Op2efb,Op2efc,Op2f00,Op2f10 ;
  .long Op2f18,Op2f20,Op2f28,Op2f30,Op2f38,Op2f39,Op2f3a,Op2f3b ;
  .long Op2f3c,Op3000,Op3010,Op3018,Op3020,Op3028,Op3030,Op3038 ;
  .long Op3039,Op303a,Op303b,Op303c,Op3040,Op3050,Op3058,Op3060 ;
  .long Op3068,Op3070,Op3078,Op3079,Op307a,Op307b,Op307c,Op3080 ;
  .long Op3090,Op3098,Op30a0,Op30a8,Op30b0,Op30b8,Op30b9,Op30ba ;
  .long Op30bb,Op30bc,Op30c0,Op30d0,Op30d8,Op30e0,Op30e8,Op30f0 ;
  .long Op30f8,Op30f9,Op30fa,Op30fb,Op30fc,Op3100,Op3110,Op3118 ;
  .long Op3120,Op3128,Op3130,Op3138,Op3139,Op313a,Op313b,Op313c ;
  .long Op3140,Op3150,Op3158,Op3160,Op3168,Op3170,Op3178,Op3179 ;
  .long Op317a,Op317b,Op317c,Op3180,Op3190,Op3198,Op31a0,Op31a8 ;
  .long Op31b0,Op31b8,Op31b9,Op31ba,Op31bb,Op31bc,Op31c0,Op31d0 ;
  .long Op31d8,Op31e0,Op31e8,Op31f0,Op31f8,Op31f9,Op31fa,Op31fb ;
  .long Op31fc,Op33c0,Op33d0,Op33d8,Op33e0,Op33e8,Op33f0,Op33f8 ;
  .long Op33f9,Op33fa,Op33fb,Op33fc,Op3ec0,Op3ed0,Op3ed8,Op3ee0 ;
  .long Op3ee8,Op3ef0,Op3ef8,Op3ef9,Op3efa,Op3efb,Op3efc,Op3f00 ;
  .long Op3f10,Op3f18,Op3f20,Op3f28,Op3f30,Op3f38,Op3f39,Op3f3a ;
  .long Op3f3b,Op3f3c,Op4000,Op4010,Op4018,Op401f,Op4020,Op4027 ;
  .long Op4028,Op4030,Op4038,Op4039,Op4040,Op4050,Op4058,Op4060 ;
  .long Op4068,Op4070,Op4078,Op4079,Op4080,Op4090,Op4098,Op40a0 ;
  .long Op40a8,Op40b0,Op40b8,Op40b9,Op40c0,Op40d0,Op40d8,Op40e0 ;
  .long Op40e8,Op40f0,Op40f8,Op40f9,Op4180,Op4190,Op4198,Op41a0 ;
  .long Op41a8,Op41b0,Op41b8,Op41b9,Op41ba,Op41bb,Op41bc,Op41d0 ;
  .long Op41e8,Op41f0,Op41f8,Op41f9,Op41fa,Op41fb,Op4200,Op4210 ;
  .long Op4218,Op421f,Op4220,Op4227,Op4228,Op4230,Op4238,Op4239 ;
  .long Op4240,Op4250,Op4258,Op4260,Op4268,Op4270,Op4278,Op4279 ;
  .long Op4280,Op4290,Op4298,Op42a0,Op42a8,Op42b0,Op42b8,Op42b9 ;
  .long Op4400,Op4410,Op4418,Op441f,Op4420,Op4427,Op4428,Op4430 ;
  .long Op4438,Op4439,Op4440,Op4450,Op4458,Op4460,Op4468,Op4470 ;
  .long Op4478,Op4479,Op4480,Op4490,Op4498,Op44a0,Op44a8,Op44b0 ;
  .long Op44b8,Op44b9,Op44c0,Op44d0,Op44d8,Op44e0,Op44e8,Op44f0 ;
  .long Op44f8,Op44f9,Op44fa,Op44fb,Op44fc,Op4600,Op4610,Op4618 ;
  .long Op461f,Op4620,Op4627,Op4628,Op4630,Op4638,Op4639,Op4640 ;
  .long Op4650,Op4658,Op4660,Op4668,Op4670,Op4678,Op4679,Op4680 ;
  .long Op4690,Op4698,Op46a0,Op46a8,Op46b0,Op46b8,Op46b9,Op46c0 ;
  .long Op46d0,Op46d8,Op46e0,Op46e8,Op46f0,Op46f8,Op46f9,Op46fa ;
  .long Op46fb,Op46fc,Op4800,Op4810,Op4818,Op481f,Op4820,Op4827 ;
  .long Op4828,Op4830,Op4838,Op4839,Op4840,Op4850,Op4868,Op4870 ;
  .long Op4878,Op4879,Op487a,Op487b,Op4880,Op4890,Op48a0,Op48a8 ;
  .long Op48b0,Op48b8,Op48b9,Op48c0,Op48d0,Op48e0,Op48e8,Op48f0 ;
  .long Op48f8,Op48f9,Op4a00,Op4a10,Op4a18,Op4a1f,Op4a20,Op4a27 ;
  .long Op4a28,Op4a30,Op4a38,Op4a39,Op4a40,Op4a50,Op4a58,Op4a60 ;
  .long Op4a68,Op4a70,Op4a78,Op4a79,Op4a80,Op4a90,Op4a98,Op4aa0 ;
  .long Op4aa8,Op4ab0,Op4ab8,Op4ab9,Op4ac0,Op4ad0,Op4ad8,Op4adf ;
  .long Op4ae0,Op4ae7,Op4ae8,Op4af0,Op4af8,Op4af9,Op4c90,Op4c98 ;
  .long Op4ca8,Op4cb0,Op4cb8,Op4cb9,Op4cba,Op4cbb,Op4cd0,Op4cd8 ;
  .long Op4ce8,Op4cf0,Op4cf8,Op4cf9,Op4cfa,Op4cfb,Op4e40,Op4e50 ;
  .long Op4e57,Op4e58,Op4e60,Op4e68,Op4e70,Op4e71,Op4e72,Op4e73 ;
  .long Op4e75,Op4e76,Op4e77,Op4e90,Op4ea8,Op4eb0,Op4eb8,Op4eb9 ;
  .long Op4eba,Op4ebb,Op4ed0,Op4ee8,Op4ef0,Op4ef8,Op4ef9,Op4efa ;
  .long Op4efb,Op5000,Op5010,Op5018,Op501f,Op5020,Op5027,Op5028 ;
  .long Op5030,Op5038,Op5039,Op5040,Op5048,Op5050,Op5058,Op5060 ;
  .long Op5068,Op5070,Op5078,Op5079,Op5080,Op5088,Op5090,Op5098 ;
  .long Op50a0,Op50a8,Op50b0,Op50b8,Op50b9,Op50c0,Op50c8,Op50d0 ;
  .long Op50d8,Op50df,Op50e0,Op50e7,Op50e8,Op50f0,Op50f8,Op50f9 ;
  .long Op5100,Op5110,Op5118,Op511f,Op5120,Op5127,Op5128,Op5130 ;
  .long Op5138,Op5139,Op5140,Op5148,Op5150,Op5158,Op5160,Op5168 ;
  .long Op5170,Op5178,Op5179,Op5180,Op5188,Op5190,Op5198,Op51a0 ;
  .long Op51a8,Op51b0,Op51b8,Op51b9,Op51c0,Op51c8,Op51d0,Op51d8 ;
  .long Op51df,Op51e0,Op51e7,Op51e8,Op51f0,Op51f8,Op51f9,Op5e00 ;
  .long Op5e10,Op5e18,Op5e1f,Op5e20,Op5e27,Op5e28,Op5e30,Op5e38 ;
  .long Op5e39,Op5e40,Op5e48,Op5e50,Op5e58,Op5e60,Op5e68,Op5e70 ;
  .long Op5e78,Op5e79,Op5e80,Op5e88,Op5e90,Op5e98,Op5ea0,Op5ea8 ;
  .long Op5eb0,Op5eb8,Op5eb9,Op52c0,Op52c8,Op52d0,Op52d8,Op52df ;
  .long Op52e0,Op52e7,Op52e8,Op52f0,Op52f8,Op52f9,Op5f00,Op5f10 ;
  .long Op5f18,Op5f1f,Op5f20,Op5f27,Op5f28,Op5f30,Op5f38,Op5f39 ;
  .long Op5f40,Op5f48,Op5f50,Op5f58,Op5f60,Op5f68,Op5f70,Op5f78 ;
  .long Op5f79,Op5f80,Op5f88,Op5f90,Op5f98,Op5fa0,Op5fa8,Op5fb0 ;
  .long Op5fb8,Op5fb9,Op53c0,Op53c8,Op53d0,Op53d8,Op53df,Op53e0 ;
  .long Op53e7,Op53e8,Op53f0,Op53f8,Op53f9,Op54c0,Op54c8,Op54d0 ;
  .long Op54d8,Op54df,Op54e0,Op54e7,Op54e8,Op54f0,Op54f8,Op54f9 ;
  .long Op55c0,Op55c8,Op55d0,Op55d8,Op55df,Op55e0,Op55e7,Op55e8 ;
  .long Op55f0,Op55f8,Op55f9,Op56c0,Op56c8,Op56d0,Op56d8,Op56df ;
  .long Op56e0,Op56e7,Op56e8,Op56f0,Op56f8,Op56f9,Op57c0,Op57c8 ;
  .long Op57d0,Op57d8,Op57df,Op57e0,Op57e7,Op57e8,Op57f0,Op57f8 ;
  .long Op57f9,Op58c0,Op58c8,Op58d0,Op58d8,Op58df,Op58e0,Op58e7 ;
  .long Op58e8,Op58f0,Op58f8,Op58f9,Op59c0,Op59c8,Op59d0,Op59d8 ;
  .long Op59df,Op59e0,Op59e7,Op59e8,Op59f0,Op59f8,Op59f9,Op5ac0 ;
  .long Op5ac8,Op5ad0,Op5ad8,Op5adf,Op5ae0,Op5ae7,Op5ae8,Op5af0 ;
  .long Op5af8,Op5af9,Op5bc0,Op5bc8,Op5bd0,Op5bd8,Op5bdf,Op5be0 ;
  .long Op5be7,Op5be8,Op5bf0,Op5bf8,Op5bf9,Op5cc0,Op5cc8,Op5cd0 ;
  .long Op5cd8,Op5cdf,Op5ce0,Op5ce7,Op5ce8,Op5cf0,Op5cf8,Op5cf9 ;
  .long Op5dc0,Op5dc8,Op5dd0,Op5dd8,Op5ddf,Op5de0,Op5de7,Op5de8 ;
  .long Op5df0,Op5df8,Op5df9,Op5ec0,Op5ec8,Op5ed0,Op5ed8,Op5edf ;
  .long Op5ee0,Op5ee7,Op5ee8,Op5ef0,Op5ef8,Op5ef9,Op5fc0,Op5fc8 ;
  .long Op5fd0,Op5fd8,Op5fdf,Op5fe0,Op5fe7,Op5fe8,Op5ff0,Op5ff8 ;
  .long Op5ff9,Op6000,Op6001,Op6100,Op6101,Op6200,Op6201,Op6300 ;
  .long Op6301,Op6400,Op6401,Op6500,Op6501,Op6600,Op6601,Op6700 ;
  .long Op6701,Op6800,Op6801,Op6900,Op6901,Op6a00,Op6a01,Op6b00 ;
  .long Op6b01,Op6c00,Op6c01,Op6d00,Op6d01,Op6e00,Op6e01,Op6f00 ;
  .long Op6f01,Op7000,Op8000,Op8010,Op8018,Op801f,Op8020,Op8027 ;
  .long Op8028,Op8030,Op8038,Op8039,Op803a,Op803b,Op803c,Op8040 ;
  .long Op8050,Op8058,Op8060,Op8068,Op8070,Op8078,Op8079,Op807a ;
  .long Op807b,Op807c,Op8080,Op8090,Op8098,Op80a0,Op80a8,Op80b0 ;
  .long Op80b8,Op80b9,Op80ba,Op80bb,Op80bc,Op80c0,Op80d0,Op80d8 ;
  .long Op80e0,Op80e8,Op80f0,Op80f8,Op80f9,Op80fa,Op80fb,Op80fc ;
  .long Op8100,Op8108,Op810f,Op8110,Op8118,Op811f,Op8120,Op8127 ;
  .long Op8128,Op8130,Op8138,Op8139,Op8150,Op8158,Op8160,Op8168 ;
  .long Op8170,Op8178,Op8179,Op8190,Op8198,Op81a0,Op81a8,Op81b0 ;
  .long Op81b8,Op81b9,Op81c0,Op81d0,Op81d8,Op81e0,Op81e8,Op81f0 ;
  .long Op81f8,Op81f9,Op81fa,Op81fb,Op81fc,Op8f08,Op8f0f,Op9000 ;
  .long Op9010,Op9018,Op901f,Op9020,Op9027,Op9028,Op9030,Op9038 ;
  .long Op9039,Op903a,Op903b,Op903c,Op9040,Op9050,Op9058,Op9060 ;
  .long Op9068,Op9070,Op9078,Op9079,Op907a,Op907b,Op907c,Op9080 ;
  .long Op9090,Op9098,Op90a0,Op90a8,Op90b0,Op90b8,Op90b9,Op90ba ;
  .long Op90bb,Op90bc,Op90c0,Op90d0,Op90d8,Op90e0,Op90e8,Op90f0 ;
  .long Op90f8,Op90f9,Op90fa,Op90fb,Op90fc,Op9100,Op9108,Op910f ;
  .long Op9110,Op9118,Op911f,Op9120,Op9127,Op9128,Op9130,Op9138 ;
  .long Op9139,Op9140,Op9148,Op9150,Op9158,Op9160,Op9168,Op9170 ;
  .long Op9178,Op9179,Op9180,Op9188,Op9190,Op9198,Op91a0,Op91a8 ;
  .long Op91b0,Op91b8,Op91b9,Op91c0,Op91d0,Op91d8,Op91e0,Op91e8 ;
  .long Op91f0,Op91f8,Op91f9,Op91fa,Op91fb,Op91fc,Op9f08,Op9f0f ;
  .long Opb000,Opb010,Opb018,Opb01f,Opb020,Opb027,Opb028,Opb030 ;
  .long Opb038,Opb039,Opb03a,Opb03b,Opb03c,Opb040,Opb050,Opb058 ;
  .long Opb060,Opb068,Opb070,Opb078,Opb079,Opb07a,Opb07b,Opb07c ;
  .long Opb080,Opb090,Opb098,Opb0a0,Opb0a8,Opb0b0,Opb0b8,Opb0b9 ;
  .long Opb0ba,Opb0bb,Opb0bc,Opb0c0,Opb0d0,Opb0d8,Opb0e0,Opb0e8 ;
  .long Opb0f0,Opb0f8,Opb0f9,Opb0fa,Opb0fb,Opb0fc,Opb100,Opb108 ;
  .long Opb10f,Opb110,Opb118,Opb11f,Opb120,Opb127,Opb128,Opb130 ;
  .long Opb138,Opb139,Opb140,Opb148,Opb150,Opb158,Opb160,Opb168 ;
  .long Opb170,Opb178,Opb179,Opb180,Opb188,Opb190,Opb198,Opb1a0 ;
  .long Opb1a8,Opb1b0,Opb1b8,Opb1b9,Opb1c0,Opb1d0,Opb1d8,Opb1e0 ;
  .long Opb1e8,Opb1f0,Opb1f8,Opb1f9,Opb1fa,Opb1fb,Opb1fc,Opbf08 ;
  .long Opbf0f,Opc000,Opc010,Opc018,Opc01f,Opc020,Opc027,Opc028 ;
  .long Opc030,Opc038,Opc039,Opc03a,Opc03b,Opc03c,Opc040,Opc050 ;
  .long Opc058,Opc060,Opc068,Opc070,Opc078,Opc079,Opc07a,Opc07b ;
  .long Opc07c,Opc080,Opc090,Opc098,Opc0a0,Opc0a8,Opc0b0,Opc0b8 ;
  .long Opc0b9,Opc0ba,Opc0bb,Opc0bc,Opc0c0,Opc0d0,Opc0d8,Opc0e0 ;
  .long Opc0e8,Opc0f0,Opc0f8,Opc0f9,Opc0fa,Opc0fb,Opc0fc,Opc100 ;
  .long Opc108,Opc10f,Opc110,Opc118,Opc11f,Opc120,Opc127,Opc128 ;
  .long Opc130,Opc138,Opc139,Opc140,Opc148,Opc150,Opc158,Opc160 ;
  .long Opc168,Opc170,Opc178,Opc179,Opc188,Opc190,Opc198,Opc1a0 ;
  .long Opc1a8,Opc1b0,Opc1b8,Opc1b9,Opc1c0,Opc1d0,Opc1d8,Opc1e0 ;
  .long Opc1e8,Opc1f0,Opc1f8,Opc1f9,Opc1fa,Opc1fb,Opc1fc,Opcf08 ;
  .long Opcf0f,Opd000,Opd010,Opd018,Opd01f,Opd020,Opd027,Opd028 ;
  .long Opd030,Opd038,Opd039,Opd03a,Opd03b,Opd03c,Opd040,Opd050 ;
  .long Opd058,Opd060,Opd068,Opd070,Opd078,Opd079,Opd07a,Opd07b ;
  .long Opd07c,Opd080,Opd090,Opd098,Opd0a0,Opd0a8,Opd0b0,Opd0b8 ;
  .long Opd0b9,Opd0ba,Opd0bb,Opd0bc,Opd0c0,Opd0d0,Opd0d8,Opd0e0 ;
  .long Opd0e8,Opd0f0,Opd0f8,Opd0f9,Opd0fa,Opd0fb,Opd0fc,Opd100 ;
  .long Opd108,Opd10f,Opd110,Opd118,Opd11f,Opd120,Opd127,Opd128 ;
  .long Opd130,Opd138,Opd139,Opd140,Opd148,Opd150,Opd158,Opd160 ;
  .long Opd168,Opd170,Opd178,Opd179,Opd180,Opd188,Opd190,Opd198 ;
  .long Opd1a0,Opd1a8,Opd1b0,Opd1b8,Opd1b9,Opd1c0,Opd1d0,Opd1d8 ;
  .long Opd1e0,Opd1e8,Opd1f0,Opd1f8,Opd1f9,Opd1fa,Opd1fb,Opd1fc ;
  .long Opdf08,Opdf0f,Ope000,Ope008,Ope010,Ope018,Ope020,Ope028 ;
  .long Ope030,Ope038,Ope040,Ope048,Ope050,Ope058,Ope060,Ope068 ;
  .long Ope070,Ope078,Ope080,Ope088,Ope090,Ope098,Ope0a0,Ope0a8 ;
  .long Ope0b0,Ope0b8,Ope0d0,Ope0d8,Ope0e0,Ope0e8,Ope0f0,Ope0f8 ;
  .long Ope0f9,Ope100,Ope108,Ope110,Ope118,Ope120,Ope128,Ope130 ;
  .long Ope138,Ope140,Ope148,Ope150,Ope158,Ope160,Ope168,Ope170 ;
  .long Ope178,Ope180,Ope188,Ope190,Ope198,Ope1a0,Ope1a8,Ope1b0 ;
  .long Ope1b8,Ope1d0,Ope1d8,Ope1e0,Ope1e8,Ope1f0,Ope1f8,Ope1f9 ;
  .long Opee00,Opee08,Ope210,Opee18,Opee40,Opee48,Ope250,Opee58 ;
  .long Opee80,Opee88,Ope290,Opee98,Ope2d0,Ope2d8,Ope2e0,Ope2e8 ;
  .long Ope2f0,Ope2f8,Ope2f9,Opef00,Opef08,Ope310,Opef18,Opef40 ;
  .long Opef48,Ope350,Opef58,Opef80,Opef88,Ope390,Opef98,Ope3d0 ;
  .long Ope3d8,Ope3e0,Ope3e8,Ope3f0,Ope3f8,Ope3f9,Opee10,Opee50 ;
  .long Opee90,Ope4d0,Ope4d8,Ope4e0,Ope4e8,Ope4f0,Ope4f8,Ope4f9 ;
  .long Opef10,Opef50,Opef90,Ope5d0,Ope5d8,Ope5e0,Ope5e8,Ope5f0 ;
  .long Ope5f8,Ope5f9,Ope6d0,Ope6d8,Ope6e0,Ope6e8,Ope6f0,Ope6f8 ;
  .long Ope6f9,Ope7d0,Ope7d8,Ope7e0,Ope7e8,Ope7f0,Ope7f8,Ope7f9 ;

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0

  .long 0,0,0,0,0,0,0,0
  .short 0x0038,0x0008,0x0048,0x0057,0x0061,0x0077,0x0081,0x0098
  .short 0x00a8,0x00b1,0x00c1,0x0002,0x00d1,0x0003,0x00e8,0x0008
  .short 0x00f8,0x0108,0x0118,0x0128,0x0138,0x0141,0x0151,0x0002
  .short 0x0161,0x0003,0x0178,0x0008,0x0188,0x0198,0x01a8,0x01b8
  .short 0x01c8,0x01d1,0x01e1,0x0000,0x0046,0x01f8,0x0208,0x0218
  .short 0x0227,0x0231,0x0247,0x0251,0x0268,0x0278,0x0281,0x0291
  .short 0x02a1,0x02b1,0x02c1,0x0003,0x02d8,0x02e8,0x02f8,0x0307
  .short 0x0311,0x0327,0x0331,0x0348,0x0358,0x0361,0x0371,0x0006
  .short 0x0388,0x0398,0x03a8,0x03b7,0x03c1,0x03d7,0x03e1,0x03f8
  .short 0x0408,0x0411,0x0421,0x0006,0x0438,0x0448,0x0458,0x0467
  .short 0x0471,0x0487,0x0491,0x04a8,0x04b8,0x04c1,0x04d1,0x0006
  .short 0x04e8,0x0008,0x04f8,0x0507,0x0511,0x0527,0x0531,0x0548
  .short 0x0558,0x0561,0x0571,0x0002,0x0581,0x0003,0x0598,0x0008
  .short 0x05a8,0x05b8,0x05c8,0x05d8,0x05e8,0x05f1,0x0601,0x0002
  .short 0x0611,0x0003,0x0628,0x0008,0x0638,0x0648,0x0658,0x0668
  .short 0x0678,0x0681,0x0691,0x0000,0x0046,0x01f8,0x0208,0x0218
  .short 0x0227,0x0231,0x0247,0x0251,0x0268,0x0278,0x0281,0x0291
  .short 0x02a1,0x02b1,0x02c1,0x0003,0x02d8,0x02e8,0x02f8,0x0307
  .short 0x0311,0x0327,0x0331,0x0348,0x0358,0x0361,0x0371,0x0006
  .short 0x0388,0x0398,0x03a8,0x03b7,0x03c1,0x03d7,0x03e1,0x03f8
  .short 0x0408,0x0411,0x0421,0x0006,0x0438,0x0448,0x0458,0x0467
  .short 0x0471,0x0487,0x0491,0x04a8,0x04b8,0x04c1,0x04d1,0x0006
  .short 0x06a8,0x0008,0x06b8,0x06c7,0x06d1,0x06e7,0x06f1,0x0708
  .short 0x0718,0x0721,0x0731,0x0006,0x0748,0x0008,0x0758,0x0768
  .short 0x0778,0x0788,0x0798,0x07a1,0x07b1,0x0006,0x07c8,0x0008
  .short 0x07d8,0x07e8,0x07f8,0x0808,0x0818,0x0821,0x0831,0x0000
  .short 0x0046,0x01f8,0x0208,0x0218,0x0227,0x0231,0x0247,0x0251
  .short 0x0268,0x0278,0x0281,0x0291,0x02a1,0x02b1,0x02c1,0x0003
  .short 0x02d8,0x02e8,0x02f8,0x0307,0x0311,0x0327,0x0331,0x0348
  .short 0x0358,0x0361,0x0371,0x0006,0x0388,0x0398,0x03a8,0x03b7
  .short 0x03c1,0x03d7,0x03e1,0x03f8,0x0408,0x0411,0x0421,0x0006
  .short 0x0438,0x0448,0x0458,0x0467,0x0471,0x0487,0x0491,0x04a8

