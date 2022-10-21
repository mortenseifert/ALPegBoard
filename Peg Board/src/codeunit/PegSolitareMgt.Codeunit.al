codeunit 50600 "Peg Solitare Mgt."
{
    TableNo = "Peg Board";

    trigger OnRun()
    begin
        Rec.TestField("In Queue", true);
        PegBoard := Rec;
        PegBoard."In Queue" := false;
        if IsSolved() then
            MarkAsSolution()
        else
            MakeMove();
    end;

    local procedure MarkAsSolution()
    begin
        PegBoard.Solution := true;
        PegBoard.Modify();
        while PegBoard."Parent Entry No." > 0 do begin
            PegBoard.Get(PegBoard."Parent Entry No.");
            PegBoard.Solution := true;
            PegBoard.Modify();
        end;
    end;

    local procedure MakeMove()
    var
        NewMoveCreated: Boolean;
        x: Integer;
        y: Integer;
    begin
        if PegBoard.Move = 0 then begin
            MovePeg(4, 2);
            PegBoard.Modify();
        end else begin
            for x := 1 to 7 do
                for y := 1 to 7 do
                    NewMoveCreated := NewMoveCreated or MovePeg(x, y);
            PegBoard."Dead End" := not NewMoveCreated;
            PegBoard.Modify();
        end;
    end;

    local procedure MovePeg(x: Integer; y: Integer) NewMoveCreated: Boolean
    begin
        if HasPeg(x, y) then begin
            NewMoveCreated := NewMoveCreated or TryMoveUp(x, y);
            NewMoveCreated := NewMoveCreated or TryMoveDown(x, y);
            NewMoveCreated := NewMoveCreated or TryMoveLeft(x, y);
            NewMoveCreated := NewMoveCreated or TryMoveRight(x, y);
        end;
    end;

    local procedure TryMoveUp(x: Integer; y: Integer): Boolean
    begin
        if y <= 2 then
            exit;
        if not HasPeg(x, y - 1) then
            exit;
        if not IsEmptry(x, y - 2) then
            exit;

        // Move is valid
        MovePeg(x, y, PegBoard.Direction::Up);
        exit(true);
    end;

    local procedure TryMoveDown(x: Integer; y: Integer): Boolean
    begin
        if y >= 6 then
            exit;
        if not HasPeg(x, y + 1) then
            exit;
        if not IsEmptry(x, y + 2) then
            exit;

        // Move is valid
        MovePeg(x, y, PegBoard.Direction::Down);
        exit(true)
    end;

    local procedure TryMoveLeft(x: Integer; y: Integer): Boolean
    begin
        if x <= 2 then
            exit;
        if not HasPeg(x - 1, y) then
            exit;
        if not IsEmptry(x - 2, y) then
            exit;

        // Move is valid
        MovePeg(x, y, PegBoard.Direction::Left);
        exit(true);
    end;

    local procedure TryMoveRight(x: Integer; y: Integer): Boolean
    begin
        if x >= 6 then
            exit;
        if not HasPeg(x + 1, y) then
            exit;
        if not IsEmptry(x + 2, y) then
            exit;

        // Move is valid
        MovePeg(x, y, PegBoard.Direction::Right);
        exit(true);
    end;

    local procedure MovePeg(x: Integer; y: Integer; Direction: Enum "Peg Direction")
    begin
        NewPegBoard := PegBoard;
        NewPegBoard."Parent Entry No." := PegBoard."Entry No.";
        NewPegBoard."Move" := PegBoard.Move + 1;
        NewPegBoard."Entry No." := 0;
        NewPegBoard.X := x;
        NewPegBoard.Y := y;
        NewPegBoard.Direction := Direction;
        RemovePeg(x, y);
        case Direction of
            Direction::Up:
                begin
                    RemovePeg(x, y - 1);
                    SetPeg(x, y - 2);
                end;
            Direction::Down:
                begin
                    RemovePeg(x, y + 1);
                    SetPeg(x, y + 2);
                end;
            Direction::Left:
                begin
                    RemovePeg(x - 1, y);
                    SetPeg(x - 2, y);
                end;
            Direction::Right:
                begin
                    RemovePeg(x + 1, y);
                    SetPeg(x + 2, y);
                end;
        end;
        NewPegBoard."Big Signature" := CalcSignature(NewPegBoard.Board);
        if NewPegBoardIsUnique() then begin
            NewPegBoard."In Queue" := true;
            NewPegBoard.Duplicate := false;
            NewPegBoard.Insert();
        end else begin
            NewPegBoard."In Queue" := false;
            NewPegBoard.Duplicate := true;
            //NewPegBoard.Insert();
        end;
    end;

    local procedure RemovePeg(x: Integer; y: Integer)
    begin
        Replace(x, y, EmptyTok);
    end;

    local procedure SetPeg(x: Integer; y: Integer)
    begin
        Replace(x, y, PegTok);
    end;

    local procedure Replace(x: Integer; y: Integer; Value: Text[1])
    var
        Left: Text;
        Right: Text;
    begin
        Left := CopyStr(NewPegBoard.Board, 1, x + ((y - 1) * 7) - 1);
        Right := CopyStr(NewPegBoard.Board, x + ((y - 1) * 7) + 1, 7 - x + ((7 - y) * 7));
        NewPegBoard.Board := Left + Value + Right;
    end;

    local procedure HasPeg(x: Integer; y: Integer): Boolean
    begin
        exit(CopyStr(PegBoard.Board, x + (y - 1) * 7, 1) = PegTok);
    end;

    local procedure IsEmptry(x: Integer; y: Integer): Boolean
    begin
        exit(CopyStr(PegBoard.Board, x + (y - 1) * 7, 1) = EmptyTok);
    end;

    local procedure IsSolved(): Boolean
    begin
        exit(PegBoard.Board = BoardSolutionTok);
    end;

    local procedure CalcSignature(Board: Text) Signature: BigInteger
    var
        I: Integer;
        Bit: Integer;
    begin
        for I := 1 to StrLen(Board) do
            case CopyStr(Board, I, 1) of
                EmptyTok:
                    Bit += 1;
                PegTok:
                    begin
                        Signature += Power(2, Bit);
                        Bit += 1;
                    end;
            end;
    end;

    local procedure NewPegBoardIsUnique(): Boolean
    var
        PegBoardSeenBig: Record "Peg Board Seen";
    begin
        PegBoardSeenBig.Init();
        PegBoardSeenBig."Game No." := NewPegBoard."Game No.";
        PegBoardSeenBig.Signature := NewPegBoard."Big Signature";
        exit(PegBoardSeenBig.Insert())
    end;

    procedure InitBoard(InitPegBoard: Record "Peg Board")
    begin
        PegBoard := InitPegBoard;
    end;

    procedure InitBoard()
    begin
        PegBoard.Init();
        PegBoard."Board" := BoardInitTok;
        PegBoard."Game No." := PegBoard.GetLastGameNo() + 1;
        PegBoard.Direction := PegBoard.Direction::" ";
        PegBoard."In Queue" := true;
        PegBoard.Insert();
    end;

    procedure CreateJob()
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        JobQueueEntry.SetRange("Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);
        JobQueueEntry.SetRange("Object ID to Run", Codeunit::"Peg Solitare Job");
        if JobQueueEntry.FindFirst() then begin
            if not JobQueueEntry.IsReadyToStart() then begin
                JobQueueEntry.Validate(Status, JobQueueEntry.Status::Ready);
                JobQueueEntry.Modify(true);
            end;
        end else
            CreateJob('S1000');
    end;

    local procedure CreateJob(ParameterString: Text)
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        JobQueueEntry.Init();
        JobQueueEntry.Validate("Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);
        JobQueueEntry.Validate("Object ID to Run", Codeunit::"Peg Solitare Job");
        JobQueueEntry.Validate("Parameter String", ParameterString);
        JobQueueEntry.Validate("Run on Mondays", true);
        JobQueueEntry.Validate("Run on Tuesdays", true);
        JobQueueEntry.Validate("Run on Wednesdays", true);
        JobQueueEntry.Validate("Run on Thursdays", true);
        JobQueueEntry.Validate("Run on Fridays", true);
        JobQueueEntry.Validate("Run on Saturdays", true);
        JobQueueEntry.Validate("Run on Sundays", true);
        JobQueueEntry.Validate("No. of Minutes between Runs", 1);
        JobQueueEntry.Insert(true);
        JobQueueEntry.Validate(Status, JobQueueEntry.Status::Ready);
        JobQueueEntry.Modify(true);
    end;

    var
        PegBoard: Record "Peg Board";
        NewPegBoard: Record "Peg Board";
        PegTok: Label '*', Locked = true;
        EmptyTok: Label 'O', Locked = true;
        BoardInitTok: Label '  ***    ***  **********O**********  ***    ***  ', Locked = true;
        BoardSolutionTok: Label '  OOO    OOO  OOOOOOOOOO*OOOOOOOOOO  OOO    OOO  ', Locked = true;
}