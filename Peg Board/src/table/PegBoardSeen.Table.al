table 50602 "Peg Board Seen"
{
    Caption = 'Peg Solitare';

    fields
    {
        field(1; "Game No."; Integer)
        {
            Caption = 'Game No.';
        }
        field(2; Signature; BigInteger)
        {
            Caption = 'Signature';
        }
    }

    keys
    {
        key(PK; "Game No.", Signature)
        {
            Clustered = true;
        }
    }
}