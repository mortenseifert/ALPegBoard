pageextension 50600 "Peg Board Business Manager" extends "Business Manager Role Center"
{
    layout
    {
        addfirst(rolecenter)
        {
            part(PegBoardActivities; "Peg Board Activities")
            {
                ApplicationArea = All;
                Caption = 'Peg Board Activities';
                Visible = true;
            }
        }
    }
}