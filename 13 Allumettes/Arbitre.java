package allumettes;

public class Arbitre {

	private Joueur joueur1;
	private Joueur joueur2;

	public Arbitre(Joueur j1, Joueur j2) {
		this.joueur1 = j1;
		this.joueur2 = j2;
	}

	private void faireJouer(Jeu jeu, Joueur j) {
		JeuProxy procuration = new JeuProxy((JeuConcret) jeu);
		System.out.println("Allumettes restantes : " + jeu.getNombreAllumettes());
		int nbPrises = 0;
		try {
			if (((JeuConcret) jeu).getModeArbitre() == Mode.confiant) {
				nbPrises = j.getPrise(jeu);
			} else {
				nbPrises = j.getPrise(procuration);
			}
			String pl = nbPrises > 1 ? "s" : "";
			System.out.println(j.getNom() + " prend " + nbPrises + " allumette" + pl + ".");
			jeu.retirer(nbPrises);
			System.out.println();
		} catch (CoupInvalideException e) {
			System.out.println("Impossible ! Nombre invalide : " + nbPrises + " " + e.getProbleme());
			System.out.println();
			this.faireJouer(jeu, j);
		} catch (OperationInterditeException e) {
			throw new OperationInterditeException(j.getNom());
		}
	}

	public void arbitrer(Jeu jeu) {
		boolean b = false;
			while (jeu.getNombreAllumettes() != 0) {
				this.faireJouer(jeu, joueur1);
				b = !b;
				if (jeu.getNombreAllumettes() != 0) {
					this.faireJouer(jeu, joueur2);
					b = !b;
				}
			}
		if (b) {
			System.out.println(joueur1.getNom() + " perd !");
			System.out.println(joueur2.getNom() + " gagne !");
		} else {
			System.out.println(joueur2.getNom() + " perd !");
			System.out.println(joueur1.getNom() + " gagne !");
		}
	}
}
