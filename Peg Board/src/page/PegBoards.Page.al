page 50600 "Peg Boards"
{
    Caption = 'Peg Boards';
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
                    ApplicationArea = All;
                }
                field("Parent Entry No."; Rec."Parent Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Game No."; Rec."Game No.")
                {
                    ApplicationArea = All;
                }
                field(Move; Rec.Move)
                {
                    ApplicationArea = All;
                }
                field(X; Rec.X)
                {
                    ApplicationArea = All;
                }
                field(Y; Rec.Y)
                {
                    ApplicationArea = All;
                }
                field(Direction; Rec.Direction)
                {
                    ApplicationArea = All;
                }
                field("In Queue"; Rec."In Queue")
                {
                    ApplicationArea = All;
                }
                field("Dead End"; Rec."Dead End")
                {
                    ApplicationArea = All;
                }
                field(Duplicate; Rec.Duplicate)
                {
                    ApplicationArea = All;
                }
                field(Signature; Rec."Big Signature")
                {
                    ApplicationArea = All;
                }
                field(Solution; Rec.Solution)
                {
                    ApplicationArea = All;
                }
            }
        }
        area(FactBoxes)
        {
            part(PegBoardFactbox; "Peg Board Factbox")
            {
                ApplicationArea = All;
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
                ApplicationArea = All;
                Image = New;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    PegSolitareMgt: Codeunit "Peg Solitare Mgt.";
                    NewGameQst: Label 'Would you like to create a new game?';
                begin
                    if not Confirm(NewGameQst, false) then
                        exit;

                    PegSolitareMgt.InitBoard();
                    CurrPage.Update();

                    PegSolitareMgt.CreateJob();
                end;
            }
            action(NextMove)
            {
                Caption = 'Next move';
                ApplicationArea = All;
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
                ApplicationArea = All;
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