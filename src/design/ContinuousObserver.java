package design;

import org.mklab.nfc.matrix.DoubleComplexMatrix;

import model.LinearPendulum;

/**
 * (1重)倒立振子の連続時間オブザーバを表すクラスです
 * @author arabian9ts
 *
 */
public class ContinuousObserver extends org.mklab.tool.control.system.controller.ContinuousObserver {
	
	/**
	 * オブジェクトを初期化します
	 */
	public ContinuousObserver(){
		super(new LinearPendulum());
		setObserverPoles(new DoubleComplexMatrix(
				new double[]{-2, -2},
				new double[]{0, 0}).transpose());
	}
}
