codeunit 50701 "Peg Board Solve Test"
{
    Subtype = Test;

    [Test]
    procedure FirstMove()
    var
        PegBoard: Record "Peg Board";
        PegSolitareMgt: Codeunit "Peg Solitare Mgt.";
        NewBoardEntryNo: Integer;
    begin
        // [GIVEN] New Gave
        PegSolitareMgt.InitBoard();
        PegBoard.FindLast();
        NewBoardEntryNo := PegBoard."Entry No.";

        // [WHEN] Making First move
        PegSolitareMgt.Run(PegBoard);

        // [THEN] New board creates only one new board. Other three boards are duplicates.
        PegBoard.SetFilter("Entry No.", '>%1', NewBoardEntryNo);
        PegBoard.FindLast();
        LibraryAssert.AreEqual(PegBoard.Count(), 1, 'Only 1 board on new game.');
        LibraryAssert.AreEqual(PegBoard.Board, '  ***    *O*  ***O*****************  ***    ***  ', 'Board after first move');
    end;

    [Test]
    procedure SecondMove()
    var
        PegBoard: Record "Peg Board";
        PegSolitareMgt: Codeunit "Peg Solitare Mgt.";
        NewBoardEntryNo: Integer;
    begin
        // [GIVEN] New Gave
        PegSolitareMgt.InitBoard();
        PegBoard.FindLast();
        NewBoardEntryNo := PegBoard."Entry No.";

        // [GIVEN] After first move
        PegSolitareMgt.Run(PegBoard);

        // [WHEN] Making Second Move
        PegBoard.FindLast();
        PegSolitareMgt.Run(PegBoard);

        // [THEN] New board creates only one new board. Other three boards are duplicates.
        PegBoard.SetFilter("Entry No.", '>=%1', NewBoardEntryNo);
        LibraryAssert.AreEqual(PegBoard.Count(), 5, 'Must be 5 boards after second move');
    end;

    var
        LibraryAssert: Codeunit "Library Assert";
}