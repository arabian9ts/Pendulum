package model;

import org.mklab.nfc.matrix.DoubleMatrix;
import org.mklab.nfc.matrix.Matrix;
import org.mklab.tool.control.LinearSystem;
import org.mklab.tool.control.LinearSystemFactory;
import org.mklab.tool.control.system.continuous.ContinuousLinearDynamicSystem;

/**
 * 倒立振子の線形近似モデルを表すクラスです
 * @author maeda
 *
 */
public class LinearPendulum extends ContinuousLinearDynamicSystem {
	
	/**
	 * 非線形倒立振子
	 */
	private Pendulum pendulum;
	
	/**
	 * 新しく生成された<code>LinearPendulum</code>オブジェクトを初期化します
	 * @param pendulum 倒立振子
	 */
	public LinearPendulum(final Pendulum pendulum){
		super();
		
		this.pendulum = pendulum;
		
		final LinearSystem system = createLinearSystem();
		setLinearSystem(system);
		
		setInputSize(system.getInputSize());
		setOutputSize(system.getOutputSize());
		setStateSize(system.getStateSize());
		
	}
	
	/**
	 * 新しく生成された<code>LinearPendulum</code>オブジェクトを初期化します
	 */
	public LinearPendulum(){
		this(new Pendulum());
	}
	
	/**
	 * 線形システムを返します
	 * @return 線形システム
	 */
	private LinearSystem createLinearSystem(){
		final double m1 = this.pendulum.m;
		
		final Matrix a = new DoubleMatrix();
		final Matrix b = new DoubleMatrix();
		final Matrix c = new DoubleMatrix();
		final Matrix d = new DoubleMatrix();
		
		return LinearSystemFactory.createLinearSystem(a, b, c, d);
		
	}
}
