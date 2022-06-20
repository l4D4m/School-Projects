package Body binaire is
   
   use BITS; use CHARACTERS; use CODES; use OCTETS;

    procedure TranslaterOctet (Un_Octet : in out T_Octet; bit : Integer) is
    begin
        Un_Octet := (Un_Octet * 2) or T_Octet(bit);
    end TranslaterOctet;
   
   
   procedure EcrireDansUnFichier(C : in Stream_Access; sda_bit : in BITS.T_LCA; sliceOctet : in out T_Octet; tailleCodeLu : in out Integer; tailleOctet : in out Integer) is
   begin
      while tailleOctet < 8 and tailleCodeLu < (BITS.Taille(sda_bit)) loop
         tailleOctet := tailleOctet + 1;
         tailleCodeLu := tailleCodeLu + 1;
         TranslaterOctet(sliceOctet, BITS.La_Donnee(sda_bit, tailleCodeLu));
      end loop;
      if tailleOctet = 8 then
         tailleOctet := 0;
         T_Octet'Write(C, sliceOctet);
         sliceOctet := 0;
         if tailleCodeLu < (BITS.Taille(sda_bit)) then
            for i in (tailleCodeLu + 1)..(BITS.Taille(sda_bit)) loop
               tailleOctet := tailleOctet + 1;
               TranslaterOctet(sliceOctet, BITS.La_Donnee(sda_bit, i));
            end loop;
         end if;
      end if;
      tailleCodeLu := 0;
   end EcrireDansUnFichier;
   
   end Binaire ;
