package design;

import org.mklab.nfc.matrix.DoubleMatrix;
import org.mklab.nfc.matrix.Matrix;
import org.mklab.tool.control.system.controller.LqrDesigner;

import model.LinearPendulum;

/**
 * LQ最適制御(安定化)のための状態フィードバックを設計するクラスです
 * @author maeda
 *
 */
public class LqrDesign {

	/**
	 * メインメソッド
	 * @param args コマンドライン引数
	 */
	public static void main(String[] args) {
		LqrDesigner designer = new LqrDesigner(new LinearPendulum());
		Matrix Q = DoubleMatrix.diagonal(new double[]{1.0E0, 1.0E0, 1, 1});
		Matrix R = new DoubleMatrix(new double[]{1});
		designer.setWeightingMatrices(Q, R);
		designer.getStateFeedback().print("F: LQ最適制御のための状態フィードバック行列"); //$NON-NLS-1$
		System.out.println(""); //$NON-NLS-1$
		designer.showClosedLoopPoles();
	}
}
