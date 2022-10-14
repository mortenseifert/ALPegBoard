table 50603 "Peg Board Cue"
{
    Caption = 'Peg Board Cue';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Moves"; Integer)
        {
            Caption = 'Moves';
            FieldClass = FlowField;
            CalcFormula = count("Peg Board" where("Game No." = field("Game No. Filter")));
        }
        field(3; "Max Move"; Integer)
        {
            Caption = 'Max Move';
            FieldClass = FlowField;
            CalcFormula = max("Peg Board".Move where("Game No." = field("Game No. Filter")));
        }
        field(4; "In Queue"; Integer)
        {
            Caption = 'In Queue';
            FieldClass = FlowField;
            CalcFormula = count("Peg Board" where("Game No." = field("Game No. Filter"), "In Queue" = const(true)));
        }
        field(5; "Duplicates"; Integer)
        {
            Caption = 'Duplicates';
            FieldClass = FlowField;
            CalcFormula = count("Peg Board" where("Game No." = field("Game No. Filter"), Duplicate = const(true)));
        }
        field(6; "Solutions"; Integer)
        {
            Caption = 'Solutions';
            FieldClass = FlowField;
            CalcFormula = count("Peg Board" where("Game No." = field("Game No. Filter"), Solution = const(true)));
        }
        field(7; "Job Queue Status"; Option)
        {
            Caption = 'Status';
            FieldClass = FlowField;
            CalcFormula = min("Job Queue Entry".Status where("Object Type to Run" = const(Codeunit), "Object ID to Run" = const(50601)));
            OptionCaption = 'Ready,In Process,Error,On Hold,Finished,On Hold with Inactivity Timeout';
            OptionMembers = Ready,"In Process",Error,"On Hold",Finished,"On Hold with Inactivity Timeout";
        }
        field(10; "Game No. Filter"; Integer)
        {
            FieldClass = FlowFilter;
        }
    }
}