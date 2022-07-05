#ifndef _COMPRESS_H
#define _COMPRESS_H
typedef unsigned char       BYTE;
typedef unsigned long       DWORD;
typedef unsigned short      WORD;
typedef enum  {LZ77FALSE = 0, LZ77TRUE = !LZ77FALSE} lz77_bool;

#ifndef min
	#define min(a,b)            (((a) < (b)) ? (a) : (b))
#endif

// ʹ�����Լ��Ķ��з��������ڵ㣬���������� 
// ÿ�����ѹ�� 16384 �ֽ����� 
// ���Ż��汾 
 
// �������ڵ��ֽڴ�С 
#define _MAX_WINDOW_SIZE	16384 //����ѹ����Ҫ�Ŀռ�
#define _TABLE_SIZE         128

// ���ڴ�С���Ϊ 16k �����Ҳ������� 
// ÿ�����ֻѹ�� 16k ���ݣ��������Է�����ļ��м俪ʼ��ѹ 
// ��ǰ���ڵĳ��� 
int nWndSize; 

// �Ի���������ÿһ��2�ֽڴ����� 
// ������Ϊ�˽��п�������ƥ�� 
// ����ķ�������һ��16k��С��ָ������ 
// �����±����ζ�Ӧÿһ��2�ֽڴ���(00 00) (00 01) ... (01 00) (01 01) ... 
// ÿһ��ָ��ָ��һ�����������еĽڵ�Ϊ��2�ֽڴ���ÿһ������λ�� 
struct STIDXNODE 
{ 
	WORD off;		  // ��src�е�ƫ�� 
	WORD off2;		// ���ڶ�Ӧ��2�ֽڴ�Ϊ�ظ��ֽڵĽڵ� 
					      // ָ�� off �� off2 ����Ӧ�˸�2�ֽڴ� 
	WORD next;		// ��SortHeap�е�ָ�� 
}; 

WORD SortTable[_MAX_WINDOW_SIZE];  // 128 * 128 ָ��SortHeap���±��ָ�� 

// ��Ϊ���ڲ�������û��ɾ���ڵ�Ĳ��������� 
// �ڵ������SortHeap ���������� 
struct STIDXNODE* SortHeap; 
int HeapPos;	// ��ǰ����λ�� 

BYTE* pWnd;

// ��ǰ���λ��(�ֽ�ƫ�Ƽ�λƫ��) 
int CurByte, CurBit; 

///////////////////////////////////////////// 
// ѹ��һ���ֽ��� 
// src - Դ������ 
// srclen - Դ�������ֽڳ���, srclen <= 65536 
// dest - ѹ��������������ǰ����srclen�ֽ��ڴ� 
// ����ֵ > 0 ѹ�����ݳ��� 
// ����ֵ = 0 �����޷�ѹ�� 
// ����ֵ < 0 ѹ�����쳣���� 
int Compress(BYTE* src, int srclen, BYTE* dest);

//ѹ���㷨
///////////////////////////////////////////////////////// 
// CopyBitsInAByte : ��һ���ֽڷ�Χ�ڸ���λ�� 
// ��������ͬ CopyBits �Ĳ��� 
// ˵���� 
//		�˺����� CopyBits ���ã����������飬�� 
//		�ٶ�Ҫ���Ƶ�λ����һ���ֽڷ�Χ�� 
void CopyBitsInAByte(BYTE* memDest, int nDestPos,  
				             BYTE* memSrc, int nSrcPos, int nBits); 
 
//////////////////////////////////////////////////////// 
// CopyBits : �����ڴ��е�λ�� 
//		memDest - Ŀ�������� 
//		nDestPos - Ŀ����������һ���ֽ��е���ʼλ 
//		memSrc - Դ������ 
//		nSrcPos - Դ��������һ���ֽڵ�����ʼλ 
//		nBits - Ҫ���Ƶ�λ�� 
//	˵���� 
//		��ʼλ�ı�ʾԼ��Ϊ���ֽڵĸ�λ����λ���������ң� 
//		����Ϊ 0��1��... , 7 
//		Ҫ���Ƶ������������������غ� 
void CopyBits(BYTE* memDest, int nDestPos,  
				      BYTE* memSrc, int nSrcPos, int nBits); 
 
// ��ʼ���������ͷ��ϴ�ѹ���õĿռ� 
void _InitSortTable(void); 

/////////////////////////////////////////////////////////// 
// �ڻ��������в������� 
// nSeekStart - �Ӻδ���ʼƥ�� 
// offset, len - ���ڽ��ս������ʾ�ڻ��������ڵ�ƫ�ƺͳ��� 
// ����ֵ- �Ƿ�鵽����Ϊ3��3���ϵ�ƥ���ֽڴ� 
lz77_bool _SeekPhase(BYTE* src, int srclen, int nSeekStart, int* offset, int* len); 
 
/////////////////////////////////////////////////////////// 
// �õ��Ѿ�ƥ����3���ֽڵĴ���λ��offset 
// ����ƥ����ٸ��ֽ� 
int _GetSameLen(BYTE* src, int srclen, int nSeekStart, int offset); 

//////////////////////////////////////// 
// ���ѹ���� 
// code - Ҫ������� 
// bits - Ҫ�����λ��(��isGamma=TRUEʱ��Ч) 
// isGamma - �Ƿ����Ϊ�ñ��� 
void _OutCode(BYTE* dest, DWORD code, int bits, lz77_bool isGamma); 

///////////////////////////////////////////////////////// 
// ȡlog2(n)��lower_bound 
int LowerLog2(int n); 

////////////////////////////////////////////////////////////// 
// ��DWORDֵ�Ӹ�λ�ֽڵ���λ�ֽ����� 
//void InvertDWord(DWORD* pDW); 
void InvertDWord(DWORD pDW);

//////////////////////////////////////////////////////////// 
// ��λָ��*piByte(�ֽ�ƫ��), *piBit(�ֽ���λƫ��)����numλ 
void MovePos(int* piByte, int* piBit, int num); 

// ȡlog2(n)��upper_bound   
int UpperLog2(int n);

// ���������һ���n���ֽ�   
void _ScrollWindow(int n);

// �����������һ��2�ֽڴ�   
void _InsertIndexItem(int off);
	
#endif
