package model;

import org.mklab.nfc.matrix.DoubleMatrix;
import org.mklab.nfc.matrix.misc.DiagonalMatrix;
import org.mklab.tool.control.system.SystemOperator;

/**
 * 倒立振子のLQR最適制御に基づく状態フィードバックによる安定化制御のシステムを生成するクラスです
 * 
 * @author arabian9ts
 *
 */
public class LqrStateFeedbackPendulum {
	
	/**
	 * 倒立振子のLQR最適制御に基づく状態フィードバックによる安定化制御のシステムを返します
	 * @return 倒立振子のLQR最適制御に基づく状態フィードバックによる安定化制御のシステム
	 */
	public static SystemOperator getInstance(){
		DoubleMatrix Q = DiagonalMatrix.create(new double[]{1.0E0, 1.0E0, 1, 1});
		DoubleMatrix R = new DoubleMatrix(new double[]{1});
		LqrStateFeedback stateFeedback = new LqrStateFeedback();
		stateFeedback.setWeightingMatrices(Q, R);
		
		return StateFeedbackPendulum.getInstance(stateFeedback);
	}
}
