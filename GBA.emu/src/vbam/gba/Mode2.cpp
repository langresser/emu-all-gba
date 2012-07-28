#include "GBA.h"
#include "Globals.h"
#include "GBAGfx.h"

void mode2RenderLine(MixColorType *lineMix, const GBAMem::IoMem &ioMem)
{
#ifdef GBALCD_TEMP_LINE_BUFFER
	u32 line2[240];
	//gfxClearArray(line2);
	u32 line3[240];
	//gfxClearArray(line3);
	u32 lineOBJ[240];
#endif
  const u16 *palette = (u16 *)paletteRAM;
  const auto BLDMOD = ioMem.BLDMOD;
  const auto COLEV = ioMem.COLEV;
  const auto COLY = ioMem.COLY;
  const auto VCOUNT = ioMem.VCOUNT;
  const auto MOSAIC = ioMem.MOSAIC;
  const auto DISPCNT = ioMem.DISPCNT;

  if(layerEnable & 0x0400) {
    int changed = gfxBG2Changed;
    if(gfxLastVCOUNT > VCOUNT)
      changed = 3;

    gfxDrawRotScreen(ioMem.BG2CNT, ioMem.BG2X_L, ioMem.BG2X_H, ioMem.BG2Y_L, ioMem.BG2Y_H,
                     ioMem.BG2PA, ioMem.BG2PB, ioMem.BG2PC, ioMem.BG2PD, gfxBG2X, gfxBG2Y,
                     changed, line2, VCOUNT, MOSAIC, palette);
  }

  if(layerEnable & 0x0800) {
    int changed = gfxBG3Changed;
    if(gfxLastVCOUNT > VCOUNT)
      changed = 3;

    gfxDrawRotScreen(ioMem.BG3CNT, ioMem.BG3X_L, ioMem.BG3X_H, ioMem.BG3Y_L, ioMem.BG3Y_H,
    		ioMem.BG3PA, ioMem.BG3PB, ioMem.BG3PC, ioMem.BG3PD, gfxBG3X, gfxBG3Y,
                     changed, line3, VCOUNT, MOSAIC, palette);
  }

  gfxDrawSprites(lineOBJ, VCOUNT, MOSAIC, DISPCNT);

  u32 backdrop;
  if(customBackdropColor == -1) {
    backdrop = (READ16LE(&palette[0]) | 0x30000000);
  } else {
    backdrop = ((customBackdropColor & 0x7FFF) | 0x30000000);
  }

  for(int x = 0; x < 240; x++) {
    u32 color = backdrop;
    u8 top = 0x20;


    if((u8)(line2[x]>>24) < (u8)(color >> 24)) {
      color = line2[x];
      top = 0x04;
    }

    if((u8)(line3[x]>>24) < (u8)(color >> 24)) {
      color = line3[x];
      top = 0x08;
    }

    if((u8)(lineOBJ[x]>>24) < (u8)(color >> 24)) {
      color = lineOBJ[x];
      top = 0x10;
    }

    if((top & 0x10) && (color & 0x00010000)) {
      // semi-transparent OBJ
      u32 back = backdrop;
      u8 top2 = 0x20;

      if((u8)(line2[x]>>24) < (u8)(back >> 24)) {
        back = line2[x];
        top2 = 0x04;
      }

      if((u8)(line3[x]>>24) < (u8)(back >> 24)) {
        back = line3[x];
        top2 = 0x08;
      }

      if(top2 & (BLDMOD>>8))
        color = gfxAlphaBlend(color, back,
                              coeff[COLEV & 0x1F],
                              coeff[(COLEV >> 8) & 0x1F]);
      else {
        switch((BLDMOD >> 6) & 3) {
        case 2:
          if(BLDMOD & top)
            color = gfxIncreaseBrightness(color, coeff[COLY & 0x1F]);
          break;
        case 3:
          if(BLDMOD & top)
            color = gfxDecreaseBrightness(color, coeff[COLY & 0x1F]);
          break;
        }
      }
    }

    lineMix[x] = convColor(color);
  }
  gfxBG2Changed = 0;
  gfxBG3Changed = 0;
  gfxLastVCOUNT = VCOUNT;
}

void mode2RenderLineNoWindow(MixColorType *lineMix, const GBAMem::IoMem &ioMem)
{
#ifdef GBALCD_TEMP_LINE_BUFFER
	u32 line2[240];
	//gfxClearArray(line2);
	u32 line3[240];
	//gfxClearArray(line3);
	u32 lineOBJ[240];
#endif
  const u16 *palette = (u16 *)paletteRAM;
  const auto BLDMOD = ioMem.BLDMOD;
  const auto COLEV = ioMem.COLEV;
  const auto COLY = ioMem.COLY;
  const auto VCOUNT = ioMem.VCOUNT;
  const auto MOSAIC = ioMem.MOSAIC;
  const auto DISPCNT = ioMem.DISPCNT;

  if(layerEnable & 0x0400) {
    int changed = gfxBG2Changed;
    if(gfxLastVCOUNT > VCOUNT)
      changed = 3;

    gfxDrawRotScreen(ioMem.BG2CNT, ioMem.BG2X_L, ioMem.BG2X_H, ioMem.BG2Y_L, ioMem.BG2Y_H,
                     ioMem.BG2PA, ioMem.BG2PB, ioMem.BG2PC, ioMem.BG2PD, gfxBG2X, gfxBG2Y,
                     changed, line2, VCOUNT, MOSAIC, palette);
  }

  if(layerEnable & 0x0800) {
    int changed = gfxBG3Changed;
    if(gfxLastVCOUNT > VCOUNT)
      changed = 3;

    gfxDrawRotScreen(ioMem.BG3CNT, ioMem.BG3X_L, ioMem.BG3X_H, ioMem.BG3Y_L, ioMem.BG3Y_H,
    		ioMem.BG3PA, ioMem.BG3PB, ioMem.BG3PC, ioMem.BG3PD, gfxBG3X, gfxBG3Y,
                     changed, line3, VCOUNT, MOSAIC, palette);
  }

  gfxDrawSprites(lineOBJ, VCOUNT, MOSAIC, DISPCNT);

  u32 backdrop;
  if(customBackdropColor == -1) {
    backdrop = (READ16LE(&palette[0]) | 0x30000000);
  } else {
    backdrop = ((customBackdropColor & 0x7FFF) | 0x30000000);
  }

  for(int x = 0; x < 240; x++) {
    u32 color = backdrop;
    u8 top = 0x20;


    if((u8)(line2[x]>>24) < (u8)(color >> 24)) {
      color = line2[x];
      top = 0x04;
    }

    if((u8)(line3[x]>>24) < (u8)(color >> 24)) {
      color = line3[x];
      top = 0x08;
    }

    if((u8)(lineOBJ[x]>>24) < (u8)(color >> 24)) {
      color = lineOBJ[x];
      top = 0x10;
    }

    if(!(color & 0x00010000)) {
      switch((BLDMOD >> 6) & 3) {
      case 0:
        break;
      case 1:
        {
          if(top & BLDMOD) {
            u32 back = backdrop;
            u8 top2 = 0x20;

            if((u8)(line2[x]>>24) < (u8)(back >> 24)) {
              if(top != 0x04) {
                back = line2[x];
                top2 = 0x04;
              }
            }

            if((u8)(line3[x]>>24) < (u8)(back >> 24)) {
              if(top != 0x08) {
                back = line3[x];
                top2 = 0x08;
              }
            }

            if((u8)(lineOBJ[x]>>24) < (u8)(back >> 24)) {
              if(top != 0x10) {
                back = lineOBJ[x];
                top2 = 0x10;
              }
            }

            if(top2 & (BLDMOD>>8))
              color = gfxAlphaBlend(color, back,
                                    coeff[COLEV & 0x1F],
                                    coeff[(COLEV >> 8) & 0x1F]);
          }
        }
        break;
      case 2:
        if(BLDMOD & top)
          color = gfxIncreaseBrightness(color, coeff[COLY & 0x1F]);
        break;
      case 3:
        if(BLDMOD & top)
          color = gfxDecreaseBrightness(color, coeff[COLY & 0x1F]);
        break;
      }
    } else {
      // semi-transparent OBJ
      u32 back = backdrop;
      u8 top2 = 0x20;

      if((u8)(line2[x]>>24) < (u8)(back >> 24)) {
        back = line2[x];
        top2 = 0x04;
      }

      if((u8)(line3[x]>>24) < (u8)(back >> 24)) {
        back = line3[x];
        top2 = 0x08;
      }

      if(top2 & (BLDMOD>>8))
        color = gfxAlphaBlend(color, back,
                              coeff[COLEV & 0x1F],
                              coeff[(COLEV >> 8) & 0x1F]);
      else {
        switch((BLDMOD >> 6) & 3) {
        case 2:
          if(BLDMOD & top)
            color = gfxIncreaseBrightness(color, coeff[COLY & 0x1F]);
          break;
        case 3:
          if(BLDMOD & top)
            color = gfxDecreaseBrightness(color, coeff[COLY & 0x1F]);
          break;
        }
      }
    }

    lineMix[x] = convColor(color);
  }
  gfxBG2Changed = 0;
  gfxBG3Changed = 0;
  gfxLastVCOUNT = VCOUNT;
}

void mode2RenderLineAll(MixColorType *lineMix, const GBAMem::IoMem &ioMem)
{
#ifdef GBALCD_TEMP_LINE_BUFFER
	u32 line2[240];
	//gfxClearArray(line2);
	u32 line3[240];
	//gfxClearArray(line3);
	u32 lineOBJ[240];
#endif
  const u16 *palette = (u16 *)paletteRAM;
  const auto BLDMOD = ioMem.BLDMOD;
  const auto COLEV = ioMem.COLEV;
  const auto COLY = ioMem.COLY;
  const auto WIN0V = ioMem.WIN0V;
  const auto WIN1V = ioMem.WIN1V;
  const auto WININ = ioMem.WININ;
  const auto WINOUT = ioMem.WINOUT;
  const auto VCOUNT = ioMem.VCOUNT;
  const auto MOSAIC = ioMem.MOSAIC;
  const auto DISPCNT = ioMem.DISPCNT;

  bool inWindow0 = false;
  bool inWindow1 = false;

  if(layerEnable & 0x2000) {
    u8 v0 = WIN0V >> 8;
    u8 v1 = WIN0V & 255;
    inWindow0 = ((v0 == v1) && (v0 >= 0xe8));
    if(v1 >= v0)
      inWindow0 |= (VCOUNT >= v0 && VCOUNT < v1);
    else
      inWindow0 |= (VCOUNT >= v0 || VCOUNT < v1);
  }
  if(layerEnable & 0x4000) {
    u8 v0 = WIN1V >> 8;
    u8 v1 = WIN1V & 255;
    inWindow1 = ((v0 == v1) && (v0 >= 0xe8));
    if(v1 >= v0)
      inWindow1 |= (VCOUNT >= v0 && VCOUNT < v1);
    else
      inWindow1 |= (VCOUNT >= v0 || VCOUNT < v1);
  }

  if(layerEnable & 0x0400) {
    int changed = gfxBG2Changed;
    if(gfxLastVCOUNT > VCOUNT)
      changed = 3;

    gfxDrawRotScreen(ioMem.BG2CNT, ioMem.BG2X_L, ioMem.BG2X_H, ioMem.BG2Y_L, ioMem.BG2Y_H,
                     ioMem.BG2PA, ioMem.BG2PB, ioMem.BG2PC, ioMem.BG2PD, gfxBG2X, gfxBG2Y,
                     changed, line2, VCOUNT, MOSAIC, palette);
  }

  if(layerEnable & 0x0800) {
    int changed = gfxBG3Changed;
    if(gfxLastVCOUNT > VCOUNT)
      changed = 3;

    gfxDrawRotScreen(ioMem.BG3CNT, ioMem.BG3X_L, ioMem.BG3X_H, ioMem.BG3Y_L, ioMem.BG3Y_H,
    		ioMem.BG3PA, ioMem.BG3PB, ioMem.BG3PC, ioMem.BG3PD, gfxBG3X, gfxBG3Y,
                     changed, line3, VCOUNT, MOSAIC, palette);
  }

  gfxDrawSprites(lineOBJ, VCOUNT, MOSAIC, DISPCNT);
  gfxDrawOBJWin(lineOBJWin, VCOUNT, DISPCNT);

  u32 backdrop;
  if(customBackdropColor == -1) {
    backdrop = (READ16LE(&palette[0]) | 0x30000000);
  } else {
    backdrop = ((customBackdropColor & 0x7FFF) | 0x30000000);
  }

  u8 inWin0Mask = WININ & 0xFF;
  u8 inWin1Mask = WININ >> 8;
  u8 outMask = WINOUT & 0xFF;

  for(int x = 0; x < 240; x++) {
    u32 color = backdrop;
    u8 top = 0x20;
    u8 mask = outMask;

    if(!(lineOBJWin[x] & 0x80000000)) {
      mask = WINOUT >> 8;
    }

    if(inWindow1) {
      if(gfxInWin1[x])
        mask = inWin1Mask;
    }

    if(inWindow0) {
      if(gfxInWin0[x]) {
        mask = inWin0Mask;
      }
    }

    if(line2[x] < color && (mask & 4)) {
      color = line2[x];
      top = 0x04;
    }

    if((u8)(line3[x]>>24) < (u8)(color >> 24) && (mask & 8)) {
      color = line3[x];
      top = 0x08;
    }

    if((u8)(lineOBJ[x]>>24) < (u8)(color >> 24) && (mask & 16)) {
      color = lineOBJ[x];
      top = 0x10;
    }

    if(color & 0x00010000) {
      // semi-transparent OBJ
      u32 back = backdrop;
      u8 top2 = 0x20;

      if((mask & 4) && line2[x] < back) {
        back = line2[x];
        top2 = 0x04;
      }

      if((mask & 8) && (u8)(line3[x]>>24) < (u8)(back >> 24)) {
        back = line3[x];
        top2 = 0x08;
      }

      if(top2 & (BLDMOD>>8))
        color = gfxAlphaBlend(color, back,
                              coeff[COLEV & 0x1F],
                              coeff[(COLEV >> 8) & 0x1F]);
      else {
        switch((BLDMOD >> 6) & 3) {
        case 2:
          if(BLDMOD & top)
            color = gfxIncreaseBrightness(color, coeff[COLY & 0x1F]);
          break;
        case 3:
          if(BLDMOD & top)
            color = gfxDecreaseBrightness(color, coeff[COLY & 0x1F]);
          break;
        }
      }
    } else if(mask & 32) {
      // special FX on the window
      switch((BLDMOD >> 6) & 3) {
      case 0:
        break;
      case 1:
        {
          if(top & BLDMOD) {
            u32 back = backdrop;
            u8 top2 = 0x20;

            if((mask & 4) && line2[x] < back) {
              if(top != 0x04) {
                back = line2[x];
                top2 = 0x04;
              }
            }

            if((mask & 8) && (u8)(line3[x]>>24) < (u8)(back >> 24)) {
              if(top != 0x08) {
                back = line3[x];
                top2 = 0x08;
              }
            }

            if((mask & 16) && (u8)(lineOBJ[x]>>24) < (u8)(back >> 24)) {
              if(top != 0x10) {
                back = lineOBJ[x];
                top2 = 0x10;
              }
            }

            if(top2 & (BLDMOD>>8))
              color = gfxAlphaBlend(color, back,
                                    coeff[COLEV & 0x1F],
                                    coeff[(COLEV >> 8) & 0x1F]);
          }
        }
        break;
      case 2:
        if(BLDMOD & top)
          color = gfxIncreaseBrightness(color, coeff[COLY & 0x1F]);
        break;
      case 3:
        if(BLDMOD & top)
          color = gfxDecreaseBrightness(color, coeff[COLY & 0x1F]);
        break;
      }
    }

    lineMix[x] = convColor(color);
  }
  gfxBG2Changed = 0;
  gfxBG3Changed = 0;
  gfxLastVCOUNT = VCOUNT;
}
