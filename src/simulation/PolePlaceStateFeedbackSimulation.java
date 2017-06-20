package simulation;

import java.io.IOException;

import org.mklab.tool.control.system.SystemOperator;

/**
 * 倒立振子の極配置に基づく状態フィードバックによる安定化制御のシミュレーションを実行するクラスです
 * 
 * @author arabian9ts
 *
 */
public class PolePlaceStateFeedbackSimulation {
	
	/**
	 * @param args コマンドライン引数
	 * @throws InterruptedException 強制終了された場合
	 * @throws IOException キーボードから入力できない場合
	 */
	public static void main(String[] args) throws InterruptedException, IOException {
		
		SystemOperator system = PolePlaceStateFeedbackPendulum.getInstance();
	}

}
