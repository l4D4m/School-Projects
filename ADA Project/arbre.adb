package body Arbre is

   procedure Initialiser_abr(arbre : out T_arbre) is
   begin
        arbre := Null;
   end Initialiser_abr;

   function CreerArbre(vcle : in T_Octet; donnee : in Integer; filsGauche : in T_Arbre; filsDroit : in T_Arbre) return T_Arbre is
   arbre : T_Arbre;
   begin
      Initialiser_abr(arbre);
      arbre := new T_Cellule_abr;
      arbre.all.cle := vcle;
      arbre.all.donnee := donnee;
      arbre.all.filsGauche := filsGauche;
      arbre.all.filsDroit := filsDroit;
      return arbre;
   end CreerArbre;


   function Est_Vide_abr(arbre : in T_arbre) return Boolean is

   begin
      if arbre = Null then
         return True;
      else
         return False;
      end if;
   end Est_Vide_abr;

   procedure Vider_abr(arbre : in out T_Arbre) is
   begin
      arbre := Null;
   end Vider_abr;

   function EstFeuille(noeud : in T_arbre) return Boolean is
   begin
      if noeud.all.filsGauche = Null then
         return True;
      else
         return False;
      end if;
   end EstFeuille;

   function Fusionner(abr1 : in T_Arbre; abr2 : in T_Arbre) return T_Arbre is
      abrRes : T_Arbre;
      freqTotale : Integer;
   begin
      freqTotale := FrequenceRacine(abr1) + FrequenceRacine(abr2);
      abrRes := CreerArbre(0, freqTotale, abr1, abr2);
      return abrRes;
   end Fusionner;


   function FrequenceRacine (arbre : in T_arbre) return integer is
   begin
      return arbre.all.donnee;
   end FrequenceRacine;

   function CaractereRacine(arbre : in T_Arbre) return T_Octet is
   begin
      return arbre.all.cle;
   end CaractereRacine;


   function LeFilsGauche(arbre : in T_Arbre) return T_Arbre is
   begin
      return arbre.all.filsGauche;
   end LeFilsGauche;

   function LeFilsDroit(arbre : in T_Arbre) return T_Arbre is
   begin
      return arbre.all.filsDroit;
   end LeFilsDroit;


   procedure SupprimerFilsGauche(arbre : in out T_Arbre) is
   begin
      Vider_abr(arbre.all.filsGauche);
   end SupprimerFilsGauche;


   procedure SupprimerFilsDroit(arbre : in out T_Arbre) is
   begin
      Vider_abr(arbre.all.filsDroit);
   end SupprimerFilsDroit;

end Arbre;
