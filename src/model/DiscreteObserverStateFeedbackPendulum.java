package model;

import org.mklab.nfc.matrix.DoubleMatrix;
import org.mklab.tool.control.system.SystemBuilder;
import org.mklab.tool.control.system.SystemOperator;
import org.mklab.tool.control.system.discontinuous.Saturation;
import org.mklab.tool.control.system.discrete.ZeroOrderHoldSystem;
import org.mklab.tool.control.system.math.ConstantSystem;
import org.mklab.tool.control.system.source.PulseSource;

/**
 * 倒立振子の(状態フィードバック+離散時間オブザーバ)による安定化制御のシステムを表すクラスです
 * 
 * @author arabian9ts
 *
 */
public class DiscreteObserverStateFeedbackPendulum {
	
	/**
	 * 倒立振子の(状態フィードバック+離散時間オブザーバ)による安定化制御のシステムを返します
	 * @param stateFeedbackSystem 状態フィードバック
	 * @return 倒立振子の(状態フィードバック+離散時間オブザーバ)による安定化制御のシステム
	 */
	public static SystemOperator getInstance(ConstantSystem stateFeedbackSystem){
		
		double samplingInterval = 0.005;
		
		Pendulum pendulumSystem = new Pendulum();
		pendulumSystem.setInitialState(new DoubleMatrix(4,1));
		
		Saturation saturationSystem = new Saturation(-15, 15);
		
		DiscreteObserver observerSystem = new DiscreteObserver();
		observerSystem.setSamplingInterval(samplingInterval);
		observerSystem.setInitialState(new DoubleMatrix(2, 1));
		
		PulseSource referenceSystem = new PulseSource(0.1, 10, 50);
		
		ZeroOrderHoldSystem zohSystem = new ZeroOrderHoldSystem();
		zohSystem.setSamplingInterval(samplingInterval);
		
		// k1
		ConstantSystem k1System = new ConstantSystem(new DoubleMatrix(
				new double[]{1, 0, 0}).transpose());
		
		// k2
		ConstantSystem k2System = new ConstantSystem(new DoubleMatrix(
				new double[][]{{0, 0},{1, 0},{0, 1}}));
		
		// k3
		ConstantSystem k3System = new ConstantSystem(DoubleMatrix.unit(3));
		
		// k4
		ConstantSystem k4System = new ConstantSystem(new DoubleMatrix(
				new double[]{1, 0, 0, 0}).transpose());
		
		SystemBuilder pendulum = new SystemBuilder(pendulumSystem);
		SystemBuilder saturation = new SystemBuilder(saturationSystem);
		SystemBuilder stateFeedback = new SystemBuilder(stateFeedbackSystem);
		SystemBuilder observer = new SystemBuilder(observerSystem);
		SystemBuilder reference = new SystemBuilder(referenceSystem);
		SystemBuilder zoh = new SystemBuilder(zohSystem);
		
		SystemBuilder k1 = new SystemBuilder(k1System);
		SystemBuilder k2 = new SystemBuilder(k2System);
		SystemBuilder k3 = new SystemBuilder(k3System);
		SystemBuilder k4 = new SystemBuilder(k4System);
		
		SystemBuilder inputOutput = k1.add(k2.multiply(pendulum));
		SystemBuilder forward = inputOutput.multiply(saturation).multiply(zoh).multiply(stateFeedback);
		SystemBuilder closedLoop = forward.feedback(observer);
		SystemBuilder all = k3.multiply(closedLoop).multiply(k4).multiply(reference);
		
		return all.getSystemOperator();
		
		
	}
}
