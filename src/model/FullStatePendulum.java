package model;

import org.mklab.nfc.matrix.Matrix;

/**
 * 倒立振子の非線形モデル(全状態観測可能)を表すクラスです
 * @author maeda
 *
 */
public class FullStatePendulum extends Pendulum {
	
	/**
	 * コンストラクター
	 */
	public FullStatePendulum(){
		super();
		setOutputSize(4);
	}
	
	/**
	 * @see model.Pendulum#outputEquation(double, org.mklab.nfc.matrix.Matrix)
	 */
	public Matrix outputEquation(final double t, final Matrix x){
		return x;
	}
}
