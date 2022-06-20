with LCA;
with binaire;                 use binaire;
package Arbre is

   type T_cellule_abr;
   type T_Arbre is access T_cellule_abr;
   type T_Cellule_abr is record
      cle : T_Octet ;        -- caractere stockee dans la cellule si c'est une feuille; 0 sinon
      donnee : Integer;      -- sa frequence; frequence totale resp
      filsGauche : T_arbre;
      filsDroit : T_arbre;
   end record;

   --type T_Octet is mod 2**8; --sur 8 bits
   --for T_Octet'Size use 8;

    -- Initialiser une arbre.  L'arbre est vide.
    procedure Initialiser_abr(arbre : out T_arbre) with
     Post => Est_Vide_abr (arbre);

   -- Creer un arbre initialisé en fonction des parametres
   function CreerArbre(vcle : in T_Octet; donnee : in Integer; filsGauche : in T_Arbre; filsDroit : in T_Arbre) return T_Arbre;

    -- Est-ce qu'un arbre est vide ?
   function Est_Vide_abr(arbre : in T_arbre) return Boolean;

   -- Vider un arbre
   procedure Vider_abr(arbre : in out T_Arbre) with
     post => Est_Vide_abr(arbre);

    -- Est-ce que les fils d'un noeud sont vides
   function EstFeuille(noeud : in T_arbre) return Boolean;

    -- Fusionner deux arbres dans la deuxieme.
   function Fusionner(abr1 : in T_arbre ; abr2 : in T_arbre) return T_Arbre;

   -- Renvoie la donnee a la racine de l'arbre
   function FrequenceRacine(arbre : in T_Arbre) return Integer with
     pre => not Est_Vide_abr(arbre);

   function CaractereRacine(arbre : in T_Arbre) return T_Octet with
     pre => not Est_Vide_abr(arbre);

   -- Recupere le fils gauche d'un arbre
   function LeFilsGauche(arbre : in T_Arbre) return T_Arbre with
     pre => not Est_Vide_abr(arbre);

   -- Recuperer le filss droit de l'arbre
   function LeFilsDroit(arbre : in T_Arbre) return T_Arbre with
     pre => not Est_Vide_abr(arbre);

   -- Supprimer le fils gauche de l'arbre
   procedure SupprimerFilsGauche(arbre : in out T_Arbre) with
     pre => not Est_Vide_abr(arbre);

   procedure SupprimerFilsDroit(arbre : in out T_Arbre) with
     pre => not Est_Vide_abr(arbre);
end Arbre;
