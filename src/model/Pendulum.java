package model;

import org.mklab.nfc.matrix.Matrix;
import org.mklab.nfc.ode.SolverStopException;

/**
 * 倒立振子のモデル
 * @author maeda
 *
 */
public class Pendulum extends org.mklab.tool.control.system.continuous.BaseContinuousExplicitDynamicSystem {

	/**
	 * デフォルトコンストラクタ
	 * @param inputSize 入力行列のサイズ
	 * @param outputSize 出力行列のサイズ
	 * @param stateSize 状態ベクトルのサイズ
	 */
	public Pendulum(int inputSize, int outputSize, int stateSize) {
		super(inputSize, outputSize, stateSize);
	}

	/**
	 * f
	 */
	public Pendulum() {
		this(1,1,1);
	}

	/**
	 * @see org.mklab.tool.control.system.continuous.ContinuousExplicitDynamicSystem#stateEquation(double, org.mklab.nfc.matrix.Matrix, org.mklab.nfc.matrix.Matrix)
	 */
	public Matrix stateEquation(double t, Matrix x, Matrix u) throws SolverStopException {
		//
		return null;
	}
	
	/**
	 * @return as
	 */
	public Matrix outputEquation(){
		
		return null;
	}
	
}
