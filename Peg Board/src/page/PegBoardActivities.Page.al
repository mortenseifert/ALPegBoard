page 50602 "Peg Board Activities"
{
    Caption = 'Peg Board Activities';
    PageType = CardPart;
    SourceTable = "Peg Board Cue";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            cuegroup(PegBoard)
            {
                ShowCaption = false;

                field(Moves; Rec.Moves)
                {
                    Image = Info;
                }
                field("Max Move"; Rec."Max Move")
                {
                }
                field("In Queue"; Rec."In Queue")
                {
                    Image = Funnel;
                }
                field(Solutions; Rec.Solutions)
                {
                    Image = Heart;
                }
                field(Status; Rec."Job Queue Status")
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        PgeBoard: Record "Peg Board";
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
        Rec.SetRange("Game No. Filter", PgeBoard.GetLastGameNo());
    end;
}