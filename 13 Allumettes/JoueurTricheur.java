package allumettes;

public class JoueurTricheur implements Strategie {

/*	public JoueurTricheur(String vnom) {
		super(vnom);
		// TODO Auto-generated constructor stub
	}*/

	@Override
	public int getPrise(Jeu jeu, Joueur j) {
		System.out.println("[Je triche...]");
		while (jeu.getNombreAllumettes() > 2) {
			try {
				jeu.retirer(1);
			} catch (CoupInvalideException e) {
				System.out.println("Hahaha");
			}
		}
		System.out.println("[Allumettes restantes : 2]");
		return 1;
	}

	@Override
	public String getStrategie() {
		String strategie = "tricheur";
		return strategie;
	}

}
