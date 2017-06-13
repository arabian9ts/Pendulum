package model;

import org.mklab.nfc.matrix.DoubleMatrix;
import org.mklab.nfc.matrix.misc.DiagonalMatrix;
import org.mklab.tool.control.system.SystemOperator;

/**
 * 倒立振子のLQ最適制御(安定化)のための状態フィードバック
 * コントローラ(定数行列)を表すクラスです
 * @author maeda
 * 
 *
 */
public class LqrStateFeedbak extends org.mklab.tool.control.system.controller.LqrStateFeedback {

	/**
	 * オブジェクトを初期化します
	 */
	public LqrStateFeedbak() {
		super(new LinearPendulum());
		DoubleMatrix Q = DiagonalMatrix.create(new double[]{1.0E0, 1.0E0, 1, 1});
		DoubleMatrix R = new DoubleMatrix(new double[]{1});
		setWeightingMatrices(Q, R);
	}
	
	
}
