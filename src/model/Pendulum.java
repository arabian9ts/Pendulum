package model;

import org.mklab.nfc.matrix.DoubleMatrix;
import org.mklab.nfc.matrix.Matrix;
import org.mklab.nfc.ode.SolverStopException;

/**
 * 倒立振子のモデル
 * @author maeda
 *
 */
public class Pendulum extends org.mklab.tool.control.system.continuous.BaseContinuousExplicitDynamicSystem {

	/**
	 * コンストラクタ
	 */
	public Pendulum(){
		super(1, 2, 4);
		setHasDirectFeedthrough(false);
	}

	/**
	 * @see org.mklab.tool.control.system.continuous.ContinuousExplicitDynamicSystem#stateEquation(double, org.mklab.nfc.matrix.Matrix, org.mklab.nfc.matrix.Matrix)
	 */
	public Matrix stateEquation(double t, Matrix x, Matrix u) throws SolverStopException {
		DoubleMatrix dx;
		
		/**
		 * dxの計算用実装
		 */
		
		return dx=null;
	}
	
	/**
	 * 出力方程式にもとづき出力を返す
	 * @return 出力
	 */
	public Matrix outputEquation(double t, Matrix x){
		DoubleMatrix y;
		
		/**
		 * 出力の計算用実装
		 */
		
		return y=null;
	}
	
}
