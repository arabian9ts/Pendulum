package simulation;

import java.io.IOException;

import org.mklab.nfc.matrix.DoubleMatrix;
import org.mklab.nfc.ode.RungeKuttaFehlberg;
import org.mklab.nfc.util.Pause;
import org.mklab.tool.control.system.SystemOperator;
import org.mklab.tool.control.system.SystemSolver;
import org.mklab.tool.graph.gnuplot.Canvas;
import org.mklab.tool.graph.gnuplot.Gnuplot;

import model.FeedbackCart;

/**
 * 定数ゲインフィードバックを施した台車のステップ応答のシムレーションを行うクラスです
 * @author maeda
 *
 */
public class FeedbackCartSimulation {
	
	/**
	 * シミュレーション計算を実行し、結果をグラフ表示します
	 * @param args コマンドライン引数
	 * @throws InterruptedException 強制終了された場合
	 * @throws IOException IO例外
	 */
	public static void main(String[] args) throws InterruptedException, IOException {
		
		SystemOperator system = FeedbackCart.getInstance();
		
		RungeKuttaFehlberg solver = new RungeKuttaFehlberg();
		solver.setAbsoluteTolerance(1.0E-8);
		new SystemSolver(solver).solveAuto(system, 0.0, 5.0);
		DoubleMatrix t = solver.getTimeSeries();
		DoubleMatrix y = solver.getOutputSeries();
		
		Gnuplot gnuplot = new Gnuplot();
		Canvas canvas = gnuplot.createCanvas();
		
		canvas.setGridVisible(true);
		canvas.plot(t, (DoubleMatrix)y.getRowVector(1), new String[]{"r"}); //$NON-NLS-1$
		Pause.pause();
		gnuplot.close();
		
		System.exit(0);
	}
}
