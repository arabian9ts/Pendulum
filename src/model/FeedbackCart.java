package model;

import org.mklab.nfc.matrix.DoubleMatrix;
import org.mklab.tool.control.system.SystemBuilder;
import org.mklab.tool.control.system.SystemOperator;
import org.mklab.tool.control.system.discontinuous.Saturation;
import org.mklab.tool.control.system.math.ConstantSystem;
import org.mklab.tool.control.system.source.StepSource;

/**
 * 定数ゲインフィードバックを施した台車にステップ信号加えたシステムを生成するクラスです
 * @author maeda
 *
 */
public class FeedbackCart {
	
	/**
	 * 定数ゲインフィードバックを施した台車にステップ信号加えたシステムを返します
	 * @author maeda
	 * @return 定数ゲインフィードバックを施した台車にステップ信号加えたシステム
	 *
	 */
	public static SystemOperator getInstance(){
		Cart cartSystem = new Cart();
		cartSystem.setInitialState(new DoubleMatrix(new double[]{0, 0}).transpose());
		
		Saturation saturationSystem = new Saturation(-15, 15);
		
		ConstantSystem gainSystem = new ConstantSystem(new DoubleMatrix(new double[]{2500}));
		
		StepSource stepSystem = new StepSource(0.15);
		
		SystemBuilder cart = new SystemBuilder(cartSystem);
		SystemBuilder gain = new SystemBuilder(gainSystem);
		SystemBuilder saturation = new SystemBuilder(saturationSystem);
		SystemBuilder step = new SystemBuilder(stepSystem);
		
		SystemBuilder forwart = cart.multiply(saturation).multiply(gain);
		SystemBuilder closedLoop = forwart.unityFeedback();
		SystemBuilder all = closedLoop.multiply(step);

		return all.getSystemOperator();
	}
		
}
