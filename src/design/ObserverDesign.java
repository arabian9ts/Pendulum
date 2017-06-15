package design;

import org.mklab.nfc.matrix.DoubleComplexMatrix;
import org.mklab.nfc.matrix.Matrix;
import org.mklab.tool.control.system.controller.ObserverDesigner;

import model.LinearPendulum;

/**
 * ゴビナスの方法で連続時間最小次元オブザーバを設計するクラスです
 * @author arabian9ts
 *
 */
public class ObserverDesign {

	/**
	 * メインメソッド
	 * @param args コマンドライン引数
	 */
	public static void main(String[] args){
		ObserverDesigner designer = new ObserverDesigner(new LinearPendulum());
		Matrix observerPoles = new DoubleComplexMatrix(
				new double[]{-2, -2},
				new double[]{0, 0}).transpose();
		
		designer.setObserverPoles(observerPoles);
		designer.showObserver();
	}
	
}
