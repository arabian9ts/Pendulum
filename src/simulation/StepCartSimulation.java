package simulation;

import java.io.IOException;

import org.mklab.nfc.matrix.DoubleMatrix;
import org.mklab.nfc.ode.RungeKuttaFehlberg;
import org.mklab.nfc.util.Pause;
import org.mklab.tool.control.system.SystemOperator;
import org.mklab.tool.control.system.SystemSolver;
import org.mklab.tool.graph.gnuplot.Canvas;
import org.mklab.tool.graph.gnuplot.Gnuplot;

import model.StepCart;

/**
 * 台車のステップ応答のシミュレーションを行うクラスです
 * @author maeda
 *
 */
public class StepCartSimulation {
	
	/**
	 * シミュレーション計算を実行し、結果をグラフ表示します
	 * @param args コマンドライン引数
	 * @throws InterruptedException 強制終了された場合
	 * @throws IOException IO例外
	 */
	public static void main(String[] args) throws InterruptedException, IOException {
		// シミュレーション対象システム
		SystemOperator system = StepCart.getInstance();
		
		// シミュレーションの条件設定と実行
		RungeKuttaFehlberg solver = new RungeKuttaFehlberg();
		solver.setAbsoluteTolerance(1.0E-5);
		new SystemSolver(solver).solveAuto(system, 0.0, 1.0);
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
