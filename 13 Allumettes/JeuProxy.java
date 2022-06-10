package allumettes;

public class JeuProxy implements Jeu {

	private JeuConcret jeuConcret;

	public JeuProxy(JeuConcret vjeu) {
		this.jeuConcret = vjeu;
	}

	@Override
	public int getNombreAllumettes() {
		return jeuConcret.getNombreAllumettes();
	}

	@Override
	public void retirer(int nbPrises) {
		throw new OperationInterditeException("Triche !!!");
	}

}
