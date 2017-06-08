package model;
import org.mklab.nfc.*;
import org.mklab.nfc.matrix.DoubleMatrix;
import org.mklab.nfc.matrix.Matrix;
import org.mklab.nfc.ode.SolverStopException;
import org.mklab.tool.control.system.continuous.*;
import org.mklab.tool.control.system.parameter.*;


/**
 * 台車を表すクラスです
 * @author maeda
 *
 */
public class Cart extends BaseContinuousExplicitDynamicSystem {
	// パラメータをフィールドとして定義します
	
	/**
	 * コンストラクタ
	 */
	public Cart(){
		super(1,2,4);
		setHasDirectFeedthrough(false);
	}

	/**
	 * 状態方程式に基づき状態の微分を返します
	 * @see org.mklab.tool.control.system.continuous.ContinuousExplicitDynamicSystem#stateEquation(double, org.mklab.nfc.matrix.Matrix, org.mklab.nfc.matrix.Matrix)
	 */
	public Matrix stateEquation(double t, Matrix x, Matrix u) {
		DoubleMatrix dx=null;
		// 微分の実装
		return dx;
	}
	
	/**
	 * 出力方程式に基づき出力を返します
	 * @see org.mklab.tool.control.system.continuous.BaseContinuousDynamicSystem#outputEquation(double, org.mklab.nfc.matrix.Matrix)
	 */
	@Override
	public Matrix outputEquation(double t, Matrix x){
		DoubleMatrix y=null;
		// 出力計算の実装
		return y;
	}
	
	
}
