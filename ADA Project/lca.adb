with Ada.Text_IO;            use Ada.Text_IO;
with SDA_Exceptions; use SDA_Exceptions;
with Ada.Unchecked_Deallocation;

package body LCA is

	procedure Free is
		new Ada.Unchecked_Deallocation (Object => T_Cellule, Name => T_LCA);


	procedure Initialiser(Sda: out T_LCA) is
	begin
		Sda := null;
	end Initialiser;


	function Est_Vide (Sda : T_LCA) return Boolean is
	begin
		return Sda = null;
	end;


   function Taille (Sda : in T_LCA) return Integer is
      Taille : Integer;
      C : T_LCA;
   begin
      Taille := 0;
      C := Sda;
      while C /= null loop
         Taille := Taille + 1;
         C := C.all.Suivant;
      end loop;
      return Taille;
	end Taille;


	procedure Enregistrer (Sda : in out T_LCA ; Cle : in T_Cle ; Donnee : in T_Donnee) is
	begin
      if Sda = null then
         Sda := new T_Cellule'(Cle, Donnee, null);
      elsif Sda.all.Cle = Cle then
         Sda.all.Donnee := Donnee;
      else
         Enregistrer (Sda.all.Suivant, Cle, Donnee);
      end if;
   end Enregistrer;


	function Cle_Presente (Sda : in T_LCA ; Cle : in T_Cle) return Boolean is
	begin
      if Sda = null then
         return False;
      elsif Sda.all.Cle = Cle then
         return True;
      else
         return Cle_Presente (Sda.all.Suivant, Cle);
      end if;
   end Cle_Presente;

   function Donnee_Presente (sda : in T_LCA; donnee : in T_Donnee) return Boolean is
   begin
      if Sda = null then
         return False;
      elsif Sda.all.Donnee = donnee then
         return True;
      else
         return Donnee_Presente(Sda.all.Suivant, donnee);
      end if;
   end Donnee_Presente;



   function Egales(sda1 : in T_LCA; sda2 : in T_LCA) return Boolean is
   begin
      if sda1.all.Cle /= sda2.all.Cle or sda1.all.Donnee /= sda2.all.Donnee or (sda1.all.Suivant/=null and sda2.all.Suivant=null) or (sda1.all.Suivant=null and sda2.all.Suivant/=null) then
         return False;
      elsif sda1.all.Cle = sda2.all.Cle and sda1.all.Donnee = sda2.all.Donnee and sda1.all.Suivant = null and sda2.all.Suivant = null then
            return True;
      else
         return Egales(sda1.all.Suivant, sda2.all.Suivant);
      end if;
   end Egales;


	function La_Donnee (Sda : in T_LCA ; Cle : in T_Cle) return T_Donnee is
	begin
      if Sda = null then
         raise Cle_Absente_Exception;
      elsif Sda.all.Cle=Cle then
         return Sda.all.Donnee;
      else
         return La_Donnee(Sda.all.suivant,cle);
      end if;
   end La_Donnee;

   function La_Cle(sda : in T_LCA ) return T_Cle is
   begin
      return sda.all.Cle;
   end La_Cle;

   procedure Supprimer (Sda : in out T_LCA ; Cle : in T_Cle) is
      A_Supprimer : T_LCA;
	begin
      if Sda=null then
             raise Cle_Absente_Exception;
        elsif sda.all.Cle=Cle then
            A_Supprimer := Sda;
            Sda := Sda.all.Suivant;
            Free (A_Supprimer);
        else
            Supprimer(Sda.all.Suivant,Cle);
        end if;
	end Supprimer;


	procedure Vider (Sda : in out T_LCA) is
		A_vider : T_LCA;
	begin
      while Sda /= null loop
         A_vider := Sda;
         Sda := Sda.all.Suivant;
         Free (A_vider);
      end loop;
   end Vider;

   function Copier(Sda : in T_LCA) return T_LCA is
      Sda_copie : T_LCA;
      inter : T_LCA;
   begin
      inter := sda;
      Initialiser(Sda_copie);
      if sda = Null then
         Sda_copie := Null;
      else
         while inter /= Null loop
            Enregistrer(Sda_copie, inter.all.Cle,inter.all.Donnee);
            inter := inter.all.suivant;
         end loop;
      end if;
      return Sda_copie;
   end Copier;


   function IndiceCle(sda : in T_LCA ; cle : T_Cle) return Integer is
       indice : Integer;
      sdaCopie : T_LCA;
   begin
      indice := 0;
      sdaCopie := Copier(sda);
      while sdaCopie.all.cle /= cle loop
         indice := indice +1;
         sdaCopie := sdaCopie.all.Suivant;
      end loop;
      return indice;
   end IndiceCle;

end LCA;
