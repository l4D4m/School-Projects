#include <stdio.h>    /* entrées sorties */
#include <unistd.h>   /* pimitives de base : fork, ...*/
#include <stdlib.h>   /* exit */
#include <sys/wait.h> /* wait */
#include <string.h>   /* opérations sur les chaines */
#include <fcntl.h>    /* opérations sur les fichiers */

#define BUFSIZE 32

void trait_err() {
    perror("erreur ");
    exit(EXIT_FAILURE);
}


int main(int argc,char *argv[]) {
    char buff[BUFSIZE];
    bzero(buff, sizeof(buff)) ;
    
    int fd_s = open(argv[1], O_RDONLY);
    int fd_d = open(argv[2], O_WRONLY | O_CREAT | O_TRUNC, 0640);
    
    if((fd_s < 0) | (fd_d < 0)) {
        trait_err();
    }
    int lus;
    do {
        lus = read(fd_s, buff, BUFSIZE);
        if(lus < 0) {
            trait_err();
        }
        int w = write(fd_d, buff, lus);
        if(w < 0) {
            trait_err();
        }
        bzero(buff, sizeof(buff));
    } while(lus > 0);
    
    close(fd_s);
    close(fd_d);
    return EXIT_SUCCESS;
}
