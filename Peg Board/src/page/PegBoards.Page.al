page 50600 "Peg Boards"
{
    Caption = 'Peg Boards';
    AdditionalSearchTerms = 'Peg Solitare';
    PageType = List;
    SourceTable = "Peg Board";
    InsertAllowed = false;
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Boards)
            {
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Parent Entry No."; Rec."Parent Entry No.")
                {
                }
                field("Game No."; Rec."Game No.")
                {
                }
                field(Move; Rec.Move)
                {
                }
                field(X; Rec.X)
                {
                }
                field(Y; Rec.Y)
                {
                }
                field(Direction; Rec.Direction)
                {
                }
                field("In Queue"; Rec."In Queue")
                {
                }
                field("Dead End"; Rec."Dead End")
                {
                }
                field(Duplicate; Rec.Duplicate)
                {
                }
                field(Signature; Rec."Big Signature")
                {
                }
                field(Solution; Rec.Solution)
                {
                }
            }
        }
        area(FactBoxes)
        {
            part(PegBoardFactbox; "Peg Board Factbox")
            {
                SubPageLink = "Entry No." = field("Entry No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(NewGame)
            {
                Caption = 'New Game';
                Image = New;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    PegSolitareMgt: Codeunit "Peg Solitare Mgt.";
                    ConfirmManagement: Codeunit "Confirm Management";
                    NewGameQst: Label 'Would you like to create a new game?';
                begin
                    if not ConfirmManagement.GetResponse(NewGameQst, false) then
                        exit;

                    PegSolitareMgt.InitBoard();
                    CurrPage.Update();

                    PegSolitareMgt.CreateJob();
                end;
            }
            action(NextMove)
            {
                Caption = 'Next move';
                Image = MovementWorksheet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = false;
                RunObject = codeunit "Peg Solitare Mgt.";
                RunPageOnRec = true;
            }
            action(BatchMove)
            {
                Caption = 'Batch next move';
                Image = ExecuteBatch;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = false;

                trigger OnAction()
                var
                    JobQueueEntry: Record "Job Queue Entry";
                begin
                    JobQueueEntry.Init();
                    JobQueueEntry."Parameter String" := 'S1000';
                    Codeunit.Run(Codeunit::"Peg Solitare Job", JobQueueEntry);
                end;
            }
        }
    }

    views
    {
        view(LatestGame)
        {
            Caption = 'Latest';
            Filters = where("Game No." = const(6), "In Queue" = const(true));
            OrderBy = descending(Move);
            SharedLayout = true;
        }
    }
}