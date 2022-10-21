table 50600 "Peg Board"
{
    Caption = 'Peg Solitare';
    DrillDownPageId = "Peg Boards";
    LookupPageId = "Peg Boards";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Parent Entry No."; Integer)
        {
            Caption = 'Parent Entry No.';
            TableRelation = "Peg Board"."Entry No.";
        }
        field(3; "Game No."; Integer)
        {
            Caption = 'Game No.';
        }
        field(4; "Move"; Integer)
        {
            Caption = 'Move';
        }
        field(5; X; Integer)
        {
            Caption = 'X';
        }
        field(6; Y; Integer)
        {
            Caption = 'Y';
        }
        field(7; Direction; Enum "Peg Direction")
        {
            Caption = 'Direction';
        }
        field(8; "In Queue"; Boolean)
        {
            Caption = 'In Queue';
        }
        field(10; "Board"; Text[49])
        {
            Caption = 'Board';
        }
        field(11; "Solution"; Boolean)
        {
            Caption = 'Solution';
        }
        field(12; "Dead End"; Boolean)
        {
            Caption = 'Dead End';
        }
        field(13; Signature; Integer)
        {
            Caption = 'Signature';
            ObsoleteState = Removed;
            ObsoleteReason = 'Changed to BigInteger. Use "Big Signature"';
        }
        field(14; "Duplicate"; Boolean)
        {
            Caption = 'Duplicate';
        }
        field(15; "Big Signature"; BigInteger)
        {
            Caption = 'Signature';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(GameNo; "Game No.")
        {
            IncludedFields = Move;
        }
        key(GameNoMoveInQueue; "Game No.", Move, "In Queue")
        { }
    }

    procedure GetLastGameNo(): Integer
    var
        PegBoard: Record "Peg Board";
    begin
        PegBoard.SetCurrentKey("Game No.");
        if PegBoard.FindLast() then
            exit(PegBoard."Game No.")
        else
            exit(0);
    end;
}