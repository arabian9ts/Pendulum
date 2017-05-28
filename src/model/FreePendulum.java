package model;

import org.mklab.nfc.matrix.DoubleMatrix;
import org.mklab.tool.control.system.SystemBuilder;
import org.mklab.tool.control.system.SystemOperator;
import org.mklab.tool.control.system.source.ConstantSource;

/**
 * 倒立振子のゼロ入力システム
 * 
 * @author maeda
 *
 */
public class FreePendulum {
	
	/**
	 * 倒立振子ゼロ入力システムを返却
	 * 
	 * @return 倒立振子のゼロ入力システム
	 */
	public static SystemOperator getInstance(){
		Pendulum pendulumSystem = new Pendulum();
		double th0 = (10.0 / 180) * Math.PI;
		pendulumSystem.setInitialState(
				new DoubleMatrix(
						new double[]{0,th0,0,0}).transpose());
		
		ConstantSource zeroSystem = new ConstantSource(new DoubleMatrix(new double[]{0}));
		SystemBuilder pendulum = new SystemBuilder(pendulumSystem);
		SystemBuilder zero = new SystemBuilder(zeroSystem);
		
		SystemBuilder all = pendulum.multiply(zero);
		return all.getSystemOperator();
	}
}
