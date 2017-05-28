package simulation;

import org.mklab.nfc.matrix.DoubleMatrix;
import org.mklab.nfc.matrix.Matrix;
import org.mklab.nfc.ode.SolverStopException;
import org.mklab.tool.control.system.SystemBuilder;
import org.mklab.tool.control.system.SystemOperator;
import org.mklab.tool.control.system.continuous.BaseContinuousExplicitDynamicSystem;
import org.mklab.tool.control.system.source.ConstantSource;

import model.Pendulum;

/**
 * 倒立振子のシミュレーションを行う
 * @author maeda
 */
public class FreePendulumSimulation extends BaseContinuousExplicitDynamicSystem {

	public FreePendulumSimulation() {
		super(1, 2, 4);
	}

	public Matrix stateEquation(double t, Matrix x, Matrix u) throws SolverStopException {
		// TODO Auto-generated method stub
		return null;
	}
	

}
