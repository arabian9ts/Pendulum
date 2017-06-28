#include <stdio.h>

#if MSVC || BCC || __DJGPP__
#include <dos.h>
#endif

#ifdef __DJGPP__
#include <go32.h>
#include <sys/farptr.h>
#endif

#ifdef LINUX
#include <sys/io.h>
#define IO_KEEP 1
#define IO_FREE 0
#endif

/* PC-AT Compatible */
#define DEFAULT_BASEL 0x78
#define DEFAULT_BASEH 0x3

/* IBM PC */
/*
#define DEFAULT_BASEL 0xBC
#define DEFAULT_BASEH 0x3
*/

extern int pport_out_adr, pport_in_adr, pport_con_adr;

#ifdef TEST

void main()
{
	int pport_out_adr, pport_in_adr, pport_con_adr;

	pport_init();


}
#endif

#ifndef PC9801
static unsigned int pport_base;

void get_pport_base(void);
void pport_init(void);
void pport_cleanup(void);

/* プリンターポートのベースアドレスの取得 */
void get_pport_base(void)
{
#if !(MSVC || BCC || LINUX)
	union REGS regs;
#endif
#if __MSC__ || TURBOC
	unsigned char far *bioswork;
#endif
	unsigned char basel, baseh;

	extern int pport_out_adr, pport_in_adr, pport_con_adr;

	basel = DEFAULT_BASEL;
	baseh = DEFAULT_BASEH;

	/*
	 *  BIOSワークエリアに書き込まれている
	 *  パラレルポートのI/Oベースアドレスの取得
	 */
	/* BIOSワークエリア */
#ifdef __DJGPP__
	basel = _farpeekb(_dos_ds, 0x40*16 + 0x08);
	baseh = _farpeekb(_dos_ds, 0x40*16 + 0x09);
#ifdef TEST
	printf("basel = %x\n", basel);
	printf("baseh = %x\n", baseh);
#endif
/*
	dosmemget(0x40 * 16 + 0x08, 1, &basel);
	dosmemget(0x40 * 16 + 0x09, 1, &baseh);
*/
#endif
#if MSVC || BCC
/*
	basel = *((unsigned char *)(0x40*16 + 0x08));
	baseh = *((unsigned char *)(0x40*16 + 0x09));
*/
#endif
#if __MSC__ || TURBOC
	bioswork = (unsigned char far *)MK_FP(0x40, 0x08);
	basel = *bioswork;
	baseh = *(bioswork + 1);
#endif
	pport_base = basel + baseh * 256;

	pport_out_adr = pport_base;
	pport_in_adr  = pport_base + 1;
	pport_con_adr = pport_base + 2;
}

/* プリンターポートの初期化 */
void pport_init(void)
{
	get_pport_base();

	/* プリンタポートの初期化 */
#if !(MSVC || BCC || LINUX)
	regs.h.ah = 0x01;
	int86(0x17, &regs, &regs);
#endif

#if LINUX
	if (ioperm(pport_base, 3, IO_KEEP) < 0) {
  		fprintf(stderr, "ioperm error to keep\n");
	}
#endif
}


/* プリンターポートの後処理 */
void pport_cleanup(void)
{
	get_pport_base();

#if LINUX
	if (ioperm(pport_base, 3, IO_FREE) < 0) {
  		fprintf(stderr, "ioperm error to free\n");
	}
#endif
}
#endif
