package model;

import org.mklab.nfc.matrix.DoubleMatrix;
import org.mklab.tool.control.system.SystemBuilder;
import org.mklab.tool.control.system.SystemOperator;
import org.mklab.tool.control.system.source.StepSource;

/**
 * 台車にステップ入力を加えたシステムを生成するクラスです
 * @author maeda
 *
 */
public class StepCart {
	
	/**
	 * 台車にステップ入力を加えたシステムを返します
	 * @return 台車にステップ入力を加えたシステム
	 */
	public static SystemOperator getInstance(){
		// 台車
		Cart cartSystem = new Cart();
		// 台車の初期状態を設定
		cartSystem.setInitialState(new DoubleMatrix(new double[]{0, 0}).transpose());
		
		// ステップ信号
		StepSource stepSystem = new StepSource();
		
		SystemBuilder cart = new SystemBuilder(cartSystem);
		SystemBuilder step = new SystemBuilder(stepSystem);
		SystemBuilder all = cart.multiply(step);
		
		return all.getSystemOperator();
	}
}
