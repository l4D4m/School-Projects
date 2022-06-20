with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with LCA;
with binaire; use binaire;
with arbre; use arbre;

package HuffmanInverse is

   -- Construire l'arbre de huffman à partir du code de parcours infixe enregistré dans le sda_bit et les octets enregistreés dans oct_sda
   procedure DecoderArbre(arbre : in out T_arbre; oct_Sda : in OCTETS.T_LCA; Sda_bit : in out BITS.T_LCA ; index : in out Integer);

   -- Produire le code huffman de chaque caractére des feuilles de l'arbre de huffman à partir d'elle et les enregistrer dans un sda_code
   procedure Code_Huff(arbre : in T_arbre ; Sda_code : in out CODES.T_LCA ; Sda_bit : in out BITS.T_LCA);

   -- Trouver l'indice i tq Egale(CODES.La_Donnee(code_sda, OCTETS.La_Donnee(oct_sda,i)), bit_sda)
   function IndiceElementaire(oct_sda : in OCTETS.T_LCA ; code_sda : in CODES.T_LCA ; bit_sda : in BITS.T_LCA) return Integer;

   -- Procedure qui suit l'algorithme de Huffman pour faire la decompression d'un fichier
   procedure Decompresser(NomFichier : Unbounded_String);

end HuffmanInverse;
