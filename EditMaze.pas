[Inherit ('Types','SMGRTL','LibRtl')]Module Edit_Maze;

{ This module facilitates the editing of a level of a maze }

Const
   Space_Char        = '.';
   Transparent_Char  = '*';
   Walk_Through_Char = ':';
   Door_Char         = '+';
   Secret_Char       = '$';
   Wall_Char         = '#';

   ZeroOrd = Ord('0');
   Up_Arrow          = CHR(18);                Down_Arrow      = CHR(19);
   Left_Arrow        = CHR(20);                Right_Arrow     = CHR(21);

Type
   Floor_Type = Array [1..20,1..20] of Room_Record;
   Print_Mode = (Specials,Rooms,Normal);
   LevelFile = File of Level;

Var
   Monster:                     List_of_monsters;
   ScreenDisplay:               [External]Unsigned;
   PrintMazeFile:               [External]Text;
   MazeFile:                    [External]LevelFile;
   Print_Queue:                 [External,Volatile]Line;
   Answer:                      Char;
   Level_Loaded:                Integer;
   Need_to_Load,Need_to_Save:   Boolean;
   SPKind_Name:                 [Readonly]Array [SPKind] of Packed Array [1..15] of char;
   Special_Kind_Name:           [Readonly]Array [Special_Kind] of Packed Array [1..15] of char;
   Floor_Number:                Integer;
   Floor:                       Level;
   Need_to_load_Monsters:       Boolean;

Value
   Level_Loaded:=0;
   Need_to_Load:=True;   Need_to_Save:=False;   Need_to_Load_Monsters:=True;

SPKind_Name[NothingSpecial]    := 'Nothing';
SPKind_Name[Msg]               := 'Message';
SPKind_Name[Msg_Item_Given]    := 'Msg/Item';
SPKind_Name[Msg_Pool]          := 'Msg/Pool';
SPKind_Name[Msg_Hidden_Item]   := 'Msg/Hddn item';
SPKind_Name[Msg_Need_Item]     := 'Msg/need_item';
SPKind_Name[Msg_Lower_AC]      := 'Msg/Lower AC';
SPKind_Name[Msg_Raise_AC]      := 'Msg/Raise AC';
SPKind_Name[Msg_Goto_Castle]   := 'Msg/goto_castle';
SPKind_Name[Msg_Encounter]     := 'Msg/encounter';
SPKind_Name[Riddle]            := 'Riddle';
SPKind_Name[Fee]               := 'Fee';
SPKind_Name[Msg_Trade_Item]    := 'Trade items';
SPKind_Name[Msg_Picture]       := 'Msg/Picture';
SPKind_Name[Unknown]           := 'Unknown';


Special_Kind[Nothing]          := 'Nothing';
Special_Kind[Stairs]           := 'Stairs';
Special_Kind[Pit]              := 'Pit';
Special_Kind[Chute]            := 'Chute';
Special_Kind[Rotate]           := 'Rotate';
Special_Kind[Darkness]         := 'Darkness';
Special_Kind[Teleport]         := 'Teleport';
Special_Kind[Damage]           := 'Damage';
Special_Kind[Elevator]         := 'Elevator';
Special_Kind[Rock]             := 'Rock';
Special_Kind[Antimagic]        := 'AntiMagic';
Special_Kind[SPFeature]        := 'Special Feature';
Special_Kind[An_Encounter]     := 'Encounter';
Special_Kind[Cliff]            := 'Cliff';

(******************************************************************************)
[External]Procedure Delay (Seconds: Real);External;
[External]Function String (Num: Integer; Len: Integer:=0):Line;external;
[External]Procedure Cursor;External;
[External]Procedure No_Cursor;External;
[External]Procedure Get_Num (Var Number: Integer; Display: Unsigned);External;
[External]Function Make_Choice (Choices: Char_Set; Time_Out: Integer:=-1;
    Time_Out_Char: Char:=' '): Char;External;
[External]Function Yes_or_No (Time_Out: Integer:=-1;
    Time_Out_Char: Char:=' '): [Volatile]Char;External;
(******************************************************************************)

Procedure Print_Level;

{ This procedure will print the name of the current level on the screen }

Begin { Print Level }
   If Level_Loaded>0 then SMG$_Put_Chars (ScreenDisplay,
       'Current Level:  '
       +String(Level_Loaded),1,1)
End;  { Print Level }

(******************************************************************************)

Procedure Print_Load_Choices;

{ This procedure will print a menu of levels to choose from }

Begin { Print Load Choices }
   SMG$Put_Chars (ScreenDisplay,
       'Load Level',5,22,,1);
   SMG$Put_Chars (ScreenDisplay,
       '---- -----',6,22,,1);
   SMG$Put_Chars (ScreenDisplay,
       ' A) Load level 1',7,22);
   SMG$Put_Chars (ScreenDisplay,
       ' B) Load level 2',8,22);
   SMG$Put_Chars (ScreenDisplay,
       ' C) Load level 3',9,22);
   SMG$Put_Chars (ScreenDisplay,
       ' D) Load level 4',10,22);
   SMG$Put_Chars (ScreenDisplay,
       ' E) Load level 5',11,22);
   SMG$Put_Chars (ScreenDisplay,
       ' F) Load level 6',12,22);
   SMG$Put_Chars (ScreenDisplay,
       ' G) Load level 7',13,22);
   SMG$Put_Chars (ScreenDisplay,
       ' H) Load level 8',14,22);
   SMG$Put_Chars (ScreenDisplay,
       ' I) Load level 9',15,22);
   SMG$Put_Chars (ScreenDisplay,
       ' J) Load level 10',16,22);
   SMG$Put_Chars (ScreenDisplay,
       ' K) Load level Hell 1',17,22);
   SMG$Put_Chars (ScreenDisplay,
       ' L) Load level Hell 2',18,22);
   SMG$Put_Chars (ScreenDisplay,
       ' M) Load level Hell 3',7,42);
   SMG$Put_Chars (ScreenDisplay,
       ' N) Load level Hell 4',8,42);
   SMG$Put_Chars (ScreenDisplay,
       ' O) Load level Hell 5',9,42);
   SMG$Put_Chars (ScreenDisplay,
       ' P) Load level Hell 6',10,42);
   SMG$Put_Chars (ScreenDisplay,
       ' Q) Load level Hell 7',11,42);
   SMG$Put_Chars (ScreenDisplay,
       ' R) Load level Hell 8',12,42);
   SMG$Put_Chars (ScreenDisplay,
       ' S) Load level Hell 9',13,42);
   SMG$Put_Chars (ScreenDisplay,
       ' T) Don''t load a level',14,42);
   SMG$Put_Chars (ScreenDisplay,
       ' Which?',19,32);
End;  { Print Load Choices }

(******************************************************************************)

Procedure Load_Floor (Number: Integer; Typed_Char: Char);

{ This procedure will load a specified floor.  If the floor file doesn't
  exist, a blank one will be created. }

Var
   Name: Line;

Begin { Load Floor }

  { Set the appropriate flags, and build the filename for the specified level }

   Floor_Number:=Number;  Level_Loaded:=Number;  Need_to_Load:=False;
   Name:='STONE_MAZE:MAZE'+Typed_Char+'.DAT;1'

  { Attempt to open the level file }

  Repeat
     Open (MazeFile,Name,Unknown,Sharing:=READONLY);
  Until (Status(MazeFile)=PAS$K_SUCCESS);
  Reset (MazeFile);

  If Not EOF(MazeFile) then
     Begin { If the file is not empty, read the level }
        Read (MazeFile,Floor);
        Close (MazeFile);
     End   { If the file is not empty, read the level }
  Else
     Begin { If the file IS empty, create the file with a null level }
         Floor:=Zero;
         Rewrite (MazeFile);
         Write (MazeFile,Floor);
         Close (MazeFile);
     End;  { If the file IS empty, create the file with a null level }

  SMG$Put_Chars (ScreenDisplay,
      'Loaded.',23,36,,1);
  Delay (1);
End;  { Load Floor }

(******************************************************************************)

Procedure Load_Level (Var Floor: Level);

{ This procedure will allow the user to load a level to be edited }

Var
   Answer: Char;

Begin { Load Level }

  { Print a menu of choices }

   SMG$Begin_Display_Update (ScreenDisplay);
   SMG$Erase_Display (ScreenDisplay);
   Print_Level;
   Print_Load_Choices;
   SMG$End_Display_Update();

  { Make and handle choice }

   Answer:=Make_Choice(['A'..'T']);
   If Answer<>'T' then
      If (Ord(Answer)-64)<>Floor_Number then Load_Floor (Ord(Answer)-64,Answer)
End;  { Load Level }

(******************************************************************************)

Procedure Save_Level (Floor: Level);

Var
  Answer: Char;

Begin
  SMG$Begin_Display_Update (ScreenDisplay);
  SMG$Erase_Display (ScreenDisplay);
  Print_Level;
  SMG$Put_Chars (ScreenDisplay,
      'Save Level',5,32,,1);
  SMG$Put_Chars (ScreenDisplay,
      '---- -----',6,32,,1);
  SMG$Put_Chars (ScreenDisplay,
      ' A) Save level '+String(Level_Loaded),7,32);
  SMG$Put_Chars (ScreenDisplay,
      ' Q) Don''t save a level',8,32);
  SMG$Put_Chars (ScreenDisplay,
      ' Which?',10,32);
  Answer:=Make_Choice (['A','Q']);
  If Answer<>'Q' then
     Begin
        Answer:=Chr(Level_loaded+64);
        Open (MazeFile,
            'STONE_MAZE'+ANSWER+'.DAT;1',Unknown);
        ReWrite (MazeFile,Floor);
        Close (MazeFile);
        SMG$Put_Chars (ScreenDisplay,
            'Saved.',23,36,,1);
        Need_to_Save:=False;
     End;
End;

(******************************************************************************)

Procedure Check_Monsters;

[External]Procedure Read_Monsters (Var Monster: List_of_Monsters);External;

Begin
  If Need_to_Load_Monsters then
     Begin
        Read_Monsters (Monster);  Need_to_Load_Monsters:=False;
     End;
End;

(******************************************************************************)

Procedure Print_Encounter_Menu (Index: Integer;  Var Enc: Encounter);

Var
   T: Line;

Begin
   Check_Monsters;
   SMG$Begin_Display_Update (ScreenDisplay);
   SMG$Erase_Display (ScreenDisplay);
   SMG$Set_Cursor_ABS (ScreenDisplay,3,1);
   SMG$Put_Line (ScreenDisplay,
       '        Edit Encounter '+String(Index,1),1,1);
   T:='        A) Base Monster: '
       +String(Enc.Base_Monster_Number)
       +'(';
   If Enc.Base_Monster_Number>0 then
      T:=T
          +Monster[Enc.Base_Monster_Number].Real_Name
          +')'
   Else
      T:=T+'None)';
   SMG$Put_Line (ScreenDisplay, T);
   T:='        B) Random addition:  '
       +String(Enc.addition.X)
       +'D'
       +String(Enc.addition.Y);
   If Enc.Addition.Z>-1 then
       T:=T+'+';
   T:=T+String (Enc.Addition.Z);
   SMG$Put_Line (ScreenDisplay,T);
   SMG$Put_Line (ScreenDisplay,
       '         C) Probability: '
       +String(Enc.Probability));
   SMG$Put_Line (ScreenDisplay,
       '         E) Exit',2);
   SMG$Put_Line (ScreenDisplay,
       '         Which?');
   Print_Level;
   SMG$End_Display_Update (ScreenDisplay);
End;

(******************************************************************************)

{ TODO: Enter this code }

[Global]Procedure Edit_Maze (Var MazeFile: LevelFile);
Begin { Edit Maze }
{ TODO: Enter this code }
End;  { Edit Maze }
End.  { Edit Maze }
