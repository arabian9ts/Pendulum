package model;

import org.mklab.nfc.matrix.DoubleMatrix;
import org.mklab.nfc.matrix.Matrix;
import org.mklab.nfc.ode.SolverStopException;
import org.mklab.tool.control.system.parameter.Parameter;
import org.mklab.tool.control.system.parameter.SIunit;

/**
 * 倒立振子のモデル
 * @author maeda
 *
 */
public class Pendulum extends org.mklab.tool.control.system.continuous.BaseContinuousExplicitDynamicSystem {
	
	/** 台車の質量 */
	@Parameter(name="M", unit=SIunit.kg, description="台車の質量")
	protected double M = 0.16;
	/** 振子の質量 */
	@Parameter(name="m", unit=SIunit.kg, description="振子の質量")
	protected double m = 0.039;
	/** 振子の慣性モーメント */
	@Parameter(name="J", unit={}, description="振子の慣性モーメント")
	protected double J = 0.045e-4;
	/** 振子の長さ	 */
	@Parameter(name="l", unit=SIunit.m, description="振子の長さ")
	protected double l = 0.121;
	/** 台車の摩擦係数 */
	@Parameter(name="f", unit={SIunit.N, SIunit.m_1, SIunit.s}, description="台車の摩擦係数")
	protected double f = 2.6;
	/** 台車の摩擦係数 */
	@Parameter(name="c", unit={}, description="振子の回転摩擦係数")
	protected double c = 4.210e-4;
	/** 重力加速度 */
	@Parameter(name="g", unit={}, description="重力加速度")
	protected double g = 9.8;
	/** uから入力電圧から台車に働く力 */
	@Parameter(name="a", unit={}, description="uから入力電圧から台車に働く力")
	protected double a = 0.73;
	
	protected double c1 = 0.1;
	protected double c2 = 0.1;
	

	/**
	 * コンストラクタ
	 */
	public Pendulum(){
		super(1, 2, 4);
		setHasDirectFeedthrough(false);
	}

	/**
	 * 状態方程式に基づき状態の微分を返す
	 * @param t 時間
	 * @param x 状態
	 * @param u 入力
	 * @return 状態の微分
	 * @see org.mklab.tool.control.system.continuous.ContinuousExplicitDynamicSystem#stateEquation(double, org.mklab.nfc.matrix.Matrix, org.mklab.nfc.matrix.Matrix)
	 */
	public Matrix stateEquation(double t, Matrix x, Matrix u) {
		double th = ((DoubleMatrix)x).getDoubleElement(1);
		double xxdot = ((DoubleMatrix)x).getDoubleElement(1);
		double thdot = ((DoubleMatrix)x).getDoubleElement(1);
		
		DoubleMatrix dx;
		
		DoubleMatrix K = new DoubleMatrix(new double[][]{
			{this.M + this.m,            this.m*this.l*Math.cos(th)},
			{this.m*this.l*Math.cos(th), this.J + this.m*Math.pow(this.l, 2)}
		});
		
		DoubleMatrix inv_K = K.inverse();

		DoubleMatrix tmp = new DoubleMatrix(new double[][]{
			{this.a*((DoubleMatrix)u).getDoubleElement(1) + this.m*this.l*Math.sin(th)*Math.pow(thdot, 2) - this.f*xxdot},
			{this.m*this.g*this.l*Math.sin(th) - this.c*thdot}	
		});
		
		DoubleMatrix dr_dth = inv_K.multiply(tmp);
		
		/**
		 * dxの計算
		 */
		dx = (DoubleMatrix)x.getRowVectors(3,4).appendDown(dr_dth);
		
		return dx;
	}

	/**
	 * 出力方程式にもとづき出力を返す
	 * @param t 時刻
	 * @param x 状態
	 * @return 出力
	 */
	@Override
	public Matrix outputEquation(double t, Matrix x){
		DoubleMatrix y;
		
		/**
		 * 出力の計算
		 */
		DoubleMatrix C = new DoubleMatrix(new double[][]{
			{this.c1, 0, 0, 0},
			{0, this.c2, 0, 0}
		});
		
		y = C.multiply((DoubleMatrix)x);
				
		return y;
	}
	
}
