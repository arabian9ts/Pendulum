package model;

import org.mklab.nfc.matrix.DoubleComplexMatrix;
import org.mklab.tool.control.system.SystemOperator;

/**
 * 倒立振子の極配置による安定化制御のための状態フィードバック
 * コントローラ(定数行列)を表すクラスです
 * @author maeda
 *
 */
public class PolePlaceStateFeedback extends org.mklab.tool.control.system.controller.PolePlaceStateFeedback {

	/**
	 * オブジェクトを初期化します
	 */
	public PolePlaceStateFeedback() {
		super(new LinearPendulum());
		setClosedLoopPoles(new DoubleComplexMatrix(
				new double[]{-1, -1, -2, -2},
				new double[]{0, 0, 0, 0}).
				transpose());
		
	}
	
}
