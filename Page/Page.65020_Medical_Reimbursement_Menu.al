page 65020 "Medical Reimbursement Menu"
{
    PageType = List;
    LinksAllowed = false;
    PopulateAllFields = true;
    UsageCategory = Lists;
    // ApplicationArea = all;
    Caption = 'HR - Medical Reimbursement';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(TextMenu2; TextMenu[2])
                {
                    ApplicationArea = all;
                    ShowCaption = false;
                    trigger OnDrillDown()
                    begin
                        Page.Run(65003);
                    end;
                }
                field(TextMenu3; TextMenu[3])
                {
                    ApplicationArea = all;
                    ShowCaption = false;
                    trigger
                    OnDrillDown()
                    begin
                        page.Run(65044);
                    end;
                }
            }
        }
    }
    var
        TextMenu: Array[10] of text;

    trigger OnOpenPage()
    var
        frz_CodeUnit: Codeunit "User Setup Custome";

    // test
    // vat: Text;
    // vatDecimal: Decimal;
    begin
        if frz_CodeUnit.AttendanceAdminCheck(UserId) = false then
            frz_CodeUnit.ModuleNotReady();

        TextMenu[1] := '';
        TextMenu[2] := 'Medical Reimbursement';
        TextMenu[3] := 'Posted Medical Reimbursement';
        TextMenu[4] := 'Master Kacamata';
        TextMenu[5] := 'Master Persalinan';
        TextMenu[6] := 'Master Rawat Jalan';
        TextMenu[7] := 'Master Rawat Inap';
        TextMenu[8] := 'Master Status Patient';

        // vat := DelChr('VAT10%', '=', 'VAT%');
        // Evaluate(vatDecimal, vat);
        // Message('%1', vatDecimal);


    end;
}