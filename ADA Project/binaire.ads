with LCA;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
package Binaire is
   
   type T_Octet is mod 256;
   for T_Octet'Size use 8;
   
   -- Liste regroupant les caracteres du texte avec leurs frequences
   package CHARACTERS is new LCA(T_Cle => T_Octet ,T_Donnee => Integer);
   -- Liste des bits indexés de 1 à taille de la liste
   package BITS is new LCA(T_Cle => Integer , T_Donnee=> Integer);
   -- Liste contenant chaque caractere avec son encodage
   package CODES is new LCA(T_Cle => T_Octet , T_Donnee => BITS.T_LCA);
   -- Tableau des caracteres indexes de 1..Taille
   package OCTETS is new LCA(T_Cle => Integer , T_Donnee => T_Octet);
   
   -- Translater un octet par un nouveau bit
   procedure TranslaterOctet (Un_Octet : in out T_Octet; bit : in Integer);
   
   -- Ecrire dans un fichier une suite de bits
   procedure EcrireDansUnFichier(C : in Stream_Access; sda_bit : in BITS.T_LCA; sliceOctet : in out T_Octet; tailleCodeLu : in out Integer; tailleOctet : in out Integer);
   
end Binaire ;
