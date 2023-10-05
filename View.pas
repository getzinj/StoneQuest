[Inherit ('SYS$LIBRARY:STARLET','Types','SMGRTL','STRRTL')]Module View;

Type
    Section_Type = (Top,Middle,Bottom);
    Horizontal_Section_Type = (Left_S,Center,Right_S);
    Side = Varying[3] of char;
    View_Line = Packed Array [1..9] of Char;
    View_Matrix = Array [1..9] of View_Line;

Var
   Rounds_Left: [External]Array [Spell_Name] of Unsigned;
   Direction: [External]Direction_Type;
   Maze: [External]Level;
   PosX,PosY,PosZ: [Byte,External]0..20;

   ViewDisplay:  [External]Unsigned;

(******************************************************************************)
[External]Function Show_Special (Member: [Unsafe]Party_Type:=0;  Current_Party_Size: Integer:=0):Boolean;External;
[External]Function Detected_Secret_Door (Member: Party_Type;  Current_Party_Size: Party_Size_Type;Rounds_Left: SpellDurationList):[Volatile]Boolean;External;
(******************************************************************************)

Function Sight_Blocked (Exit: Exit_Type): Boolean;

Begin
   Sight_Blocked:=Not (Exit in [Transparent,Passage]);
End;

(******************************************************************************)

Function Is_Special (Spot: Room_Record): Boolean;

Begin
   Is_Special:=(Maze.Special_Table[Spot.Contents].Special<>Nothing);
End;

(******************************************************************************)

Function Is_Stairs (Spot: Room_Record): Boolean;

Begin
   Is_Stairs:=(Maze.Special_Table[Spot.Contents].Special=Stairs);
End;

(******************************************************************************)

Procedure Get_Bearings (Spot: Room_Record; Var Up,Down,Left,Right: Exit_Type);

Begin
   Case Direction of
        North: Begin
                  Up:=Spot.North;
                  Down:=Spot.South;
                  Left:=Spot.West;
                  Right:=Spot.East;
               End;
        South: Begin
                  Up:=Spot.South;
                  Down:=Spot.North;
                  Left:=Spot.East;
                  Right:=Spot.West;
               End;
        East: Begin
                  Up:=Spot.East;
                  Down:=Spot.West;
                  Left:=Spot.North;
                  Right:=Spot.South;
               End;
        West: Begin
                  Up:=Spot.West;
                  Down:=Spot.East;
                  Left:=Spot.South;
                  Right:=Spot.North;
               End;
   End;
End;

(******************************************************************************)

Function Symbol_Type (Symbol: Exit_Type; Member: Party_Type;  Current_Party_Size: Integer): [Volatile]Char;

Begin
   Case Symbol of
            Passage:  Symbol_Type:=' ';
        Transparent:  If Not Show_Special (Member, Current_Party_Size) then
                         Symbol_Type:=' '
                      Else
                         Symbol_Type:='*';
             Secret:  If Detected_Secret_Door (Member,Current_Party_Size,Rounds_Left) then
                         Symbol_Type:='$'
                      Else
                         Symbol_Type:='#';
               Wall:  Symbol_Type:='#';
       Walk_Through:  If Not Show_Special (Member,Current_Party_Size) then
                         Symbol_Type:='#'
                      Else
                         Symbol_Type:=':';
              Door:  Symbol_Type:='+';
   End;
End;

(******************************************************************************)

Function Top_Row (Spot: Room_Record; Up,Down,Left,Right: Exit_Type; Member: Party_Type; Current_Party_Size: Integer): Line;

Var
   T: Line;

Begin
   If Sight_Blocked(Up) or Sight_Blocked(Left) then
       T:='#'
   Else
       T:=' ';

   T:=T+Symbol_Type (Up,Member,Current_Party_Size);

   If Sight_Blocked(Up) or Sight_Blocked(Right) then
       T:=T+'#'
   Else
       T:=T+' ';

   Top_Row:=T;
End;

(******************************************************************************)

Function Bottom_Row (Spot: Room_Record; Up,Down,Left,Right: Exit_Type; Member: Party_Type; Current_Party_Size: Integer): Line;

Var
   T: Line;

Begin
   If Sight_Blocked(Down) or Sight_Blocked(Left) then
       T:='#'
   Else
       T:=' ';

   T:=T+Symbol_Type (Down,Member,Current_Party_Size);

   If Sight_Blocked(Down) or Sight_Blocked(Right) then
       T:=T+'#'
   Else
       T:=T+' ';

   Top_Row:=T;
End;


(******************************************************************************)

Function Middle_Row (Spot: Room_Record; Up,Down,Left,Right: Exit_Type; Member: Party_Type;
                              Current_Party_Size: Integer;
                              Section: Horizontal_Section_Type:=Center): Line;

Var
   T: Line;

Begin
   T:='';
   If Section<>Right_S then
       T:=Symbol_Type (Left,Member,Current_Party_Size)
   Else
       T:=' ';

   If Is_Stairs (Spot) then
      T:=T+'@'
   Else
      If Is_Special(Spot) and Show_Special (Member,Current_Party_Size) then
          T:=T+'o'
      Else
          T:=T+'.';

   If Section<>Left_S then
       T:=T+Symbol_Type (Right,Member,Current_Party_Size)
   Else
       T:=T+' ';

   Middle_Row:=T;
End;

(******************************************************************************)

Function Graphic_Room_Generic (Spot: Room_Record; Section: Section_Type; Member: Party_Type;
                                       Current_Party_Size: Party_Size_Type;
                                       H_Section: Horizontal_Section_Type:=Center) : Side;

Var
   T: Side;
   Up, Down, Left, Right: Exit_Type;

Begin
   Get_Bearings (Spot,Up,Down,Left,Right);
   Case Section of
          Top:  T:=Top_Row (Spot,Up,Down,Left,Right,Member,Current_Party_Size);
       Bottom:  T:=Bottom_Row (Spot,Up,Down,Left,Right,Member,Current_Party_Size);
       Middle:  T:=Middle_Row (Spot,Up,Down,Left,Right,Member,Current_Party_Size,H_Section);
   End;
   Graphic_Room_Generic:=T;
End;

(******************************************************************************)

Function Graphic_Room (Spot: Room_Record; Section: Section_Type; Member: Party_Type;.
                               Current_Party_Size: Party_Size_Type;
                               H_Section: Horizontal_Section_Type:=Center_ Side;

Begin
   Graphic_Room:='   ';
   If Maze.Special_Table[Spot.Contents].Special<>Darkness then
      Graphic_Room:=Graphic_Room_Generic (Spot,Section,Member,Current_Party_Size,H_Section);
End;

(******************************************************************************)

Function Has_Light: [Volatile]Boolean;

Begin
   Has_Light:=(Rounds_Left[Lght]>0) or (Rounds_LeftCoLi]>0);
End;

(******************************************************************************)

Function Left_Side (Direction: Direction_Type; Section: Section_Type; Member: Party_Type;
                            Current_Party_Size: Party_Size_Type;
                            H_Section: Horizontal_Section_Type:=Left_S): Side;

Var
   Temp: Side;

Begin
   Temp:='   ';
   If Has_Light then
      Case Direction of
          North: If Maze.Room[PosX,PosY].West in [Passage,Transparent] then
                 If PosX>1 then
                    Temp:=Graphic_Room(Maze,Room[PosX-1,PosY],Section,Member,Current_Party_Size,H_Section)
                 Else
                    Temp:=Graphic_Room(Maze,Room[20,PosY],Section,Member,Current_Party_Size,H_Section);
          South: If Maze.Room[PosX,PosY].East in [Passage,Transparent] then
                 If PosX<20 then
                    Temp:=Graphic_Room(Maze,Room[PosX-1,PosY],Section,Member,Current_Party_Size,H_Section)
                 Else
                    Temp:=Graphic_Room(Maze,Room[20,PosY],Section,Member,Current_Party_Size,H_Section);
          East: If Maze.Room[PosX,PosY].North in [Passage,Transparent] then
                 If PosY>1 then
                    Temp:=Graphic_Room(Maze,Room[PosX,PosY-1],Section,Member,Current_Party_Size,H_Section)
                 Else
                    Temp:=Graphic_Room(Maze,Room[PosX,20],Section,Member,Current_Party_Size,H_Section);
          West: If Maze.Room[PosX,PosY].South in [Passage,Transparent] then
                 If PosY<20 then
                    Temp:=Graphic_Room(Maze,Room[PosX,PosY+1],Section,Member,Current_Party_Size,H_Section)
                 Else
                    Temp:=Graphic_Room(Maze,Room[PosX,1],Section,Member,Current_Party_Size,H_Section);
      End
   Else
      Temp:='   ';
   Left_Side:=Temp;
End;

(******************************************************************************)

Function Right_Side (Direction: Direction_Type; Section: Section_Type;
                             Member: Party_Type;
                             Current_Party_Size: Party_Size_Type): Side;

Begin
   Case Direction of
        North: Right_Side:=Left_Side (South,Section,Member,Current_Party_Size,Right_S);
        South: Right_Side:=Left_Side (North,Section,Member,Current_Party_Size,Right_S);
        East:  Right_Side:=Left_Side  (West,Section,Member,Current_Party_Size,Right_S);
        West:  Right_Side:=Left_Side  (East,Section,Member,Current_Party_Size,Right_S);
   End;
End;

(******************************************************************************)

Function Top_Side (Direction: Direction_Type; Section: Section_Type; Member: Party_Type;
                            Current_Party_Size: Party_Size_Type): Side;

Var
   Temp: Side;

Begin
   Temp:='   ';
   If Has_Light then
      Case Direction of
          North: If Maze.Room[PosX,PosY].North in [Passage,Transparent] then
                 If PosY>1 then
                    Temp:=Graphic_Room(Maze,Room[PosX,PosY-1],Section,Member,Current_Party_Size)
                 Else
                    Temp:=Graphic_Room(Maze,Room[PosX,20],Section,Member,Current_Party_Size);
          South: If Maze.Room[PosX,PosY].South in [Passage,Transparent] then
                 If PosY<20 then
                    Temp:=Graphic_Room(Maze,Room[PosX,PosY+1],Section,Member,Current_Party_Size)
                 Else
                    Temp:=Graphic_Room(Maze,Room[PosX,1],Section,Member,Current_Party_Size);
          East: If Maze.Room[PosX,PosY].South in [Passage,Transparent] then
                 If PosX<20 then
                    Temp:=Graphic_Room(Maze,Room[PosX+1,PosY],Section,Member,Current_Party_Size)
                 Else
                    Temp:=Graphic_Room(Maze,Room[1,PosY],Section,Member,Current_Party_Size);
          West: If Maze.Room[PosX,PosY].East in [Passage,Transparent] then
                 If PosX>1 then
                    Temp:=graphic_Room(Maze,Room[PosX-1,PosY],Section,Member,Current_Party_Size)
                 Else
                    Temp:=Graphic_Room(Maze,Room[20,PosY],Section,Member,Current_Party_Size);
      End
   Else
      Temp:='   ';
   Top_Side:=Temp;
End;

(******************************************************************************)

Function Bottom_Side (Direction: Direction_Type; Section: Section_Type; Member: Party_Type;
                             Current_Party_Size: Party_Size_Type): Side;

Begin
   Case Direction of
        South: Bottom_Side:=Top_Side (North,Section,Member,Current_Party_Size);
        North: Bottom_Side:=Top_Side (South,Section,Member,Current_Party_Size);
         West: Bottom_Side:=Top_Side  (East,Section,Member,Current_Party_Size);
         East: Bottom_Side:=Top_Side  (West,Section,Member,Current_Party_Size);
   End;
End;

(******************************************************************************)

Procedure Display_View (View: View_Matrix);

Var
   Bright: Unsigned;

Begin
   Bright:=0;
   If Has_Light then Bright:=Bright+SMG$M_BOLD;

   SMG$Put_Line (ViewDisplay,
       '   '
       +View[1],1);
   SMG$Put_Line (ViewDisplay,
       '   '
       +View[2],1);
   SMG$Put_Line (ViewDisplay,
       '   '
       +View[3],1);

   SMG$Put_Chars (ViewDisplay,
       '   '
       +View[4,1]
       +View[4,2]
       +View[4,3],
       ,,1,);
   SMG$Put_Chars (ViewDisplay,
       View[4,4]
       +View[4,5]
       +View[4,6],
       ,,,Bright);
   SMG$Put_Line (ViewDisplay,
       View[4,7]
       +View[4,8]
       +View[4,9]);

   SMG$Put_Chars (ViewDisplay,
       '   '
       +View[5,1]
       +View[5,2]
       +View[5,3],
       ,,1,);
   SMG$Put_Chars (ViewDisplay,
       View[5,4]
       +View[5,5]
       +View[5,6],
       ,,,Bright);
   SMG$Put_Line (ViewDisplay,
       View[5,7]
       +View[5,8]
       +View[5,9]);

   SMG$Put_Chars (ViewDisplay,
       '   '
       +View[6,1]
       +View[6,2]
       +View[6,3],
       ,,1,);
   SMG$Put_Chars (ViewDisplay,
       View[6,4]
       +View[6,5]
       +View[6,6],
       ,,,Bright);
   SMG$Put_Line (ViewDisplay,
       View[6,7]
       +View[6,8]
       +View[6,9]);

   SMG$Put_Line (ViewDisplay,
       '   '
       +View[7],
       1);
   SMG$Put_Line (ViewDisplay,
       '   '
       +View[8],
       1);
   SMG$Put_Line (ViewDisplay,
       '   '
       +View[9],
       1);

End;

(******************************************************************************)

Function Looks_Like_Wall (Exit: Exit_Type): Boolean;

Begin
   Looks_Like_Wall:=Not (Exit in [Passage,Transparent]);
End;

(******************************************************************************)

{ TODO: Enter this code }

[Global]Procedure Print_View (Direction: Direction_Type; Member: Party_Type;  Current_Party_Size: Party_Size_Type);

Begin { Print View }

{ TODO: Enter this code }

End;  { Print View }
End.  { View }
