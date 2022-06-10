package allumettes;
import java.util.Arrays;

/** Lance une partie des 13 allumettes en fonction des arguments fournis
 * sur la ligne de commande.
 * @author	Xavier Crégut
 * @version	$Revision: 1.5 $
 */
public class Jouer {

    static final int NB_ALLUMETTES = 13;
    static final int CTE_ARGS = 3;

	/** Lancer une partie. En argument sont donnés les deux joueurs sous
	 * la forme nom@stratégie.
	 * @param args la description des deux joueurs
	 */
	public static void main(String[] args) {
		Mode modeArbitre = Mode.nonConfiant;
		try {
			verifierNombreArguments(args);
			if (args.length == CTE_ARGS) {
				if (!args[0].equals("-confiant")) {
					throw new ConfigurationException("Mode de l'arbitre invalide");
				}
				modeArbitre = Mode.confiant;
				args = Arrays.copyOfRange(args, 1, CTE_ARGS);
			}
			if (!args[0].contains("@") || !args[1].contains("@")) {
				throw new ConfigurationException("Il vous manque un @!");
			}

			// Recuperation des noms et strategies des joueurs
			String[] args1 = args[0].split("@");
			String[] args2 = args[1].split("@");

			// Initialisation des joueurs
			Joueur j1 = initialiserJoueur(args1);
			Joueur j2 = initialiserJoueur(args2);

			//Lancement de la partie
			Arbitre a = new Arbitre(j1, j2);
			Jeu jeu = new JeuConcret(NB_ALLUMETTES, modeArbitre);
			a.arbitrer(jeu);

		} catch (ConfigurationException e) {
			System.out.println();
			System.out.println("Erreur : " + e.getMessage());
			afficherUsage();
			System.exit(1);
		} catch (OperationInterditeException e) {
      System.out.println("Abandon de la partie car " + e.getNomTricheur() + " triche !");
		}
	}

	/*
	 * Initialiser un joueur avec un nom et unes strategie passes en parametres
	 * @param args un tableau de String contenant la strategie et le nom d'un joueur
	 * @return lees joueur ainsi initialiser
	 */
	private static Joueur initialiserJoueur(String[] args) {
		if (args[1].equalsIgnoreCase("Humain")) {
			return new Joueur(args[0], new JoueurHumain());
		} else if (args[1].equalsIgnoreCase("Expert")) {
			return new Joueur(args[0], new JoueurExpert());
		} else if (args[1].equalsIgnoreCase("Rapide")) {
			return new Joueur(args[0], new JoueurRapide());
		} else if (args[1].equalsIgnoreCase("Naif")) {
			return new Joueur(args[0], new JoueurNaif());
		} else if (args[1].equalsIgnoreCase("Tricheur")) {
			return new Joueur(args[0], new JoueurTricheur());
		} else {
			throw new ConfigurationException("Choix de stratégies incorrect !");
		}
	}

	private static void verifierNombreArguments(String[] args) {
		final int nbJoueurs = 2;
		if (args.length < nbJoueurs) {
			throw new ConfigurationException("Trop peu d'arguments : "
					+ args.length);
		}
		if (args.length > nbJoueurs + 1) {
			throw new ConfigurationException("Trop d'arguments : "
					+ args.length);
		}
	}

	/** Afficher des indications sur la manière d'exécuter cette classe. */
	public static void afficherUsage() {
		System.out.println("\n" + "Usage :"
				+ "\n\t" + "java allumettes.Jouer joueur1 joueur2"
				+ "\n\t\t" + "joueur est de la forme nom@stratégie"
				+ "\n\t\t" + "strategie = naif | rapide | expert | humain | tricheur"
				+ "\n"
				+ "\n\t" + "Exemple :"
				+ "\n\t" + "	java allumettes.Jouer Xavier@humain "
					   + "Ordinateur@naif"
				+ "\n"
				);
	}

}
