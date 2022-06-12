#include <stdio.h>    /* entrées sorties */
#include <unistd.h>   /* pimitives de base : fork, ...*/
#include <stdlib.h>   /* exit */
#include <sys/wait.h> /* wait */
#include <string.h>   /* opérations sur les chaines */
#include <signal.h>
#include <fcntl.h>

int main(int argc, char * argv[]) {

    if (argc != 2) {printf("Arguments insuffusants\n"); return EXIT_FAILURE;}

    int p1[2], p2[2], fils, pidFils;
    char * buff = argv[1];
    
    // Ouverture des pipes
    int ret1 = pipe(p1); 
    if(ret1 < 0) {printf("error pipe\n"); return 1;}
    int ret2 = pipe(p2);
    if(ret2 < 0) {printf("error pipe\n"); return 2;}
    
    for(fils = 1; fils <= 3; fils++) {
        pidFils = fork();
        if (pidFils < 0) {printf("error fork\n"); return 3;}
        if (pidFils == 0) {   /* fils */

            if (fils == 1) {    /* fils no 1 */
                
                close(p1[0]);
                close(p2[0]);
                close(p2[1]);

                if(dup2(p1[1], 1) <0 ) {perror("erreur dup2\n"); return 4;}

                execlp("who","who" ,NULL);
                perror("err who\n");
                return 5;
            } else if (fils == 2) {    /* fils no 2 */

                close(p1[1]);
                close(p2[0]);

                if(dup2(p2[1], 1) <0 ) {perror("erreur dup2\n"); return 6;}
                if(dup2(p1[0],0) <0 ) {perror("erreur dup2\n"); return 7;}
                
                execlp("grep","grep",buff , NULL);
                perror("err grep\n");
                return 8;
            } else if (fils == 3){     /* fils no 3 */
                close(p1[1]);
                close(p1[0]);
                close(p2[1]);
                if(dup2(p2[0],0) <0 ) {printf("erreur dup2\n"); return 9;}
                execlp("wc", "wc", "-l", NULL);
                perror("err wc\n");
                return 10;
            }
        }
    }
    
    /* pere */
    wait(NULL);
    close(p1[1]);
    close(p1[0]);
    close(p2[1]);
    close(p2[0]);
    return 0;
}
