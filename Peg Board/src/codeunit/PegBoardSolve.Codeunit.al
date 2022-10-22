codeunit 50602 "Peg Board Solve"
{
    procedure Solve1()
    var
        PegBoard: Record "Peg Board";
        PegSolitareMgt: Codeunit "Peg Solitare Mgt.";
        DoneLbl: Label 'Solved in %1, %2 tries', Comment = '%1 = Duration, %2 Tries';
        Method1Lbl: Label 'Method 1 : FindFirst()';
        StartTime: DateTime;
        Steps, GameNo : Integer;
    begin
        StartTime := CurrentDateTime();
        PegSolitareMgt.InitBoard();
        PegBoard.FindLast();
        GameNo := PegBoard."Game No.";

        Steps := 0;
        OpenStatus(Method1Lbl);
        repeat
            UpdateStatus(GameNo, StartTime, Steps);

            Steps += 1;
            PegSolitareMgt.Run(PegBoard);
            PegBoard.SetRange("Game No.", GameNo);
            PegBoard.SetRange("In Queue", true);
            PegBoard.FindLast();
        until PegBoard.Solution;
        CloseStatus();

        Message(DoneLbl, CurrentDateTime() - StartTime, Steps);
    end;

    procedure Solve2()
    var
        PegBoard: Record "Peg Board";
        PegSolitareMgt: Codeunit "Peg Solitare Mgt.";
        DoneLbl: Label 'Solved in %1, %2 tries', Comment = '%1 = Duration, %2 Tries';
        Method2Lbl: Label 'Method 2 : findLast()';
        StartTime: DateTime;
        Steps, GameNo : Integer;
    begin
        StartTime := CurrentDateTime();
        PegSolitareMgt.InitBoard();
        PegBoard.FindLast();
        GameNo := PegBoard."Game No.";

        Steps := 0;
        OpenStatus(Method2Lbl);
        repeat
            UpdateStatus(GameNo, StartTime, Steps);

            Steps += 1;
            PegBoard.SetRange("In Queue", true);
            PegBoard.SetRange("Game No.", GameNo);
            PegBoard.FindFirst();
            PegSolitareMgt.Run(PegBoard);

            PegBoard.SetLoadFields(Solution);
            PegBoard.Get(PegBoard."Entry No.");
        until PegBoard.Solution;
        CloseStatus();

        Message(DoneLbl, CurrentDateTime() - StartTime, Steps);
    end;

    procedure Solve3()
    var
        PegBoard: Record "Peg Board";
        PegSolitareMgt: Codeunit "Peg Solitare Mgt.";
        DoneLbl: Label 'Solved in %1, %2 tries', Comment = '%1 = Duration, %2 Tries';
        Method3Lbl: Label 'Method 3 : Find(''+''); Next(-1)';
        StartTime: DateTime;
        Steps, GameNo : Integer;
    begin
        StartTime := CurrentDateTime();
        PegSolitareMgt.InitBoard();
        PegBoard.FindLast();
        GameNo := PegBoard."Game No.";

        PegBoard.SetRange("Game No.", GameNo);
        PegBoard.SetRange("In Queue", true);
        PegBoard.Find('+');
        Steps := 0;
        OpenStatus(Method3Lbl);
        repeat
            UpdateStatus(GameNo, StartTime, Steps);

            Steps += 1;
            if PegBoard.Next(-1) = 0 then begin
                PegBoard.SetRange("Game No.", GameNo);
                PegBoard.SetRange("In Queue", true);
                PegBoard.Find('+');
            end;
            PegSolitareMgt.Run(PegBoard);
        until HasSolution(GameNo);
        CloseStatus();

        Message(DoneLbl, CurrentDateTime() - StartTime, Steps);
    end;

    local procedure HasSolution(GameNo: Integer): Boolean
    var
        PegBoard: Record "Peg Board";
    begin
        PegBoard.SetRange("Game No.", GameNo);
        PegBoard.SetRange(Solution, true);
        exit(not PegBoard.IsEmpty());
    end;

    local procedure OpenStatus(Method: Text)
    begin
        LastUpdate := CurrentDateTime();
        StatusDialog.Open(
            Method + '\' +
            'Steps     : #1############\' +
            'Max Moves : #2############\' +
            'Boards    : #3############\' +
            'In Queue  : #4############\' +
            'Duration  : #5############');
    end;

    local procedure UpdateStatus(GameNo: Integer; StartTime: DateTime; Steps: Integer)
    var
        PegBoardCue: Record "Peg Board Cue";
    begin
        // Update every second
        if CurrentDateTime() - LastUpdate < 1000 then
            exit;

        PegBoardCue.SetAutoCalcFields("Max Move", "Moves", "In Queue");
        PegBoardCue.SetFilter("Game No. Filter", '=%1', GameNo);
        PegBoardCue.Get();
        StatusDialog.Update(1, Steps);
        StatusDialog.Update(2, PegBoardCue."Max Move");
        StatusDialog.Update(3, PegBoardCue.Moves);
        StatusDialog.Update(4, PegBoardCue."In Queue");
        StatusDialog.Update(5, CurrentDateTime() - StartTime);
        LastUpdate := CurrentDateTime();
    end;

    local procedure CloseStatus()
    begin
        StatusDialog.Close();
    end;

    var
        StatusDialog: Dialog;
        LastUpdate: DateTime;
}