#define LOGMAX 10000
//Real dth, ddth;
Integer cmd, count;
Real smtime;
Matrix u, y, kc, yc;
Matrix Ahd, Bhd, Chd, Dhd, Jhd, F;
Matrix z;
Matrix yb,DE;
Real swinging;
Real pre_r, pre_th, pre_dr, pre_dth, pre_ddth;
Array data;

Real ref, time;

// センサとアクチュエータ関連の変数 (hardware.mmで使用される)
Matrix mp_data, PtoMR;

// メイン関数
Func void main()
{
	void para_init(), var_init();
	void on_task(), break_task(), off_task_loop();
	void machine_ready(), machine_stop(), data_save();

	para_init();			// パラメータの初期化
	var_init();             // 変数の初期化
	machine_ready();        // 実験装置の準備

	rtSetClock(smtime);     // サンプリング周期の設定
	rtSetTask(on_task);		// オンライン関数の設定(制御)
	rtSetBreak(break_task); // 割り込みキーに対応する関数の設定

	rtStart();              // リアルタイム制御開始
	off_task_loop();        // オフライン関数
	rtStop();               // リアルタイム制御終了

	machine_stop();         // 実験装置を停止

	data_save();			// データを保存する
}

// パラメータの初期化
Func void para_init()
{
	read Ahd, Bhd, Chd, Dhd, Jhd, F <- "para.mx";
}

// 変数の初期化
Func void var_init()
{
	smtime = 0.005;		// サンプリング周期 [s]
	cmd = 0;			// 制御出力を抑制
	count = 0;			// ロギングデータの数
	data = Z(4,LOGMAX); // ロギングデータを保存する場所
	u = [8.0];			// 入力 [v]
//	kc = [900];
//	yc = [0.0];
	z = [0 0]';			//オブザーバの初期状態
	ref = 0;
	time = 0;
	yb = [0, -PI + 0.01]';
	swinging = 1;
	pre_r = 0;
	pre_th = -PI;
	pre_dr = 0;
	pre_dth = 0;
	pre_ddth = 0;	
}

Func Matrix DiscreteEstimator()
{

	Matrix xh;
	xh = [[y][(y - yb)/smtime]];
	return xh;	

}



Func void AngleWrapper()
{

	Real r, th;

	r = y(1,1);
	th = y(2,1);

	while (th > 2*PI) {
		th = th - 2 * PI;
	}

	while (th < -2*PI) {
		th = th + 2 * PI;
	}

	y = [[r][th]];
	
}

Func void swing()
{
	Real m,l,M,f,J,c,a,g;
//	Real r, th, dr, ddr;
	Real r, th, dr, dth, ddr, ddth;
	Real r_max, th_min, E0, E;
	Real kk, n;
	Matrix xh, xref;


//	m = 0.0398;
//	l = 0.124;
//	M = 1.02;
//	f = 9.89;
//	J = 3.90E-4;
//	c = 2.30E-4;
//	a = 0.717;
//	g = 9.8;


	m = 0.038;
	l = 0.12;
	M = 1.001;
	f = 9.67;
	J = 3.9E-4;
	c = 9.82E-5;
	a = 0.49;
	g = 9.8;


	E0 = 0;
	r_max = 0.065;
	th_min = 25;

	kk = 2400;
	n = 0.4;



	xref = [0 0 0 0]';

	r = DE(1);
	th = DE(2);
	dr = DE(3);
	dth = DE(4);

	if (abs(th) <= th_min*PI/180 && abs(r) <r_max) {
		swinging = 0;
	}
	
	//振り上げ
	if (abs(th) > th_min*PI/180) {
	//if (isSolverTrial() == 0&& abs(th) > th_min*PI/180) {
		swinging = 1;

	}
	
	if (count < 40){
	}	
	else if (swinging == 1) {
		E = (J + m*l*l)*dth*dth/2 + m*g*l*(cos(th) - 1);
		ddr = max(-n*g, min(n*g, kk*(E - E0)*sgn(dth*cos(th))));
		
	//	if (isSolverTrial() == 0) {
			pre_ddth = ddth = (dth - pre_dth)/smtime;
			pre_dth = dth;

	//	}
	//	else{
	//		ddth = pre_ddth;
	//	}
	
		u = [((M + m)*ddr + m*l*(ddth*cos(th) - dth*dth*sin(th)) + f*dr)/(a + 0.3)];
	
		if (abs(r) > r_max && r*u(1,1) > 0) {
			u = [0];
		}
	}
	else {
	//	u = -F*z1;
		z = Ahd*z + Bhd*y + Jhd*u;			//オブザーバの状態の更新

		xh = Chd*z + Dhd*y;			//状態の推定値	
		u = F*(xref - xh);			//制御入力	
	}
	//	gotoxy(5, 9);
	//	printf("swinging = %8.4f[k], yb = %8.4f[k]", dth, ddth);
	if(u(1) > 15){
		u(1) = 15;
	}
	else if(u(1) < -15) {
		u(1) = -15;
	}
}	

// オンライン関数
Func void on_task()
{	

	Matrix sensor();
	void actuator();
	void AngleWrapper(), swing();
	Matrix DiscreteEstimator();


	y = sensor();				// センサから入力
	AngleWrapper();
	DE = DiscreteEstimator();
	swing();

	yb = y;
	// リハーサル中でなければ
	if (cmd == 1 && ! rtIsRehearsal()) {
		actuator(u(1));
		//u = kc * (yc(1) - y(1));			// アクチュエータへ出力
	}

	// データのロギング
	if (cmd == 1 && count < LOGMAX) {
		count++;
		data(1:1, count) = u;
		data(2:3, count) = y;
		data(4, count) = ref;
	}
}

// オフライン関数
Func void off_task_loop()
{
	Integer end_flag;

	end_flag = 0;

	gotoxy(5, 6);
	printf("'c': アクチュエータへ出力開始");
	gotoxy(5, 7);
	printf("ESC: アクチュエータへ出力停止");

	do {

		gotoxy(5, 9);
		printf("swinging = %8.4f[k], yb = %8.4f[k]", y(1), y(2));

		gotoxy(5, 11);
		printf("  台車位置 = %8.4f[m], 振子角度 = %8.4f[deg]",
			y(1), y(2)/PI*180);
		gotoxy(5, 12);
		printf("入力 = %10.4f[N]", u(1));

		gotoxy(5, 14);
		printf("データ数 = %4d, 時間 = %7.3f [s]", count, count*smtime);
		if (rtIsTimeOut()) {
			gotoxy(5, 18);
			warning("\n時間切れ !\n");
			break;
		}

		if (kbhit()) {
			switch (getch()) {
			  case 0x1b:            /* ESC */
				end_flag = 1;
				break;
		/* 'c' */  case 0x43: // アクチュエータへ出力開始
		/* 'C' */  case 0x63: // If 'c' or 'C' is 
				      // pressed, start motor
				cmd = 1;
				break;

		/*' R ' */ case 0x52:
		/*' r ' */ case 0x72:

			gotoxy (5, 16);
	
			print "台車の目標値　[m] : "; read ref;
			break;
			  default:
				break;
			}
		}
    } while ( ! end_flag);  // If end_flag != 0, END
}

// 割り込みキーに対応する関数
Func void break_task()
{
	void machine_stop();

	rtStop();
	machine_stop(); // 実験装置停止
}

// 実験装置の準備
Func void machine_ready()
{
	void sensor_init(), actuator_init();

	sensor_init();                  // センサの初期化
	actuator_init();                // アクチュエータの初期化

	gotoxy(5,5);
	printf("台車の初期位置 : レールの中央");
	gotoxy(5,6);
	printf("振子の初期位置 : 真下");
	gotoxy(5,9);
	pause "台車と振子を初期位置に移動し，リターンキーを入力して下さい。";
	gotoxy(5,9);
	printf("                                                            ");
	gotoxy(5,9);
	pause "リターンキーを入力すると，制御が開始されます。";
	clear;
}

// 実験装置停止
Func void machine_stop()
{
	void actuator_stop();

	actuator_stop();
}

// データのファイルへの保存
Func void data_save()
{
	String filename;
	Array TT;

	filename = "data";
	read filename;

	if (count > 1) {
		TT = [0:count-1]*smtime;
		print [[TT][data(:,1:count)]] >> filename + ".mat";
	}
}
