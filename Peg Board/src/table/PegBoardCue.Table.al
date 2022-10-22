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
            Editable = false;
        }
        field(3; "Max Move"; Integer)
        {
            Caption = 'Max Move';
            FieldClass = FlowField;
            CalcFormula = max("Peg Board".Move where("Game No." = field("Game No. Filter")));
            Editable = false;
        }
        field(4; "In Queue"; Integer)
        {
            Caption = 'In Queue';
            FieldClass = FlowField;
            CalcFormula = count("Peg Board" where("Game No." = field("Game No. Filter"), "In Queue" = const(true)));
            Editable = false;
        }
        field(5; "Duplicates"; Integer)
        {
            Caption = 'Duplicates';
            FieldClass = FlowField;
            CalcFormula = count("Peg Board" where("Game No." = field("Game No. Filter"), Duplicate = const(true)));
            Editable = false;
            ObsoleteState = Removed;
            ObsoleteReason = 'Unused';
        }
        field(6; "Solutions"; Integer)
        {
            Caption = 'Solutions';
            FieldClass = FlowField;
            CalcFormula = count("Peg Board" where("Game No." = field("Game No. Filter"), Solution = const(true)));
            Editable = false;
        }
        field(7; "Job Queue Status"; Option)
        {
            Caption = 'Status';
            FieldClass = FlowField;
            CalcFormula = min("Job Queue Entry".Status where("Object Type to Run" = const(Codeunit), "Object ID to Run" = const(50601)));
            Editable = false;
            OptionCaption = 'Ready,In Process,Error,On Hold,Finished,On Hold with Inactivity Timeout';
            OptionMembers = Ready,"In Process",Error,"On Hold",Finished,"On Hold with Inactivity Timeout";
        }
        field(10; "Game No. Filter"; Integer)
        {
            Caption = 'Game No. Filter';
            FieldClass = FlowFilter;
        }
    }
}
