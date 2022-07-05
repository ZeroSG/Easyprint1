#include "Compress.h"
#include <stdlib.h>
#include <string.h>
/////////////////////////////////////////////
// —πÀı“ª∂Œ◊÷Ω⁄¡˜
// src - ‘¥ ˝æ›«¯
// srclen - ‘¥ ˝æ›«¯◊÷Ω⁄≥§∂»
// dest - —πÀı ˝æ›«¯£¨µ˜”√«∞∑÷≈‰srclen+5◊÷Ω⁄ƒ⁄¥Ê
// ∑µªÿ÷µ > 0 —πÀı ˝æ›≥§∂»
// ∑µªÿ÷µ = 0  ˝æ›Œﬁ∑®—πÀı
// ∑µªÿ÷µ < 0 —πÀı÷–“Ï≥£¥ÌŒÛ
int Compress(BYTE* src, int srclen, BYTE* dest)
{
    int i;
    int off, len,destlen;
    
    CurByte = 0; CurBit = 0;

    if (srclen > _MAX_WINDOW_SIZE)  return -1;
   
    pWnd = src;
    _InitSortTable();
    for (i = 0; i < srclen; i++)
    {
        if (CurByte >= srclen) return 0;
        if (_SeekPhase(src, srclen, i, &off, &len))
        {
            //  ‰≥ˆ∆•≈‰ ı”Ô flag(1bit) + len(¶√±‡¬Î) + offset(◊Ó¥Û16bit)
            _OutCode(dest, 1, 1, LZ77FALSE);
            _OutCode(dest, len, 0, LZ77TRUE);

            // ‘⁄¥∞ø⁄≤ª¬˙64k¥Û–° ±£¨≤ª–Ë“™16Œª¥Ê¥¢∆´“∆
            _OutCode(dest, off, UpperLog2(nWndSize), LZ77FALSE);
                                         
            _ScrollWindow(len);
            i += len - 1;
        }
        else
        {
            //  ‰≥ˆµ•∏ˆ∑«∆•≈‰◊÷∑˚ 0(1bit) + char(8bit)
            _OutCode(dest, 0, 1, LZ77FALSE);
            _OutCode(dest, (DWORD)(src[i]), 8, LZ77FALSE);
            _ScrollWindow(1);
        }
    }
    destlen = CurByte + ((CurBit) ? 1 : 0);
    if (destlen >= srclen) return 0;
  
    return destlen;
}

//≥ı ºªØSortHeapƒ⁄¥Ê¥Û–° 16K
void InitCompress(void)
{
    SortHeap = malloc(_MAX_WINDOW_SIZE);  //∂ØÃ¨∑÷≈‰ƒ⁄¥Ê
}

// Õ∑≈SortHeapƒ⁄¥Ê¥Û–° 16K
void FreeCompress(void)
{
    free(SortHeap);   // Õ∑≈ƒ⁄¥Ê
}
   
// ≥ı ºªØÀ˜“˝±Ì£¨ Õ∑≈…œ¥Œ—πÀı”√µƒø’º‰
void _InitSortTable(void)
{
    memset(SortTable, 0, sizeof(WORD) * _MAX_WINDOW_SIZE);
    nWndSize = 0;
    HeapPos = 1;
}

//////////////////////////////////////////////////////////////
// Ω´DWORD÷µ¥”∏ﬂŒª◊÷Ω⁄µΩµÕŒª◊÷Ω⁄≈≈¡–
union {
    BYTE ch[4];
    DWORD dw;
}dw2char;

void InvertDWord(DWORD pDW)
{
    BYTE b;
    
    dw2char.dw=pDW;
    b=dw2char.ch[0];
    dw2char.ch[0]=dw2char.ch[3];
    dw2char.ch[3]=b;
    b=dw2char.ch[1];
    dw2char.ch[1]=dw2char.ch[2];
    dw2char.ch[2]=b;
}
// InvertDWord
//////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////
// ‘⁄ª¨∂Ø¥∞ø⁄÷–≤È’“ ı”Ô
// nSeekStart - ¥”∫Œ¥¶ø™ º∆•≈‰
// offset, len - ”√”⁄Ω” ’Ω·π˚£¨±Ì æ‘⁄ª¨∂Ø¥∞ø⁄ƒ⁄µƒ∆´“∆∫Õ≥§∂»
// ∑µªÿ÷µ-  «∑Ò≤ÈµΩ≥§∂»Œ™2ªÚ2“‘…œµƒ∆•≈‰◊÷Ω⁄¥Æ
lz77_bool _SeekPhase(BYTE* src, int srclen, int nSeekStart, int* offset, int* len)
{
    int j, m, n;
  WORD p;
    BYTE ch1, ch2;
    
    if (nSeekStart < srclen - 1)
    {
        ch1 = src[nSeekStart];
        ch2 = src[nSeekStart + 1];
        p = SortTable[ch1 * _TABLE_SIZE + ch2];
        if (p != 0)
        {
            m = 2;
            n = SortHeap[p].off;
            while (p != 0)
            {
                j = _GetSameLen(src, srclen,nSeekStart, SortHeap[p].off);
                if ( j > m )
                {
                    m = j;
                    n = SortHeap[p].off;
                }
                p = SortHeap[p].next;
            }
            (*offset) = n;
            (*len) = m;
            return LZ77TRUE;
        }
    }
    return LZ77FALSE;
}

///////////////////////////////////////////////////////////
// µ√µΩ“—æ≠∆•≈‰¡À2∏ˆ◊÷Ω⁄µƒ¥∞ø⁄Œª÷√offset
// π≤ƒ‹∆•≈‰∂‡…Ÿ∏ˆ◊÷Ω⁄
int _GetSameLen(BYTE* src, int srclen, int nSeekStart, int offset)
{
    int i = 2; // “—æ≠∆•≈‰¡À2∏ˆ◊÷Ω⁄
    int maxsame = min(srclen - nSeekStart, nWndSize - offset);
    while (i < maxsame && src[nSeekStart + i] == pWnd[offset + i]) i++;
    return i;
}

////////////////////////////////////////
//  ‰≥ˆ—πÀı¬Î
// code - “™ ‰≥ˆµƒ ˝
// bits - “™ ‰≥ˆµƒŒª ˝(∂‘isGamma=TRUE ±Œﬁ–ß)
// isGamma -  «∑Ò ‰≥ˆŒ™¶√±‡¬Î
void _OutCode(BYTE* dest, DWORD code, int bits, lz77_bool isGamma)
{
    int sh,GammaCode,q;
    BYTE* pb;
    DWORD out,dw;
    
    if ( isGamma )
    {
        // º∆À„ ‰≥ˆŒª ˝
        GammaCode = (int)code - 1;
        q = LowerLog2(GammaCode);
        if (q > 0)
        {
            out = 0xffff;
            pb = (BYTE*)&out;
            //  ‰≥ˆq∏ˆ1
            CopyBits(dest + CurByte, CurBit, pb, 0, q);
            MovePos(&CurByte, &CurBit, q);
        }
        //  ‰≥ˆ“ª∏ˆ0
        out = 0;
        pb = (BYTE*)&out;
        CopyBits(dest + CurByte, CurBit, pb + 3, 7, 1);
        MovePos(&CurByte, &CurBit, 1);
        if (q > 0)
        {
            //  ‰≥ˆ”‡ ˝, qŒª
            sh = 1;
            sh <<= q;
            out = GammaCode - sh;
            pb = (BYTE*)&out;
            InvertDWord(out);
            out=dw2char.dw;
            CopyBits(dest + CurByte, CurBit, pb + (32 - q) / 8, (32 - q) % 8, q);
            MovePos(&CurByte, &CurBit, q);
        }
    }
    else
    {
        dw = (DWORD)code;
        pb = (BYTE*)&dw;
        InvertDWord(dw);
        dw=dw2char.dw;
        CopyBits(dest + CurByte, CurBit, pb + (32 - bits) / 8, (32 - bits) % 8, bits);
        MovePos(&CurByte, &CurBit, bits);
    }
}

/////////////////////////////////////////////////////////
// »°log2(n)µƒlower_bound
int LowerLog2(int n)
{
    int i = 0;
    int m = 1;
  
    if (n > 0)
    {
        while(1)
        {
            if (m == n)
                return i;
            if (m > n)
                return i - 1;
            m <<= 1;
            i++;
        }
    }
    else
    {
        return -1;
    }
}
// LowerLog2
/////////////////////////////////////////////////////////
   
////////////////////////////////////////////////////////
// CopyBits : ∏¥÷∆ƒ⁄¥Ê÷–µƒŒª¡˜
//      memDest - ƒø±Í ˝æ›«¯
//      nDestPos - ƒø±Í ˝æ›«¯µ⁄“ª∏ˆ◊÷Ω⁄÷–µƒ∆ ºŒª
//      memSrc - ‘¥ ˝æ›«¯
//      nSrcPos - ‘¥ ˝æ›«¯µ⁄“ª∏ˆ◊÷Ω⁄µƒ÷–∆ ºŒª
//      nBits - “™∏¥÷∆µƒŒª ˝
//  Àµ√˜£∫
//      ∆ ºŒªµƒ±Ì æ‘º∂®Œ™¥”◊÷Ω⁄µƒ∏ﬂŒª÷¡µÕŒª£®”…◊Û÷¡”“£©
//      “¿¥ŒŒ™ 0£¨1£¨... , 7
//      “™∏¥÷∆µƒ¡ΩøÈ ˝æ›«¯≤ªƒ‹”–÷ÿ∫œ
void CopyBits(BYTE* memDest, int nDestPos,
              BYTE* memSrc, int nSrcPos, int nBits)
{
    int iByteDest = 0, iBitDest;
    int iByteSrc = 0, iBitSrc = nSrcPos;
 
    int nBitsToFill, nBitsCanFill;
 
    while (nBits > 0)
    {
        // º∆À„“™‘⁄ƒø±Í«¯µ±«∞◊÷Ω⁄ÃÓ≥‰µƒŒª ˝
        nBitsToFill = min(nBits, iByteDest ? 8 : 8 - nDestPos);
        // ƒø±Í«¯µ±«∞◊÷Ω⁄“™ÃÓ≥‰µƒ∆ ºŒª
        iBitDest = iByteDest ? 0 : nDestPos;
        // º∆À„ø…“‘“ª¥Œ¥”‘¥ ˝æ›«¯÷–∏¥÷∆µƒŒª ˝
        nBitsCanFill = min(nBitsToFill, 8 - iBitSrc);
        // ◊÷Ω⁄ƒ⁄∏¥÷∆
        CopyBitsInAByte(memDest + iByteDest, iBitDest,
                          memSrc + iByteSrc, iBitSrc, nBitsCanFill);
        // »Áπ˚ªπ√ª”–∏¥÷∆ÕÍ nBitsToFill ∏ˆ
        if (nBitsToFill > nBitsCanFill)
        {
            iByteSrc++; iBitSrc = 0; iBitDest += nBitsCanFill;
            CopyBitsInAByte(memDest + iByteDest, iBitDest,
                                    memSrc + iByteSrc, iBitSrc,
                                    nBitsToFill - nBitsCanFill);
            iBitSrc += nBitsToFill - nBitsCanFill;
        }
        else
        {
            iBitSrc += nBitsCanFill;
            if (iBitSrc >= 8)
            {
                iByteSrc++; iBitSrc = 0;
            }
        }

        nBits -= nBitsToFill;   // “—æ≠ÃÓ≥‰¡ÀnBitsToFillŒª
        iByteDest++;
    }
}
// CopyBits
/////////////////////////////////////////////////////////
   
/////////////////////////////////////////////////////////
// CopyBitsInAByte : ‘⁄“ª∏ˆ◊÷Ω⁄∑∂Œßƒ⁄∏¥÷∆Œª¡˜
// ≤Œ ˝∫¨“ÂÕ¨ CopyBits µƒ≤Œ ˝
// Àµ√˜£∫
//      ¥À∫Ø ˝”… CopyBits µ˜”√£¨≤ª◊ˆ¥ÌŒÛºÏ≤È£¨º¥
//      ºŸ∂®“™∏¥÷∆µƒŒª∂º‘⁄“ª∏ˆ◊÷Ω⁄∑∂Œßƒ⁄
void CopyBitsInAByte(BYTE* memDest, int nDestPos,
                     BYTE* memSrc, int nSrcPos, int nBits)
{
    BYTE b1, b2;
    b1 = *memSrc;
    b1 <<= nSrcPos; b1 >>= 8 - nBits;   // Ω´≤ª”√∏¥÷∆µƒŒª«Â0
    b1 <<= 8 - nBits - nDestPos;      // Ω´‘¥∫Õƒøµƒ◊÷Ω⁄∂‘∆Î
    *memDest |= b1;     // ∏¥÷∆÷µŒ™1µƒŒª
    b2 = 0xff; b2 <<= 8 - nDestPos;       // Ω´≤ª”√∏¥÷∆µƒŒª÷√1
    b1 |= b2;
    b2 = 0xff; b2 >>= nDestPos + nBits;
    b1 |= b2;
    *memDest &= b1;     // ∏¥÷∆÷µŒ™0µƒŒª
}
// CopyBitsInAByte
/////////////////////////////////////////////////////////
   
////////////////////////////////////////////////////////////
// Ω´Œª÷∏’Î*piByte(◊÷Ω⁄∆´“∆), *piBit(◊÷Ω⁄ƒ⁄Œª∆´“∆)∫Û“∆numŒª
void MovePos(int* piByte, int* piBit, int num)
{
    num += (*piBit);
    (*piByte) += num / 8;
    (*piBit) = num % 8;
}
// MovePos
////////////////////////////////////////////////////////////
   
// »°log2(n)µƒupper_bound
int UpperLog2(int n)
{
    int i = 0;
    int m = 1;
    
    if (n > 0)
    {
        while(1)
        {
            if (m >= n) return i;
            m <<= 1;
            i++;
        }
    }
    else
    {
        return -1;
    }
}
// UpperLog2
/////////////////////////////////////////////////////////
 
//////////////////////////////////////////
// Ω´¥∞ø⁄œÚ”“ª¨∂Øn∏ˆ◊÷Ω⁄
void _ScrollWindow(int n)
{
    int i;
    
    for (i = 0; i < n; i++)
    {
        nWndSize++;
        if (nWndSize > 1) _InsertIndexItem(nWndSize - 2);
    }
}

// œÚÀ˜“˝÷–ÃÌº”“ª∏ˆ2◊÷Ω⁄¥Æ
void _InsertIndexItem(int off)
{
    WORD q;
    BYTE ch1, ch2;
    ch1 = pWnd[off]; ch2 = pWnd[off + 1];
         
    if (ch1 != ch2)
    {
        // –¬Ω®Ω⁄µ„
        q = HeapPos;
        HeapPos++;
        SortHeap[q].off = off;
        SortHeap[q].next = SortTable[ch1 * _TABLE_SIZE + ch2];
        SortTable[ch1 * _TABLE_SIZE + ch2] = q;
    }
    else
    {
        // ∂‘÷ÿ∏¥2◊÷Ω⁄¥Æ
        // “ÚŒ™√ª”––Èƒ‚∆´“∆“≤√ª”–…æ≥˝≤Ÿ◊˜£¨÷ª“™±»Ωœµ⁄“ª∏ˆΩ⁄µ„
        //  «∑Ò∫Õ off œ‡¡¨Ω”º¥ø…
        q = SortTable[ch1 * _TABLE_SIZE + ch2];
        if (q != 0 && off == SortHeap[q].off2 + 1)
        {
            // Ω⁄µ„∫œ≤¢
            SortHeap[q].off2 = off;
        }
        else
        {
            // –¬Ω®Ω⁄µ„
            q = HeapPos;
            HeapPos++;
            SortHeap[q].off = off;
            SortHeap[q].off2 = off;
            SortHeap[q].next = SortTable[ch1 * _TABLE_SIZE + ch2];
            SortTable[ch1 * _TABLE_SIZE + ch2] = q;
        }
    }
}


