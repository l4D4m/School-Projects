with Ada.Command_Line, Text_IO, Ada.Strings.Unbounded;
use  Ada.Command_Line, Text_IO, Ada.Strings.Unbounded;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with HuffmanInverse; use HuffmanInverse;
with Ada.IO_Exceptions; use Ada.IO_Exceptions;
procedure Decompresser is

begin

   Decompresser(To_Unbounded_string(Argument(1))) ;

end Decompresser;
