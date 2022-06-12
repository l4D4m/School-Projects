#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/wait.h>

void garnir(char zone[], int lg, char motif) {
	int ind;
	for (ind=0; ind<lg; ind++) {
		zone[ind] = motif ;
	}
}

void lister(char zone[], int lg) {
	int ind;
	for (ind=0; ind<lg; ind++) {
		printf("%c",zone[ind]);
	}
	printf("\n");
}

int main(int argc,char *argv[]) {
	int taillepage = sysconf(_SC_PAGESIZE);
	
	// Ouverture d'un fichier
	int fd = open("txt", O_CREAT | O_RDWR | O_TRUNC, 0644);
	if(fd < 0) {
		perror("Erreur ouverture de fichier");
		exit(1);
	}

	char c = 'a';
	char buff[2*taillepage];
	garnir(buff, 2*taillepage, c);

	// Ecriture dans le fichier
	int retWrite = write(fd, buff, 2*taillepage);
	if(retWrite < 0) {
		perror("Erreur écriture dans le fichier");
		exit(2);
	}

	// Coupler le fichier à un segment de taille 2*taillepage
	char* base = mmap(NULL, 2*taillepage, PROT_WRITE | PROT_READ, MAP_SHARED, fd, 0);
	if (base == MAP_FAILED) {
		perror("Erreur mmap");
		exit(3);
	}

	int retFork = fork();
	if(retFork < 0) {
		perror("Erreur fork");
		exit(4);
	}

	// Fils
	if (retFork == 0) {
		sleep(2);
		// Lire dans la zone et afficher
		printf("Affichage de la premiere page par le fils:\n\t"); lister(base, 10);
		printf("Affichage de la deuxieme page par le fils:\n\t"); lister(base + taillepage, 10);
		
		//Remplir la premiere page de 'c'
		garnir(base, taillepage, 'c');
		exit(0);
	}

	// Pere

	//Remplir la deuxieme page de 'b'
	garnir(base + taillepage, taillepage, 'b');
	int retWait = wait(NULL);
	if (retWait == -1) {
		perror("Erreur wait");
		exit(4);
	}
	// Lire dans la zone et afficher
	printf("Affichage de la premiere page par le pere:\n\t"); lister(base, 10);
	exit(0);

}
