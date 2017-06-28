#define LOGMAX 5000

Real ref;
Integer cmd, count;
Real smtime, yc, kc;
Matrix u, y;
Array data;

/*--- append ---*/
Matrix Ahd, Bhd, Chd, Dhd, Jhd, F;
Matrix z;

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
	z = [0 0]';			// 入力 [v]
	ref = 0.1;
}

// オンライン関数
Func void on_task()
{
	Matrix xh, xref;
	Matrix sensor();
	void actuator();

	y = sensor();		// センサから入力

	xh = Chd*z + Dhd*y;

	if(rem(count * smtime, 5) == 0){
		ref = abs(ref - 0.1);
	}

	xref = [ref 0 0 0]';
	u = F * (xref - xh);
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
			/* 'R' */  case 0x52:
			/* 'r' */  case 0x72:
				gotoxy(5, 16);
				print  "台車の目標値 [m] : ";
				read ref;
				gotoxy(5, 16);
				printf("                                              ");
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
