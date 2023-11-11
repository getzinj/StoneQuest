[Inherit ('Types','SMGRTL','STRRTL')]Module Edit_Items;

Type
   Attack_Set = Set of Attack_Type;
   Monster_Set = Set of Monster_Type;

Const
   Table_Size = 250;

Var
   Keyboard,ScreenDisplay: [External]Unsigned;
   Number: Integer;
   Cat: Array [1..22] of Packed Array [1..24] of char;
   Monster_T: Array [Monster_Type] of Packed Array [1..13] of char;
   Spell: [External]Array [Spell_Name] of Varying [4] of Char;
   Item_Name: [External]Array [Item_Type] of Varying [7] of Char;
   AlignName: [External]Array [Align_Type] of Packed Array [1..7] of char;
   Item_List: [External]List_of_Items;

Value
        Cat[1]:='Item Number';
        Cat[2]:='Unidentified Name';
        Cat[3]:='Actual Name';
        Cat[4]:='Alignment';
        Cat[5]:='Item type';
        Cat[6]:='Cursed?';
        Cat[7]:='Special occurance number';
        Cat[8]:='Percentage of breaking';
        Cat[9]:='Turns into';
        Cat[10]:='GP sale value';
        Cat[11]:='Number in store';
        Cat[12]:='Cast spell';
        Cat[13]:='Usable by';
        Cat[14]:='Regenerates';
        Cat[15]:='Protects against';
        Cat[16]:='Resists';
        Cat[17]:='Hates';
        Cat[18]:='Damage';
        Cat[19]:='Plus to-hit';
        Cat[20]:='AC adjustment';
        Cat[21]:='Auto Kill?';
        Cat[22]:='Additional Attacks';
        Monster_T[Warrior]:='Fighters';
        Monster_T[Mage]:='Wizards';
        Monster_T[Priest]:='Clerics';
        Monster_T[Pilferer]:='Thieves';
        Monster_T[Karateka]:='Monks';
        Monster_T[Midget]:='Midgets';
        Monster_T[Giant]:='Giants';
        Monster_T[Myth]:='Myths';
        Monster_T[Animal]:='Animals';
        Monster_T[Lycanthrope]:='Lycanthropes';
        Monster_T[Undead]:='Undead';
        Monster_T[Demon]:='Demons';
        Monster_T[Insect]:='Insects';
        Monster_T[Multiplanar]:='Multi-Planar';
        Monster_T[Dragon]:='Dragon';
        Monster_T[Statue]:='Statue';
        Monster_T[Reptile]:='Reptile';
        Monster_T[Enchanted]:='Enchanted';

[External]Function Get_Num (Display: Unsigned): Integer;External;
[External]Procedure Change_Class_Set (Var ClassSet: Class_Set; T1: Line);external;
[External]Procedure Change_Attack_Set (Var AttackSet: Attack_Set; T1: Line);External;
[External]Procedure Cursor;External;
[External]Procedure No_Cursor;External;
[External]Function Make_Choice (Choices: Char_Set; Time_Out: Integer:=-1;
    Time_Out_Char: Char:=' '): Char;External;
[External]Function String (Num: Integer; Len: Integer:=0):Line;external;
[External]Function Yes_or_No (Time_Out: Integer:=-1;
    Time_Out_Char: Char:=' '): [Volatile]Char;External;
[External]Function Get_Store_Quantity(slot: Integer): Integer;External;
[External]Procedure Write_Store_Quantity(slot: Integer; amount: Integer);External;
(******************************************************************************)

Procedure Select_Item_Spell (Var SpellChosen: Spell_Name);

Var
   SpellName: Line;
   Location,Loop: Spell_Name;

Begin
   SpellName:='';
   Location:=NoSp;
   Cursor;
   SMG$Read_String (Keyboard,Spellname,Display_ID:=ScreenDisplay);
   No_Cursor;
   For Loop:=Crlt to DetS do
      If (STR$Case_Blind_Compare(Spell[Loop]+'',SpellName)=0) then
         Location:=Loop;
   SpellChosen:=Location;
End;

(******************************************************************************)

Procedure SpellCast (Var Curr_Spell: Spell_Name);

Begin
   SMG$Begin_Display_Update (ScreenDisplay);
   SMG$Erase_Display (ScreenDisplay,15);
   SMG$Put_Line (ScreenDisplay,
       'Item currently casts spell '
       +Spell[Curr_Spell]);
   SMG$Put_Line (ScreenDisplay,
       'Cast which spell now?');
   SMG$End_Display_Update (ScreenDisplay);
   Select_Item_Spell (Curr_Spell);
   SMG$Erase_Display (ScreenDisplay,15);
   SMG$End_Display_Update (ScreenDisplay);
End;

(******************************************************************************)
Procedure HatesP (Var CantStand: Monster_Set);

Var
   Pos: Integer;
   Loop: Monster_Type;
   Temp: Monster_Type;
   MonsterNum: Integer;
   Answer: Char;
   T: Line;

Begin { HatesP }
   Repeat
      Begin { Repeat }
         SMG$Begin_Display_Update (ScreenDisplay);
         SMG$Erase_Display (ScreenDisplay);
         SMG$Home_Cursor (ScreenDisplay);
         SMG$Put_Line (ScreenDisplay,
             'The item does extra damage '
             +'to these monster-types: ');
         Pos:=1;
         T:='';
         For Loop:=Warrior to Enchanted do
         Begin { For loop 1 }
            If Loop in CantStand then
            Begin
                T:=T+Pad(Monster_T[Loop],' ',20);
                If Pos/3<>Pos div 3 then
                   T:=T+'    '
                Else
                   Begin
                      SMG$Put_Line (ScreenDisplay,T);
                      T:='';
                   End;
                Pos:=Pos+1;
            End;
         End; { For loop 1 }
         SMG$Put_Line (ScreenDisplay,T,0);
         SMG$Set_Cursor_ABS (ScreenDisplay,15,1);
         SMG$Put_Line (ScreenDisplay,
             'Change which monster?');
         Pos:=1;
         T:='';
         For Loop:=Warrior to Enchanted do
         Begin { For Loop 2 }
             T:=T
                 +CHR(Ord(Loop)+65)
                 +'  '
                 +Pad(Monster_T[Loop],' ',20);
             If Pos/3<>pos div 3 then
                 T:=T+'    '
             Else
                 Begin { third entry }
                    SMG$Put_Line (ScreenDisplay, T);
                    T:='';
                 End;  { third entry }
             Pos:=Pos+1;
         End;  { For Loop 2 }
         SMG$Put_Line(ScreenDisplay,T,0);
         SMG$End_Display_Update (ScreenDisplay);
         Answer:=Make_Choice (
             ['A'..CHR(Ord(Enchanted)+65),
              ' ']);
         If Answer<>' ' then
                 Begin { Not space }
                    MonsterNum:=Ord(Answer)-65;
                    Temp:=Warrior;
                    While Ord(Temp)<>MonsterNum do
                         Temp:=Succ(Temp);
                    If Temp in CantStand then
                       CantStand:=CantStand-[Temp]
                    Else
                       CantStand:=CantStand+[Temp];
                 End;  { Not space }
      End;  { Repeat }
   Until Answer=' ';
End;  { HatesP }


(******************************************************************************)

Procedure ProtectsAgainst (Var CantHurt: Monster_Set);

Var
   Pos: Integer;
   Loop: Monster_Type;
   Temp: Monster_Type;
   MonsterNum: Integer;
   Answer: Char;
   T: Line;

Begin
   Repeat
      Begin
         SMG$Begin_Display_Update (ScreenDisplay);
         SMG$Erase_Display (ScreenDisplay);
         SMG$Home_Cursor (ScreenDisplay);
         SMG$Put_Line (ScreenDisplay,
             'The item protects against '
             +'these monster-types: ');
         Pos:=1;
         T:='';
         For Loop:=Warrior to Enchanted do
                 If Loop in CantHurt then
                    Begin
                        T:=T+Pad(Monster_T[Loop],' ',20);
                        If Pos/3<>Pos div 3 then
                           T:=T+'    '
                        Else
                           Begin
                              SMG$Put_Line (ScreenDisplay,T);
                              T:='';
                           End;
                        Pos:=Pos+1;
                    End;
         SMG$Put_Line (ScreenDisplay,T,0);
         SMG$Set_Cursor_ABS (ScreenDisplay,15,1);
         SMG$Put_Line (ScreenDisplay,'Change which monster?');
         Pos:=1;
         T:='';
         For Loop:=Warrior to Enchanted do
             Begin
                 T:=T
                     +CHR(Ord(Loop)+65)
                     +'  '
                     +Pad(Monster_T[Loop],' ',20);
                 If Pos/3<>pos div 3 then
                     T:=T+'    '
                 Else
                     Begin
                        SMG$Put_Line (ScreenDisplay, T);
                        T:='';
                     End;
                 Pos:=Pos+1;
             End;
         SMG$Put_Line(ScreenDisplay,T,0);
         SMG$End_Display_Update (ScreenDisplay);
         Answer:=Make_Choice (
             ['A'..CHR(Ord(Enchanted)+65),
              ' ']);
         If Answer<>' ' then
                 Begin
                    MonsterNum:=Ord(Answer)-65;
                    Temp:=Warrior;
                    While Ord(Temp)<>MonsterNum do
                         Temp:=Succ(Temp);
                    If Temp in CantHurt then
                       CantHurt:=CantHurt-[Temp]
                    Else
                       CantHurt:=CantHurt+[Temp];
                 End;
      End;
   Until Answer=' ';
End;

(******************************************************************************)

Procedure Print_Characteristic (Item: Item_Record; Number: Integer; Position: Integer; Items: List_of_items;  Allow_Number_Change: Boolean);

Var
   Amount: Integer;

Begin
   SMG$Put_Chars (ScreenDisplay,
       CHR(Position+64)
       +'  '
       +Cat[Position]
       +': ');
   Case Position of
      1: SMG$Put_Chars (ScreenDisplay,String(Item.Item_Number));
      2: SMG$Put_Chars (ScreenDisplay,Item.Name);
      3: SMG$Put_Chars (ScreenDisplay,Item.True_Name);
      4: SMG$Put_Chars (ScreenDisplay,AlignName[Item.Alignment]);
      5: SMG$Put_Chars (ScreenDisplay,Item_Name[Item.Kind]);
      6: If Item.Cursed=True then
             SMG$Put_Chars (ScreenDisplay,
                 'Yes')
         Else
             SMG$Put_Chars (ScreenDisplay,
                 'No');
      7: SMG$Put_Chars (ScreenDisplay,String(Item.Special_Occurance_No));
      8: SMG$Put_Chars (ScreenDisplay,String(Item.Percentage_Breaks));
      9: SMG$Put_Chars (ScreenDisplay,Items[Item.Turns_Into].True_Name);
      10: SMG$Put_Chars (ScreenDisplay,String(Item.GP_Value));
      11: Begin
            amount:=Get_Store_Quantity(Number);
            If amount=0 then
               SMG$Put_Chars (ScreenDisplay,
                   'None')
            Else
               If amount=-1 then
                  SMG$Put_Chars (ScreenDisplay,
                      'Unlimited')
               Else
                  SMG$Put_Chars (ScreenDisplay,String(amount));
         End;
      12: If Ord(Item.Spell_Cast)=0 then
             SMG$Put_Chars (ScreenDisplay,
                 'None')
         Else
             SMG$Put_Chars (ScreenDisplay,Spell[Item.Spell_Cast]);
      13: If Item.Usable_By=[] then
             SMG$Put_Chars (ScreenDisplay,
                 'No one')
         Else
             SMG$Put_Chars (ScreenDisplay,
                 'Press "'+CHR(13+64)+'" to edit list');
      14: SMG$Put_Chars (ScreenDisplay,String(Item.Regenerates));
      15: If Item.Protects_Against=[] then
             SMG$Put_Chars (ScreenDisplay,
                 'Nothing')
         Else
             SMG$Put_Chars (ScreenDisplay,
                 'Press "'+CHR(15+64)+'" to edit list');
      16: If Item.Resists=[] then
             SMG$Put_Chars (ScreenDisplay,
                 'Nothing')
         Else
             SMG$Put_Chars (ScreenDisplay,
                 'Press "'+CHR(16+64)+'" to edit list');
      17: If Item.Versus=[] then
             SMG$Put_Chars (ScreenDisplay,'Nothing')
         Else
             SMG$Put_Chars (ScreenDisplay,
                 'Press "'+CHR(17+64)+'" to edit list');
      18: Begin
             SMG$Put_Chars (ScreenDisplay,String(Item.Damage.X)
                 +'D');
             SMG$Put_Chars (ScreenDisplay,String(Item.Damage.Y));
             if Item.Damage.Z<0 then
                SMG$Put_Chars (ScreenDisplay,
                    '-')
             Else
                SMG$Put_Chars (ScreenDisplay,
                    '+');
             SMG$Put_Chars (ScreenDisplay,String(Item.Damage.Z));
          End;
      19: SMG$Put_Chars (ScreenDisplay,String(Item.Plus_to_hit));
      20: SMG$Put_Chars (ScreenDisplay,String(Item.AC_Plus));
      21: If Item.autoKill then
             SMG$Put_Chars (ScreenDisplay,
                 'Yes')
         Else
             SMG$Put_Chars (ScreenDisplay,
                 'No');
      22: SMG$Put_Chars (ScreenDisplay,String(Item.Additional_Attacks));
   End;
   SMG$Put_Line (ScreenDisplay,'');
End;

(******************************************************************************)

Procedure Handle_Choice (Var Item: Item_Record; Choice_Num: Integer; Item_Number: Integer;  Allow_Number_Change: Boolean);

Var
   Num: Integer;
   Strng: Line;

Begin
   Case Choice_Num of
      2,3:  Begin
                SMG$Set_Cursor_ABS (ScreenDisplay,1,40);
                SMG$Put_Line (ScreenDisplay,
                    'Enter a string of up'
                    +' to 20 characters');
                Cursor; SMG$Read_String(Keyboard,Strng,Display_ID:=ScreenDisplay); No_Cursor;
                If Strng.Length>20 then Strng:=Substr(Strng,1,20);
                If Choice_Num= 2 then
                   Item.Name:=Strng
                Else
                   Item.True_Name:=Strng;
           End;
       4: If Item.Alignment=Evil then
             Item.Alignment:=NoAlign
          Else
             Item.Alignment:=Succ(Item.Alignment);
       5: If Item.Kind=Cloak then
             Item.Kind:=Weapon
          Else
             Item.Kind:=Succ(Item.Kind);
       6: Item.Cursed:=Not (Item.Cursed);
       1,7,8,9,10,11,14,19,20,22:
          Begin
             SMG$Set_Cursor_ABS (ScreenDisplay,1,40);
             SMG$Put_Line (ScreenDisplay,
                 'Enter an integer.');
             SMG$Set_Cursor_ABS (ScreenDisplay,2,40);
             Num:=Get_Num (ScreenDisplay);
             Case Choice_Num of
                1: If Num<251 then Item.Item_Number:=Num;
                7: Item.Special_Occurance_No:=Num;
                8: If (Num>-1) and (Num<101) then
                   Item.Percentage_Breaks:=Num;
                9: If (Num>-1) and (Num<451) then
                   Item.Turns_Into:=Num;
               10: Item.GP_Value:=Num;
               11: If Allow_Number_Change then
                      Write_Store_Quantity(Item_Number, Num);
               14:  Item.Regenerates:=Num;
               19: If (Num>-128) and (Num<128) then
                      Item.Plus_to_hit:=Num;
               20: If (Num>-21) and (Num<21) then
                      Item.AC_Plus:=Num;
               22: Item.Additional_Attacks:=Num;
             End;
          End;
       18: Begin
             SMG$Put_Chars (ScreenDisplay,
                 'Enter X: ',1,40);
             Item.Damage.X:=Get_Num(ScreenDisplay);
             SMG$Put_Chars (ScreenDisplay,
                 'Enter Y: ',2,40);
             Item.Damage.Y:=Get_Num(ScreenDisplay);
             SMG$Put_Chars (ScreenDisplay,
                 'Enter Z: ',3,40);
             Item.Damage.Z:=Get_Num(ScreenDisplay);
           End;
       12: SpellCast (Item.Spell_Cast);
       13: Change_Class_Set (Item.Usable_By,
              'The item can be used by these classes');
       15: Protectsagainst (Item.Protects_Against);
       16: Change_Attack_Set (Item.Resists,
               'The item is resistant to these attack forms');
       17: HatesP (Item.Versus);
       21: Item.autoKill:=Not (Item.autoKill);
   End;
End;

(******************************************************************************)

[Global]Procedure Item_Change_Screen (Var Item: Item_Record;  Number: Integer;
                                      Var Items: List_of_Items;  Allow_Number_Change: Boolean:=True);

Var
   Loop: Integer;
   Answer: Char;

Begin
  Loop:=0;
  Repeat
     Begin
        SMG$Begin_Display_Update (ScreenDisplay);
        SMG$Erase_Display (ScreenDisplay);
        SMG$Home_Cursor (ScreenDisplay);
        SMG$Put_Line (ScreenDisplay,
            'Item #'+String(Number,3));
        SMG$Put_Line (ScreenDisplay,
            '---- ----');
        For Loop:=1 to 22 do
           Print_Characteristic (Item,Number,Loop,Items,Allow_Number_Change);
        SMG$End_Display_Update (ScreenDisplay);
        Answer:=Make_Choice (
            ['A'..'V',' ']);
        If Answer<>' ' then
           Handle_Choice (Item,Ord(Answer)-64,Number,Allow_Number_Change);
     End;
  Until Answer=' ';
End;

(******************************************************************************)

Procedure Change_Item (Number: Integer; Var Item_List: List_of_Items);

Begin
   SMG$Erase_Display (ScreenDisplay);
   SMG$Home_Cursor (ScreenDisplay);
   Item_Change_Screen (Item_List[Number],Number,Item_list,True);
End;

(******************************************************************************)

Procedure Print_Table (Item: List_of_Items);

Const
   Page_Size = 22;

Var
   Loop,First,Last: Integer;
   T,Temp: Line;
   Answer: Char;

Begin
   Answer:=' ';
   First:=1;   Last:=First+Page_Size;
   Repeat
      Begin
         SMG$Begin_Display_Update (ScreenDisplay);
         SMG$Erase_Display (ScreenDisplay);
         SMG$Home_Cursor (ScreenDisplay);
         For Loop:=First to Last do
             Begin
                T:=String(Loop,3)
                    +'    '
                    +Pad(Item[Loop].True_Name,' ',22);
                Writev (Temp,Item[Loop].Kind);
                T:=T+Temp;
                SMG$Put_Line (ScreenDisplay,T);
             End;
         SMG$Put_Line (ScreenDisplay,
             'F)orward, B)ack, E)xit',0);
         SMG$End_Display_Update (ScreenDisplay);
         Answer:=Make_Choice (['F','B','E']);
         If (Answer='F') and (First+Page_size<=Table_Size) then
            Begin
               First:=First+Page_Size;
               Last:=First+Page_Size;
               If Last>Table_Size then
                   Last:=Table_Size;
               End
            Else
               If (Answer='B') and (First>=10) then
                  Begin
                     First:=First-Page_Size;
                     If First<1 then
                        First:=1;
                     Last:=First+Page_Size;
                  End;
      End;
   Until Answer='E';
End;

(******************************************************************************)

Procedure Swap_Record;

Var
  T: Line;
  Answer: Char;
  Old_Slot,New_Slot: Integer;
  Old_Num,New_Num: Integer;
  Temp_Record: Item_Record;

Begin
   SMG$Put_Chars (ScreenDisplay,
       'Record A -->');
   Old_Slot:=Get_Num(ScreenDisplay);

   SMG$Put_Chars (ScreenDisplay,
       'Record B -->');
   New_Slot:=Get_Num(ScreenDisplay);

   T:='Swap: ';
   T:=T
      +Item_List[New_Slot].True_Name
      +' with '
      +Item_List[Old_Slot].True_Name;
   SMG$Put_Line (ScreenDisplay, T);
   SMG$Put_Line (ScreenDisplay,
       'Confirm? (Y/N)');

   Answer:=Yes_or_No;
   If Answer='Y' then
      Begin
         Old_num:=Get_Store_Quantity(Old_Slot);
         New_num:=Get_Store_Quantity(New_Slot);

         Write_Store_Quantity(New_Slot,Old_Num);
         Write_Store_Quantity(Old_Slot,New_Num);

         Temp_Record:=Item_List[Old_Slot];
         Item_List[Old_Slot]:=Item_List[New_Slot];
         Item_List[New_Slot]:=Temp_Record;

         Item_List[New_Slot].Item_Number:=New_Slot;
         Item_List[Old_Slot].Item_Number:=Old_Slot;
      End;
End;

(******************************************************************************)

{ Function Find_Last (Curr: Integer): Integer;

Var
   X: Integer;
   Done: Boolean;

Begin
   X:=Curr;
   Done:=(X>448);
   While Not Done do
      Begin
         X:=X+1;
         Done:=(Item_List[X]=Null_Item);
         Done:=Done or (X>440);
      End;
   Find_Last:=X;
End; }

(******************************************************************************)

[Global]Procedure Edit_Item;

Begin { Edit Item }
   Number:=0;
   Repeat
      Begin
         SMG$Begin_Display_Update (ScreenDisplay);
         SMG$Erase_Display (ScreenDisplay);
         SMG$Home_Cursor (ScreenDisplay);
         SMG$Put_Line (ScreenDisplay,
             '           '
             +'       Edit Item',1,1);
         SMG$Put_Line (ScreenDisplay,String(Table_Size)
             +' is the cu'
             +'rrent table size.  '
             +'Edit which item?');
         SMG$End_Display_Update (ScreenDisplay);
         SMG$Put_Chars (ScreenDisplay,
             '(0-250, -4 to insert,'
             +' -3 swaps, -2 lists,'
             +' -1 exits)',3,1);
         Number:=Get_Num(ScreenDisplay);
         SMG$Set_Cursor_ABS (ScreenDisplay,4,1);
         If (Number > -1) and (Number < 251) then
            Change_Item (Number,Item_List);
{        If Number=-4 then Insert_Item; }
         If Number=-3 then Swap_Record;
         If Number=-2 then Print_Table (Item_List);
      End;
   Until Number=-1;
End;  { Edit Item }
End.  { Edit Items }
