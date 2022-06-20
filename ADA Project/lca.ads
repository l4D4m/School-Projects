generic
	type T_Cle is private;
	type T_Donnee is private;

package LCA is
   type T_Cellule;
   type T_LCA is access T_Cellule;
   type T_Cellule is
      record
         Cle : T_Cle;
         Donnee : T_Donnee;
         Suivant : T_LCA;
      end record;
   
   
	-- Initialiser une Sda.  La Sda est vide.
	procedure Initialiser(sda: out T_LCA) with
		Post => Est_Vide (Sda);


	-- Est-ce qu'une Sda est vide ?
	function Est_Vide(Sda : T_LCA) return Boolean;


	-- Obtenir le nombre d'éléments d'une Sda. 
	function Taille (Sda : in T_LCA) return Integer with
		Post => Taille'Result >= 0
			and (Taille'Result = 0) = Est_Vide (Sda);
   

	-- Enregistrer une Donnée associée à une Clé dans une Sda.
	-- Si la clé est déjà présente dans la Sda, sa donnée est changée.
	procedure Enregistrer (Sda : in out T_LCA ; Cle : in T_Cle ; Donnee : in T_Donnee) with
		Post => Cle_Presente (Sda, Cle) and (La_Donnee (Sda, Cle) = Donnee)   -- donnée insérée
				and (not (Cle_Presente (Sda, Cle)'Old) or Taille (Sda) = Taille (Sda)'Old)
				and (Cle_Presente (Sda, Cle)'Old or Taille (Sda) = Taille (Sda)'Old + 1);

	-- Supprimer la Donnée associée à une Clé dans une Sda.
   -- Exception : Cle_Absente_Exception si Clé n'est pas utilisée dans la Sda
	procedure Supprimer (Sda : in out T_LCA ; Cle : in T_Cle) with
		Post =>  Taille (Sda) = Taille (Sda)'Old - 1 -- un élément de moins
			and not Cle_Presente (Sda, Cle);         -- la clé a été supprimée

	-- Savoir si une Clé est présente dans une Sda.
	function Cle_Presente (Sda : in T_LCA ; Cle : in T_Cle) return Boolean;
   
   -- Savoir si une donnee est presente dans une sda.
   function Donnee_Presente (sda : in T_LCA; donnee : in T_Donnee) return Boolean;
   
   -- Savoir si deux sda sont egales
   function Egales(sda1 : in T_LCA; sda2 : in T_LCA) return Boolean;

	-- Obtenir la donnée associée à une Cle dans la Sda.
	-- Exception : Cle_Absente_Exception si Clé n'est pas utilisée dans l'Sda
	function La_Donnee (Sda : in T_LCA ; Cle : in T_Cle) return T_Donnee;
   
   -- Obtenir la premiere Cle dans une sda;
   function La_Cle(sda : in T_LCA ) return T_Cle with
     post => Cle_Presente(sda,La_Cle'Result);

	-- Supprimer tous les éléments d'une Sda.
	procedure Vider (Sda : in out T_LCA) with
		Post => Est_Vide (Sda);
   
   --Copier une sda dans une autre.
   function Copier(Sda : in T_LCA) return T_LCA;
   
   -- Obtenir l'indice de la cle dans la sda
   function IndiceCle(sda : in T_LCA ; cle : T_Cle) return Integer with
     pre => Cle_Presente(sda, cle);

end LCA;
