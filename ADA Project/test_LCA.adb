with LCA;
with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;  use Ada.Integer_Text_IO;

procedure test_LCA is

    package INTEGERS is new LCA(T_Cle => Integer, T_Donnee => Integer);
   use INTEGERS;

   -- afficher la sda
   procedure toString_LCA(sda : in INTEGERS.T_LCA) is
      n : Integer;
      m : Integer;
      sda_copie :INTEGERS.T_LCA;
   begin
      sda_copie := sda;
      Put("[");

      while sda_copie /= Null loop
         m := La_Cle(sda_copie);
         Put(m,1);
         Put(" : ");
         n := La_Donnee(sda_copie, m);
         Put(n, 1);
         if sda_copie.all.Suivant /= Null then
            Put(", ");
         end if;
         sda_copie := sda_copie.all.Suivant;
      end loop;
      Put_Line("]");
   end toString_LCA;


   sda : INTEGERS.T_LCA;
   cop : INTEGERS.T_LCA;
begin
   New_Line;
   Put("On initialise la sda :");
   Initialiser(sda);
   New_Line;
   Put_Line("On enregistre le couple (1, 2) dans sda :");
   Enregistrer(sda, 1,2);
   toString_LCA(sda);
   New_Line;
   Put_Line("On enregistre le couple (5, 10) dans sda :");
   Enregistrer(sda, 5,10);
   toString_LCA(sda);
   New_Line;
   Put_Line("On fait une copie de sda :");
   cop := Copier(sda);
   Put("sda_copy = "); toString_LCA(cop);
   Put("sda = "); toString_LCA(sda);
   New_Line;
   Put_Line("On enregistre le couple (11, 3) dans sda :");
   Enregistrer(sda, 11,3);
   Put("sda = "); toString_LCA(sda);
   Put("sda_copy = "); toString_LCA(cop);
   Put_Line("Cela n'a aucun effet sur la copie.");
   New_Line;
   Put_Line("On supprime le couple de la cle 11 de sda :");
   Supprimer(sda, 11);
   Put("sda = "); toString_LCA(sda);
   Put("sda_copy = "); toString_LCA(cop);
   if (Egales(sda, cop)) then
      Put_Line("Les deux sda sont egales.");
   else
      Put_Line("Les deux sda ne sont pas egales!");
   end if;
   New_Line;
   Put_Line("On enregistre le couple (11, 5) dans copie :");
   Enregistrer(cop, 11,5);

   Put("sda = "); toString_LCA(sda);
   Put("sda_copy = "); toString_LCA(cop);
   if (Egales(sda, cop)) then
      Put_Line("Les deux sda sont egales.");
   else
      Put_Line("Les deux sda ne sont pas egales!");
   end if;
   Put("On supprime la cle 10 de sda (inexistante donc exception levee) :");
   supprimer(sda, 10);
end test_LCA;
