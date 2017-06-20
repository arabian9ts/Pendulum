package model;

import org.mklab.nfc.matrix.DoubleComplexMatrix;

/**
 * (1重)倒立振子のりサン時間オブザーバを表すクラスです
 * 
 * @author arabian9ts
 *
 */
public class DiscreteObserver extends org.mklab.tool.control.system.controller.DiscreteObserver {

	/**
	 * 新しく生成された<code>DiscreteObserver</code>オブジェクトを初期化します
	 */
	public DiscreteObserver() {
		super(new LinearPendulum());
		setContinuousObserverPoles(new DoubleComplexMatrix(
				new double[]{-2, -2},
				new double[]{0, 0}).transpose());
		
		setSamplingInterval(0.005);
	}
	
	
}
