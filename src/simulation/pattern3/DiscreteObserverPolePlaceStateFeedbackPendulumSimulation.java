package simulation.pattern3;

import java.io.IOException;

import org.mklab.nfc.matrix.DoubleMatrix;
import org.mklab.nfc.ode.RungeKuttaFehlberg;
import org.mklab.nfc.util.Pause;
import org.mklab.tool.control.system.SystemOperator;
import org.mklab.tool.control.system.SystemSolver;
import org.mklab.tool.graph.gnuplot.Canvas;
import org.mklab.tool.graph.gnuplot.Gnuplot;

import model.pattern3.DiscreteObserverPolePlaceStateFeedbackPendulum;

/**
 * 倒立振子の(極配置に基づく状態フィードバック+離散時間オブザーバ)による安定化制御のシミュレーションを実行するクラスです
 * 
 * @author arabian9ts
 *
 */
public class DiscreteObserverPolePlaceStateFeedbackPendulumSimulation {
	
	/**
	 * @param args コマンドライン引数
	 * @throws InterruptedException 強制終了された場合
	 * @throws IOException キーボードから入力できない場合
	 */
	public static void main(String[] args) throws InterruptedException, IOException {
		
		SystemOperator system = DiscreteObserverPolePlaceStateFeedbackPendulum.getInstance();
		
		RungeKuttaFehlberg solver = new RungeKuttaFehlberg();
		solver.setAbsoluteTolerance(1.0E-8);
		solver.setMinimumSavingInterval(0.1);
		solver.setSaveAtSamplingPoint(true);
		
		new SystemSolver(solver).solveAuto(system, 0.0, 10.0);
		DoubleMatrix t = solver.getTimeSeries();
		DoubleMatrix xc = solver.getContinuousStateSeries();
		DoubleMatrix xd = solver.getDiscreteStateSeries();
		DoubleMatrix y = solver.getOutputSeries();
		
		Gnuplot gnuplot1 = new Gnuplot();
		Gnuplot gnuplot2 = new Gnuplot();
		Gnuplot gnuplot3 = new Gnuplot();
		Canvas canvas1 = gnuplot1.createCanvas();
		Canvas canvas2 = gnuplot2.createCanvas();
		Canvas canvas3 = gnuplot3.createCanvas();
		
		canvas1.setGridVisible(true);
		canvas2.setGridVisible(true);
		canvas3.setGridVisible(true);
		
		canvas1.plot(t, (DoubleMatrix)xc.getRowVectors(1, 2), new String[]{"r", "th"});  //$NON-NLS-1$//$NON-NLS-2$
		canvas2.plot(t, (DoubleMatrix)xd.getRowVectors(1, 2), new String[]{"xd1", "xd2"});  //$NON-NLS-1$//$NON-NLS-2$
		canvas3.plot(t, (DoubleMatrix)y.getRowVector(1), new String[]{"u"}); //$NON-NLS-1$
		
		Pause.pause();
		gnuplot1.close();
		gnuplot2.close();
		gnuplot3.close();
		
		System.exit(0);
		
	}
}
