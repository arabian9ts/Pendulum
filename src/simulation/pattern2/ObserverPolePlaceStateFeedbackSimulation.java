package simulation.pattern2;

import java.io.IOException;

import org.mklab.nfc.matrix.DoubleMatrix;
import org.mklab.nfc.ode.RungeKuttaFehlberg;
import org.mklab.nfc.util.Pause;
import org.mklab.tool.control.system.SystemOperator;
import org.mklab.tool.control.system.SystemSolver;
import org.mklab.tool.graph.gnuplot.Canvas;
import org.mklab.tool.graph.gnuplot.Gnuplot;

import model.pattern2.ObserverPolePlaceStateFeedbackPendulum;

/**
 * 倒立振子の(LQ最適制御に基づく状態フィードバック+連続時間オブザーバ)
 * による安定化制御のシミュレーションを実行するクラスです
 * 
 * @author arabian9ts
 *
 */
public class ObserverPolePlaceStateFeedbackSimulation {

	/**
	 * シミュレーション系sなんを実行し、結果をグラフ表示します
	 * 
	 * @param args コマンドライン引数
	 * @throws InterruptedException 強制終了された場合
	 * @throws IOException キーボードから入力できない場合
	 */
	public static void main(String[] args) throws InterruptedException, IOException {
		
		// シミュレーション対象
		SystemOperator system = ObserverPolePlaceStateFeedbackPendulum.getInstance();
//		SystemOperator system = ObserverLqrStateFeedbackPendulum.getInstance();
		
		
		// シミュレーション条件の設定と実行
		RungeKuttaFehlberg solver = new RungeKuttaFehlberg();
		solver.setAbsoluteTolerance(1.0E-8);
		solver.setMinimumSavingInterval(0.1);
		new SystemSolver(solver).solveAuto(system, 0.0, 20.0);
		DoubleMatrix t = solver.getTimeSeries();
		DoubleMatrix y = solver.getOutputSeries();
		
		// 状態の時間応答のプロット
		Gnuplot gnuplot1 = new Gnuplot();
		Gnuplot gnuplot2 = new Gnuplot();
		Canvas canvas1 = gnuplot1.createCanvas();
		Canvas canvas2 = gnuplot2.createCanvas();
		canvas1.setGridVisible(true);
		canvas2.setGridVisible(true);
		canvas1.plot(t, (DoubleMatrix)y.getRowVectors(2, 3), new String[]{"r", "h"});  //$NON-NLS-1$//$NON-NLS-2$
		canvas2.plot(t, (DoubleMatrix)y.getRowVector(1), new String[]{"u"}); //$NON-NLS-1$
		Pause.pause();
		gnuplot1.close();
		gnuplot2.close();
		
		System.exit(0);
		
	}
	
}
