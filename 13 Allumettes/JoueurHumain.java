package allumettes;

import java.util.Scanner;

public class JoueurHumain implements Strategie {

	private static Scanner scanner = new Scanner(System.in);

	@Override
	public int getPrise(Jeu jeu, Joueur j) {
		System.out.print(j.getNom() + ", combien d'allumettes ? ");
		try {
			String input = scanner.nextLine();
			if (input.equals("triche")) {
				try {
					jeu.retirer(1);
				} catch (CoupInvalideException e) {
					System.out.print("J'ai triché haha"); // ce message ne s'affiche jamais
				}
				System.out.println("[Une allumette en moins, plus que " + jeu.getNombreAllumettes() + ". Chut !]");
				return j.getPrise(jeu);
			}
			int nbPrise  = Integer.parseInt(input);
			return nbPrise;
		} catch (NumberFormatException e) {
			System.out.println("Vous devez donner un entier.");
			return j.getPrise(jeu);
		}
	}

	@Override
	public String getStrategie() {
		return "humain";
	}
}
