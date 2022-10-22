codeunit 50601 "Peg Solitare Job"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        case UpperCase(Rec."Parameter String".Substring(1, 1)) of
            'S':
                SolveBoards(Rec."Parameter String");
            'D':
                DeleteBoards(Rec."Parameter String");
        end;
    end;

    local procedure SolveBoards(ParameterString: Text)
    var
        PegBoard: Record "Peg Board";
        StatusDialog: Dialog;
        Limit, I : Integer;
    begin
        if not Evaluate(Limit, ParameterString.Substring(2)) then
            Limit := 1000;
        PegBoard.SetRange("In Queue", true);
        PegBoard.SetRange("Game No.", PegBoard.GetLastGameNo());

        // Reverse        
        StatusDialog.Open('Backward #1############');
        I := 0;
        while PegBoard.Find('+') and (I < Limit) do begin
            I += 1;
            UpdateStatus(StatusDialog, I, Limit);
            Codeunit.Run(Codeunit::"Peg Solitare Mgt.", PegBoard);
        end;
        StatusDialog.Close();
    end;

    local procedure UpdateStatus(var StatusDialog: Dialog; I: Integer; Limit: Integer)
    var
        BoardStatusLbl: Label 'Board %1 of %2', Comment = '%1 = Board No., %2 = Total number of boards.';
    begin
        if I mod 10 = 0 then
            StatusDialog.Update(1, StrSubstNo(BoardStatusLbl, I, Limit));
    end;

    local procedure DeleteBoards(ParameterString: Text)
    var
        PegBoard: Record "Peg Board";
        Limit: Integer;
    begin
        if not Evaluate(Limit, ParameterString.Substring(2)) then
            Limit := 1000;
        PegBoard.SetRange("Game No.", 0, PegBoard.GetLastGameNo() - 1);
        // Find first Entry No.
        if PegBoard.FindFirst() then begin
            PegBoard.SetRange("Entry No.", 0, PegBoard."Entry No." + Limit);
            PegBoard.DeleteAll();
        end;
    end;
}