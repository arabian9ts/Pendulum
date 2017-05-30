package simulation;

import java.io.IOException;

import org.mklab.nfc.matrix.DoubleMatrix;
import org.mklab.nfc.matrix.Matrix;
import org.mklab.nfc.ode.RungeKuttaFehlberg;
import org.mklab.nfc.ode.SolverStopException;
import org.mklab.nfc.util.Pause;
import org.mklab.tool.control.system.SystemBuilder;
import org.mklab.tool.control.system.SystemOperator;
import org.mklab.tool.control.system.SystemSolver;
import org.mklab.tool.control.system.continuous.BaseContinuousExplicitDynamicSystem;
import org.mklab.tool.control.system.source.ConstantSource;
import org.mklab.tool.graph.gnuplot.Canvas;
import org.mklab.tool.graph.gnuplot.Gnuplot;

import model.FreePendulum;
import model.Pendulum;

/**
 * 倒立振子の自由応答のシミュレーションを行う
 * @author maeda
 */
public class FreePendulumSimulation {
	
	
	/**
	 * シミュレーション計算を実行し、結果をグラフ表示する
	 * @param args コマンドライン引数
	 * @throws InterruptedException キャンセルボタンが押された場合
	 * @throws IOException キーボードから入力できない場合
	 */
	public static void main(String[] args) throws InterruptedException, IOException {
		SystemOperator system = FreePendulum.getInstance();
		
		RungeKuttaFehlberg solver = new RungeKuttaFehlberg();
		solver.setAbsoluteTolerance(1.0E-5);
		System.out.println(system);
		new SystemSolver(solver).solveAuto(system, 0.0, 5.0);
		DoubleMatrix t = solver.getTimeSeries();
		DoubleMatrix y = solver.getOutputSeries();
		
		Gnuplot gnuplot = new Gnuplot();
		Canvas canvas = gnuplot.createCanvas();
		canvas.setGridVisible(true);
		canvas.plot(t, (DoubleMatrix)y.getRowVectors(1,2), new String[]{"r", "th"});  //$NON-NLS-1$//$NON-NLS-2$
		Pause.pause();
		gnuplot.close();
		
		System.exit(0);
	}
	

}
