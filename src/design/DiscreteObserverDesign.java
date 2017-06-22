package design;

import org.mklab.nfc.matrix.DoubleComplexMatrix;
import org.mklab.nfc.matrix.Matrix;
import org.mklab.tool.control.system.controller.DiscreteObserverDesigner;

import model.LinearPendulum;

/**
 * 連続時間オブザーバを離散化した理三時間オブザーバを求めるクラスです
 * 
 * @author arabian9ts
 *
 */
public class DiscreteObserverDesign {

	/**
	 * メインメソッド
	 * @param args コマンドライン引数
	 */
	public static void main(String[] args) {
		Matrix observerPoles = new DoubleComplexMatrix(
				new double[]{-2, -2},
				new double[]{0, 0}).transpose();
		
		double samplingInterval = 0.005;
		DiscreteObserverDesigner dDesigner = new DiscreteObserverDesigner(new LinearPendulum());
		dDesigner.setSamplingInterval(samplingInterval);
		dDesigner.setContinuousObserverPoles(observerPoles);
		dDesigner.showObserver();
		
	}

}
