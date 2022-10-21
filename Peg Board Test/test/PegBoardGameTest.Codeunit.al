codeunit 50700 "Peg Board Game Test"
{
    Subtype = Test;

    [Test]
    procedure NewGame()
    var
        PegBoard: Record "Peg Board";
        PegSolitareMgt: Codeunit "Peg Solitare Mgt.";
        GameNo: Integer;
    begin
        //  [GIVEN] Current last game
        if PegBoard.FindLast() then
            GameNo := PegBoard."Game No."
        else
            GameNo := 0;

        // [WHEN] New game is created
        PegSolitareMgt.InitBoard();

        // [THEN] New game is one higher
        PegBoard.FindLast();
        LibraryAssert.AreEqual(PegBoard."Game No.", GameNo + 1, 'Game was not created.');
    end;

    var
        LibraryAssert: Codeunit "Library Assert";
}