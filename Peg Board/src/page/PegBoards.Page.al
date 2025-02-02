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

                trigger OnAction()
                var
                    PegBoard: Record "Peg Board";
                    PegSolitareMgt: Codeunit "Peg Solitare Mgt.";
                    ConfirmManagement: Codeunit "Confirm Management";
                    NewGameQst: Label 'Would you like to create a new game?';
                begin
                    if not ConfirmManagement.GetResponse(NewGameQst, false) then
                        exit;

                    PegSolitareMgt.InitBoard();
                    PegBoard.FindLast();
                    Rec.SetFilter("Game No.", '=%1', PegBoard."Game No.");
                    CurrPage.Update();

                    PegSolitareMgt.CreateJob();
                end;
            }
            action(NextMove)
            {
                Caption = 'Next move';
                Image = MovementWorksheet;
                RunObject = codeunit "Peg Solitare Mgt.";
                RunPageOnRec = true;
            }
            action(BatchMove)
            {
                Caption = 'Batch next move';
                Image = ExecuteBatch;

                trigger OnAction()
                var
                    JobQueueEntry: Record "Job Queue Entry";
                begin
                    JobQueueEntry.Init();
                    JobQueueEntry."Parameter String" := 'S1000';
                    Codeunit.Run(Codeunit::"Peg Solitare Job", JobQueueEntry);
                end;
            }
            action(SolveOne)
            {
                Caption = 'Solve 1';
                ToolTip = 'Create new game and solve buttom up.';
                Image = NewSum;

                trigger OnAction()
                var
                    PegBoard: Record "Peg Board";
                    PegBoardSolve: Codeunit "Peg Board Solve";
                begin
                    PegBoardSolve.Solve1();

                    PegBoard.FindLast();
                    Rec.Reset();
                    Rec.SetRange("Game No.", PegBoard."Game No.");
                    Rec.SetRange(Solution, true);
                    Rec.SetView('Sorting(Move) Order(Ascending)');
                end;
            }
            action(SolveTwo)
            {
                Caption = 'Solve 2';
                ToolTip = 'Create new game and solve top down.';
                Image = NewSum;

                trigger OnAction()
                var
                    PegBoard: Record "Peg Board";
                    PegBoardSolve: Codeunit "Peg Board Solve";
                begin
                    PegBoardSolve.Solve2();

                    PegBoard.FindLast();
                    Rec.Reset();
                    Rec.SetRange("Game No.", PegBoard."Game No.");
                    Rec.SetRange(Solution, true);
                    Rec.SetView('Sorting(Move) Order(Ascending)');
                end;
            }
            action(SolveThree)
            {
                Caption = 'Solve 3';
                ToolTip = 'Create new game and solve top down + buttom up.';
                Image = NewSum;

                trigger OnAction()
                var
                    PegBoard: Record "Peg Board";
                    PegBoardSolve: Codeunit "Peg Board Solve";
                begin
                    PegBoardSolve.Solve3();

                    PegBoard.FindLast();
                    Rec.Reset();
                    Rec.SetRange("Game No.", PegBoard."Game No.");
                    Rec.SetRange(Solution, true);
                    Rec.SetView('Sorting(Move) Order(Ascending)');
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';
                ShowAs = SplitButton;

                actionref(NewGame_Promoted; NewGame)
                {
                }
                actionref(NextMove_Promoted; NextMove)
                {
                }
                actionref(BatchMove_Promoted; BatchMove)
                {
                }
            }
            group(Category_Solve)
            {
                Caption = 'Solve';
                ShowAs = SplitButton;

                actionref(SolveOne_Promoted; SolveOne)
                {
                }
                actionref(SolveTwo_Promoted; SolveTwo)
                {
                }
                actionref(SolveThree_Promoted; SolveThree)
                {
                }
            }
        }
    }

    views
    {
        view(ShowSolution)
        {
            Caption = 'Solution';
            Filters = where(Solution = const(true));
            OrderBy = ascending(Move);
            SharedLayout = true;
        }
        view(ShowQueue)
        {
            Caption = 'In Queue';
            Filters = where("In Queue" = const(true));
            OrderBy = descending(Move);
            SharedLayout = true;
        }
    }
}