package simulation.pattern1;

import java.io.IOException;

import org.mklab.nfc.matrix.DoubleMatrix;
import org.mklab.nfc.ode.RungeKuttaFehlberg;
import org.mklab.nfc.util.Pause;
import org.mklab.tool.control.system.SystemOperator;
import org.mklab.tool.control.system.SystemSolver;
import org.mklab.tool.graph.gnuplot.Canvas;
import org.mklab.tool.graph.gnuplot.Gnuplot;

import model.pattern1.PolePlaceStateFeedbackPendulum;

/**
 * 倒立振子の極配置に基づく状態フィードバックによる安定化制御のシミュレーションを実行するクラスです
 * 
 * @author arabian9ts
 *
 */
public class PolePlaceStateFeedbackSimulation {
	
	/**
	 * @param args コマンドライン引数
	 * @throws InterruptedException 強制終了された場合
	 * @throws IOException キーボードから入力できない場合
	 */
	public static void main(String[] args) throws InterruptedException, IOException {
		
		SystemOperator system = PolePlaceStateFeedbackPendulum.getInstance();
		RungeKuttaFehlberg solver = new RungeKuttaFehlberg();
		solver.setAbsoluteTolerance(1.0E-8);
		new SystemSolver(solver).solveAuto(system, 0.0, 10.0);
		DoubleMatrix t = solver.getTimeSeries();
		DoubleMatrix y = solver.getOutputSeries();
		
		Gnuplot gnuplot = new Gnuplot();
		Canvas canvas = gnuplot.createCanvas();
		canvas.setGridVisible(true);
		canvas.plot(t, (DoubleMatrix)y.getRowVectors(1, 2), new String[]{"r", "th"});  //$NON-NLS-1$//$NON-NLS-2$
		Pause.pause();
		gnuplot.close();
		
		System.exit(0);
		
	}

}
