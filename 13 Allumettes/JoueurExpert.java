package allumettes;


public class JoueurExpert implements Strategie {

	static final int NB_EXPERT = 4;

	@Override
	public int getPrise(Jeu jeu, Joueur j) {
		if ((jeu.getNombreAllumettes() - Jeu.PRISE_MAX) % NB_EXPERT == 1) {
    		return Jeu.PRISE_MAX;
    	}
    	if ((jeu.getNombreAllumettes() - 2) % NB_EXPERT == 1) {
    		return 2;
    	} else {
    		return 1;
    	}
	}

	@Override
	public String getStrategie() {
		// TODO Auto-generated method stub
		return "expert";
	}
}
