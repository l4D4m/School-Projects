package allumettes;
import org.junit.*;
import static org.junit.Assert.*;

public class StrategieRapideTest {

    //les joueurs du sujet
    private Joueur joueurRapide;

    //les jeux du sujet
    private Jeu jeu1all, jeu2all, jeu3all,jeu13all;

    @Before public void setUp() {
		// Construire les jeux
        jeu1all = new JeuConcret(1, Mode.confiant);
        jeu2all = new JeuConcret(2, Mode.confiant);
        jeu3all = new JeuConcret(3, Mode.confiant);
        jeu13all = new JeuConcret(13, Mode.confiant);

        // Construire un joueur de stratégie rapide
        joueurRapide = new Joueur("Toto", new JoueurRapide());
    }

    @Test public void testerPrise(){
            assertEquals("Prise incorrecte pour un jeu avec 1 allumette restante", 1, joueurRapide.getPrise(jeu1all));
    
            assertEquals("Prise incorrecte pour un jeu avec 2 allumettes restantes", 2, joueurRapide.getPrise(jeu2all));

            assertEquals("Prise incorrecte pour un jeu avec 3 allumettes restantes", 3, joueurRapide.getPrise(jeu3all));

            assertEquals("Prise incorrecte pour un jeu avec 13 allumettes restantes", 3, joueurRapide.getPrise(jeu13all));
    }
}
