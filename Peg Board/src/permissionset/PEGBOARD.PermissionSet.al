permissionset 50600 "Peg Board"
{
    Access = Internal;
    Assignable = true;
    Caption = 'Peg Board', Locked = true;

    Permissions =
         codeunit "Peg Board Solve" = X,
         codeunit "Peg Solitare Job" = X,
         codeunit "Peg Solitare Mgt." = X,
         page "Peg Board Activities" = X,
         page "Peg Board Factbox" = X,
         page "Peg Board Moves" = X,
         page "Peg Boards" = X,
         table "Peg Board" = X,
         table "Peg Board Cue" = X,
         table "Peg Board Moves" = X,
         table "Peg Board Seen" = X,
         tabledata "Peg Board" = RIMD,
         tabledata "Peg Board Cue" = RIMD,
         tabledata "Peg Board Moves" = RIMD,
         tabledata "Peg Board Seen" = RIMD;
}