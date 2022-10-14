page 50601 "Peg Board Factbox"
{
    Caption = 'Board';
    PageType = ListPart;
    SourceTable = "Peg Board";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            usercontrol(HTML; HTML)
            {
                trigger ControlReady()
                begin
                    RenderHTML();
                    IsControlReady := true;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
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
        IsControlReady: Boolean;
}