#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/wait.h>
int main() {
    int wstatus;
    int retour = fork();
    /* Traiter l'erreur du fork */
    if (retour < 0) {
        printf("Erreur fork. \n");
        exit(1);
    }
 
 /* Fils */
 if (retour == 0) {
    /* Ouverture du fichier temp */
    int desc_fils = open("temp", O_RDONLY);
    /* Traitement de l'erreur d'ouverture */
    if (desc_fils < 0) {
        perror("Erreur lors de l'ouverture du fichier ");
        exit(1);
    }
    int contenu;
    sleep(1);
    /* Affichage du contenu du fichier toutes les 10 secondes */
    for (int affichage = 1; affichage <= 3; affichage++) {
        sleep(10);
        /* Placer la tête en début de fichier */
        lseek(desc_fils, 0, SEEK_SET);
        printf("Affichage n°%d:\n", affichage);
        while(read(desc_fils, &contenu, sizeof(contenu))) {
            printf("%d\n", contenu);
        }
 
        if (read(desc_fils, &contenu, sizeof(contenu)) < 0) {
            perror("Erreur lors de la lecture ");
            exit(1);
        }
    }
    
    
    /* Fermeture du fichier */
    if (close(desc_fils) < 0) {
        perror("Erreur lors de la fermeture du fichier ");
        exit(1);
    } 
    exit(EXIT_SUCCESS);
/* Pere */
} else {
    /* Création du fichier temp */
    int desc_pere = open("temp", O_WRONLY|O_CREAT|O_TRUNC, 0644);
    /* Traitement de l'erreur d'ouverture */
    if (desc_pere < 0) {
        perror("Erreur lors de la création du fichier ");
        exit(1);
    }
    for (int entier = 1; entier <= 30; entier++) {
        /* Ecriture de l'entier */ 
        sleep(1);
        /* Placer la tête en début de fichier tous les 10 entiers */
        if (entier % 10 == 1) { 
            lseek(desc_pere, 0, SEEK_SET);
        }
        if (write(desc_pere, &entier, sizeof(entier)) < 0) {
            perror("Erreur lors de l'écriture");
        }
    }
    /* Fermeture du fichier */
    if (close(desc_pere) < 0) {
        perror("Erreur lors de la fermeture du fichier ");
        exit(1);
    } 
}
 
 
 /* Attendre la terminaison du fils */
 wait(&wstatus);
 return EXIT_SUCCESS; }
