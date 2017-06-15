package model;

import org.mklab.nfc.matrix.DoubleComplexMatrix;
import org.mklab.nfc.matrix.DoubleMatrix;
import org.mklab.nfc.matrix.Matrix;
import org.mklab.tool.control.system.SystemBuilder;
import org.mklab.tool.control.system.SystemOperator;
import org.mklab.tool.control.system.controller.ContinuousObserver;
import org.mklab.tool.control.system.discontinuous.Saturation;
import org.mklab.tool.control.system.math.ConstantSystem;
import org.mklab.tool.control.system.source.PulseSource;

/**
 * 倒立振子(状態フィードバック+連続時間オブザーバ)による
 * 安定化制御のシステムを生成するクラスです
 * 
 * @author arabian9ts
 *
 */
public class ObserverStateFeedbackPendulum {
	
	/**
	 * 倒立振子(状態フィードバック+連続時間オブザーバ)による
	 * 安定化制御のシステムを返します
	 * 
	 * @param stateFeedbackSystem 状態フィードバック
	 * @return 倒立振子(状態フィードバック+連続時間オブザーバ)による安定化制御のシステム
	 */
	public static SystemOperator getInstance(ConstantSystem stateFeedbackSystem){
		Pendulum pendulumSystem = new Pendulum();
		pendulumSystem.setInitialState(new DoubleMatrix(new double[]{4, 1}));
		
		Saturation saturationSystem = new Saturation(-15, 15);
		
		ContinuousObserver observerSystem = new ContinuousObserver(new LinearPendulum());
		
		Matrix observerPoles = new DoubleComplexMatrix(
				new double[]{-2, -2},
				new double[]{0, 0}).transpose();
		
		observerSystem.setObserverPoles(observerPoles);
		observerSystem.setInitialState(new DoubleMatrix(new double[]{0, 0}).transpose());
		
		PulseSource referenceSystem = new PulseSource(0.1, 10, 50);
		
		// k1
		ConstantSystem k1System = new ConstantSystem(new DoubleMatrix(new double[]{1, 0, 0}).transpose());
		
		// k2
		ConstantSystem k2System = new ConstantSystem(new DoubleMatrix(new double[][]{
			{0, 0},
			{1, 0},
			{0, 1}
			}));
		
		// k3
		ConstantSystem k3System = new ConstantSystem(DoubleMatrix.unit(3));
		
		// k4
		ConstantSystem k4System = new ConstantSystem(new DoubleMatrix(new double[]{1, 0, 0, 0}).transpose());
		
		SystemBuilder pendulum = new SystemBuilder(pendulumSystem);
		SystemBuilder saturation = new SystemBuilder(saturationSystem);
		SystemBuilder stateFeedback = new SystemBuilder(stateFeedbackSystem);
		SystemBuilder observer = new SystemBuilder(observerSystem);
		SystemBuilder reference = new SystemBuilder(referenceSystem);
		
		SystemBuilder k1 = new SystemBuilder(k1System);
		SystemBuilder k2 = new SystemBuilder(k2System);
		SystemBuilder k3 = new SystemBuilder(k3System);
		SystemBuilder k4 = new SystemBuilder(k4System);
		
		SystemBuilder inputOutput = k1.add(k2.multiply(pendulum));
		SystemBuilder forward = inputOutput.multiply(saturation).multiply(stateFeedback);
		SystemBuilder closedLoop = forward.feedback(observer);
		SystemBuilder all = k3.multiply(closedLoop).multiply(k4).multiply(reference);
		
		return all.getSystemOperator();
	}
}
