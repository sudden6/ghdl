--  String table.
--  Copyright (C) 2002, 2003, 2004, 2005 Tristan Gingold
--
--  GHDL is free software; you can redistribute it and/or modify it under
--  the terms of the GNU General Public License as published by the Free
--  Software Foundation; either version 2, or (at your option) any later
--  version.
--
--  GHDL is distributed in the hope that it will be useful, but WITHOUT ANY
--  WARRANTY; without even the implied warranty of MERCHANTABILITY or
--  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
--  for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with GHDL; see the file COPYING.  If not, write to the Free
--  Software Foundation, 59 Temple Place - Suite 330, Boston, MA
--  02111-1307, USA.
with GNAT.Table;

package body Str_Table is
   package String8_Table is new GNAT.Table
     (Table_Index_Type => String8_Id,
      Table_Component_Type => Nat8,
      Table_Low_Bound => Null_String8 + 1,
      Table_Initial => 1024,
      Table_Increment => 100);

   Cur_String8 : String8_Id := 0;

   function Create_String8 return String8_Id is
   begin
      Cur_String8 := String8_Table.Last + 1;
      return Cur_String8;
   end Create_String8;

   procedure Append_String8 (El : Nat8) is
   begin
      String8_Table.Append (El);
   end Append_String8;

   procedure Append_String8_Char (El : Character) is
   begin
      Append_String8 (Character'Pos (El));
   end Append_String8_Char;

   procedure Resize_String8 (Len : Nat32) is
   begin
      String8_Table.Set_Last (Cur_String8 + String8_Id (Len) - 1);
   end Resize_String8;

   function Element_String8 (Id : String8_Id; N : Pos32) return Nat8 is
   begin
      return String8_Table.Table (Id + String8_Id (N - 1));
   end Element_String8;

   procedure Set_Element_String8 (Id : String8_Id; N : Pos32; Val : Nat8) is
   begin
      String8_Table.Table (Id + String8_Id (N - 1)) := Val;
   end Set_Element_String8;

   function Char_String8 (Id : String8_Id; N : Pos32) return Character is
   begin
      return Character'Val (Element_String8 (Id, N));
   end Char_String8;

   function String_String8 (Id : String8_Id; Len : Nat32) return String
   is
      Res : String (1 .. Natural (Len));
   begin
      for I in 1 .. Len loop
         Res (Natural (I)) := Char_String8 (Id, I);
      end loop;
      return Res;
   end String_String8;

   procedure Initialize is
   begin
      String8_Table.Free;
      String8_Table.Init;
   end Initialize;
end Str_Table;
