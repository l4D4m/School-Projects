with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with binaire; use binaire;
with LCA;
with Arbre; use Arbre;

package body Huffman is
   use ARBRES; use BITS; use CHARACTERS; use CODES;


   procedure Codage(arbre : in T_arbre ; sdaCode : in out CODES.T_LCA ; sdaBit : in out BITS.T_LCA) is
   sdaBitCopie : BITS.T_LCA;
   begin
      if EstFeuille(arbre) then
         CODES.Enregistrer(sdaCode, CaractereRacine(arbre), sdaBit);
      else
         BITS.Enregistrer(sdaBit, Taille(sdaBit) + 1, 0);
         sdaBitCopie := Copier(sdaBit);
         Codage(LeFilsGauche(arbre), sdaCode ,sdaBitCopie);
         BITS.Enregistrer(sdaBit, Taille(sdaBit), 1);
         sdaBitCopie := Copier(sdaBit);
         Codage(LeFilsDroit(arbre), sdaCode, sdaBitCopie);
      end if;
   end Codage;

   -- Remplir un tableau des arbres elementaires (feuilles) a partir d'une liste de caracteres
   function RemplirTabArbre(sdaChar : in out CHARACTERS.T_LCA) return ARBRES.T_LCA is
      taille : Integer;
      sdaArbre : ARBRES.T_LCA;
      Octet : T_Octet;
   begin
      taille := 0;
      Initialiser(sdaArbre);
      while not CHARACTERS.Est_Vide(sdaChar) loop
         taille := taille + 1;
         Octet := CHARACTERS.La_Cle(sdaChar);
         ARBRES.Enregistrer(sdaArbre, taille, CreerArbre(Octet, CHARACTERS.La_Donnee(sdaChar, Octet),Null,Null));
         CHARACTERS.Supprimer(sdaChar, Octet);
      end loop;
      return sdaArbre;
   end RemplirTabArbre;


   function IndiceMin(sdaArbre : in ARBRES.T_LCA) return Integer is
      Indice : Integer;
   begin
      Indice := 1;
      for i in 1..Taille(sdaArbre) loop
         if FrequenceRacine(La_Donnee(sdaArbre,i)) <= FrequenceRacine(La_Donnee(sdaArbre,Indice)) then
            Indice := i;
         end if;
      end loop;
      return Indice;
   end IndiceMin;

   function postFusion(sdaArbre : in ARBRES.T_LCA) return ARBRES.T_LCA is
      nouvelleSda : ARBRES.T_LCA;
      indice : Integer;
      arbreFusion : T_arbre;
      i1, i2 : Integer; --Les indices des deux arbres à fusionner
   begin
      i1 := IndiceMin(sdaArbre);
      if i1 = 1 then
         i2 := 2;
      else
         i2 := 1;
      end if;
      for i in 1..Taille(sdaArbre) loop
         if FrequenceRacine(La_Donnee(sdaArbre,i)) < FrequenceRacine(La_Donnee(sdaArbre,i2)) and i/=i1 then
            i2 := i;
         end if;
      end loop;
      Initialiser(nouvelleSda);
      Initialiser_abr(arbreFusion);
      indice := 0;
      for k in 1..Taille(sdaArbre) loop
         if k /= i1 and k /= i2 then
            indice := indice + 1;
            Enregistrer(nouvelleSda,indice,La_Donnee(sdaArbre,k));
         end if;
      end loop;
      arbreFusion := Fusionner(La_Donnee(sdaArbre, i1), La_Donnee(sdaArbre, i2));
      Enregistrer(nouvelleSda, indice+1, arbreFusion);
      return nouvelleSda;
   end postFusion;


   function ArbreHuffman(sdaArbre : in ARBRES.T_LCA) return T_Arbre is
   begin
      if Taille(sdaArbre) = 1 then
         return La_Donnee(sdaArbre,1);
      else
         return ArbreHuffman(postFusion(sdaArbre));
      end if;
   end ArbreHuffman;

   procedure Infixe(arbre : in T_arbre ; sdaBit : in out BITS.T_LCA) is
   begin
      if EstFeuille(arbre) then
         Enregistrer(sdaBit, Taille(sdaBit) + 1, 1);
      else
         Enregistrer(sdaBit, Taille(sdaBit) + 1, 0);
         Infixe(LeFilsGauche(arbre), sdaBit);
         Infixe(LeFilsDroit(arbre), sdaBit);
      end if;
   end Infixe;

   procedure Compresser(NomFichier : Unbounded_String) is
      fic, ficHuff  : Ada.Streams.Stream_IO.File_Type;
      S, C : Stream_Access;
      Octet, sliceOctet : T_Octet;
      tailleCodeLu, tailleOctet : Integer ;
      Char_Tab : CHARACTERS.T_LCA;
      arbre : T_arbre;
      Sda_arbre : ARBRES.T_LCA;
      Sda_bit , bit_Sda1: BITS.T_LCA;
      Sda_code1 , Sda_code2 : CODES.T_LCA;
   begin
      Open(fic, In_File, To_String(NomFichier));
      S := Stream(fic);
      Initialiser(Char_Tab);
      while not End_Of_File(fic) loop
         Octet := T_Octet'Input(S);
         if not Cle_Presente(Char_Tab, Octet) then
            CHARACTERS.Enregistrer(Char_Tab,Octet,1);
         else
            CHARACTERS.Enregistrer(Char_Tab,Octet,La_Donnee(Char_Tab,Octet)+1); -- On enregistre les caracteres et on calcule leurs frequences simultanement
         end if;
      end loop;
      CHARACTERS.Enregistrer(Char_Tab, -1, 0); -- (-1) est la valeur d octet donnÃ©e au symbole \$
      Close(fic);

      -- Remplir le tableau sda_arbre pour construire l'arbre de Huffman
      Sda_arbre := RemplirTabArbre(Char_Tab);

      -- Construire l'arbre de Huffman
      Initialiser_abr(arbre);
      arbre := ArbreHuffman(Sda_arbre);

      -- Parcourir l'arbre de Huffman et calculer le codage de chaque caractere
      BITS.Initialiser(bit_Sda1);
      CODES.Initialiser(Sda_code1);
      Codage(arbre, Sda_code1, bit_Sda1);
      -- sda_code2 va servir pour ecrire les symboles au debut du fichier
      Sda_code2 := CODES.Copier(Sda_code1);

      -- Creer le fichier .hff compressé
      Create(ficHuff, Out_File, to_String(NomFichier) & ".hff");
      C := Stream(ficHuff);
      Open(fic, In_File, to_String(NomFichier));
      S := Stream(fic);


      -- Ecrire les differents caracteres pour pouvoir les interpreter plus tard dans la decompression
      T_Octet'Write(C, T_Octet(CODES.IndiceCle(Sda_code1,-1)));
      Supprimer(Sda_code2, -1);
      while not Est_Vide(Sda_code2) loop
         T_Octet'Write(C, La_Cle(sda_code2));
         -- Ecrire deux fois le dernier octet de la liste des caracteres pour marquer la fin de lecture des symboles
         if CODES.Taille(sda_code2) = 1  then
            T_Octet'Write(C, La_Cle(sda_code2));
         end if ;
         Supprimer(sda_code2, La_Cle(sda_code2)) ;
      end loop ;


      -- Ecrire le code de parcours infixe de l'arbre et du texte
      BITS.Initialiser(Sda_bit);
      Infixe(arbre, Sda_bit);

      sliceOctet := 0; -- Va servir d'ecriture d'un octet tout au long du fichier
      tailleOctet := 0; -- indique la longueur de l'octet, on ecrira l'octet si tailleOctet = 8
      tailleCodeLu := 0; -- Indique la taille du code du Huffman lu du caractere.

      for i in 1..(BITS.Taille(Sda_bit)) loop
         tailleOctet := tailleOctet + 1;
         TranslaterOctet(sliceOctet, BITS.La_Donnee(Sda_bit,i));
         if tailleOctet = 8 then
            tailleOctet := 0;
            T_Octet'Write(C, sliceOctet);
            sliceOctet := 0;
         end if;
      end loop;

      -- Ecriture du texte
      BITS.Initialiser(Sda_bit);
      while not End_Of_File(fic) loop
         Octet := T_Octet'Input(S);
         sda_bit := Copier(CODES.La_Donnee(Sda_code1, Octet));
         EcrireDansUnFichier(C, sda_bit, sliceOctet, tailleCodeLu, tailleOctet);
      end loop;

      -- Ajouter le code Huffman du symbole '\$'
      EcrireDansUnFichier(C , CODES.La_Donnee(Sda_code1, -1), sliceOctet, tailleCodeLu, tailleOctet);

      -- Ajouter des 0 a droite des derniers bits pour complÃ©ter un octet si n'est pas complet
      while tailleOctet < 8 loop
         tailleOctet := tailleOctet + 1;
         sliceOctet := (sliceOctet*2);
      end loop;
      T_Octet'Write(C, sliceOctet);
      tailleOctet := 0;
      sliceOctet := 0;

      -- Fermer les fichiers
      Close(fic);
      Close(ficHuff);
   end Compresser;


end Huffman;
