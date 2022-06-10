package allumettes;

public interface Strategie {

	int getPrise(Jeu jeu, Joueur joueur);

	String getStrategie();
}
