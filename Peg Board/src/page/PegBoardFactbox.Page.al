page 50601 "Peg Board Factbox"
{
    Caption = 'Board';
    PageType = ListPart;
    SourceTable = "Peg Board";

    layout
    {
        area(Content)
        {
            usercontrol(HTML; HTML)
            {
                ApplicationArea = All;

                trigger ControlReady()
                begin
                    RenderHTML();
                    IsControlReady := true;
                end;
            }
            field(Line1; BoardLine[1])
            {
                ApplicationArea = All;
                ShowCaption = false;
            }
            field(Line2; BoardLine[2])
            {
                ApplicationArea = All;
                ShowCaption = false;
            }
            field(Line3; BoardLine[3])
            {
                ApplicationArea = All;
                ShowCaption = false;
            }
            field(Line4; BoardLine[4])
            {
                ApplicationArea = All;
                ShowCaption = false;
            }
            field(Line5; BoardLine[5])
            {
                ApplicationArea = All;
                ShowCaption = false;
            }
            field(Line6; BoardLine[6])
            {
                ApplicationArea = All;
                ShowCaption = false;
            }
            field(Line7; BoardLine[7])
            {
                ApplicationArea = All;
                ShowCaption = false;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        // Prettify(Rec.Board);
        if IsControlReady then
            RenderHTML();

    end;

    local procedure RenderHTML()
    var
        HTMLBigText: BigText;
        x, y : Integer;
    begin
        HTMLBigText.AddText('<table>');
        for y := 1 to 7 do begin
            HTMLBigText.AddText('<tr>');
            for x := 1 to 7 do begin
                HTMLBigText.AddText('<td style="text-align: center; vertical-align: middle;">');
                case CopyStr(Rec.Board, ((y - 1) * 7) + x, 1) of
                    '*':
                        HTMLBigText.AddText('◉');
                    'O':
                        HTMLBigText.AddText('○');
                end;
                HTMLBigText.AddText('</td>');
            end;
            HTMLBigText.AddText('</tr>');
        end;
        HTMLBigText.AddText('</table>');
        CurrPage.HTML.Render(Format(HTMLBigText));
    end;

    var
        BoardLine: array[7] of Text;
        IsControlReady: Boolean;
}