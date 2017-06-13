package model;

import org.mklab.nfc.matrix.DoubleMatrix;
import org.mklab.tool.control.system.SystemBuilder;
import org.mklab.tool.control.system.SystemOperator;
import org.mklab.tool.control.system.discontinuous.Saturation;
import org.mklab.tool.control.system.math.ConstantSystem;
import org.mklab.tool.control.system.source.PulseSource;

/**
 * 倒立振子の状態フィードバックによる安定化制御のシステムを表すクラスです
 * @author maeda
 *
 */
public class StateFeedbackPendulum {
	
	/**
	 * 倒立振子の状態フィードバックによる安定化制御のシステムを返します
	 * @param stateFeedbackSystem 状態フィードバック
	 * @return 倒立振子の状態フィードバックによる安定化制御のシステム
	 */
	public static SystemOperator getInstance(ConstantSystem stateFeedbackSystem){
		
		FullStatePendulum pendulumSystem = new FullStatePendulum();
		pendulumSystem.setInitialState(new DoubleMatrix(new double[]{0, 0, 0, 0}).transpose());
		
		Saturation saturationSystem = new Saturation(-15, 15);
		PulseSource referenceSystem = new PulseSource(0.1, 10, 50);
		
		ConstantSystem k1System = new ConstantSystem(new DoubleMatrix(new double[]{1, 0, 0, 0}).transpose());
		
		SystemBuilder pendulum = new SystemBuilder(pendulumSystem);
		SystemBuilder saturation = new SystemBuilder(saturationSystem);
		SystemBuilder stateFeedback = new SystemBuilder(stateFeedbackSystem);
		SystemBuilder reference = new SystemBuilder(referenceSystem);
		SystemBuilder k1 = new SystemBuilder(k1System);
		
		SystemBuilder forward = pendulum.multiply(saturation).multiply(stateFeedback);
		SystemBuilder closedLoop = forward.unityFeedback();
		SystemBuilder all = closedLoop.multiply(k1.multiply(reference));
		
		return all.getSystemOperator();
	}
}
