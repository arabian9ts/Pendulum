#define LOGMAX 1000

Integer cmd, count;
Real smtime, yc, kc;
Matrix u, y;
Array data;

/*--- append ---*/
Integer swinging;
Matrix Ahd, Bhd, Chd, Dhd, Jhd, F;
Matrix z;
Real M, m, J, g, l, f, a, n, k ,c;
Real r, th,dr, dth, ddr, ddth;
Real E0, E, r_max, th_min, sign_dtct, sat_ng, v;
Real pre_r, pre_th, pre_dr, pre_dth, pre_ddth;


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
	data = Z(3,LOGMAX); // ロギングデータを保存する場所
	z = [0 0]';			// 入力 [v]
	E0 = 0;
	swinging = 1;
	r_max = 0.08;
	th_min = 10.0;
	read M, m, J, g, l, f, a <- "params.mx";
	n = 0.75;
	k = 100.0;
	c = 0.0002089;
}

// オンライン関数
Func void on_task()
{



	Matrix xh, xref;
	Matrix sensor();
	void actuator();

	y = sensor();		// センサから入力
	
		
	th = y(2);
		//角が正の時
	if(0 < th)
	{
		//角が180度オーバーの時負へ
		while(PI < th)
		{
			th = th - 2.0*PI;
		}
	}
	//角が負の時
	else
	{
		//角が-180度オーバーの時正へ
		while(th < -PI)
		{
			th = th + 2.0*PI;
		}
	}
	y(2) = th;

	xh = Chd*z + Dhd*y;
	xref = [0 0 0 0]';
	
	
	r = y(1);
	swinging = 1;
	
	// 振り上げの判定開始
	swinging = 1 - abs(th) <= (th_min/180*PI) && abs(r) < r_max;
	swinging = (th_min/180*PI) < abs(th);

	// 振り上げ開始
	if(swinging){
	
		//力学的エネルギーEの計算
		E = (J+m*l*l)*dth*dth/2 + m*g*l*(cos(th) -1);

		//------------
		//dr,dt,ddtの計算
		//------------
		dr = (r - pre_r)/smtime;
		dth = (th - pre_th)/smtime;
		ddth = (dth - pre_dth)/smtime;
		pre_r = r;
		pre_th = th;
		pre_dth = dth;
	
	
	
		//sign(dt*cos(th))の計算
		sign_dtct = 0;
		if(dth*cos(th) < 0)
		{
			sign_dtct = -1;
		}
		else if(0 < dth*cos(th))
		{
			sign_dtct = 1;
		}
		else{
			sign_dtct = 0;
		}
				//sat_ngの計算
		sat_ng = max(-n*g, min(n*g, k*(E - E0)*sign_dtct));
	
				//台車の加速目標vの計算
		v = -c*dth/(m*l*cos(th)) + sat_ng;
				//入力値uの計算
		u = [(f*dr - m*l*dth*dth*sin(th) + m*l*ddth*cos(th) + (M + m)*v)/a];	
		//台車の位置が入力可能範囲外で且つ進行方向が台車の端側の場合
		if(r_max < abs(r) && 0 < r*u(1,1))
		{
			u = [0];
		}

	}
	else
	{
		u = [F*(xref - xh)];
	}
		
	//入力電圧の制限
	if(u(1) < -15.0)
	{
		u(1) = -15.0;
	}
	else if(15.0 < u(1))
	{
		u(1) = 15.0;
	}

	z = Ahd*z + Bhd*y + Jhd*u;

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

	filename = "";
	read filename;

	if (count > 1) {
		TT = [0:count-1]*smtime;
		print [[TT][data(:,1:count)]] >> filename + ".mat";
	}
}
