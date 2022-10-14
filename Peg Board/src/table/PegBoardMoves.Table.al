table 50604 "Peg Board Moves"
{
    Caption = 'Peg Board Moves';

    fields
    {
        field(1; "Game No."; Integer)
        {
            Caption = 'Game No.';
        }
        field(2; "Move"; Integer)
        {
            Caption = 'Move';
        }
        field(3; Moves; Integer)
        {
            Caption = 'Moves';
            FieldClass = FlowField;
            CalcFormula = count ("Peg Board" where("Game No." = field("Game No."), Move = field(Move)));
        }
        field(4; "Moves In Queue"; Integer)
        {
            Caption = 'Moves In Queue';
            FieldClass = FlowField;
            CalcFormula = count ("Peg Board" where("Game No." = field("Game No."), Move = field(Move), "In Queue" = const(true)));
        }
    }

    keys
    {
        key(PK; "Game No.", Move)
        {
            Clustered = true;
        }
    }
}