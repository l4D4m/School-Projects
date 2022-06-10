package allumettes;

public class JoueurRapide implements Strategie {

/*	public JoueurRapide(String vnom) {
		super(vnom);
		// TODO Auto-generated constructor stub
	} */

	@Override
	public int getPrise(Jeu jeu, Joueur j) {
		int nbPrise = Math.min(Jeu.PRISE_MAX, jeu.getNombreAllumettes());
		return nbPrise;
	}

	@Override
	public String getStrategie() {
		String strategie = "Rapide";
		return strategie;
	}

}
