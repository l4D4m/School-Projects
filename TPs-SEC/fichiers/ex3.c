#include <stdio.h>    /* entrées sorties */
#include <unistd.h>   /* pimitives de base : fork, ...*/
#include <stdlib.h>   /* exit */
#include <sys/wait.h> /* wait */
#include <string.h>   /* opérations sur les chaines */
#include <fcntl.h>    /* opérations sur les fichiers */

#define BUFSIZE 32

int main(int argc,char *argv[]) {

    int fd = open("temp.txt", O_WRONLY | O_CREAT | O_TRUNC, 0640);
    
    int ret = fork();
    
    if (ret < 0) {          /*erreur fork*/
        printf("erreur fork");
        exit(1);
    } else if (ret == 0) {  /*fils*/
        int i = 0;
        while(i<10) {
            sleep(5);
            write(fd, "FILS\n", 5);
            i++;
        }
        
    } else {                /*pere*/
        int j = 0;
        while(j<10) {
            write(fd, "PERE\n", 5);
            j++;
            sleep(5);
        } 
    }
    close(fd);
    return 0;
}
