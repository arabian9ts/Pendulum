package design;

import org.mklab.nfc.matrix.DoubleComplexMatrix;
import org.mklab.nfc.matrix.Matrix;
import org.mklab.tool.control.system.controller.PolePlaceDesigner;

import model.LinearPendulum;

/**
 * 極配置のための状態フィードバックを設計するクラスです
 * @author maeda
 *
 */
public class PolePlaceDesign {
	
	
	/**
	 * メインメソッド
	 * @param args コマンドライン引数
	 */
	public static void main(String[] args) {
		PolePlaceDesigner designer = new PolePlaceDesigner(new LinearPendulum());
		Matrix closedLoopPoles = new DoubleComplexMatrix(new double[]{-1, -1, -2, -2}, new double[]{0, 0, 0, 0}).transpose();
		
		designer.setClosedLoopPoles(closedLoopPoles);
		Matrix F = designer.getStateFeedback();
		F.print("F: 極配置のための状態フィードバック"); //$NON-NLS-1$
	}
}
