codeunit 50700 "Peg Board Game Test"
{
    Subtype = Test;

    [Test]
    procedure NewGame()
    var
        PegBoard: Record "Peg Board";
        PegBoards: TestPage "Peg Boards";
        GameNo: Integer;
    begin
        //  [GIVEN] Current last game
        if PegBoard.FindLast() then
            GameNo := PegBoard."Game No."
        else
            GameNo := 0;

        // [WHEN] New game is created
        PegBoards.OpenView();
        PegBoards.NewGame.Invoke();

        // [THEN] New game is one higher
        PegBoard.FindLast();
        LibraryAssert.AreEqual(PegBoard."Game No.", GameNo + 1, 'Game was not created.');
    end;

    [ConfirmHandler]
    procedure ConfirmHandler(Question: Text[1024]; var Reply: Boolean);
    begin
        case Question of
            'Would you like to create a new game?':
                Reply := true;
            else
                Reply := true;
        end;
    end;

    var
        LibraryAssert: Codeunit "Library Assert";
}