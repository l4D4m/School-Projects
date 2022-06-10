package allumettes;

import java.util.Random;
public class JoueurNaif implements Strategie {

/*	public JoueurNaif(String vnom) {
		super(vnom);
	} */

	@Override
	public int getPrise(Jeu jeu, Joueur j) {
		Random rand = new Random();
		int nbPrise = 1 + rand.nextInt(Jeu.PRISE_MAX);
		return nbPrise;
	}

	@Override
	public String getStrategie() {
		String strategie = "Naîf";
		return strategie;
	}

}
