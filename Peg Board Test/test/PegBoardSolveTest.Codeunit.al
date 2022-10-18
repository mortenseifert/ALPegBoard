codeunit 50701 "Peg Board Solve Test"
{
    Subtype = Test;
    [HandlerFunctions('ConfirmHandler')]
    [Test]
    procedure FirstMove()
    var
        PegBoard: Record "Peg Board";
        PegBoards: TestPage "Peg Boards";
        NewBoardEntryNo: Integer;
    begin
        // [GIVEN] New Gave
        InitNewGame();
        PegBoard.FindLast();
        NewBoardEntryNo := PegBoard."Entry No.";

        // [WHEN] Making First move
        PegBoards.OpenView();
        PegBoards.Last();
        PegBoards.NextMove.Invoke();

        // [THEN] New board creates only one new board. Other three boards are duplicates.
        PegBoard.SetFilter("Entry No.", '>%1', NewBoardEntryNo);
        LibraryAssert.AreEqual(PegBoard.Count(), 1, 'Only 1 board on new game.');
        LibraryAssert.AreEqual(PegBoard.Board, '  ***    *O*  ***O*****************  ***    ***  ', 'Board after first move');
    end;

    [HandlerFunctions('ConfirmHandler')]
    [Test]
    procedure SecondMove()
    var
        PegBoard: Record "Peg Board";
        PegBoards: TestPage "Peg Boards";
        NewBoardEntryNo: Integer;
    begin
        // [GIVEN] New Gave
        InitNewGame();

        // [WHEN] Making First move
        PegBoards.OpenView();
        PegBoards.Last();
        PegBoards.NextMove.Invoke();
        PegBoard.FindLast();
        NewBoardEntryNo := PegBoard."Entry No.";

        // [WHEN] Making Second Move
        PegBoards.NextMove.Invoke();

        // [THEN] New board creates only one new board. Other three boards are duplicates.
        PegBoard.SetFilter("Entry No.", '>%1', NewBoardEntryNo);
        LibraryAssert.AreEqual(PegBoard.Count(), 3, 'Must be 3 boards after second move');
    end;

    procedure InitNewGame()
    var
        PegBoards: TestPage "Peg Boards";
    begin
        PegBoards.OpenView();
        PegBoards.NewGame.Invoke();
    end;

    [ConfirmHandler]
    procedure ConfirmHandler(Question: Text[1024]; var Reply: Boolean);
    begin
        Reply := true;
    end;

    var
        LibraryAssert: Codeunit "Library Assert";
}