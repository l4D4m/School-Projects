package allumettes;

public class OperationInterditeException extends RuntimeException {

	private String nomTricheur;

	public OperationInterditeException(String vnomTricheur) {
		super();
		this.nomTricheur = vnomTricheur;
	}

	public String getNomTricheur() {
		return this.nomTricheur;
	}
}
