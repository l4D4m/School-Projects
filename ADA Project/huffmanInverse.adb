with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO ; use Ada.Text_IO ;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Ada.Streams.Stream_IO ; use Ada.Streams.Stream_IO ;
with LCA;
with arbre ; use arbre ;
with Binaire; use binaire;
with Ada.IO_Exceptions; use Ada.IO_Exceptions;

package body HuffmanInverse is

    procedure DecoderArbre(arbre : in out T_arbre; oct_Sda : in OCTETS.T_LCA; Sda_bit : in out BITS.T_LCA ; index : in out Integer) is
    begin
      if arbre = Null then
        arbre := CreerArbre(0,0,Null,Null) ;
      end if ;
      if BITS.Taille(Sda_bit) >= 1 then
        if BITS.La_Donnee(Sda_bit, BITS.La_Cle(Sda_bit)) = 1 then
          arbre.All.Cle := OCTETS.La_Donnee(oct_Sda,index) ;
          BITS.Supprimer(Sda_bit, BITS.La_Cle(Sda_bit)) ;
          index := index + 1 ;
        else
          BITS.Supprimer(Sda_bit, BITS.La_Cle(Sda_bit)) ;
          DecoderArbre(arbre.All.filsGauche, oct_Sda, Sda_bit, index);
          DecoderArbre(arbre.All.filsDroit, oct_Sda, Sda_bit, index);
        end if ;
      end if ;
    end DecoderArbre ;

    procedure Code_Huff(arbre : in T_arbre ; Sda_code : in out CODES.T_LCA ; Sda_bit : in out BITS.T_LCA) is
       tab_bit : BITS.T_LCA ;
    begin
       BITS.Initialiser(tab_bit) ;
       if Est_Vide_abr(arbre) then
         Null;
       elsif EstFeuille(arbre) then
         CODES.Enregistrer(Sda_code, CaractereRacine(arbre), Sda_bit) ;
       else
         BITS.Enregistrer(Sda_bit, BITS.Taille(Sda_bit) + 1, 0) ;
         tab_bit := BITS.Copier(Sda_bit) ;
         Code_Huff(LeFilsGauche(arbre), Sda_code ,tab_bit);
         BITS.Enregistrer(Sda_bit, BITS.Taille(Sda_bit), 1);
         tab_bit := BITS.Copier(Sda_bit) ;
         Code_Huff(LeFilsDroit(arbre), Sda_code, tab_bit) ;
       end if ;
    end Code_Huff ;

   function IndiceElementaire(oct_sda : in OCTETS.T_LCA ; code_sda : in CODES.T_LCA ; bit_sda : in BITS.T_LCA) return Integer is
       indice : Integer := 0 ;
    begin
       if CODES.Taille(code_sda) = OCTETS.Taille(oct_sda) then
         for i in 1..(CODES.Taille(code_sda)) loop
           if BITS.Egales(CODES.La_Donnee(code_sda,OCTETS.La_Donnee(oct_sda,i)), bit_sda) then
             indice := i ;
           end if ;
         end loop ;
       end if ;
       return indice ;
    end IndiceElementaire ;


   procedure Decompresser(NomFichier : Unbounded_String) is
    arbre : T_arbre ;
    sda_octet : OCTETS.T_LCA ;
    sda_char : CHARACTERS.T_LCA ;
    Sda_bit , Sda_deco : BITS.T_LCA ;
    sda_code : CODES.T_LCA ;
    Octet , oct , bit : T_Octet ;
    exist, fin_deco : Boolean ;
    indice_char , indice_feuille,  fin_pos, debut_parcours, ind_parcours, n_parcours, n_feuille : Integer ;
    n_procedure  , ind_Sda: Integer ;
    Fic , Fic_Huff  : Ada.Streams.Stream_IO.File_Type ;
    S , C : Stream_Access;

   begin
      --Récupérer les differents charactères du texte et la position du symbole fin de fichier '\$'
      OCTETS.Initialiser(Sda_octet) ;
      CHARACTERS.Initialiser(sda_char) ;
      indice_char := 0 ;
      fin_pos := 0 ;
      Open(Fic_Huff, In_File, To_String(NomFichier));
      C:= Stream(Fic_Huff);
      OCTETS.Initialiser(Sda_octet) ;
      loop

         Octet := T_Octet'Input(C);
         exist := CHARACTERS.Cle_Presente(sda_char, Octet);
         --exist := OCTETS.Donnee_Presente(Sda_octet, Octet);
         if not exist then
            if indice_char = 0 then
               fin_pos := Integer(Octet);
            elsif indice_char = fin_pos + 1  then
               --OCTETS.Enregistrer(Sda_octet, indice_char, -1);
               CHARACTERS.Enregistrer(Sda_char, -1, 0);
               --OCTETS.Enregistrer(Sda_octet, indice_char, Octet);
               CHARACTERS.Enregistrer(Sda_char, Octet, 0) ;
            else
               CHARACTERS.Enregistrer(Sda_char, Octet, 0) ;
               --OCTETS.Enregistrer(Sda_octet, indice_char, Octet);
            end if;
            indice_char := indice_char + 1 ;
         end if;
         exit when End_Of_File(Fic_Huff) or exist;
      end loop;


      --Enregistrer ces octets dans une sda de type OCTETS.T_LCA
      OCTETS.Initialiser(Sda_octet) ;
      for i in 1..indice_char loop
         OCTETS.Enregistrer(Sda_octet, i, CHARACTERS.La_Cle(Sda_char));
         CHARACTERS.Supprimer(Sda_char, CHARACTERS.La_Cle(Sda_Char)) ;
      end loop ;

      Close(Fic_Huff) ;
      -- Extraire du fichier compresse le code du parcours infixe et les codes des caracteres du texte
      debut_parcours := 0 ; ind_parcours:= 0 ; n_parcours:= 0 ; n_feuille := 0 ;
      n_procedure := 1 ; indice_feuille := 1;
      fin_deco := False;
      BITS.Initialiser(Sda_bit) ; Initialiser_abr(arbre);
      BITS.Initialiser(Sda_deco) ;
      Create (Fic, Out_File, to_String(NomFichier)(1..(length(NomFichier)-4)) );
      S := Stream(Fic);
      Open(Fic_Huff, In_File, To_String(NomFichier));
      C:= Stream(Fic_Huff);

      while (not End_Of_File(Fic_Huff)) and (not fin_deco) loop
         Octet := T_Octet'Input(C);
         if debut_parcours < indice_char +1 then
            debut_parcours :=  debut_parcours  + 1;
         else
            oct := Octet ;
            for i in  1..8 loop
               bit := oct/128 ;
               oct := oct*2 ;
               if n_feuille < OCTETS.Taille(Sda_octet) then
                  -- Enregistrer le code du parcours infixe
                  BITS.Enregistrer(Sda_bit, BITS.Taille(Sda_bit) + 1 , Integer(bit)) ;
                  if bit = T_Octet(1) then
                     n_feuille := n_feuille + 1 ;
                  end if ;
               else
                  if n_procedure = 1 then
                     -- Construction de l'arbre Huffman du texte compresse
                     DecoderArbre(arbre, Sda_octet, Sda_bit, indice_feuille) ;
                     -- Extraire de l'arbre le code Huffman de chaque caractère
                     BITS.Vider(Sda_bit) ;
                     Code_Huff(arbre, Sda_code, Sda_bit);
                     n_procedure := 0 ;
                  end if ;
                  -- Ecrire le texte decompresse
                  BITS.Enregistrer(Sda_deco, BITS.Taille(Sda_deco) + 1, Integer(bit)) ;
                  ind_sda := IndiceElementaire(Sda_octet, Sda_code ,Sda_deco) ;
                  if ind_sda /= 0 and ind_sda /= (fin_pos + 1) then
                     T_Octet'Write(S, OCTETS.La_Donnee(Sda_octet, ind_sda));
                     BITS.Vider(Sda_deco) ;

                  elsif ind_sda /= 0 and ind_sda = (fin_pos + 1) then
                     fin_deco := True ;
                  end if ;
               end if ;
            end loop ;
         end if ;
      end loop ;
      Close(Fic) ;
      Close(Fic_Huff) ;
   end Decompresser;

end HuffmanInverse ;
