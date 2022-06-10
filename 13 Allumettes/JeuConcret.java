package allumettes;

public class JeuConcret implements Jeu {

	private int nbAllumettes;
	private Mode modeArbitre;

	public JeuConcret(int vnbAllumettes, Mode mode) {
		this.nbAllumettes = vnbAllumettes;
		this.modeArbitre = mode;
	}

	@Override
	public int getNombreAllumettes() {
		return this.nbAllumettes;
	}

	public Mode getModeArbitre() {
    	return this.modeArbitre;
    }

	@Override
	public void retirer(int nbPrises) throws CoupInvalideException {
		if (this.nbAllumettes < nbPrises) {
			throw new CoupInvalideException(nbPrises, "(" + ">" + this.nbAllumettes + ")");
		} else if (nbPrises > Jeu.PRISE_MAX) {
			throw new CoupInvalideException(nbPrises, "(" + ">" + Jeu.PRISE_MAX + ")");
		} else if (nbPrises < 1) {
			throw new CoupInvalideException(nbPrises, "(" + "<" + 1 + ")");
		} else {
			this.nbAllumettes -= nbPrises;
		}
	}

}
