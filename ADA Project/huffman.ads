with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO; use Ada.Text_IO;
with Arbre; use Arbre;
with binaire; use binaire;
with LCA;
package Huffman is

   -- Liste contenant les arbres qui sont en cours de fusion en cle la frequence en racine de l'arbre
   package ARBRES is new LCA(T_Cle=>Integer , T_Donnee=> T_arbre) ;

   -- Procedure qui calcul le codage de Huffman de chaque caractere a partir de l'arbre
   procedure Codage(arbre : in T_arbre ; sdaCode : in out CODES.T_LCA ; sdaBit : in out BITS.T_LCA);

   -- Fonction qui retourne l'indice de l'arbre avec la frequence minimale à la racine
   function IndiceMin(sdaArbre : in ARBRES.T_LCA) return Integer with
     Pre => not ARBRES.Est_Vide(sdaArbre);

   -- Fonction qui fait une fusion à la fois de deux arbres dans une liste des arbres et retourne une nouvelle
   -- liste cette fois-ci de taille decrementée de 1
   function postFusion(sdaArbre : in ARBRES.T_LCA) return ARBRES.T_LCA with
     Pre => not ARBRES.Est_Vide(sdaArbre);

   -- Fonction qui construit l'arbre de Huffman
   function ArbreHuffman(sdaArbre : in ARBRES.T_LCA) return T_Arbre with
     Pre => not ARBRES.Est_Vide(sdaArbre);

   -- Procedure qui fait le parcours infixe de l'arbre de Huffman
   procedure Infixe(arbre : in T_arbre ; sdaBit : in out BITS.T_LCA);

   -- Procedure qui fait la compression d'un fichier
   procedure Compresser(NomFichier : Unbounded_String);


end Huffman;
