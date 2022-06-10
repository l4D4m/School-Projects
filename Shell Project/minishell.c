#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include "readcmd.h"
#include "readcmd.c"
#include <errno.h>
#include <assert.h>
#include <stdbool.h>
#include <fcntl.h>

/** Minishell
  * @author Adam Bouam
  * @version 1.9
  */
 
typedef struct cmdline cmdline;
enum procEtats{AUTRE,ACTIF, SUS, FIN};
struct bgProc {
    pid_t pid;
    char *cmd;
    enum procEtats etat;
};

typedef struct bgProc bgProc;
pid_t pidFils;
int nbProcBg = 0;
int IDcourantEnBg = 0;
bgProc * procs;

int pidfgCourant;
bool fgCourantFin = false;
char * fgCmd;
char* cmdLance;

/**
 * @brief fait une copie de la commande
 * @param cmd la commande lancée
 */
void copieCmd(cmdline cmd){
    cmdLance = malloc(sizeof(char*));
    assert(cmdLance != NULL);
    int i = 0;
    while(cmd.seq[0][0][i]!='\0') {
        char c = cmd.seq[0][0][i];
        cmdLance[i] = c;
        i++;
    }
    cmdLance[i] = '\0';
}

/*----------------------------------------------GESTION DES PROCESSUS----------------------------------------------*/

/**
 * @brief retourne l'ID d'un processus s'il existe dans la liste procs -1 sinon
 *
 * @param pid pid du processus
 * @return -1 si le processus n'existe pas; son ID si existe
 */
int procExiste(pid_t pid) {
    for (int i = 0; i < nbProcBg; i++) {
        if (procs[i].pid == pid) {
            return i;
        }
        else {continue;}
    }
    return -1;
}


/**
 * @brief Est ce que l'état d'un processus est conforme suite à l'appel d'une commande sur celui-ci
 *
 * @param cmd la commande du processus
 * @param susp indique si ce processus est suspendu ou pas
 * @param id du processus
 * @return true si l'opération est conforme
 * @return false sinon
 */
bool procConforme(char * cmd, bool susp, int id) {
    if (id > nbProcBg || id <= 0 || procs[id -1].etat == AUTRE) {
        printf("[%d] : tâche inexistante\n", id);
        return false;}
    if(susp && procs[id-1].etat != SUS) {
        printf("%s: opération non conforme sur la tâche [%i]\n", cmd, id);
        return false;
    }
    return true;
}

// Suspendre le minishell
void susp() {
    kill(getpid(), SIGSTOP);
}

// Afficher les processus
void listjobs() {
    for(int i = 0; i < nbProcBg; i++) {
        if (procs[i].etat != AUTRE && procs[i].etat != FIN) {
            bool b = (procs[i].etat == SUS);
            printf("[%i]\t%s\t\t\t%s\n", i+1, b ? "Suspendu" : "Actif", procs[i].cmd);
        }
    }
    return;
}

/**
 * @brief Ajouter un processus en arrière plan à notre liste de processus
 * @param vpid pid du processus
 * @param vcmd cmd du processus lancé en arrière plan
 */
void ajouterProc(pid_t vpid, char* vcmd) {
    procs[IDcourantEnBg].pid = vpid;
    procs[IDcourantEnBg].cmd = vcmd;
    procs[IDcourantEnBg].etat = ACTIF;
    nbProcBg++;
    IDcourantEnBg++;
    return;
}

// Retourne le nombre de processus actif en arrère plan
int procBgActif() {
    int s = 0;
    for (int i = 0; i<nbProcBg; i++) {
        if (procs[i].etat == ACTIF) {s++;}
    }
    return s;
}

/**
 * @brief Supprime un processus en arrière plan en mettant son état à AUTRE
 * @param id du processus
 */
void supprimerProc(int id) {
    procs[id].etat = AUTRE;

    // Réinitialiser l'id courant des processus en arrière plan si plus aucun n'est actif
    if(procBgActif() == 0) {
        IDcourantEnBg = 0;
    }
    return;
}

// Reprendre un processus en arrière plan
void background(int id) {
    if(!procConforme("bg", true, id)){return;}
    int ret = kill(procs[id-1].pid, SIGCONT);
    printf("%s\n", procs[id-1].cmd);
    if (ret<0) {
        perror("background ");
    }
    return;
}

// Reprendre un processus en avant plan
void foreground(int id) {
    if(!procConforme("fg", false, id)){return;}

    if(procs[id-1].etat == SUS) {
        kill(procs[id-1].pid, SIGCONT);
    }
    supprimerProc(id-1);

    printf("%s\n", procs[id-1].cmd);
    pidfgCourant = procs[id-1].pid;
    fgCmd = procs[id-1].cmd;
    fgCourantFin = false;
    while(!fgCourantFin) {
        // On attend..
    }
}

/**
 * @brief Arrêter un processus
 *
 * @param id du processus
 */
void stopjob(int id) {
    if(!procConforme("stop", false, id)){return;}
    if (procs[id-1].etat == SUS) {printf("processus [%d] déjà arrêté\n", id); return;}
    int ret = kill(procs[id-1].pid, SIGSTOP);
    return;
    if (ret<0) {
        perror("stopjob ");
    }
}
/*----------------------------------------------------ETATS PROC---------------------------------------------------*/
/**
 * @brief Changer l'état du processus à ACTIF
 *
 * @param pid
 */
void changerACont(pid_t pid) {
    int id = 0;
    while(pid != procs[id].pid && id <= nbProcBg) {id++;}
    procs[id].etat = ACTIF;
    return;
}

/**
 * @brief Changer l'état su processus à FIN s'il a fini normalement AUTRE sinon
 *
 * @param pid
 * @param exitState
 */
void changerAExit (pid_t pid, int exitState) {
    if(pid == pidfgCourant) {
        fgCourantFin = true;
        pidfgCourant = -1;      // On se retrouve dans le shell
        int d = procExiste(pid);
        if (d != -1) {
            procs[d].etat = (exitState == -1 ? AUTRE : FIN);
        }
    }
    else {
        int id = 0;
        while(pid != procs[id].pid && id <= nbProcBg) {id++;}
            procs[id].etat = (exitState == -1 ? AUTRE : FIN);
        return;
    }
}

/**
 * @brief Changer l'état d'un processus à SUS
 *
 * @param pid du proc
 */
void changerASusp(pid_t pid) {
    if(pid == pidfgCourant) {
        fgCourantFin = true;
        pidfgCourant = -1;  // On se retrouve dans le shell
        int d = procExiste(pid);
        if (d != -1) {
            procs[d].etat = SUS;
        }
        else {
            ajouterProc(pid, fgCmd);
            procs[procExiste(pid)].etat = SUS;
        }
    }
    int id = 0;
    while(pid != procs[id].pid && id <= nbProcBg) {id++;}
    procs[id].etat = SUS;
    printf("[%i]\t%s\t\t\t%s\n", id+1,"Suspendu", procs[id].cmd);
    return;
}


/*--------------------------------------------------EXEC DES CMDS--------------------------------------------------*/

// Changer répertoire courant
void cd(char* dir) {
    int ret = chdir(dir);
    if (ret < 0) {
        perror("cd ");
    }
}

// Exécuter une commande
void executer(cmdline cmd) {

        pidFils = fork();
        if (pidFils == -1) { printf("Erreur fork\n"); exit(2);}

        /* fils */
        else if (pidFils == 0) {
            // Bloquer le signal SIGTSTP et SIGINT
            sigset_t block_set;
            sigemptyset(&block_set);
            sigaddset(&block_set, SIGTSTP);
            sigaddset(&block_set, SIGINT);
            sigprocmask(SIG_BLOCK, &block_set, NULL);

            //Redirections
            if (cmd.in || cmd.out) {

                if (cmd.out) {
                    int fd = open(cmd.out, O_WRONLY | O_CREAT | O_TRUNC, 0644);
                    if(dup2(fd, STDOUT_FILENO) == -1) {perror("dup2 "); exit(3);}
                    close(fd);
                }
                if (cmd.in) {
                    int fd = open(cmd.in, O_RDONLY, 0644);
                    if(dup2(fd, STDIN_FILENO) == -1) {perror("dup2 "); exit(4);}
                    close(fd);
                }
            }
            
            // Si commande simple, ne demande pas des tubes 
            if (cmd.seq[1] == NULL) {
                execvp(cmd.seq[0][0], cmd.seq[0]);
                perror("exec ");
                exit(2);
            }

            // Si commande complexe, demande des tubes (pipelines)
            if (cmd.seq[1] != NULL) {
                int p[2];
                int q[2];
                int ret1 = pipe(p); 
                if(ret1 < 0) {perror("Pipe "); exit(6);}
                int ret2 = pipe(q); 
                if(ret2 < 0) {perror("Pipe "); exit(66);}
                // On a besoin d'un autre processus qui va exécuter la première commande
                int filsAux;
                if((filsAux = fork()) == -1) {
                    perror("fork ");
                    exit(7);
                }
                if (filsAux == 0) { /* Fils Auxiliaire */
					
			// Cas de trois commandes
                    if (cmd.seq[2] != NULL) {
                        int filsAux2;
                        // On crée un autre fils auxiliare
                        if((filsAux2 = fork()) == -1) {
                            perror("fork ");
                            exit(75);
                        }
                        if (filsAux2 == 0) {
                            close(p[0]);
                            close(q[0]);
                            close(q[1]);

                            if(dup2(p[1], 1) <0 ) {perror("dup2 "); exit(88);}
                            execvp(cmd.seq[0][0],cmd.seq[0]);
                            perror("exec \n");
                            exit(100);
                        }

                        /* Fils Auxiliare No. 2 */
                        close(p[1]);
                        close(q[0]);
                        if(dup2(q[1], 1) <0 ) {perror("dup2 "); exit(57);}
                        if(dup2(p[0],0) <0 ) {perror("dup2 "); exit(56);}

                        execvp(cmd.seq[1][0],cmd.seq[1]);
                        perror("exec \n");
                        exit(110);
                    }
                    
                    // Cas de deux commandes seulement
                    if (cmd.seq[2] == NULL) {
                        close(p[0]);
                        if(dup2(p[1], STDOUT_FILENO) == -1) {perror("dup2 "); exit(8);}
                        execvp(cmd.seq[0][0], cmd.seq[0]);
                        perror("exec ");
                        exit(9);
                    }
                    
                }
                /* Fils original */
                if (cmd.seq[2] == NULL) {
                	close(p[1]);
		            if (dup2(p[0], STDIN_FILENO) == -1) {perror("dup2 "); exit(88);}
		            execvp(cmd.seq[1][0], cmd.seq[1]);
		            perror("exec ");
		            exit(99);
				}
				
				if (cmd.seq[2] != NULL) {
					close(p[1]);
					close(p[0]);
                    			close(q[1]);
					if (dup2(q[0], STDIN_FILENO) == -1) {perror("dup2 "); exit(88);}
		            execvp(cmd.seq[2][0], cmd.seq[2]);
		            perror("exec ");
		            exit(99);
				}
                
            }
            
        }
        /* Père */
        else {
            if (cmd.backgrounded != NULL) {
                ajouterProc(pidFils, cmdLance);
                printf("[%i] %i\n", IDcourantEnBg, pidFils);
                return;
            } else {
                fgCourantFin = false;
                pidfgCourant = pidFils;
                fgCmd = cmdLance;
                while(!fgCourantFin) {
                    // On attend..
                }
            }
        }
         
}

// Exécuter une commande interne
void executerIntene (cmdline cmd) {
        if (cmd.err) {
            printf("%s\n", cmd.err);
        } else if (strcmp(cmd.seq[0][0], "exit")==0) {
            exit(0);
        } else if (strcmp(cmd.seq[0][0], "bg")==0) {
            background(strtol(cmd.seq[0][1], NULL, 10));
        } else if (strcmp(cmd.seq[0][0], "cd")==0) {
                cd(cmd.seq[0][1]);
        } else if (strcmp(cmd.seq[0][0], "sj")==0) {
            stopjob(strtol(cmd.seq[0][1], NULL, 10));
        } else if (strcmp(cmd.seq[0][0], "lj")==0) {
            listjobs();
        } else if (strcmp(cmd.seq[0][0], "fg")==0) {
            foreground(strtol(cmd.seq[0][1], NULL, 10));
        } else if (strcmp(cmd.seq[0][0], "susp")==0) {
            susp();
        } else {
            executer(cmd);
        }
}

// Vérifier des états des processus en arrière plan, afficher si un processus a fini et le supprimer de la liste
void verifierBgProcs() {
    for (int i =0; i<=nbProcBg; i++) {
        if (procs[i].etat != FIN) {
            continue;
        }
        supprimerProc(i);
        printf("[%i]\t%s\t\t\t%s\n", i+1, "Fini", procs[i].cmd);
    }
    return;
}

/*-----------------------------------------------------SIGNAUX-----------------------------------------------------*/

// Handler SIGCHLD
void handler_sigchld(int signal) {
    int status;
    pid_t pidChange;
    do {
        pidChange = waitpid(-1, &status, WNOHANG|WSTOPPED|WCONTINUED);
        if(pidChange == -1 && errno != ECHILD) {
            perror("waitpid ");
            exit(EXIT_FAILURE);
        }
        else if(pidChange > 0) {
            if(WIFSTOPPED(status)) {
                changerASusp(pidChange);
            }
            else if(WIFCONTINUED(status)) {
                changerACont(pidChange);
            }
            else if(WIFEXITED(status)) {
                changerAExit(pidChange, WEXITSTATUS(status));
            }
            else if(WIFSIGNALED(status)) {
                changerAExit(pidChange, -1);
            }
        }
    } while(pidChange > 0);
}
// Handler SIGTSTP
void sigtstp_handler(int signal) {
    if (pidfgCourant == -1) { /* le minishell */
        return;
    }
    kill(pidfgCourant, SIGSTOP);
    return;
}
// Handler SIGINT
void sigint_handler() {
    if (pidfgCourant == -1) {
        return;
    } else {
        kill(pidfgCourant, SIGKILL);
        return;
    }
}
/*-------------------------------------------------BOUCLE DU SHELL-------------------------------------------------*/
int main() {
    procs = malloc(sizeof(bgProc)*10);
    cmdLance = malloc(sizeof(char)*10);
    signal(SIGCHLD, handler_sigchld);
    signal(SIGTSTP, sigtstp_handler);
    signal(SIGINT, sigint_handler);
    cmdline * commande;
   
    do {
        pidfgCourant = -1; // On associe au minishell (qui est un proc en fg) la valeur de pid -1
        printf("adam@bouam:$ ");
        commande = readcmd();
        if (commande->seq[0] == NULL) {
            continue;    
        }
            copieCmd(*commande);
            executerIntene(*commande);
            verifierBgProcs();
    } while(1);
}
