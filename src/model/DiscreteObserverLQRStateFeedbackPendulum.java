package model;

import org.mklab.nfc.matrix.DoubleMatrix;
import org.mklab.tool.control.system.SystemOperator;

/**
 * 倒立振子の(LQR最適制御に基づく状態フィードバック+離散時間オブザーバ)による安定化制御のシステムを生成するクラスです
 * 
 * @author arabian9ts
 *
 */
public class DiscreteObserverLQRStateFeedbackPendulum {
	
	/**
	 * 倒立振子の(LQR最適制御に基づく状態フィードバック+離散時間オブザーバ)による安定化制御のシステムを返します
	 * @return 倒立振子の(LQR最適制御に基づく状態フィードバック+離散時間オブザーバ)による安定化制御のシステム
	 */
	public static SystemOperator getInstance(){
		LqrStateFeedback stateFeedback = new LqrStateFeedback();
		DoubleMatrix Q = DoubleMatrix.diagonal(new double[]{1, 1, 1, 1});
		DoubleMatrix R = new DoubleMatrix(new double[]{1});
		stateFeedback.setWeightingMatrices(Q, R);
		
		return DiscreteObserverStateFeedbackPendulum.getInstance(stateFeedback);
	}
}
