with Ada.Command_Line, Text_IO, Ada.Strings.Unbounded;
use  Ada.Command_Line, Text_IO, Ada.Strings.Unbounded;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with Huffman; use Huffman;
with Ada.IO_Exceptions; use Ada.IO_Exceptions;
procedure compresser is

begin

   if Argument_Count = 0 then
      Raise ADA.IO_EXCEPTIONS.NAME_ERROR;
   elsif Argument_Count = 1 then
      Compresser(To_Unbounded_string(Argument(1)));
   end if;

end compresser;
