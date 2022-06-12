#include <stdio.h>    /* entrées sorties */
#include <unistd.h>   /* pimitives de base : fork, ...*/
#include <stdlib.h>   /* exit */
#include <sys/wait.h> /* wait */
#include <string.h>   /* opérations sur les chaines */
#include <fcntl.h>    /* opérations sur les fichiers */

#define NB_FILS 2   //un fils qui lit et son frere qui ecrit

void trait_err() {
    perror("erreur ");
    exit(EXIT_FAILURE);
}



int main() {
    int wstatus;
    for (int fils = 1 ; fils <= NB_FILS ; fils++) {
         
         int retour = fork() ;
 
         /* Bonne pratique : tester systématiquement le retour des appels système */
         if (retour < 0) {   /* échec du fork */
             printf("Erreur fork\n") ;
             /* Convention : s'arrêter avec une valeur > 0 en cas d'erreur */
             exit(1) ;
         }
 
         /* fils */
         if (retour == 0) {
            
            if (fils == 1) { /* fils qui cree le fichier et ecrit les entiers */
                int fd = open("temp", O_WRONLY | O_CREAT | O_TRUNC, 0644);
                if (fd<0) {
                    trait_err();
                }
                for (int i = 1; i<=30; i++) {
                    sleep(1);
                    /* placer la tete en début de fichier tous les 10 entiers */
                    if (i % 10 == 1) { 
                        lseek(fd, 0, SEEK_SET);
                    }
                    int w = write(fd, &i, sizeof(i));
                    if (w < 0) {
                        trait_err();
                    }
                    //sleep(1);
                }
                close(fd);
                exit(EXIT_SUCCESS);
            }
            
            if (fils == 2) { /* fils qui lit le fichier et affiche les entiers */
                 int buff;
                 sleep(1);
                 int fd_r = open("temp", O_RDONLY);
                 if (fd_r<0) {
                     trait_err();
                 }
                 /* affichage des entiers toutes les 10 secondes */
                 for (int affichage = 1; affichage <= 3; affichage++) {
                    sleep(10);
                    printf("debut de l'affichage %d :\n",affichage);
                    /* placer la tete en début de fichier */
                    lseek(fd_r, 0, SEEK_SET);
                    while (read(fd_r, &buff, sizeof(buff)) > 0) {
                        printf("%d\n", buff) ;
                    }
                }
                close(fd_r);
                exit(EXIT_SUCCESS) ;
         } }
 
         /* pere */
         else {
            //Il attend la terminaison de ses deux fils 
         } }
         
         /* attendre la fin des fils */
        for (int fils = 1 ; fils <= NB_FILS ; fils++) {
         /* attendre la fin d'un fils */
         wait(&wstatus);
     }
}
