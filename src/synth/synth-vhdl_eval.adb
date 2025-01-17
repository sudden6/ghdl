--  Operations synthesis.
--  Copyright (C) 2019 Tristan Gingold
--
--  This file is part of GHDL.
--
--  This program is free software: you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation, either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program.  If not, see <gnu.org/licenses>.

with Types; use Types;
with Types_Utils; use Types_Utils;
with Name_Table;

with Grt.Types; use Grt.Types;
with Grt.Vhdl_Types; use Grt.Vhdl_Types;
with Grt.To_Strings;

with Vhdl.Utils;
with Vhdl.Ieee.Std_Logic_1164; use Vhdl.Ieee.Std_Logic_1164;

with Elab.Memtype; use Elab.Memtype;
with Elab.Vhdl_Files;
with Elab.Vhdl_Expr; use Elab.Vhdl_Expr;
with Elab.Vhdl_Types;

with Netlists; use Netlists;

with Synth.Errors; use Synth.Errors;
with Synth.Source; use Synth.Source;
with Synth.Vhdl_Expr; use Synth.Vhdl_Expr;
with Synth.Ieee.Std_Logic_1164; use Synth.Ieee.Std_Logic_1164;
with Synth.Ieee.Numeric_Std; use Synth.Ieee.Numeric_Std;

package body Synth.Vhdl_Eval is
   --  As log2(3m) is directly referenced, the program must be linked with -lm
   --  (math library) on unix systems.
   pragma Linker_Options ("-lm");

   type Tf_Table_2d is array (Boolean, Boolean) of Boolean;

   Tf_2d_And : constant Tf_Table_2d :=
     (False => (others => False),
      True => (True => True, False => False));

   Tf_2d_Nand : constant Tf_Table_2d :=
     (False => (others => True),
      True => (True => False, False => True));

   Tf_2d_Or : constant Tf_Table_2d :=
     (False => (True => True, False => False),
      True => (True => True, False => True));

   Tf_2d_Nor : constant Tf_Table_2d :=
     (False => (True => False, False => True),
      True => (True => False, False => False));

   Tf_2d_Xor : constant Tf_Table_2d :=
     (False => (False => False, True => True),
      True  => (False => True,  True => False));

   Tf_2d_Xnor : constant Tf_Table_2d :=
     (False => (False => True, True => False),
      True  => (False => False,  True => True));

   function Create_Res_Bound (Prev : Type_Acc) return Type_Acc is
   begin
      if Prev.Abound.Dir = Dir_Downto
        and then Prev.Abound.Right = 0
      then
         --  Normalized range
         return Prev;
      end if;

      return Create_Vec_Type_By_Length (Prev.W, Prev.Arr_El);
   end Create_Res_Bound;

   function Eval_Vector_Dyadic (Left, Right : Memtyp;
                                Op : Table_2d;
                                Loc : Syn_Src) return Memtyp
   is
      Res : Memtyp;
   begin
      if Left.Typ.W /= Right.Typ.W then
         Error_Msg_Synth (+Loc, "length of operands mismatch");
         return Null_Memtyp;
      end if;

      Res := Create_Memory (Create_Res_Bound (Left.Typ));
      for I in 1 .. Uns32 (Vec_Length (Res.Typ)) loop
         declare
            Ls : constant Std_Ulogic := Read_Std_Logic (Left.Mem, I - 1);
            Rs : constant Std_Ulogic := Read_Std_Logic (Right.Mem, I - 1);
            V : constant Std_Ulogic := Op (Ls, Rs);
         begin
            Write_Std_Logic (Res.Mem, I - 1, V);
         end;
      end loop;

      return Res;
   end Eval_Vector_Dyadic;

   function Eval_TF_Vector_Dyadic (Left, Right : Memtyp;
                                   Op : Tf_Table_2d;
                                   Loc : Syn_Src) return Memtyp
   is
      Res : Memtyp;
      L, R : Boolean;
   begin
      if Left.Typ.Sz /= Right.Typ.Sz then
         Error_Msg_Synth (+Loc, "length mismatch");
         return Null_Memtyp;
      end if;

      Res := Create_Memory (Left.Typ);
      for I in 1 .. Left.Typ.Sz loop
         L := Boolean'Val (Read_U8 (Left.Mem + (I - 1)));
         R := Boolean'Val (Read_U8 (Right.Mem + (I - 1)));
         Write_U8 (Res.Mem + (I - 1), Boolean'Pos (Op (L, R)));
      end loop;
      return Res;
   end Eval_TF_Vector_Dyadic;

   function Eval_TF_Array_Element (El, Arr : Memtyp;
                                   Op : Tf_Table_2d) return Memtyp
   is
      Res : Memtyp;
      Ve, Va : Boolean;
   begin
      Res := Create_Memory (Arr.Typ);
      Ve := Boolean'Val (Read_U8 (El.Mem));
      for I in 1 .. Arr.Typ.Sz loop
         Va := Boolean'Val (Read_U8 (Arr.Mem + (I - 1)));
         Write_U8 (Res.Mem + (I - 1), Boolean'Pos (Op (Ve, Va)));
      end loop;
      return Res;
   end Eval_TF_Array_Element;

   function Compare (L, R : Memtyp) return Order_Type is
   begin
      case L.Typ.Kind is
         when Type_Bit
           | Type_Logic =>
            declare
               Lv : constant Ghdl_U8 := Read_U8 (L.Mem);
               Rv : constant Ghdl_U8 := Read_U8 (R.Mem);
            begin
               if Lv < Rv then
                  return Less;
               elsif Lv > Rv then
                  return Greater;
               else
                  return Equal;
               end if;
            end;
         when Type_Discrete =>
            pragma Assert (L.Typ.Sz = R.Typ.Sz);
            if L.Typ.Sz = 1 then
               declare
                  Lv : constant Ghdl_U8 := Read_U8 (L.Mem);
                  Rv : constant Ghdl_U8 := Read_U8 (R.Mem);
               begin
                  if Lv < Rv then
                     return Less;
                  elsif Lv > Rv then
                     return Greater;
                  else
                     return Equal;
                  end if;
               end;
            elsif L.Typ.Sz = 4 then
               declare
                  Lv : constant Ghdl_I32 := Read_I32 (L.Mem);
                  Rv : constant Ghdl_I32 := Read_I32 (R.Mem);
               begin
                  if Lv < Rv then
                     return Less;
                  elsif Lv > Rv then
                     return Greater;
                  else
                     return Equal;
                  end if;
               end;
            else
               raise Internal_Error;
            end if;
         when others =>
            raise Internal_Error;
      end case;
   end Compare;

   function Compare_Array (L, R : Memtyp) return Order_Type
   is
      Len : Uns32;
      Res : Order_Type;
   begin
      Len := Uns32'Min (L.Typ.Abound.Len, R.Typ.Abound.Len);
      for I in 1 .. Size_Type (Len) loop
         Res := Compare
           ((L.Typ.Arr_El, L.Mem + (I - 1) * L.Typ.Arr_El.Sz),
            (R.Typ.Arr_El, R.Mem + (I - 1) * R.Typ.Arr_El.Sz));
         if Res /= Equal then
            return Res;
         end if;
      end loop;
      if L.Typ.Abound.Len > Len then
         return Greater;
      end if;
      if R.Typ.Abound.Len > Len then
         return Less;
      end if;
      return Equal;
   end Compare_Array;

   function Execute_Shift_Operator (Left : Memtyp;
                                    Count : Int64;
                                    Op : Iir_Predefined_Shift_Functions)
                                   return Memtyp
   is
      Cnt : Uns32;
      Len : constant Uns32 := Left.Typ.Abound.Len;
      Dir_Left : Boolean;
      P : Size_Type;
      Res : Memtyp;
      E : Ghdl_U8;
   begin
      --  LRM93 7.2.3
      --  That is, if R is 0 or if L is a null array, the return value is L.
      if Count = 0 or else Len = 0 then
         return Left;
      end if;

      case Op is
         when Iir_Predefined_Array_Sll
           | Iir_Predefined_Array_Sla
           | Iir_Predefined_Array_Rol =>
            Dir_Left := True;
         when Iir_Predefined_Array_Srl
           | Iir_Predefined_Array_Sra
           | Iir_Predefined_Array_Ror =>
            Dir_Left := False;
      end case;
      if Count < 0 then
         Cnt := Uns32 (-Count);
         Dir_Left := not Dir_Left;
      else
         Cnt := Uns32 (Count);
      end if;

      case Op is
         when Iir_Predefined_Array_Sll
           | Iir_Predefined_Array_Srl =>
            E := 0;
         when Iir_Predefined_Array_Sla
           | Iir_Predefined_Array_Sra =>
            if Dir_Left then
               E := Read_U8 (Left.Mem + Size_Type (Len - 1));
            else
               E := Read_U8 (Left.Mem);
            end if;
         when Iir_Predefined_Array_Rol
           | Iir_Predefined_Array_Ror =>
            Cnt := Cnt mod Len;
            if not Dir_Left then
               Cnt := (Len - Cnt) mod Len;
            end if;
      end case;

      Res := Create_Memory (Left.Typ);
      P := 0;

      case Op is
         when Iir_Predefined_Array_Sll
           | Iir_Predefined_Array_Srl
           | Iir_Predefined_Array_Sla
           | Iir_Predefined_Array_Sra =>
            if Dir_Left then
               if Cnt < Len then
                  for I in Cnt .. Len - 1 loop
                     Write_U8 (Res.Mem + P,
                               Read_U8 (Left.Mem + Size_Type (I + 1)));
                     P := P + 1;
                  end loop;
               else
                  Cnt := Len;
               end if;
               for I in 0 .. Cnt - 1 loop
                  Write_U8 (Res.Mem + P, E);
                  P := P + 1;
               end loop;
            else
               if Cnt > Len then
                  Cnt := Len;
               end if;
               for I in 0 .. Cnt - 1 loop
                  Write_U8 (Res.Mem + P, E);
                  P := P + 1;
               end loop;
               for I in Cnt .. Len - 1 loop
                  Write_U8 (Res.Mem + P,
                            Read_U8 (Left.Mem + Size_Type (I - Cnt + 1)));
                  P := P + 1;
               end loop;
            end if;
         when Iir_Predefined_Array_Rol
           | Iir_Predefined_Array_Ror =>
            for I in 1 .. Len loop
               Write_U8 (Res.Mem + P,
                         Read_U8 (Left.Mem + Size_Type (Cnt + 1)));
               P := P + 1;
               Cnt := Cnt + 1;
               if Cnt = Len then
                  Cnt := 0;
               end if;
            end loop;
      end case;
      return Res;
   end Execute_Shift_Operator;

   function Get_Static_Ulogic (Op : Memtyp) return Std_Ulogic is
   begin
      pragma Assert (Op.Typ.Kind = Type_Logic);
      return Std_Ulogic'Val (Read_U8 (Op.Mem));
   end Get_Static_Ulogic;

   procedure Check_Integer_Overflow
     (Val : in out Int64; Typ : Type_Acc; Loc : Syn_Src) is
   begin
      pragma Assert (Typ.Kind = Type_Discrete);
      case Typ.Sz is
         when 4 =>
            if Val < -2**31 or Val >= 2**31 then
               Error_Msg_Synth (+Loc, "integer overflow");
               --  Just keep the lower 32bit (and sign extend).
               Val := Int64
                 (To_Int32 (Uns32 (To_Uns64 (Val) and 16#ffff_ffff#)));
            end if;
         when 8 =>
            null;
         when others =>
            raise Internal_Error;
      end case;
   end Check_Integer_Overflow;

   function Create_Memory_Boolean (V : Boolean) return Memtyp is
   begin
      return Create_Memory_U8 (Boolean'Pos (V), Boolean_Type);
   end Create_Memory_Boolean;

   function Eval_Static_Dyadic_Predefined (Imp : Node;
                                           Res_Typ : Type_Acc;
                                           Left : Memtyp;
                                           Right : Memtyp;
                                           Expr : Node) return Memtyp
   is
      Def : constant Iir_Predefined_Functions :=
        Get_Implicit_Definition (Imp);
   begin
      case Def is
         when Iir_Predefined_Error =>
            return Null_Memtyp;

         when Iir_Predefined_Boolean_Xor
            | Iir_Predefined_Bit_Xor =>
            return Create_Memory_U8
              (Boolean'Pos (Boolean'Val (Read_Discrete (Left))
                              xor Boolean'Val (Read_Discrete (Right))),
               Res_Typ);

         when Iir_Predefined_Integer_Plus
           | Iir_Predefined_Physical_Plus =>
            declare
               Res : Int64;
            begin
               Res := Read_Discrete (Left) + Read_Discrete (Right);
               Check_Integer_Overflow (Res, Res_Typ, Expr);
               return Create_Memory_Discrete (Res, Res_Typ);
            end;
         when Iir_Predefined_Integer_Minus
            | Iir_Predefined_Physical_Minus =>
            declare
               Res : Int64;
            begin
               Res := Read_Discrete (Left) - Read_Discrete (Right);
               Check_Integer_Overflow (Res, Res_Typ, Expr);
               return Create_Memory_Discrete (Res, Res_Typ);
            end;
         when Iir_Predefined_Integer_Mul
           | Iir_Predefined_Physical_Integer_Mul
           | Iir_Predefined_Integer_Physical_Mul =>
            declare
               Res : Int64;
            begin
               Res := Read_Discrete (Left) * Read_Discrete (Right);
               Check_Integer_Overflow (Res, Res_Typ, Expr);
               return Create_Memory_Discrete (Res, Res_Typ);
            end;
         when Iir_Predefined_Integer_Div
           | Iir_Predefined_Physical_Physical_Div
           | Iir_Predefined_Physical_Integer_Div =>
            declare
               Res : Int64;
            begin
               Res := Read_Discrete (Left) / Read_Discrete (Right);
               Check_Integer_Overflow (Res, Res_Typ, Expr);
               return Create_Memory_Discrete (Res, Res_Typ);
            end;
         when Iir_Predefined_Integer_Mod =>
            declare
               Res : Int64;
            begin
               Res := Read_Discrete (Left) mod Read_Discrete (Right);
               Check_Integer_Overflow (Res, Res_Typ, Expr);
               return Create_Memory_Discrete (Res, Res_Typ);
            end;
         when Iir_Predefined_Integer_Rem =>
            declare
               Res : Int64;
            begin
               Res := Read_Discrete (Left) rem Read_Discrete (Right);
               Check_Integer_Overflow (Res, Res_Typ, Expr);
               return Create_Memory_Discrete (Res, Res_Typ);
            end;

         when Iir_Predefined_Integer_Exp =>
            return Create_Memory_Discrete
              (Read_Discrete (Left) ** Natural (Read_Discrete (Right)),
               Res_Typ);

         when Iir_Predefined_Integer_Less_Equal
            | Iir_Predefined_Physical_Less_Equal
            | Iir_Predefined_Enum_Less_Equal =>
            return Create_Memory_Boolean
              (Read_Discrete (Left) <= Read_Discrete (Right));
         when Iir_Predefined_Integer_Less
            | Iir_Predefined_Physical_Less
            | Iir_Predefined_Enum_Less =>
            return Create_Memory_Boolean
              (Read_Discrete (Left) < Read_Discrete (Right));
         when Iir_Predefined_Integer_Greater_Equal
            | Iir_Predefined_Physical_Greater_Equal
            | Iir_Predefined_Enum_Greater_Equal =>
            return Create_Memory_Boolean
              (Read_Discrete (Left) >= Read_Discrete (Right));
         when Iir_Predefined_Integer_Greater
            | Iir_Predefined_Physical_Greater
            | Iir_Predefined_Enum_Greater =>
            return Create_Memory_Boolean
              (Read_Discrete (Left) > Read_Discrete (Right));
         when Iir_Predefined_Integer_Equality
            | Iir_Predefined_Physical_Equality
            | Iir_Predefined_Enum_Equality
            | Iir_Predefined_Bit_Match_Equality =>
            return Create_Memory_Boolean
              (Read_Discrete (Left) = Read_Discrete (Right));
         when Iir_Predefined_Integer_Inequality
            | Iir_Predefined_Physical_Inequality
            | Iir_Predefined_Enum_Inequality
            | Iir_Predefined_Bit_Match_Inequality =>
            return Create_Memory_Boolean
              (Read_Discrete (Left) /= Read_Discrete (Right));

         when Iir_Predefined_Physical_Real_Mul =>
            return Create_Memory_Discrete
              (Int64 (Fp64 (Read_Discrete (Left)) * Read_Fp64 (Right)),
               Res_Typ);
         when Iir_Predefined_Real_Physical_Mul =>
            return Create_Memory_Discrete
              (Int64 (Read_Fp64 (Left) * Fp64 (Read_Discrete (Right))),
               Res_Typ);
         when Iir_Predefined_Physical_Real_Div =>
            return Create_Memory_Discrete
              (Int64 (Fp64 (Read_Discrete (Left)) / Read_Fp64 (Right)),
               Res_Typ);

         when Iir_Predefined_Floating_Less =>
            return Create_Memory_U8
              (Boolean'Pos (Read_Fp64 (Left) < Read_Fp64 (Right)),
               Boolean_Type);
         when Iir_Predefined_Floating_Less_Equal =>
            return Create_Memory_U8
              (Boolean'Pos (Read_Fp64 (Left) <= Read_Fp64 (Right)),
               Boolean_Type);
         when Iir_Predefined_Floating_Equality =>
            return Create_Memory_U8
              (Boolean'Pos (Read_Fp64 (Left) = Read_Fp64 (Right)),
               Boolean_Type);
         when Iir_Predefined_Floating_Inequality =>
            return Create_Memory_U8
              (Boolean'Pos (Read_Fp64 (Left) /= Read_Fp64 (Right)),
               Boolean_Type);
         when Iir_Predefined_Floating_Greater =>
            return Create_Memory_U8
              (Boolean'Pos (Read_Fp64 (Left) > Read_Fp64 (Right)),
               Boolean_Type);
         when Iir_Predefined_Floating_Greater_Equal =>
            return Create_Memory_U8
              (Boolean'Pos (Read_Fp64 (Left) >= Read_Fp64 (Right)),
               Boolean_Type);

         when Iir_Predefined_Floating_Plus =>
            return Create_Memory_Fp64 (Read_Fp64 (Left) + Read_Fp64 (Right),
                                       Res_Typ);
         when Iir_Predefined_Floating_Minus =>
            return Create_Memory_Fp64 (Read_Fp64 (Left) - Read_Fp64 (Right),
                                       Res_Typ);
         when Iir_Predefined_Floating_Mul =>
            return Create_Memory_Fp64 (Read_Fp64 (Left) * Read_Fp64 (Right),
                                       Res_Typ);
         when Iir_Predefined_Floating_Div =>
            return Create_Memory_Fp64 (Read_Fp64 (Left) / Read_Fp64 (Right),
                                       Res_Typ);
         when Iir_Predefined_Floating_Exp =>
            return Create_Memory_Fp64
              (Read_Fp64 (Left) ** Integer (Read_Discrete (Right)), Res_Typ);

         when Iir_Predefined_Array_Array_Concat =>
            declare
               L_Len : constant Iir_Index32 :=
                 Iir_Index32 (Get_Bound_Length (Left.Typ));
               R_Len : constant Iir_Index32 :=
                 Iir_Index32 (Get_Bound_Length (Right.Typ));
               Le_Typ : constant Type_Acc := Get_Array_Element (Left.Typ);
               Re_Typ : constant Type_Acc := Get_Array_Element (Right.Typ);
               Bnd : Bound_Type;
               Res_St : Type_Acc;
               Res : Memtyp;
            begin
               Check_Matching_Bounds (Le_Typ, Re_Typ, Expr);
               Bnd := Elab.Vhdl_Types.Create_Bounds_From_Length
                 (Get_Uarray_Index (Res_Typ).Drange, L_Len + R_Len);
               Res_St := Create_Onedimensional_Array_Subtype
                 (Res_Typ, Bnd, Le_Typ);
               Res := Create_Memory (Res_St);
               if Left.Typ.Sz > 0 then
                  Copy_Memory (Res.Mem, Left.Mem, Left.Typ.Sz);
               end if;
               if Right.Typ.Sz > 0 then
                  Copy_Memory (Res.Mem + Left.Typ.Sz, Right.Mem, Right.Typ.Sz);
               end if;
               return Res;
            end;
         when Iir_Predefined_Element_Array_Concat =>
            declare
               Rlen : constant Iir_Index32 :=
                 Iir_Index32 (Get_Bound_Length (Right.Typ));
               Re_Typ : constant Type_Acc := Get_Array_Element (Right.Typ);
               Bnd : Bound_Type;
               Res_St : Type_Acc;
               Res : Memtyp;
            begin
               Check_Matching_Bounds (Left.Typ, Re_Typ, Expr);
               Bnd := Elab.Vhdl_Types.Create_Bounds_From_Length
                 (Get_Uarray_Index (Res_Typ).Drange, 1 + Rlen);
               Res_St := Create_Onedimensional_Array_Subtype
                 (Res_Typ, Bnd, Re_Typ);
               Res := Create_Memory (Res_St);
               Copy_Memory (Res.Mem, Left.Mem, Left.Typ.Sz);
               Copy_Memory (Res.Mem + Left.Typ.Sz,
                            Right.Mem, Right.Typ.Sz);
               return Res;
            end;
         when Iir_Predefined_Array_Element_Concat =>
            declare
               Llen : constant Iir_Index32 :=
                 Iir_Index32 (Get_Bound_Length (Left.Typ));
               Le_Typ : constant Type_Acc := Get_Array_Element (Left.Typ);
               Bnd : Bound_Type;
               Res_St : Type_Acc;
               Res : Memtyp;
            begin
               Check_Matching_Bounds (Le_Typ, Right.Typ, Expr);
               Bnd := Elab.Vhdl_Types.Create_Bounds_From_Length
                 (Get_Uarray_Index (Res_Typ).Drange, Llen + 1);
               Res_St := Create_Onedimensional_Array_Subtype
                 (Res_Typ, Bnd, Le_Typ);
               Res := Create_Memory (Res_St);
               Copy_Memory (Res.Mem, Left.Mem, Left.Typ.Sz);
               Copy_Memory (Res.Mem + Left.Typ.Sz,
                            Right.Mem, Right.Typ.Sz);
               return Res;
            end;
         when Iir_Predefined_Element_Element_Concat =>
            declare
               El_Typ : constant Type_Acc := Left.Typ;
               Bnd : Bound_Type;
               Res_St : Type_Acc;
               Res : Memtyp;
            begin
               Check_Matching_Bounds (Left.Typ, Right.Typ, Expr);
               Bnd := Elab.Vhdl_Types.Create_Bounds_From_Length
                 (Get_Uarray_Index (Res_Typ).Drange, 2);
               Res_St := Create_Onedimensional_Array_Subtype
                 (Res_Typ, Bnd, El_Typ);
               Res := Create_Memory (Res_St);
               Copy_Memory (Res.Mem, Left.Mem, El_Typ.Sz);
               Copy_Memory (Res.Mem + El_Typ.Sz,
                            Right.Mem, El_Typ.Sz);
               return Res;
            end;

         when Iir_Predefined_Array_Equality
            | Iir_Predefined_Record_Equality
            | Iir_Predefined_Bit_Array_Match_Equality =>
            return Create_Memory_Boolean (Is_Equal (Left, Right));
         when Iir_Predefined_Array_Inequality
            | Iir_Predefined_Record_Inequality
            | Iir_Predefined_Bit_Array_Match_Inequality =>
            return Create_Memory_Boolean (not Is_Equal (Left, Right));

         when Iir_Predefined_Access_Equality =>
            return Create_Memory_Boolean
              (Read_Access (Left) = Read_Access (Right));
         when Iir_Predefined_Access_Inequality =>
            return Create_Memory_Boolean
              (Read_Access (Left) /= Read_Access (Right));

         when Iir_Predefined_Array_Less =>
            return Create_Memory_Boolean
              (Compare_Array (Left, Right) = Less);
         when Iir_Predefined_Array_Less_Equal =>
            return Create_Memory_Boolean
              (Compare_Array (Left, Right) <= Equal);
         when Iir_Predefined_Array_Greater =>
            return Create_Memory_Boolean
              (Compare_Array (Left, Right) = Greater);
         when Iir_Predefined_Array_Greater_Equal =>
            return Create_Memory_Boolean
              (Compare_Array (Left, Right) >= Equal);

         when Iir_Predefined_Array_Maximum =>
            --  IEEE 1076-2008 5.3.2.4 Predefined operations on array types
            if Compare_Array (Left, Right) = Less then
               return Right;
            else
               return Left;
            end if;
         when Iir_Predefined_Array_Minimum =>
            --  IEEE 1076-2008 5.3.2.4 Predefined operations on array types
            if Compare_Array (Left, Right) = Less then
               return Left;
            else
               return Right;
            end if;

         when Iir_Predefined_Array_Sll =>
            return Execute_Shift_Operator (Left, Read_Discrete (Right), Def);

         when Iir_Predefined_TF_Array_And =>
            return Eval_TF_Vector_Dyadic (Left, Right, Tf_2d_And, Expr);
         when Iir_Predefined_TF_Array_Or =>
            return Eval_TF_Vector_Dyadic (Left, Right, Tf_2d_Or, Expr);
         when Iir_Predefined_TF_Array_Xor =>
            return Eval_TF_Vector_Dyadic (Left, Right, Tf_2d_Xor, Expr);
         when Iir_Predefined_TF_Array_Nand =>
            return Eval_TF_Vector_Dyadic (Left, Right, Tf_2d_Nand, Expr);
         when Iir_Predefined_TF_Array_Nor =>
            return Eval_TF_Vector_Dyadic (Left, Right, Tf_2d_Nor, Expr);
         when Iir_Predefined_TF_Array_Xnor =>
            return Eval_TF_Vector_Dyadic (Left, Right, Tf_2d_Xnor, Expr);

         when Iir_Predefined_TF_Element_Array_Or =>
            return Eval_TF_Array_Element (Left, Right, Tf_2d_Or);
         when Iir_Predefined_TF_Array_Element_Or =>
            return Eval_TF_Array_Element (Right, Left, Tf_2d_Or);

         when Iir_Predefined_TF_Element_Array_Nor =>
            return Eval_TF_Array_Element (Left, Right, Tf_2d_Nor);
         when Iir_Predefined_TF_Array_Element_Nor =>
            return Eval_TF_Array_Element (Right, Left, Tf_2d_Nor);

         when Iir_Predefined_TF_Element_Array_And =>
            return Eval_TF_Array_Element (Left, Right, Tf_2d_And);
         when Iir_Predefined_TF_Array_Element_And =>
            return Eval_TF_Array_Element (Right, Left, Tf_2d_And);

         when Iir_Predefined_TF_Element_Array_Nand =>
            return Eval_TF_Array_Element (Left, Right, Tf_2d_Nand);
         when Iir_Predefined_TF_Array_Element_Nand =>
            return Eval_TF_Array_Element (Right, Left, Tf_2d_Nand);

         when Iir_Predefined_TF_Element_Array_Xor =>
            return Eval_TF_Array_Element (Left, Right, Tf_2d_Xor);
         when Iir_Predefined_TF_Array_Element_Xor =>
            return Eval_TF_Array_Element (Right, Left, Tf_2d_Xor);

         when Iir_Predefined_TF_Element_Array_Xnor =>
            return Eval_TF_Array_Element (Left, Right, Tf_2d_Xnor);
         when Iir_Predefined_TF_Array_Element_Xnor =>
            return Eval_TF_Array_Element (Right, Left, Tf_2d_Xnor);

         when Iir_Predefined_Ieee_1164_Vector_And
           | Iir_Predefined_Ieee_Numeric_Std_And_Uns_Uns
           | Iir_Predefined_Ieee_Numeric_Std_And_Sgn_Sgn =>
            return Eval_Vector_Dyadic (Left, Right, And_Table, Expr);

         when Iir_Predefined_Ieee_1164_Vector_Or
           | Iir_Predefined_Ieee_Numeric_Std_Or_Uns_Uns
           | Iir_Predefined_Ieee_Numeric_Std_Or_Sgn_Sgn =>
            return Eval_Vector_Dyadic (Left, Right, Or_Table, Expr);

         when Iir_Predefined_Ieee_1164_Vector_Xor
           | Iir_Predefined_Ieee_Numeric_Std_Xor_Uns_Uns
           | Iir_Predefined_Ieee_Numeric_Std_Xor_Sgn_Sgn =>
            return Eval_Vector_Dyadic (Left, Right, Xor_Table, Expr);

         when Iir_Predefined_Ieee_1164_Scalar_Or =>
            return Create_Memory_U8
              (Std_Ulogic'Pos (Or_Table (Get_Static_Ulogic (Left),
                                         Get_Static_Ulogic (Right))),
               Res_Typ);

         when Iir_Predefined_Ieee_1164_Scalar_And =>
            return Create_Memory_U8
              (Std_Ulogic'Pos (And_Table (Get_Static_Ulogic (Left),
                                          Get_Static_Ulogic (Right))),
               Res_Typ);

         when Iir_Predefined_Ieee_1164_Scalar_Xor =>
            return Create_Memory_U8
              (Std_Ulogic'Pos (Xor_Table (Get_Static_Ulogic (Left),
                                          Get_Static_Ulogic (Right))),
               Res_Typ);

         when Iir_Predefined_Ieee_Numeric_Std_Eq_Uns_Uns =>
            declare
               Res : Boolean;
            begin
               Res := Compare_Uns_Uns (Left, Right, Greater, Expr) = Equal;
               return Create_Memory_U8 (Boolean'Pos (Res), Res_Typ);
            end;
         when Iir_Predefined_Ieee_Numeric_Std_Ne_Uns_Uns =>
            declare
               Res : Boolean;
            begin
               Res := Compare_Uns_Uns (Left, Right, Greater, Expr) /= Equal;
               return Create_Memory_U8 (Boolean'Pos (Res), Res_Typ);
            end;
         when Iir_Predefined_Ieee_Numeric_Std_Ne_Uns_Nat =>
            declare
               Res : Boolean;
            begin
               Res := Compare_Uns_Nat (Left, Right, Greater, Expr) /= Equal;
               return Create_Memory_U8 (Boolean'Pos (Res), Res_Typ);
            end;
         when Iir_Predefined_Ieee_Numeric_Std_Eq_Sgn_Sgn =>
            declare
               Res : Boolean;
            begin
               Res := Compare_Sgn_Sgn (Left, Right, Greater, Expr) = Equal;
               return Create_Memory_U8 (Boolean'Pos (Res), Res_Typ);
            end;
         when Iir_Predefined_Ieee_Numeric_Std_Eq_Uns_Nat =>
            declare
               Res : Boolean;
            begin
               Res := Compare_Uns_Nat (Left, Right, Greater, Expr) = Equal;
               return Create_Memory_U8 (Boolean'Pos (Res), Res_Typ);
            end;
         when Iir_Predefined_Ieee_Numeric_Std_Eq_Sgn_Int =>
            declare
               Res : Boolean;
            begin
               Res := Compare_Sgn_Int (Left, Right, Greater, Expr) = Equal;
               return Create_Memory_U8 (Boolean'Pos (Res), Res_Typ);
            end;

         when Iir_Predefined_Ieee_Numeric_Std_Gt_Uns_Uns =>
            declare
               Res : Boolean;
            begin
               Res := Compare_Uns_Uns (Left, Right, Less, Expr) = Greater;
               return Create_Memory_U8 (Boolean'Pos (Res), Res_Typ);
            end;
         when Iir_Predefined_Ieee_Numeric_Std_Gt_Sgn_Sgn =>
            declare
               Res : Boolean;
            begin
               Res := Compare_Sgn_Sgn (Left, Right, Less, Expr) = Greater;
               return Create_Memory_U8 (Boolean'Pos (Res), Res_Typ);
            end;
         when Iir_Predefined_Ieee_Numeric_Std_Gt_Nat_Uns =>
            declare
               Res : Boolean;
            begin
               Res := Compare_Nat_Uns (Left, Right, Less, Expr) = Greater;
               return Create_Memory_U8 (Boolean'Pos (Res), Res_Typ);
            end;
         when Iir_Predefined_Ieee_Numeric_Std_Gt_Uns_Nat =>
            declare
               Res : Boolean;
            begin
               Res := Compare_Uns_Nat (Left, Right, Less, Expr) = Greater;
               return Create_Memory_U8 (Boolean'Pos (Res), Res_Typ);
            end;

         when Iir_Predefined_Ieee_Numeric_Std_Ge_Uns_Uns =>
            declare
               Res : Boolean;
            begin
               Res := Compare_Uns_Uns (Left, Right, Greater, Expr) >= Equal;
               return Create_Memory_U8 (Boolean'Pos (Res), Res_Typ);
            end;
         when Iir_Predefined_Ieee_Numeric_Std_Ge_Sgn_Sgn =>
            declare
               Res : Boolean;
            begin
               Res := Compare_Sgn_Sgn (Left, Right, Less, Expr) >= Equal;
               return Create_Memory_U8 (Boolean'Pos (Res), Res_Typ);
            end;
         when Iir_Predefined_Ieee_Numeric_Std_Ge_Uns_Nat =>
            declare
               Res : Boolean;
            begin
               Res := Compare_Uns_Nat (Left, Right, Less, Expr) >= Equal;
               return Create_Memory_U8 (Boolean'Pos (Res), Res_Typ);
            end;

         when Iir_Predefined_Ieee_Numeric_Std_Le_Uns_Uns =>
            declare
               Res : Boolean;
            begin
               Res := Compare_Uns_Uns (Left, Right, Greater, Expr) <= Equal;
               return Create_Memory_U8 (Boolean'Pos (Res), Res_Typ);
            end;
         when Iir_Predefined_Ieee_Numeric_Std_Le_Uns_Nat =>
            declare
               Res : Boolean;
            begin
               Res := Compare_Uns_Nat (Left, Right, Greater, Expr) <= Equal;
               return Create_Memory_U8 (Boolean'Pos (Res), Res_Typ);
            end;
         when Iir_Predefined_Ieee_Numeric_Std_Le_Sgn_Sgn =>
            declare
               Res : Boolean;
            begin
               Res := Compare_Sgn_Sgn (Left, Right, Less, Expr) <= Equal;
               return Create_Memory_U8 (Boolean'Pos (Res), Res_Typ);
            end;

         when Iir_Predefined_Ieee_Numeric_Std_Lt_Uns_Uns =>
            declare
               Res : Boolean;
            begin
               Res := Compare_Uns_Uns (Left, Right, Greater, Expr) < Equal;
               return Create_Memory_U8 (Boolean'Pos (Res), Res_Typ);
            end;
         when Iir_Predefined_Ieee_Numeric_Std_Lt_Uns_Nat =>
            declare
               Res : Boolean;
            begin
               Res := Compare_Uns_Nat (Left, Right, Greater, Expr) < Equal;
               return Create_Memory_U8 (Boolean'Pos (Res), Res_Typ);
            end;
         when Iir_Predefined_Ieee_Numeric_Std_Lt_Nat_Uns =>
            declare
               Res : Boolean;
            begin
               Res := Compare_Nat_Uns (Left, Right, Greater, Expr) < Equal;
               return Create_Memory_U8 (Boolean'Pos (Res), Res_Typ);
            end;
         when Iir_Predefined_Ieee_Numeric_Std_Lt_Sgn_Sgn =>
            declare
               Res : Boolean;
            begin
               Res := Compare_Sgn_Sgn (Left, Right, Less, Expr) < Equal;
               return Create_Memory_U8 (Boolean'Pos (Res), Res_Typ);
            end;

         when Iir_Predefined_Ieee_Numeric_Std_Add_Uns_Uns
           | Iir_Predefined_Ieee_Numeric_Std_Add_Uns_Log
           | Iir_Predefined_Ieee_Std_Logic_Unsigned_Add_Slv_Log
           | Iir_Predefined_Ieee_Std_Logic_Unsigned_Add_Slv_Slv
           | Iir_Predefined_Ieee_Std_Logic_Arith_Add_Uns_Uns_Slv =>
            return Add_Uns_Uns (Left, Right, Expr);

         when Iir_Predefined_Ieee_Numeric_Std_Add_Sgn_Int =>
            return Add_Sgn_Int (Left, Read_Discrete (Right), Expr);

         when Iir_Predefined_Ieee_Numeric_Std_Add_Uns_Nat
           | Iir_Predefined_Ieee_Std_Logic_Unsigned_Add_Slv_Int =>
            return Add_Uns_Nat (Left, To_Uns64 (Read_Discrete (Right)), Expr);
         when Iir_Predefined_Ieee_Numeric_Std_Add_Sgn_Sgn =>
            return Add_Sgn_Sgn (Left, Right, Expr);

         when Iir_Predefined_Ieee_Numeric_Std_Sub_Uns_Uns =>
            return Sub_Uns_Uns (Left, Right, Expr);
         when Iir_Predefined_Ieee_Numeric_Std_Sub_Uns_Nat =>
            return Sub_Uns_Nat (Left, To_Uns64 (Read_Discrete (Right)), Expr);

         when Iir_Predefined_Ieee_Numeric_Std_Sub_Sgn_Int =>
            return Sub_Sgn_Int (Left, Read_Discrete (Right), Expr);
         when Iir_Predefined_Ieee_Numeric_Std_Sub_Sgn_Sgn =>
            return Sub_Sgn_Sgn (Left, Right, Expr);

         when Iir_Predefined_Ieee_Numeric_Std_Mul_Uns_Uns =>
            return Mul_Uns_Uns (Left, Right, Expr);
         when Iir_Predefined_Ieee_Numeric_Std_Mul_Nat_Uns =>
            return Mul_Nat_Uns (To_Uns64 (Read_Discrete (Left)), Right, Expr);
         when Iir_Predefined_Ieee_Numeric_Std_Mul_Uns_Nat =>
            return Mul_Uns_Nat (Left, To_Uns64 (Read_Discrete (Right)), Expr);

         when Iir_Predefined_Ieee_Numeric_Std_Mul_Sgn_Sgn =>
            return Mul_Sgn_Sgn (Left, Right, Expr);
         when Iir_Predefined_Ieee_Numeric_Std_Mul_Sgn_Int =>
            return Mul_Sgn_Int (Left, Read_Discrete (Right), Expr);
         when Iir_Predefined_Ieee_Numeric_Std_Mul_Int_Sgn =>
            return Mul_Int_Sgn (Read_Discrete (Left), Right, Expr);

         when Iir_Predefined_Ieee_Numeric_Std_Div_Uns_Uns =>
            return Div_Uns_Uns (Left, Right, Expr);
         when Iir_Predefined_Ieee_Numeric_Std_Div_Sgn_Sgn =>
            return Div_Sgn_Sgn (Left, Right, Expr);

         when Iir_Predefined_Ieee_Numeric_Std_Srl_Uns_Int
           |  Iir_Predefined_Ieee_Numeric_Std_Srl_Sgn_Int =>
            declare
               Amt : Int64;
            begin
               Amt := Read_Discrete (Right);
               if Amt >= 0 then
                  return Shift_Vec (Left, Uns32 (Amt), True, False);
               else
                  return Shift_Vec (Left, Uns32 (-Amt), False, False);
               end if;
            end;
         when Iir_Predefined_Ieee_Numeric_Std_Sll_Uns_Int
           |  Iir_Predefined_Ieee_Numeric_Std_Sll_Sgn_Int =>
            declare
               Amt : Int64;
            begin
               Amt := Read_Discrete (Right);
               if Amt >= 0 then
                  return Shift_Vec (Left, Uns32 (Amt), False, False);
               else
                  return Shift_Vec (Left, Uns32 (-Amt), True, False);
               end if;
            end;

         when Iir_Predefined_Ieee_Math_Real_Pow =>
            declare
               function Pow (L, R : Fp64) return Fp64;
               pragma Import (C, Pow);
            begin
               return Create_Memory_Fp64
                 (Pow (Read_Fp64 (Left), Read_Fp64 (Right)), Res_Typ);
            end;

         when others =>
            Error_Msg_Synth
              (+Expr, "eval_static_dyadic_predefined: unhandled "
                 & Iir_Predefined_Functions'Image (Def));
            return Null_Memtyp;
      end case;
   end Eval_Static_Dyadic_Predefined;

   function Eval_Vector_Monadic (Vec : Memtyp; Op : Table_1d) return Memtyp
   is
      Len : constant Iir_Index32 := Vec_Length (Vec.Typ);
      Res : Memtyp;
   begin
      Res := Create_Memory (Create_Res_Bound (Vec.Typ));
      for I in 1 .. Uns32 (Len) loop
         declare
            V : constant Std_Ulogic := Read_Std_Logic (Vec.Mem, I - 1);
         begin
            Write_Std_Logic (Res.Mem, I - 1, Op (V));
         end;
      end loop;
      return Res;
   end Eval_Vector_Monadic;

   function Eval_Vector_Reduce
     (Init : Std_Ulogic; Vec : Memtyp; Op : Table_2d) return Memtyp
   is
      El_Typ : constant Type_Acc := Vec.Typ.Arr_El;
      Res : Std_Ulogic;
   begin
      Res := Init;
      for I in 1 .. Uns32 (Vec_Length (Vec.Typ)) loop
         declare
            V : constant Std_Ulogic := Read_Std_Logic (Vec.Mem, I - 1);
         begin
            Res := Op (Res, V);
         end;
      end loop;

      return Create_Memory_U8 (Std_Ulogic'Pos (Res), El_Typ);
   end Eval_Vector_Reduce;

   function Eval_TF_Vector_Monadic (Vec : Memtyp) return Memtyp
   is
      Len : constant Iir_Index32 := Vec_Length (Vec.Typ);
      Res : Memtyp;
   begin
      Res := Create_Memory (Create_Res_Bound (Vec.Typ));
      for I in 1 .. Uns32 (Len) loop
         declare
            V : constant Boolean :=
              Boolean'Val (Read_U8 (Vec.Mem + Size_Type (I - 1)));
         begin
            Write_U8 (Res.Mem + Size_Type (I - 1), Boolean'Pos (not V));
         end;
      end loop;
      return Res;
   end Eval_TF_Vector_Monadic;

   function Eval_TF_Vector_Reduce (Init : Boolean;
                                   Neg : Boolean;
                                   Vec : Memtyp;
                                   Op : Tf_Table_2d) return Memtyp
   is
      El_Typ : constant Type_Acc := Vec.Typ.Arr_El;
      Res : Boolean;
   begin
      Res := Init;
      for I in 1 .. Size_Type (Vec.Typ.Abound.Len) loop
         declare
            V : constant Boolean := Boolean'Val (Read_U8 (Vec.Mem + (I - 1)));
         begin
            Res := Op (Res, V);
         end;
      end loop;

      return Create_Memory_U8 (Boolean'Pos (Res xor Neg), El_Typ);
   end Eval_TF_Vector_Reduce;

   function Eval_Vector_Maximum (Vec : Memtyp) return Memtyp
   is
      Etyp : constant Type_Acc := Vec.Typ.Arr_El;
      Len : constant Uns32 := Vec.Typ.Abound.Len;
   begin
      case Etyp.Kind is
         when Type_Logic
           | Type_Bit
           | Type_Discrete =>
            declare
               Res : Int64;
               V : Int64;
            begin
               case Etyp.Drange.Dir is
                  when Dir_To =>
                     Res := Etyp.Drange.Left;
                  when Dir_Downto =>
                     Res := Etyp.Drange.Right;
               end case;

               for I in 1 .. Len loop
                  V := Read_Discrete
                    (Vec.Mem + Size_Type (I - 1) * Etyp.Sz, Etyp);
                  if V > Res then
                     Res := V;
                  end if;
               end loop;
               return Create_Memory_Discrete (Res, Etyp);
            end;
         when Type_Float =>
            declare
               Res : Fp64;
               V : Fp64;
            begin
               case Etyp.Frange.Dir is
                  when Dir_To =>
                     Res := Etyp.Frange.Left;
                  when Dir_Downto =>
                     Res := Etyp.Frange.Right;
               end case;

               for I in 1 .. Len loop
                  V := Read_Fp64
                    (Vec.Mem + Size_Type (I - 1) * Etyp.Sz);
                  if V > Res then
                     Res := V;
                  end if;
               end loop;
               return Create_Memory_Fp64 (Res, Etyp);
            end;
         when others =>
            raise Internal_Error;
      end case;
   end Eval_Vector_Maximum;

   function Eval_Vector_Minimum (Vec : Memtyp) return Memtyp
   is
      Etyp : constant Type_Acc := Vec.Typ.Arr_El;
      Len : constant Uns32 := Vec.Typ.Abound.Len;
   begin
      case Etyp.Kind is
         when Type_Logic
           | Type_Bit
           | Type_Discrete =>
            declare
               Res : Int64;
               V : Int64;
            begin
               case Etyp.Drange.Dir is
                  when Dir_To =>
                     Res := Etyp.Drange.Right;
                  when Dir_Downto =>
                     Res := Etyp.Drange.Left;
               end case;

               for I in 1 .. Len loop
                  V := Read_Discrete
                    (Vec.Mem + Size_Type (I - 1) * Etyp.Sz, Etyp);
                  if V < Res then
                     Res := V;
                  end if;
               end loop;
               return Create_Memory_Discrete (Res, Etyp);
            end;
         when Type_Float =>
            declare
               Res : Fp64;
               V : Fp64;
            begin
               case Etyp.Frange.Dir is
                  when Dir_To =>
                     Res := Etyp.Frange.Right;
                  when Dir_Downto =>
                     Res := Etyp.Frange.Left;
               end case;

               for I in 1 .. Len loop
                  V := Read_Fp64
                    (Vec.Mem + Size_Type (I - 1) * Etyp.Sz);
                  if V < Res then
                     Res := V;
                  end if;
               end loop;
               return Create_Memory_Fp64 (Res, Etyp);
            end;
         when others =>
            raise Internal_Error;
      end case;
   end Eval_Vector_Minimum;

   function Eval_Static_Monadic_Predefined (Imp : Node;
                                             Operand : Memtyp;
                                             Expr : Node) return Memtyp
   is
      Def : constant Iir_Predefined_Functions :=
        Get_Implicit_Definition (Imp);
   begin
      case Def is
         when Iir_Predefined_Boolean_Not
           | Iir_Predefined_Bit_Not =>
            return Create_Memory_U8 (1 - Read_U8 (Operand), Operand.Typ);

         when Iir_Predefined_Bit_Condition =>
            return Create_Memory_U8 (Read_U8 (Operand), Operand.Typ);

         when Iir_Predefined_Integer_Negation
           | Iir_Predefined_Physical_Negation =>
            return Create_Memory_Discrete
              (-Read_Discrete (Operand), Operand.Typ);
         when Iir_Predefined_Integer_Absolute
           | Iir_Predefined_Physical_Absolute =>
            return Create_Memory_Discrete
              (abs Read_Discrete (Operand), Operand.Typ);
         when Iir_Predefined_Integer_Identity
           | Iir_Predefined_Physical_Identity =>
            return Operand;

         when Iir_Predefined_Floating_Negation =>
            return Create_Memory_Fp64 (-Read_Fp64 (Operand), Operand.Typ);
         when Iir_Predefined_Floating_Identity =>
            return Operand;
         when Iir_Predefined_Floating_Absolute =>
            return Create_Memory_Fp64 (abs Read_Fp64 (Operand), Operand.Typ);

         when Iir_Predefined_Vector_Maximum =>
            return Eval_Vector_Maximum (Operand);
         when Iir_Predefined_Vector_Minimum =>
            return Eval_Vector_Minimum (Operand);

         when Iir_Predefined_TF_Array_Not =>
            return Eval_TF_Vector_Monadic (Operand);

         when Iir_Predefined_TF_Reduction_Or =>
            return Eval_TF_Vector_Reduce (False, False, Operand, Tf_2d_Or);
         when Iir_Predefined_TF_Reduction_And =>
            return Eval_TF_Vector_Reduce (True, False, Operand, Tf_2d_And);
         when Iir_Predefined_TF_Reduction_Xor =>
            return Eval_TF_Vector_Reduce (False, False, Operand, Tf_2d_Xor);
         when Iir_Predefined_TF_Reduction_Nor =>
            return Eval_TF_Vector_Reduce (False, True, Operand, Tf_2d_Or);
         when Iir_Predefined_TF_Reduction_Nand =>
            return Eval_TF_Vector_Reduce (True, True, Operand, Tf_2d_And);
         when Iir_Predefined_TF_Reduction_Xnor =>
            return Eval_TF_Vector_Reduce (False, True, Operand, Tf_2d_Xor);

         when Iir_Predefined_Ieee_1164_Condition_Operator =>
            --  Constant std_logic: need to convert.
            declare
               Val : Uns32;
               Zx : Uns32;
            begin
               From_Std_Logic (Int64 (Read_U8 (Operand)), Val, Zx);
               return Create_Memory_U8
                 (Boolean'Pos (Val = 1 and Zx = 0), Boolean_Type);
            end;

         when Iir_Predefined_Ieee_Numeric_Std_Neg_Sgn =>
            return Neg_Vec (Operand, Expr);
         when Iir_Predefined_Ieee_Numeric_Std_Abs_Sgn =>
            return Abs_Vec (Operand, Expr);

         when Iir_Predefined_Ieee_1164_Vector_Not
           | Iir_Predefined_Ieee_Numeric_Std_Not_Uns
           | Iir_Predefined_Ieee_Numeric_Std_Not_Sgn =>
            return Eval_Vector_Monadic (Operand, Not_Table);

         when Iir_Predefined_Ieee_1164_Scalar_Not =>
            return Create_Memory_U8
              (Std_Ulogic'Pos (Not_Table (Read_Std_Logic (Operand.Mem, 0))),
               Operand.Typ);

         when Iir_Predefined_Ieee_Numeric_Std_And_Uns =>
            return Eval_Vector_Reduce ('1', Operand, And_Table);

         when Iir_Predefined_Ieee_1164_Or_Suv
           | Iir_Predefined_Ieee_Numeric_Std_Or_Uns =>
            return Eval_Vector_Reduce ('0', Operand, Or_Table);
         when Iir_Predefined_Ieee_1164_Xor_Suv =>
            return Eval_Vector_Reduce ('0', Operand, Xor_Table);

         when others =>
            Error_Msg_Synth
              (+Expr, "eval_static_monadic_predefined: unhandled "
                 & Iir_Predefined_Functions'Image (Def));
            raise Internal_Error;
      end case;
   end Eval_Static_Monadic_Predefined;

   function Eval_To_Vector (Arg : Uns64; Sz : Int64; Res_Type : Type_Acc)
                           return Memtyp
   is
      Len : constant Iir_Index32 := Iir_Index32 (Sz);
      El_Type : constant Type_Acc := Get_Array_Element (Res_Type);
      Res : Memtyp;
      Bnd : Type_Acc;
      B : Uns64;
   begin
      Bnd := Create_Vec_Type_By_Length (Width (Len), El_Type);
      Res := Create_Memory (Bnd);
      for I in 1 .. Len loop
         B := Shift_Right_Arithmetic (Arg, Natural (I - 1)) and 1;
         Write_Std_Logic (Res.Mem, Uns32 (Len - I),
                          Std_Ulogic'Val (Std_Logic_0_Pos + B));
      end loop;
      return Res;
   end Eval_To_Vector;

   function Eval_Unsigned_To_Integer (Arg : Memtyp; Loc : Node) return Int64
   is
      Res : Uns64;
      V : Std_Ulogic;
   begin
      Res := 0;
      for I in 1 .. Vec_Length (Arg.Typ) loop
         V := Std_Ulogic'Val (Read_U8 (Arg.Mem + Size_Type (I - 1)));
         case To_X01 (V) is
            when '0' =>
               Res := Res * 2;
            when '1' =>
               Res := Res * 2 + 1;
            when 'X' =>
               Warning_Msg_Synth
                 (+Loc, "metavalue detected, returning 0");
               Res := 0;
               exit;
         end case;
      end loop;
      return To_Int64 (Res);
   end Eval_Unsigned_To_Integer;

   function Eval_Signed_To_Integer (Arg : Memtyp; Loc : Node) return Int64
   is
      Len : constant Iir_Index32 := Vec_Length (Arg.Typ);
      Res : Uns64;
      E : Std_Ulogic;
   begin
      if Len = 0 then
         Warning_Msg_Synth
           (+Loc, "numeric_std.to_integer: null detected, returning 0");
         return 0;
      end if;

      E := Std_Ulogic'Val (Read_U8 (Arg.Mem));
      case To_X01 (E) is
         when '0' =>
            Res := 0;
         when '1' =>
            Res := not 0;
         when 'X' =>
            Warning_Msg_Synth (+Loc, "metavalue detected, returning 0");
            return 0;
      end case;
      for I in 2 .. Len loop
         E := Std_Ulogic'Val (Read_U8 (Arg.Mem + Size_Type (I - 1)));
         case To_X01 (E) is
            when '0' =>
               Res := Res * 2;
            when '1' =>
               Res := Res * 2 + 1;
            when 'X' =>
               Warning_Msg_Synth (+Loc, "metavalue detected, returning 0");
               return 0;
         end case;
      end loop;
      return To_Int64 (Res);
   end Eval_Signed_To_Integer;

   function Eval_Array_Char_To_String (Param : Memtyp;
                                       Res_Typ : Type_Acc;
                                       Imp : Node) return Memtyp
   is
      use Vhdl.Utils;
      use Name_Table;
      Len : constant Uns32 := Param.Typ.Abound.Len;
      Elt : constant Type_Acc := Param.Typ.Arr_El;
      Etype : constant Node := Get_Base_Type
        (Get_Element_Subtype
           (Get_Type (Get_Interface_Declaration_Chain (Imp))));
      pragma Assert (Get_Kind (Etype) = Iir_Kind_Enumeration_Type_Definition);
      Enums : constant Iir_Flist := Get_Enumeration_Literal_List (Etype);
      Lit : Node;
      Lit_Id : Name_Id;
      Bnd : Bound_Type;
      Res_St : Type_Acc;
      Res : Memtyp;
      V : Int64;
   begin
      Bnd := Elab.Vhdl_Types.Create_Bounds_From_Length
        (Res_Typ.Uarr_Idx.Drange, Iir_Index32 (Len));
      Res_St := Create_Onedimensional_Array_Subtype (Res_Typ, Bnd, Elt);
      Res := Create_Memory (Res_St);
      for I in 1 .. Len loop
         V := Read_Discrete (Param.Mem + Size_Type (I - 1) * Elt.Sz, Elt);
         Lit := Get_Nth_Element (Enums, Natural (V));
         Lit_Id := Get_Identifier (Lit);
         pragma Assert (Is_Character (Lit_Id));
         Write_U8 (Res.Mem + Size_Type (I - 1),
                   Character'Pos (Get_Character (Lit_Id)));
      end loop;
      return Res;
   end Eval_Array_Char_To_String;

   function String_To_Memtyp (Str : String; Styp : Type_Acc) return Memtyp
   is
      Len : constant Natural := Str'Length;
      Bnd : Bound_Type;
      Typ : Type_Acc;
      Res : Memtyp;
   begin
      Bnd := (Dir => Dir_To, Left => 1, Right => Int32 (Len),
              Len => Uns32 (Len));
      Typ := Create_Array_Type (Bnd, True, Styp.Uarr_El);

      Res := Create_Memory (Typ);
      for I in Str'Range loop
         Write_U8 (Res.Mem + Size_Type (I - Str'First),
                   Character'Pos (Str (I)));
      end loop;
      return Res;
   end String_To_Memtyp;

   function Eval_Enum_To_String (Param : Memtyp;
                                 Res_Typ : Type_Acc;
                                 Imp : Node) return Memtyp
   is
      use Vhdl.Utils;
      use Name_Table;
      Etype : constant Node := Get_Base_Type
        (Get_Type (Get_Interface_Declaration_Chain (Imp)));
      pragma Assert (Get_Kind (Etype) = Iir_Kind_Enumeration_Type_Definition);
      Enums : constant Iir_Flist := Get_Enumeration_Literal_List (Etype);
      Lit : Node;
      Lit_Id : Name_Id;
      V : Int64;
      C : String (1 .. 1);
   begin
      V := Read_Discrete (Param.Mem, Param.Typ);
      Lit := Get_Nth_Element (Enums, Natural (V));
      Lit_Id := Get_Identifier (Lit);
      if Is_Character (Lit_Id) then
         C (1) := Get_Character (Lit_Id);
         return String_To_Memtyp (C, Res_Typ);
      else
         return String_To_Memtyp (Image (Lit_Id), Res_Typ);
      end if;
   end Eval_Enum_To_String;

   Hex_Chars : constant array (Natural range 0 .. 15) of Character :=
     "0123456789ABCDEF";

   function Eval_Bit_Vector_To_String (Val : Memtyp;
                                       Res_Typ : Type_Acc;
                                       Log_Base : Natural) return Memtyp
   is
      Base : constant Natural := 2 ** Log_Base;
      Blen : constant Natural := Natural (Val.Typ.Abound.Len);
      Str : String (1 .. (Blen + Log_Base - 1) / Log_Base);
      Pos : Natural;
      V : Natural;
      N : Natural;
   begin
      V := 0;
      N := 1;
      Pos := Str'Last;
      for I in 1 .. Blen loop
         V := V + Natural (Read_U8 (Val.Mem + Size_Type (Blen - I))) * N;
         N := N * 2;
         if N = Base or else I = Blen then
            Str (Pos) := Hex_Chars (V);
            Pos := Pos - 1;
            N := 1;
            V := 0;
         end if;
      end loop;
      return String_To_Memtyp (Str, Res_Typ);
   end Eval_Bit_Vector_To_String;

   function Eval_Static_Predefined_Function_Call (Param1 : Valtyp;
                                                  Param2 : Valtyp;
                                                  Res_Typ : Type_Acc;
                                                  Expr : Node) return Memtyp
   is
      Imp  : constant Node := Get_Implementation (Expr);
      Def : constant Iir_Predefined_Functions :=
        Get_Implicit_Definition (Imp);
   begin
      case Def is
         when Iir_Predefined_Physical_Minimum
           | Iir_Predefined_Integer_Minimum
           | Iir_Predefined_Enum_Minimum =>
            return Create_Memory_Discrete
              (Int64'Min (Read_Discrete (Param1), Read_Discrete (Param2)),
               Res_Typ);
         when Iir_Predefined_Floating_Maximum =>
            return Create_Memory_Fp64
              (Fp64'Max (Read_Fp64 (Param1), Read_Fp64 (Param2)), Res_Typ);
         when Iir_Predefined_Physical_Maximum
           | Iir_Predefined_Integer_Maximum
           | Iir_Predefined_Enum_Maximum =>
            return Create_Memory_Discrete
              (Int64'Max (Read_Discrete (Param1), Read_Discrete (Param2)),
               Res_Typ);
         when Iir_Predefined_Floating_Minimum =>
            return Create_Memory_Fp64
              (Fp64'Min (Read_Fp64 (Param1), Read_Fp64 (Param2)), Res_Typ);

         when Iir_Predefined_Now_Function =>
            return Create_Memory_Discrete
              (Int64 (Grt.Vhdl_Types.Current_Time), Res_Typ);

         when Iir_Predefined_Endfile =>
            declare
               Res : Boolean;
            begin
               Res := Elab.Vhdl_Files.Endfile (Param1.Val.File, Expr);
               return Create_Memory_U8 (Boolean'Pos (Res), Boolean_Type);
            end;

         when Iir_Predefined_Integer_To_String =>
            declare
               Str : String (1 .. 21);
               First : Natural;
            begin
               Grt.To_Strings.To_String
                 (Str, First, Ghdl_I64 (Read_Discrete (Param1)));
               return String_To_Memtyp (Str (First .. Str'Last), Res_Typ);
            end;
         when Iir_Predefined_Array_Char_To_String =>
            return Eval_Array_Char_To_String
              (Get_Memtyp (Param1), Res_Typ, Imp);
         when Iir_Predefined_Enum_To_String =>
            return Eval_Enum_To_String (Get_Memtyp (Param1), Res_Typ, Imp);

         when Iir_Predefined_Bit_Vector_To_Hstring =>
            return Eval_Bit_Vector_To_String (Get_Memtyp (Param1), Res_Typ, 4);
         when Iir_Predefined_Bit_Vector_To_Ostring =>
            return Eval_Bit_Vector_To_String (Get_Memtyp (Param1), Res_Typ, 3);

         when Iir_Predefined_Std_Env_Resolution_Limit =>
            return Create_Memory_Discrete (1, Res_Typ);

         when Iir_Predefined_Ieee_Numeric_Std_Touns_Nat_Nat_Uns
            | Iir_Predefined_Ieee_Std_Logic_Arith_Conv_Unsigned_Int
            | Iir_Predefined_Ieee_Numeric_Std_Unsigned_To_Slv_Nat_Nat_Slv =>
            return Eval_To_Vector
              (Uns64 (Read_Discrete (Param1)), Read_Discrete (Param2),
               Res_Typ);
         when Iir_Predefined_Ieee_Numeric_Std_Tosgn_Int_Nat_Sgn
            | Iir_Predefined_Ieee_Std_Logic_Arith_Conv_Vector_Int =>
            return Eval_To_Vector
              (To_Uns64 (Read_Discrete (Param1)), Read_Discrete (Param2),
               Res_Typ);
         when Iir_Predefined_Ieee_Numeric_Std_Toint_Uns_Nat
            | Iir_Predefined_Ieee_Std_Logic_Arith_Conv_Integer_Uns
            | Iir_Predefined_Ieee_Std_Logic_Unsigned_Conv_Integer =>
            --  UNSIGNED to Natural.
            return Create_Memory_Discrete
              (Eval_Unsigned_To_Integer (Get_Memtyp (Param1), Expr), Res_Typ);
         when Iir_Predefined_Ieee_Numeric_Std_Toint_Sgn_Int =>
            --  SIGNED to Integer
            return Create_Memory_Discrete
              (Eval_Signed_To_Integer (Get_Memtyp (Param1), Expr), Res_Typ);
         when Iir_Predefined_Ieee_Std_Logic_Arith_Conv_Integer_Int =>
            return Get_Memtyp (Param1);

         when Iir_Predefined_Ieee_Numeric_Std_Shf_Left_Uns_Nat
            | Iir_Predefined_Ieee_Numeric_Std_Shf_Left_Sgn_Nat =>
            return Shift_Vec
              (Get_Memtyp (Param1), Uns32 (Read_Discrete (Param2)),
               False, False);
         when Iir_Predefined_Ieee_Numeric_Std_Shf_Right_Uns_Nat =>
            return Shift_Vec
              (Get_Memtyp (Param1), Uns32 (Read_Discrete (Param2)),
               True, False);
         when Iir_Predefined_Ieee_Numeric_Std_Shf_Right_Sgn_Nat =>
            return Shift_Vec
              (Get_Memtyp (Param1), Uns32 (Read_Discrete (Param2)),
               True, True);
         when Iir_Predefined_Ieee_Numeric_Std_Resize_Sgn_Nat =>
            return Resize_Vec
              (Get_Memtyp (Param1), Uns32 (Read_Discrete (Param2)), True);
         when Iir_Predefined_Ieee_Numeric_Std_Resize_Uns_Nat =>
            return Resize_Vec
              (Get_Memtyp (Param1), Uns32 (Read_Discrete (Param2)), False);

         when Iir_Predefined_Ieee_1164_To_Stdulogic =>
            declare
               B : Std_Ulogic;
            begin
               B := Read_Bit_To_Std_Logic (Param1.Val.Mem, 0);
               return Create_Memory_U8 (Std_Ulogic'Pos (B), Res_Typ);
            end;

         when Iir_Predefined_Ieee_1164_To_X01_Log =>
            declare
               B : Std_Ulogic;
            begin
               B := Read_Std_Logic (Param1.Val.Mem, 0);
               B := To_X01 (B);
               return Create_Memory_U8 (Std_Ulogic'Pos (B), Res_Typ);
            end;
         when Iir_Predefined_Ieee_1164_To_X01_Slv =>
            declare
               El_Type : constant Type_Acc := Get_Array_Element (Res_Typ);
               Res : Memtyp;
               Bnd : Type_Acc;
               B : Std_Ulogic;
            begin
               Bnd := Create_Vec_Type_By_Length
                 (Uns32 (Vec_Length (Param1.Typ)), El_Type);
               Res := Create_Memory (Bnd);
               for I in 1 .. Uns32 (Vec_Length (Param1.Typ)) loop
                  B := Read_Std_Logic (Param1.Val.Mem, I - 1);
                  B := To_X01 (B);
                  Write_Std_Logic (Res.Mem, I - 1, B);
               end loop;
               return Res;
            end;

         when Iir_Predefined_Ieee_1164_To_Stdlogicvector_Bv
            | Iir_Predefined_Ieee_1164_To_Stdulogicvector_Bv =>
            declare
               El_Type : constant Type_Acc := Get_Array_Element (Res_Typ);
               Res : Memtyp;
               Bnd : Type_Acc;
               B : Std_Ulogic;
            begin
               Bnd := Create_Vec_Type_By_Length
                 (Uns32 (Vec_Length (Param1.Typ)), El_Type);
               Res := Create_Memory (Bnd);
               for I in 1 .. Uns32 (Vec_Length (Param1.Typ)) loop
                  B := Read_Bit_To_Std_Logic (Param1.Val.Mem, I - 1);
                  Write_Std_Logic (Res.Mem, I - 1, B);
               end loop;
               return Res;
            end;

         when Iir_Predefined_Ieee_1164_To_Bit =>
            declare
               V : Std_Ulogic;
               X : Bit;
               R : Bit;
            begin
               V := Read_Std_Logic (Param1.Val.Mem, 0);
               X := Read_Bit (Param2.Val.Mem, 0);
               R := To_Bit (V, X);
               return Create_Memory_U8 (Bit'Pos(R), Res_Typ);
            end;
         when Iir_Predefined_Ieee_1164_To_Bitvector =>
            declare
               El_Type : constant Type_Acc := Get_Array_Element (Res_Typ);
               Res     : Memtyp;
               Bnd     : Type_Acc;
               S       : Std_Ulogic;
               X       : Bit;
               R       : Bit;
            begin
               X := Read_Bit (Param2.Val.Mem, 0);
               Bnd := Create_Vec_Type_By_Length
                 (Uns32 (Vec_Length (Param1.Typ)), El_Type);
               Res := Create_Memory (Bnd);
               for I in 1 .. Uns32 (Vec_Length (Param1.Typ)) loop
                  S := Read_Std_Logic (Param1.Val.Mem, I - 1);
                  R := To_Bit (S, X);
                  Write_Bit (Res.Mem, I - 1, R);
               end loop;
               return Res;
            end;

         when Iir_Predefined_Ieee_1164_Scalar_Is_X =>
            declare
               B : Std_Ulogic;
            begin
               B := Read_Std_Logic (Param1.Val.Mem, 0);
               B := To_X01 (B);
               return Create_Memory_U8 (Boolean'Pos (B = 'X'), Res_Typ);
            end;

         when Iir_Predefined_Ieee_Math_Real_Log2 =>
            declare
               function Log2 (Arg : Fp64) return Fp64;
               pragma Import (C, Log2);
            begin
               return Create_Memory_Fp64 (Log2 (Read_Fp64 (Param1)), Res_Typ);
            end;
         when Iir_Predefined_Ieee_Math_Real_Ceil =>
            declare
               function Ceil (Arg : Fp64) return Fp64;
               pragma Import (C, Ceil);
            begin
               return Create_Memory_Fp64 (Ceil (Read_Fp64 (Param1)), Res_Typ);
            end;
         when Iir_Predefined_Ieee_Math_Real_Floor =>
            declare
               function Floor (Arg : Fp64) return Fp64;
               pragma Import (C, Floor);
            begin
               return Create_Memory_Fp64 (Floor (Read_Fp64 (Param1)), Res_Typ);
            end;
         when Iir_Predefined_Ieee_Math_Real_Round =>
            declare
               function Round (Arg : Fp64) return Fp64;
               pragma Import (C, Round);
            begin
               return Create_Memory_Fp64 (Round (Read_Fp64 (Param1)), Res_Typ);
            end;
         when Iir_Predefined_Ieee_Math_Real_Sin =>
            declare
               function Sin (Arg : Fp64) return Fp64;
               pragma Import (C, Sin);
            begin
               return Create_Memory_Fp64 (Sin (Read_Fp64 (Param1)), Res_Typ);
            end;
         when Iir_Predefined_Ieee_Math_Real_Cos =>
            declare
               function Cos (Arg : Fp64) return Fp64;
               pragma Import (C, Cos);
            begin
               return Create_Memory_Fp64 (Cos (Read_Fp64 (Param1)), Res_Typ);
            end;
         when Iir_Predefined_Ieee_Math_Real_Arctan =>
            declare
               function Atan (Arg : Fp64) return Fp64;
               pragma Import (C, Atan);
            begin
               return Create_Memory_Fp64 (Atan (Read_Fp64 (Param1)), Res_Typ);
            end;
         when others =>
            null;
      end case;
      Error_Msg_Synth (+Expr, "unhandled (static) function: "
                         & Iir_Predefined_Functions'Image (Def));
      return Null_Memtyp;
   end Eval_Static_Predefined_Function_Call;
end Synth.Vhdl_Eval;
