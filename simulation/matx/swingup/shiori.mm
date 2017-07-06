#define LOGMAX 3000

Integer cmd, count;
Real smtime;
Real t;
Matrix u, y;
Array data;

Matrix Aod, Bod, Cod, Dod, Jod, F;
Matrix z;
Matrix z_E, z_O;
Matrix zn_E, zn_O;
Matrix xh_E, xh_O;

Integer swinging;
Real pre_r, pre_th, pre_dr, pre_dth, pre_ddth;

// センサとアクチュエータ関連の変数 (hardware.mmで使用される)
Matrix mp_data, PtoMR;

// メイン関数
Func void main()
{
	void para_init(), var_init();
	void on_task(), break_task(), off_task_loop();
	void machine_ready(), machine_stop(), data_save();
	Matrix T, X;	

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
	read Aod, Bod, Cod, Dod, Jod, F <- "para.mx";	// パラメータ読み込み
}

// 変数の初期化
Func void var_init()
{
	smtime = 0.005;			// サンプリング周期 [s]
	cmd = 0;			// 制御出力を抑制
	count = 0;			// ロギングデータの数
	data = Z(3,LOGMAX); 		// ロギングデータを保存する場所
	z = [0 0]';			// オブザーバの初期状態
	
	z_E = [0 0]';
	z_O = [0 0]';
	
	xh_E = [0 0 0 0]';
	xh_O = [0 0 0 0]';
	u = [0];
	
	swinging = 1;
	
	pre_r = 0;
	pre_th = PI;
	pre_dr = 0;
	pre_dth = 0;
	pre_ddth = 0;
}

// オンライン関数
Func void on_task()
{

	Matrix sensor();
	Matrix actuator();
	Matrix Swing();
	Matrix uy;
	Real r, th;
	Matrix r_th;
	Matrix xx;

	
	y = sensor();
//	y(1,1) = -y(1,1);
	

	/* Angle Wrapper */
	r = y(1,1);
	th = y(2,1);
	
	while(th < -2*PI){
		th = th + 2*PI;
	}
	
	while(th > 2*PI){
		th = th - 2*PI;
	}
	
	y = [[r][th]];
	
	/* DiscreteEstimator */
	zn_E = y;
	xh_E = [[y][(y-z_E)/smtime]];
	z_E = zn_E;	
	
	/* DiscreteObserver */

	uy = [[u] [y]];
	
	if(swinging == 1){
		zn_O = [0 0]';
	} else {
		zn_O = Aod*z_O + Bod*uy + Jod*u;
	}
	
	r_th = uy(2:3,1);
	
	if(swinging == 1){
		xh_O = [[r_th]
			[Z(2,1)]];
	} else {
		xh_O = Cod*z_O + Dod*uy;
	}
	
	z_O = zn_O;
	
	
	u = Swing(xh_E, xh_O);
	

	// リハーサル中でなければ
	if (cmd == 1 && ! rtIsRehearsal()) {
		actuator(u(1));			// アクチュエータへ出力
	}




	// データのロギング
	if (cmd == 1 && count < LOGMAX) {
		count++;
		data(1:1, count) = u;
		data(2:3, count) = y;
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
			  default:
				break;
			}
		}
    } while ( ! end_flag);  // If end_flag != 0, END
}
Func Matrix Swing(xh_E,xh_O)
	Matrix xh_E, xh_O;
{
	Real kk, n;
	
	Real M, m, J, g, l, f, a;
	Real r, th, dr, dth, ddr, ddth;
	Real E0, E, r_max, th_min;
	Matrix xh, xref;

//	kk = 1.0E10;
//	n = 0.6;
	kk = 1.0E6;
	n = 0.5;


	E0 = 0;
	r_max = 0.1;	// 入力を加える台車の範囲
	th_min = 15.0;	// 安定化制御へ切替る振子の角度

	a = 0.49;
	M = 1.001;
	l = 0.12;
	m = 0.038;
	g = 9.8;
	J = 3.9E-4;
	f = 9.67;

	r =  xh_E(1,1);
	th = xh_E(2,1);
	dr = xh_E(3,1);
	dth = xh_E(4,1);

	if(abs(th) <= th_min*PI/180 && abs(r) < r_max){
		swinging = 0;
	}
	if(abs(th) > th_min*PI/180){
		swinging = 1;
	}

	if(swinging == 1){
		E = (J + m*l*l)*dth*dth/2 + m*g*l*(cos(th) - 1);
		ddr = max(-n*g, min(n*g, kk*(E - E0)*sgn(dth*cos(th))));


		pre_ddth = ddth = (dth - pre_dth)/smtime;
		pre_dth = dth;

		u = [((M + m)*ddr + m*l*(ddth*cos(th) - dth*dth*sin(th)) + f*dr)/a];

		if(abs(r) > r_max && r*u(1,1) > 0){
			u = [0];
		}
	} else {
	
		u = -F*xh_O(1:4,1);

	}
	return u;

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
