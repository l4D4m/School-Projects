#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>

int main() {
    
    int wstatus, fils_termine;
    
    printf("%s", ">>>Donnez une commande : ");
    char buf[30] ;
        int ret ;
        ret = scanf("%s" , buf);
    if(ret==1) { 
    int pidFils=fork();
    if (pidFils == -1) {
        printf("Erreur fork\n");
        exit(1);
    }
    if (pidFils == 0) {		/* fils */
            execlp(buf, buf, NULL);
            exit(1);
            
    } else {		/* père */
        fils_termine = wait(&wstatus);
        if (fils_termine < 0) {
          perror("wait ");
          exit(6);
        }
        if (wstatus == 0) {
          printf("SUCCES\n");
          return main();
        } else {
          printf("ECHEC : Commande introuvable !\n");
          return main();
        }
    }
    }
    else {
    printf("\nSalut\n");
    exit(0); }
}
