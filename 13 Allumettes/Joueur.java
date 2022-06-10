package allumettes;

public class Joueur {

	private String nom;				// Nom du joueur.
	private Strategie strategie;    // Strategie du joueur

	public Joueur(String vnom, Strategie str) {
		this.nom = vnom;
		this.strategie = str;
	}

	public int getPrise(Jeu jeu) {
		return this.strategie.getPrise(jeu, this);
	}

//	public abstract String getStrategie();

	public String getNom() {
		return this.nom;
	}

	public String getStrategie() {
		return this.strategie.getStrategie();
	}
}
