[Inherit ('SYS$LIBRARY:STARLET','Types','SMGRTL')]Module View3d;

Const
  Diamond_Join = 0;
  Clear_Char_Near = ' ';
  Clear_Char_Middle = ' ';
  Clear_Char_Far = ' ';

Type
   Vertex = Packed Array [1..4] of Integer;
  NewISpot = Record
            direction: Direction_Type;
            kind: Area_Type;
            front,left,right: Exit_Type;
            contents: [Byte]0..15; {index of Special_Table }
            rowX,rowY: [Byte]1..20;
          End;

Var
  ViewDisplay: [External]Unsigned;
  renderNear: Unsigned;
  renderMiddle: Unsigned;
  renderFar: Unsigned;

Value
  renderNear := SMG$M_NORMAL;
  renderMiddle := SMG$M_NORMAL;
  renderFar := SMG$M_NORMAL;

{********************************************************************************************************************}
[External]Function getNearCenter(Direction: Direction_Type): NewISpot;External;
[External]Function getMiddleCenter(Direction: Direction_Type): NewISpot;External;
[External]Function getCenterFar(Direction: Direction_Type): NewISpot;External;
[External]Function getLeftLeftFar(Direction: Direction_Type): NewISpot;External;
[External]Function getLeftFar(Direction: Direction_Type): NewISpot;External;
[External]Function getRightFar(Direction: Direction_Type): NewISpot;External;
[External]Function getRightRightFar(Direction: Direction_Type): NewISpot;External;
[External]Function getCenterMiddle(Direction: Direction_Type): NewISpot;External;
[External]Function getLeftMiddle(Direction: Direction_Type): NewISpot;External;
[External]Function getRightMiddle(Direction: Direction_Type): NewISpot;External;
[External]Function getCenterNear(Direction: Direction_Type): NewISpot;External;
[External]Function getLeftNear(Direction: Direction_Type): NewISpot;External;
[External]Function getRightNear(Direction: Direction_Type): NewISpot;External;
{********************************************************************************************************************}
{**************************************************** NEAR ROW ******************************************************}
{********************************************************************************************************************}

Procedure wallNearFrontCenter;

var
  col, row: integer;

Begin
    For col := 4 to 20 do
      For row := 1 to 6 do
         SMG$Put_Chars (ViewDisplay, Clear_Char_Near, row, col);

    { Vertical line }
    SMG$Draw_Line(ViewDisplay, 1, 3, 7, 3, renderNear);
    SMG$Draw_Line(ViewDisplay, 1, 21, 7, 21, renderNear);

    { Horizontal Line }
    SMG$Draw_Line(ViewDisplay, 7, 3, 7, 21);
End;

{********************************************************************************************************************}

Procedure wallNearFrontLeft;

Var
   row, col: Integer;

Begin
    For col := 1 to 2 do
      For row := 1 to 16 do
        SMG$Put_Chars(ViewDisplay,Clear_Char_Near,row,col);

    SMG$Draw_Line(ViewDisplay, 1, 3, 7, 3, renderNear);
    SMG$Draw_Line(ViewDisplay, 7, 1, 7, 3, renderNear);
    SMG$Draw_Char(ViewDisplay, Diamond_Join, 7, 3, renderNear);
End;

{********************************************************************************************************************}

Procedure wallNearFrontRight;

Var
   row, col: Integer;

Begin
    For col := 22 to 23 do
      For row := 1 to 16 do
        SMG$Put_Chars(ViewDisplay,Clear_Char_Near,row,col);

    SMG$Draw_Line(ViewDisplay, 1, 21, 7, 21, renderNear);
    SMG$Draw_Line(ViewDisplay, 7, 21, 7, 23, renderNear);
    SMG$Draw_Char(ViewDisplay, Diamond_Join, 7, 21, renderNear);
End;

{********************************************************************************************************************}

Procedure wallNearLeftSide;

Begin
    SMG$Put_Chars (ViewDisplay, Clear_Char_Near, 1, 1);
    SMG$Put_Chars (ViewDisplay, Clear_Char_Near, 2, 1);
    SMG$Put_Chars (ViewDisplay, Clear_Char_Near, 3, 1);
    SMG$Put_Chars (ViewDisplay, Clear_Char_Near, 4, 1);
    SMG$Put_Chars (ViewDisplay, Clear_Char_Near, 5, 1);
    SMG$Put_Chars (ViewDisplay, Clear_Char_Near, 6, 1);
    SMG$Put_Chars (ViewDisplay, Clear_Char_Near, 7, 1);
    SMG$Put_Chars (ViewDisplay, Clear_Char_Near, 8, 1);

    SMG$Put_Chars (ViewDisplay, Clear_Char_Near, 1, 2);
    SMG$Put_Chars (ViewDisplay, Clear_Char_Near, 2, 2);
    SMG$Put_Chars (ViewDisplay, Clear_Char_Near, 3, 2);
    SMG$Put_Chars (ViewDisplay, Clear_Char_Near, 4, 2);
    SMG$Put_Chars (ViewDisplay, Clear_Char_Near, 5, 2);
    SMG$Put_Chars (ViewDisplay, Clear_Char_Near, 6, 2);
    SMG$Put_Chars (ViewDisplay, Clear_Char_Near, 7, 2);

    SMG$Put_Chars(ViewDisplay, '/', 8, 2, renderNear);
    SMG$Put_Chars(ViewDisplay, '/', 9, 1, renderNear);

    SMG$Draw_Line (ViewDisplay, 1, 3, 6, 3);
    SMG$Draw_Char(ViewDisplay, Diamond_Join, 7, 3, renderNear);
End;

{********************************************************************************************************************}

Procedure wallNearRightSide;

Begin
    SMG$Put_Chars (ViewDisplay, Clear_Char_Near, 1, 22);
    SMG$Put_Chars (ViewDisplay, Clear_Char_Near, 2, 22);
    SMG$Put_Chars (ViewDisplay, Clear_Char_Near, 3, 22);
    SMG$Put_Chars (ViewDisplay, Clear_Char_Near, 4, 22);
    SMG$Put_Chars (ViewDisplay, Clear_Char_Near, 5, 22);
    SMG$Put_Chars (ViewDisplay, Clear_Char_Near, 6, 22);
    SMG$Put_Chars (ViewDisplay, Clear_Char_Near, 7, 22);

    SMG$Put_Chars (ViewDisplay, Clear_Char_Near, 1, 23);
    SMG$Put_Chars (ViewDisplay, Clear_Char_Near, 2, 23);
    SMG$Put_Chars (ViewDisplay, Clear_Char_Near, 3, 23);
    SMG$Put_Chars (ViewDisplay, Clear_Char_Near, 4, 23);
    SMG$Put_Chars (ViewDisplay, Clear_Char_Near, 5, 23);
    SMG$Put_Chars (ViewDisplay, Clear_Char_Near, 6, 23);
    SMG$Put_Chars (ViewDisplay, Clear_Char_Near, 7, 23);
    SMG$Put_Chars (ViewDisplay, Clear_Char_Near, 8, 23);

    SMG$Put_Chars(ViewDisplay, '\', 8, 22, renderNear);
    SMG$Put_Chars(ViewDisplay, '\', 9, 23, renderNear);

    SMG$Draw_Line (ViewDisplay, 1, 21, 6, 21);
    SMG$Draw_Char(ViewDisplay, Diamond_Join, 7, 21, renderNear);
End;

{********************************************************************************************************************}
{**************************************************** MIDDLE ROW ****************************************************}
{********************************************************************************************************************}

Procedure wallMiddleFrontCenter;

Var
   row, col: Integer;

Begin
    For col := 6 to 17 do
      For row := 1 to 3 do
        SMG$Put_Chars(ViewDisplay,Clear_Char_Middle,row,col);

    SMG$Draw_Line(ViewDisplay, 1,  6, 4,  6, renderMiddle);
    SMG$Draw_Line(ViewDisplay, 4,  6, 4, 18, renderMiddle);
    SMG$Draw_Line(ViewDisplay, 1, 18, 4, 18, renderMiddle);

    SMG$Draw_Char(ViewDisplay, Diamond_Join, 4, 6, renderMiddle);
    SMG$Draw_Char(ViewDisplay, Diamond_Join, 4, 18, renderMiddle);
End;

{********************************************************************************************************************}

Procedure wallMiddleFrontLeft;

Var
   row, col: Integer;

Begin
    For col := 1 to 5 do
      For row := 1 to 3 do
        SMG$Put_Chars(ViewDisplay,Clear_Char_Middle,row,col);

    SMG$Draw_Line(ViewDisplay, 4, 1, 4, 6, renderMiddle);
    SMG$Draw_Line(ViewDisplay, 1, 6, 4, 6, renderMiddle);
    SMG$Draw_Char(ViewDisplay, Diamond_Join, 4, 6, renderMiddle);
End;

{********************************************************************************************************************}

Procedure wallMiddleFrontRight;

Var
   row, col: Integer;

Begin
    For col := 19 to 23 do
      For row := 1 to 3 do
        SMG$Put_Chars(ViewDisplay,Clear_Char_Middle,row,col);

    SMG$Draw_Line(ViewDisplay, 1, 18, 4, 18, renderMiddle);
    SMG$Draw_Line(ViewDisplay, 4, 18, 4, 23, renderMiddle);
    SMG$Draw_Char(ViewDisplay, Diamond_Join, 4, 18, renderMiddle);
End;

{********************************************************************************************************************}

Procedure wallMiddleLeftSide;

Begin
    SMG$Put_Chars(ViewDisplay, Clear_Char_Middle, 1, 4, renderMiddle);
    SMG$Put_Chars(ViewDisplay, Clear_Char_Middle, 2, 4, renderMiddle);
    SMG$Put_Chars(ViewDisplay, Clear_Char_Middle, 3, 4, renderMiddle);
    SMG$Put_Chars(ViewDisplay, Clear_Char_Middle, 4, 4, renderMiddle);
    SMG$Put_Chars(ViewDisplay, Clear_Char_Middle, 5, 4, renderMiddle);

    SMG$Put_Chars(ViewDisplay, Clear_Char_Middle, 1, 5, renderMiddle);
    SMG$Put_Chars(ViewDisplay, Clear_Char_Middle, 2, 5, renderMiddle);
    SMG$Put_Chars(ViewDisplay, Clear_Char_Middle, 3, 5, renderMiddle);
    SMG$Put_Chars(ViewDisplay, Clear_Char_Middle, 4, 5, renderMiddle);

    SMG$Draw_Line(ViewDisplay, 1, 3, 6, 3, renderMiddle);
    SMG$Draw_Char(ViewDisplay, Diamond_Join, 7, 3, renderMiddle);

    SMG$Put_Chars(ViewDisplay, '/', 6, 4, renderMiddle); { Wall bottom }
    SMG$Put_Chars(ViewDisplay, '/', 5, 5, renderMiddle); { Wall bottom }

    SMG$Draw_Line(ViewDisplay, 1, 6, 3, 6, renderMiddle);
    SMG$Draw_Char(ViewDisplay, Diamond_Join, 4, 6, renderMiddle);
End;

{********************************************************************************************************************}

Procedure wallMiddleRightSide;

Begin
    SMG$Put_Chars(ViewDisplay, Clear_Char_Middle, 1, 19, renderMiddle);
    SMG$Put_Chars(ViewDisplay, Clear_Char_Middle, 2, 19, renderMiddle);
    SMG$Put_Chars(ViewDisplay, Clear_Char_Middle, 3, 19, renderMiddle);
    SMG$Put_Chars(ViewDisplay, Clear_Char_Middle, 4, 19, renderMiddle);

    SMG$Put_Chars(ViewDisplay, Clear_Char_Middle, 1, 20, renderMiddle);
    SMG$Put_Chars(ViewDisplay, Clear_Char_Middle, 2, 20, renderMiddle);
    SMG$Put_Chars(ViewDisplay, Clear_Char_Middle, 3, 20, renderMiddle);
    SMG$Put_Chars(ViewDisplay, Clear_Char_Middle, 4, 20, renderMiddle);
    SMG$Put_Chars(ViewDisplay, Clear_Char_Middle, 5, 20, renderMiddle);

    SMG$Draw_Line(ViewDisplay, 1, 18, 3, 18, renderMiddle);
    SMG$Draw_Char(ViewDisplay, Diamond_Join, 4, 18, renderMiddle);

    SMG$Put_Chars(ViewDisplay, '\', 5, 19, renderMiddle);
    SMG$Put_Chars(ViewDisplay, '\', 6, 20, renderMiddle);

    SMG$Draw_Line(ViewDisplay, 1, 21, 6, 21, renderMiddle);
    SMG$Draw_Char(ViewDisplay, Diamond_Join, 7, 21, renderMiddle);
End;

{********************************************************************************************************************}
{****************************************************** FAR ROW *****************************************************}
{********************************************************************************************************************}

Procedure wallFarFrontLeftLeft;

Begin
    SMG$Draw_Line(ViewDisplay, 1, 1, 1, 2, renderFar);
End;

{********************************************************************************************************************}

Procedure wallFarFrontLeft;

Begin
  SMG$Draw_Line(ViewDisplay, 1, 2, 1, 9, renderFar);
End;

{********************************************************************************************************************}

Procedure wallFarFrontCenter;

Begin
    SMG$Draw_Line(ViewDisplay, 1, 9, 1, 15, renderFar);
End;

{********************************************************************************************************************}

Procedure wallFarFrontRight;

Begin
    SMG$Draw_Line(ViewDisplay, 1, 15, 1, 22, renderFar);
End;

{********************************************************************************************************************}

Procedure wallFarFrontRightRight;

Begin
    SMG$Draw_Line(ViewDisplay, 1, 22, 1, 23, renderFar);
End;

{********************************************************************************************************************}

Procedure wallFarLeftLeftSide;

Begin
    SMG$Draw_Char(ViewDisplay, Diamond_Join, 1, 2, renderFar);
    SMG$Put_Chars(ViewDisplay, '/', 2, 1, renderFar);
End;

{********************************************************************************************************************}

Procedure wallFarLeftSide;

Begin
    SMG$Put_Chars(ViewDisplay, Clear_Char_Far, 1, 7, renderFar);
    SMG$Put_Chars(ViewDisplay, Clear_Char_Far, 2, 7, renderFar);

    SMG$Put_Chars(ViewDisplay, Clear_Char_Far, 1, 8, renderFar);

    SMG$Put_Chars(ViewDisplay, '/', 2, 8, renderFar);
    SMG$Put_Chars(ViewDisplay, '/', 3, 7, renderFar);

    SMG$Draw_Line(ViewDisplay, 1, 6, 3, 6, renderFar);

    SMG$Draw_Char(ViewDisplay, Diamond_Join, 1, 9, renderFar);
    SMG$Draw_Char(ViewDisplay, Diamond_Join, 4, 6, renderFar);
End;

{********************************************************************************************************************}

Procedure wallFarRightSide;

Begin
    SMG$Put_Chars(ViewDisplay, Clear_Char_Far, 1, 16, renderFar);

    SMG$Put_Chars(ViewDisplay, Clear_Char_Far, 1, 17, renderFar);
    SMG$Put_Chars(ViewDisplay, Clear_Char_Far, 2, 17, renderFar);

    SMG$Put_Chars(ViewDisplay, '\', 2, 16, renderFar);
    SMG$Put_Chars(ViewDisplay, '\', 3, 17, renderFar);
    SMG$Draw_Line(ViewDisplay, 1, 18, 3, 18, renderFar);

    SMG$Draw_Char(ViewDisplay, Diamond_Join, 1, 15, renderFar);
    SMG$Draw_Char(ViewDisplay, Diamond_Join, 4, 18, renderFar);
End;

{********************************************************************************************************************}

Procedure wallFarRightRightSide;

Begin
    SMG$Put_Chars(ViewDisplay, '\', 2, 23, renderFar);
    SMG$Draw_Char(ViewDisplay, Diamond_Join, 1, 22, renderFar);
End;

{********************************************************************************************************************}

Function looksLikeWall(exit: Exit_Type): Boolean;

Begin
  return (exit in [Wall,Door,Walk_Through,Secret]);
End;

{********************************************************************************************************************}

[Global]Procedure far(leftLeftRoom: NewISpot; leftRoom: NewISpot; centerRoom: NewISpot; rightRoom: NewISpot; rightRightRoom: NewISpot);

Begin
   if (looksLikeWall(leftLeftRoom.front)) then
      wallFarFrontLeftLeft;

    if (looksLikeWall(leftRoom.front)) then
      wallFarFrontLeft;

    if (looksLikeWall(centerRoom.front)) then
      wallFarFrontCenter;

    if (looksLikeWall(rightRoom.front)) then
      wallFarFrontRight;

    if (looksLikeWall(rightRightRoom.front)) then
      wallFarFrontRightRight;

    if (looksLikeWall(leftRoom.left)) then
      wallFarLeftLeftSide;

    if (looksLikeWall(centerRoom.left)) then
      wallFarLeftSide;

    if (looksLikeWall(centerRoom.right)) then
      wallFarRightSide;

    if (looksLikeWall(rightRoom.right)) then
      wallFarRightRightSide;
End;

{********************************************************************************************************************}

Procedure middle(leftRoom: NewISpot; centerRoom: NewISpot; rightRoom: NewISpot);

Begin
  if (looksLikeWall(leftRoom.front)) then
    Begin
      wallMiddleFrontLeft;
    End;
  if (looksLikeWall(rightRoom.front)) then
    Begin
      wallMiddleFrontRight;
    End;
  if (looksLikeWall(centerRoom.front)) then
    Begin
      wallMiddleFrontCenter;
    End;

  if (looksLikeWall(centerRoom.left)) then
    Begin
      wallMiddleLeftSide;
    End;

  if (looksLikeWall(centerRoom.right)) then
    Begin
      wallMiddleRightSide;
    End;
End;

{********************************************************************************************************************}

Procedure near(leftRoom: NewISpot; centerRoom: NewISpot; rightRoom: NewISpot);

Begin
  if (looksLikeWall(leftRoom.front)) then
    Begin
      wallNearFrontLeft;
    End;
  if (looksLikeWall(rightRoom.front)) then
    Begin
      wallNearFrontRight;
    End;
  if (looksLikeWall(centerRoom.front)) then
    Begin
      wallNearFrontCenter;
    End;
  if (looksLikeWall(centerRoom.left)) then
    Begin
      wallNearLeftSide;
    End;
  if (looksLikeWall(centerRoom.right)) then
    Begin
      wallNearRightSide;
    End;
End;

{********************************************************************************************************************}

[Global]Procedure printView3D (Direction: Direction_Type; Member: Party_Type; Current_Party_Size: Party_Size_Type);

var
  leftNear,centerNear,rightNear: NewISpot;

Begin
  SMG$Begin_Display_Update(ViewDisplay);

  far(
      getLeftLeftFar(Direction),
      getLeftFar(Direction),
      getCenterFar(Direction),
      getRightFar(Direction),
      getRightRightFar(Direction)
  );
  middle(
    getLeftMiddle(Direction),
    getCenterMiddle(Direction),
    getRightMiddle(Direction)
  );

  leftNear:=getLeftNear(Direction);
  centerNear:=getCenterNear(Direction);
  rightNear:=getRightNear(Direction);

  near(
    leftNear,
    centerNear,
    rightNear
  );

  SMG$End_Display_Update(ViewDisplay);
End;
End.
