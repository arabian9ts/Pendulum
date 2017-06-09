package analysis;

import org.mklab.tool.control.Ctrm;
import org.mklab.tool.control.LinearSystem;
import org.mklab.tool.control.Obsm;
import org.mklab.nfc.matrix.*;
import model.LinearPendulum;

import model.LinearPendulum;

/**
 * 線形システムの解析を行うクラスです
 * @author maeda
 *
 */
public class Analyzer {
	
	/**
	 * 線形システム
	 */
	private LinearSystem linearSystem;
	
	/**
	 * メインメソッド
	 * @param args コマンドライン引数
	 */
	public static void main(String[] args) {
		Analyzer analyzer = new Analyzer(new LinearPendulum().getLinearSystem());
		
		analyzer.showControllability();
		analyzer.showObservability();
		
	}
	
	/**
	 * コンストラクタ
	 * @param linearSystem 解析対象の線形システム
	 */
	public Analyzer(LinearSystem linearSystem){
		this.linearSystem = linearSystem;
	}
	
	/**
	 * システムの極と安定性判別結果を表示します
	 */
	public void showStability(){
		final DoubleMatrix A = (DoubleMatrix)this.linearSystem.getA();
		final Matrix poles = A.eigenValue();
		
		// 安定性判別結果の表示処理
	}
	
	/**
	 * システムの可制御性行列のランクと可制御性判別結果を表示します
	 */
	public void showControllability(){
		final Matrix A = this.linearSystem.getA();
		final Matrix B = this.linearSystem.getB();
		final DoubleMatrix Nc = (DoubleMatrix)Ctrm.ctrm(A, B);
		
		// システムの可制御性行列のランクと可制御性判別結果を表示します
		System.out.println("rank is "+Nc.rank()); //$NON-NLS-1$
		if(Nc.isFullRank())
			System.out.println("可制御である"); //$NON-NLS-1$
		
	}
	
	/**
	 * システムの可観測性行列のランクと可観測性判別結果を表示します
	 */
	public void showObservability(){
		final Matrix A = this.linearSystem.getA();
		final Matrix C = this.linearSystem.getC();
		final DoubleMatrix No = (DoubleMatrix)Obsm.obsm(A, C);
		
		// システムの可観測性行列のランクと可観測性判別結果を表示します
		System.out.println("rank is "+No.rank()); //$NON-NLS-1$
		if(No.isFullRank())
			System.out.println("可観測である"); //$NON-NLS-1$
	}
	
}
