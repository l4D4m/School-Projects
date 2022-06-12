# include <stdio.h> /* entr  ́e es / sorties */
# include <unistd.h> /* primitives de base : fork , ...*/
# include <stdlib.h> /* exit */
# include <signal.h>   /* traitement des signaux */
# define MAX_PAUSES 10 /* nombre d ’ attentes maximum */

void handler (int num_sig) {
   printf("Reception %d\n", num_sig);
}

int main ( int argc , char * argv []) {
    signal(SIGUSR1, handler) ;
    signal(SIGUSR2, handler) ;
    
    //ensemble des signaux
    sigset_t ens_signaux_1;
    sigset_t ens_signaux_2;                     
    sigemptyset(&ens_signaux_1);      
    sigemptyset(&ens_signaux_2);
          
    //ajout des signaux SIGINT, SIGUSR1
    sigaddset(&ens_signaux_1, SIGINT);   
    sigaddset(&ens_signaux_2, SIGUSR1);
    
    //programme
    sigprocmask(SIG_BLOCK, &ens_signaux_1, NULL);
    sigprocmask(SIG_BLOCK, &ens_signaux_2, NULL);
    sleep(10);
    kill(getpid(), SIGUSR1);
    kill(getpid(), SIGUSR1);   
    sleep(5);
    kill(getpid(), SIGUSR2);
    kill(getpid(), SIGUSR2); 
    sigprocmask(SIG_UNBLOCK, &ens_signaux_2, NULL);
    sleep(10);
    sigprocmask(SIG_UNBLOCK, &ens_signaux_1, NULL);
    printf("Salut\n");
    return EXIT_SUCCESS ;
}
