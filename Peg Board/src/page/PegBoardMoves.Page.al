page 50603 "Peg Board Moves"
{
    Caption = 'Peg Board Moves';
    PageType = List;
    SourceTable = "Peg Board Moves";
    Editable = false;
    UsageCategory = History;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Repeater1)
            {
                field("Game No."; Rec."Game No.")
                {
                    ApplicationArea = All;
                }
                field(Move; Rec.Move)
                {
                    ApplicationArea = All;
                }
                field(Moves; Rec.Moves)
                {
                    ApplicationArea = All;
                }
                field("Moves In Queue"; Rec."Moves In Queue")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        PegBoardMoves: Record "Peg Board Moves";
        PegBoard: Record "Peg Board";
        GameNo, NewMove : Integer;
    begin
        GameNo := PegBoard.GetLastGameNo();
        PegBoardMoves.SetRange("Game No.", GameNo);
        if not PegBoardMoves.IsEmpty() then
            exit;
        for NewMove := 0 to 31 do begin
            PegBoardMoves.Init();
            PegBoardMoves."Game No." := GameNo;
            PegBoardMoves.Move := NewMove;
            PegBoardMoves.Insert();
        end;
        CurrPage.Update();
    end;
}