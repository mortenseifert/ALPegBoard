namespace System.Test.Tooling;

using Microsoft.Inventory.Item;

codeunit 50811 "BCPT Open Item List"
{
    // Test codeunits can only run in foreground (UI)
    Subtype = Test;

    trigger OnRun();
    begin
    end;

    [Test]
    procedure OpenItemList()
    var
        ItemList: testpage "Item List";
    begin
        ItemList.OpenView();
        ItemList.Close();
    end;
}
