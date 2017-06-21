package model.pattern2;

import org.mklab.nfc.matrix.DoubleMatrix;
import org.mklab.tool.control.system.SystemOperator;

import model.pattern1.LqrStateFeedback;

/**
 * 倒立振子の(LQ最適制御に基づく状態フィードバック+連続時間オブザーバ)による
 * 安定化制御のシステムを生成するクラスです
 * 
 * @author arabian9ts
 *
 */
public class ObserverLqrStateFeedbackPendulum {
	
	/**
	 * 倒立振子の(LQ最適制御に基づく状態フィードバック+連続時間オブザーバ)による
	 * 安定化制御のシステムを返します
	 * 
	 * @return 倒立振子の(LQ最適制御に基づく状態フィードバック+連続時間オブザーバ)による安定化制御のシステム
	 */
	public static SystemOperator getInstance(){
		LqrStateFeedback stateFeedback = new LqrStateFeedback();
		DoubleMatrix Q = DoubleMatrix.diagonal(new double[]{1.0, 1.0, 1.0, 1.0});
		DoubleMatrix R = new DoubleMatrix(new double[]{1});
		stateFeedback.setWeightingMatrices(Q, R);
		
		return ObserverStateFeedbackPendulum.getInstance(stateFeedback);
	}
	
}
