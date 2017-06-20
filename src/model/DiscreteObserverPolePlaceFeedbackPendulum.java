package model;

import org.mklab.nfc.matrix.DoubleComplexMatrix;
import org.mklab.nfc.matrix.Matrix;
import org.mklab.tool.control.system.SystemOperator;

/**
 * 倒立振子の(極配置に基づく状態フィードバック+離散時間オブザーバ)による安定化制御のシステムを生成するクラスです
 * 
 * @author arabian9ts
 *
 */
public class DiscreteObserverPolePlaceFeedbackPendulum {
	
	/**
	 * 倒立振子の(極配置に基づく状態フィードバック+離散時間オブザーバ)による安定化制御のシステムを返します
	 * @return 倒立振子の(極配置に基づく状態フィードバック+離散時間オブザーバ)による安定化制御のシステム
	 */
	public static SystemOperator getInstance(){
		PolePlaceStateFeedback stateFeedback = new PolePlaceStateFeedback();
		Matrix closedLoopPoles = new DoubleComplexMatrix(
				new double[]{-2, -2, -2, -2},
				new double[]{0, 0, 0, 0}).transpose();
		stateFeedback.setClosedLoopPoles(closedLoopPoles);
		
		return DiscreteObserverStateFeedbackPendulum.getInstance(stateFeedback);
	}
}
