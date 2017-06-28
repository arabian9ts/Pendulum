/*
 *	ミニ倒立振子(新式)用  ハードウェアインターフェースプログラム
 */
#define NEW_HARDWARE 0
#define OLD_HARDWARE 1


#if NEW_HARDWARE
#define PtoMet 6.027846e-5
                                /* 0.368/6105 400p/r [m/pulse]        */
                                /* 台車位置パルスをmに変換            */
#define PtoRad 1.570796327e-3
                                /* 2*Pi/1000*4 [rad/pulse]            */
                                /* 振子角度パルスをradに変換          */

#define toVolt1 8.6253
                                /* 256/29.68[V]  [1/V]                */
                                /* モータ電圧をバイナリーデータに変換 */
#define toVolt2 6.061
                                /* 1.0/0.165                          */
                                /* モータ電圧をバイナリーデータに変換 */
#else /* NEW_HARDWARE */
#if OLD_HARDWARE
#define PtoMet 6.09856e-5
                                /* 0.297/4870 [m/pulse]               */
                                /* 台車位置パルスをmに変換            */
#define PtoRad 1.570796327e-3
                                /* 2*Pi/1000*4 [rad/pulse]            */
                                /* 振子角度パルスをradに変換          */

#define toVolt1 5.464
                                /* 1.0/0.183                          */
                                /* モータ電圧をバイナリーデータに変換 */
#define toVolt2 6.061
                                /* 1.0/0.165                          */
                                /* モータ電圧をバイナリーデータに変換 */
#endif /* OLD_HARDWARE */
#endif /* NEW_HARDWARE */

// センサ，アクチュエータの変数
extern Matrix mp_data, PtoMR;
Integer mp1_old, mp2_old;
Integer pport_in_adr, pport_out_adr, pport_con_adr;

// センサの初期化
Func void sensor_init()
{
#ifdef PC9801
	void mport_init();
	Integer mport_in();

	mport_init();			// マウスポートの初期化
	mp1_old = mport_in(1);
	mp2_old = mport_in(2);
#else
	void pport_init();
	Integer pport_in();
	
	pport_init();
	mp1_old = pport_in(1);
	mp2_old = pport_in(2);
#endif

	PtoMR = [[PtoMet]
			 [PtoRad]];

	mp_data = [[0.0]		// 台車位置の初期値
			   [-PI]];		// 振子角度の初期値
}

// センサー処理
Func Matrix sensor()
{
    Integer mp1, mp2, mpd1, mpd2;

#ifdef PC9801
    Integer mport_in();
    mp1 = mport_in(1);
    mp2 = mport_in(2);
#else
    Integer pport_in();
    mp1 = pport_in(1);
    mp2 = pport_in(2);
#endif

    mpd1 = mp1 - mp1_old;		// 台車位置の算出
    mpd2 = mp2 - mp2_old;		// 振子角度の算出
    mp1_old = mp1;
    mp2_old = mp2;

    if (mpd1 < -128) {
		mpd1 = mpd1 + 256;
    } else if (mpd1 > 128) {
		mpd1 = mpd1 - 256;
    }

    if (mpd2 < -128) {
		mpd2 = mpd2 + 256;
    } else if (mpd2 > 128) {
		mpd2 = mpd2 - 256;
    }

	// センサの出力を物理量に変換(m，rad)
    mp_data = mp_data + [[PtoMet*mpd1]
						 [PtoRad*mpd2]];
    return mp_data;
}

// アクチュエータの初期化
Func void actuator_init()
{
	Integer err;

	void pport_init(), actuator_stop();

	pport_init();			// パラレルポートの初期化
	actuator_stop();		// アクチュエータ停止
}

// アクチュエータ停止
Func void actuator_stop()
{
	void pport_out();

	pport_out(0);
}

// アクチュエータ処理
Func void actuator(data)
	Real data;
{
	Integer uv;
	void pport_out();

	// 物理量(N)を電圧に変換
	if (data >= 0.0) {
		uv = Integer(toVolt1 * data);
	} else {
		uv = Integer(toVolt2 * data);
	}

	if (uv > 127) {
		uv = 127;
	} else if (uv < -128) {
		uv = -128;
	}

	pport_out(uv);
}

// マウスポートの初期化
#ifdef PC9801
Func void mport_init()
{
	Outportb(0x7FDF, 0x93);
	Outportb(0x7FDF, 0x05);
	Outportb(0x7FDF, 0x0F);
}
#endif

/*
 * マウスポートからデータの入力 
 * mport_in(1)とmport_in(2)は連続して呼ばれなければならない
 */
#ifdef PC9801
Func Integer mport_in(p)
	Integer p;
{
    Integer y1l, y1h, ym1, y2l, y2h, ym2;

    if (p == 1) {
		Outportb(0x7FDD, 0x10);
		y1l = Inport(0x7FD9);
		Outportb(0x7FDD, 0x30);
		y1h = Inport(0x7FD9);

		ym1 = bit_and(y1l, 0x0f) + bit_and(bit_lshift(y1h, 4), 0xf0);
		return ym1;
    } else if (p == 2) {
		Outportb(0x7FDD, 0x50);
		y2l = Inport(0x7FD9);
		Outportb(0x7FDD, 0x70);
		y2h = Inport(0x7FD9);

		ym2 = bit_and(y2l, 0x0f) + bit_and(bit_lshift(y2h,4), 0xf0);
        return ym2;
    }
}
#endif

// プリンターポートの初期化
#ifdef PC9801
Func void pport_init()
{
	pport_out_adr = 0x40;
	Outportb(0x46, 0x82);
}
#endif

#ifndef PC9801
/*
 * プリンタポートからデータの入力 (For PC/AT)
 * pport_in(1)とpport_in(2)は連続して呼ばれなければならない
 */

/*
 * 旧式ミニ倒立振子用
 */
#if 0
Func Integer pport_in(p)
	Integer p;
{
	Integer x, y;
	Integer xl, xh, yl, yh, cdata;

	cdata = 0x0a;

	if (p == 1) {
		Outportb(pport_con_adr, cdata);
		xl = Inport(pport_in_adr);
		Outportb(pport_con_adr, cdata+1);
		xh = Inport(pport_in_adr);
		Outportb(pport_con_adr, 0);
		x = bit_and(bit_rshift(xl, 3), 0x0f) +
			bit_and(bit_lshift(xh, 1), 0xf0);
		return x;
	} else if (p == 2) {
		Outportb(pport_con_adr, cdata+4);
		yl = Inport(pport_in_adr);
		Outportb(pport_con_adr, cdata+5);
		yh = Inport(pport_in_adr);
		Outportb(pport_con_adr, 0);
		y = bit_and(bit_rshift(yl, 3), 0x0f) +
			bit_and(bit_lshift(yh, 1), 0xf0);
		return y;
	}
}
#endif

/*
 * 新式ミニ倒立振子用
 */
Func Integer pport_in(p)
	Integer p;
{
	Integer stbh, stbl, sdh, opeh, opel;
	Integer x, y, xl, xh, yl, yh;

	void pport_out_stat();
	Integer arp_wait(), pport_in_data();

	stbh = 0x01;
	stbl = 0x00;
	opeh = 0x08;
	opel = 0x00;
	
	if (p == 1) {
		// Ready ?
		pport_out_stat(bit_or(bit_lshift(0x00, 1), stbh));
		arp_wait(opeh);
		
		// X下位4bitリクエスト
		pport_out_stat(bit_or(bit_lshift(0x00, 1), stbl));
		arp_wait(opel);
		xl = bit_and(pport_in_data(), 0xf0);	// X下位4bitリード
		
		// Ready ?
		pport_out_stat(bit_or(bit_lshift(0x01, 1), stbh));
		arp_wait(opeh);
		
		// X上位4bitリクエスト
		pport_out_stat(bit_or(bit_lshift(0x01, 1), stbl));
		arp_wait(opel);
		xh = bit_and(pport_in_data(), 0xf0); // X上位4bitリード
	
		x = xh + bit_rshift(xl, 4);
		return x;
	} else {
		// Ready ?
		pport_out_stat(bit_or(bit_lshift(0x02, 1), stbh));
		arp_wait(opeh);

		// Y下位4bitリクエスト
		pport_out_stat(bit_or(bit_lshift(0x02, 1), stbl));
		arp_wait(opel);
		yl = bit_and(pport_in_data(), 0xf0); // Y下位4bitリード
		
		// Ready ?
		pport_out_stat(bit_or(bit_lshift(0x03, 1), stbh));
		arp_wait(opeh);
		
		// Y上位4bitリクエスト
		pport_out_stat(bit_or(bit_lshift(0x03, 1), stbl));
		arp_wait(opel);
		yh = bit_and(pport_in_data(), 0xf0); // Y上位4bitリード

		// end of access
		pport_out_stat(bit_or(bit_lshift(0x00, 1), stbh));

		y = yh + bit_rshift(yl, 4);
		return y;
	}
}

/* output to output-port */
Func void pport_out_data(x)
	Integer x;
{
	Outportb(pport_out_adr, x);
}

/* output to status-port */
Func void pport_out_stat(x)
	Integer x;
{
	Outportb(pport_con_adr, bit_xor(bit_and(x, 0x0f), 0x0b));
}

/* input from input-port */
Func Integer pport_in_data()
{
	return bit_xor(bit_and(Inportb(pport_in_adr), 0xf8), 0x80);
}
#endif

// プリンターポートにデータを出力
Func void pport_out(d)
	Integer d;
{
	Integer zero;

	zero = 0x80;
	Outportb(pport_out_adr, d + zero);
}

#if 0
/*
 * ARP アンプのチェック (4/5bit version)
 */
Func Integer arp_4bit_check()
{
	Integer err, opeh, data;

	void pport_out_stat();
	Integer pport_in_data();

	err = 0;
	opeh = 0x08;

	pport_out_stat(0x01);
	printf(" ");
	if ((data = bit_and(pport_in_data(), 0x08)) != 0x08) {
		err = -1;
		printf("ARP amp. not ready (%d)\n", err);
		printf("data = %0x\n", data);
	}

	pport_out_stat(0x00);
	printf(" ");
	if ((data = bit_and(pport_in_data(), 0x08)) != 0x00) {
		err = -2;
		printf("ARP amp. not ready (%d)\n", err);
		printf("data = %0x\n", data);
	}

	pport_out_stat(0x01);
	printf(" \n");
	if ((data = bit_and(pport_in_data(), 0x08)) != 0x08) {
		err = -3;
		printf("ARP amp. not ready (%d)\n", err);
		printf("data = %0x\n", data);
	}

	return err;
}
#endif

/*
 * ARP アンプ処理待ち (IBM/AT only)
 */  
Func Integer arp_wait(s)
	Integer s;
{
	Integer i, opeh;
	void arp_cpu_wait();

	opeh = 0x08;
	
	for (i = 50000; i > 0; i--) {
		if (bit_and(Inportb(pport_in_adr), opeh) == s) {
			break;
		}
		arp_cpu_wait(1); 
	}
	if (i == 0){
		return -1;
	} else {
		return 0;
	}
}

/*
 * ウェイト(時間かせぎ) (CPU依存)
 */
Func void arp_cpu_wait(count)
	Integer count;
{
	Integer i;
	Real x;

	x = 1.0;
	for (i = 0; i < count; i++) {
		x = x*i*3.0;
	}
}

