with Arbre; use Arbre;
with binaire; use binaire;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;

procedure test_Arbre is

   abr1 : T_Arbre;
   abr2 : T_Arbre;
   res : T_Arbre;
   n : Integer;
begin
   -- On initialise deux arbress
   abr1 := CreerArbre(T_Octet(2),3 ,null, null);
   n := FrequenceRacine(abr1);
   Put_Line("La frequence au sommet de l'arbre 1 est : " & n'Image);

   abr2 := creerArbre(T_Octet(4),6 ,null, null);
   n := FrequenceRacine(abr2);
   Put_Line("La frequence au sommet de l'arbre 2 est : " & n'Image);

   -- On fusionne les deux arbres
   res := fusionner (abr1, abr2);
   n := FrequenceRacine(res);
   Put_Line("La frequence au sommet de l'arbre apres fusion est : " & n'Image);
   n := FrequenceRacine(res.all.filsGauche);
   Put_Line("La frequence au sommet du fils gauche est : " & n'Image);
   n := FrequenceRacine(res.all.filsDroit);
   Put_Line("La frequence au sommet du fils droit est : " & n'Image);
end test_Arbre;
