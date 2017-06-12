package model;
import org.mklab.nfc.matrix.DoubleMatrix;
import org.mklab.nfc.matrix.Matrix;
import org.mklab.tool.control.system.continuous.BaseContinuousExplicitDynamicSystem;
import org.mklab.tool.control.system.parameter.Parameter;
import org.mklab.tool.control.system.parameter.SIunit;


/**
 * 台車を表すクラスです
 * @author maeda
 *
 */
public class Cart extends BaseContinuousExplicitDynamicSystem {
	// パラメータをフィールドとして定義します
	/** 台車の質量 */
	@Parameter(name="M", unit=SIunit.kg, description="台車の質量")
	protected double M = 1.51;
	/** 台車の摩擦係数 */
	@Parameter(name="f", unit={}, description="台車の摩擦係数")
	protected double f = 16.5;
	/** 台車に加わる力の近似直線の傾き */
	protected double a = 0.49;
	
	protected double c1 = 1.0;
	protected double c2 = 1.0;
	
	
	/**
	 * コンストラクタ
	 */
	public Cart(){
		super(1,1,2);
		setHasDirectFeedthrough(false);
	}

	/**
	 * 状態方程式に基づき状態の微分を返します
	 * @see org.mklab.tool.control.system.continuous.ContinuousExplicitDynamicSystem#stateEquation(double, org.mklab.nfc.matrix.Matrix, org.mklab.nfc.matrix.Matrix)
	 */
	public Matrix stateEquation(double t, Matrix x, Matrix u) {
		DoubleMatrix dx;
		
		double r2 = ((DoubleMatrix)x).getDoubleElement(2);
		double _u = ((DoubleMatrix)u).getDoubleElement(1);
		
		
		// 微分の実装
		dx = new DoubleMatrix(new double[][]{
			{r2},
			{this.a*_u/this.M - this.f*r2/this.M}	
		});
		
		return dx;
	}
	
	/**
	 * 出力方程式に基づき出力を返します
	 * @see org.mklab.tool.control.system.continuous.BaseContinuousDynamicSystem#outputEquation(double, org.mklab.nfc.matrix.Matrix)
	 */
	@Override
	public Matrix outputEquation(double t, Matrix x){
		DoubleMatrix y;
		
		// 出力計算の実装
		y = new DoubleMatrix(new double[]{this.c1 * ((DoubleMatrix)x).getDoubleElement(1)});
		
		return y;
	}
	
	
}
