page 60023 Troubleshoot
{
    PageType = List;
    ShowFilter = false;
    LinksAllowed = false;
    PopulateAllFields = true;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            field(TextMenu1; TextMenu[1])
            {
                ShowCaption = false;
                ApplicationArea = all;
            }
            field(TextMenu2; TextMenu[2])
            {
                ApplicationArea = all;
                ShowCaption = false;
                trigger
                OnDrillDown()
                begin
                    //run page Tarif PKP Ledger Entries
                    page.Run(73000016);
                end;
            }
            field(TextMenu3; TextMenu[3])
            {
                ApplicationArea = all;
                ShowCaption = false;
                trigger
                OnDrillDown()
                begin
                    //run page Payroll Ledger Entries
                    page.Run(73000021);
                end;
            }
            field(TextMenu4; TextMenu[4])
            {
                ApplicationArea = all;
                ShowCaption = false;
                trigger
                OnDrillDown()
                begin
                    //run page Detailed Payroll Ledger Entries
                    page.Run(73000022);
                end;
            }
            field(TextMenu5; TextMenu[5])
            {
                ApplicationArea = all;
                ShowCaption = false;
                trigger
                OnDrillDown()
                begin
                    //run page Detailed Payroll Ledger Entries
                    page.Run(73000026);
                end;
            }
            field(TextMenu6; TextMenu[6])
            {
                ApplicationArea = all;
                ShowCaption = false;
                trigger
                OnDrillDown()
                begin
                    //run page Detailed Payroll Ledger Entries
                    page.Run(73000030);
                end;
            }
            field(TextMenu7; TextMenu[7])
            {
                ApplicationArea = all;
                ShowCaption = false;
                trigger
                OnDrillDown()
                begin
                    //run page Test Tool
                    page.Run(130401);
                end;
            }
        }
    }


    var
        TextMenu: Array[10] of text;

    trigger
    OnOpenPage()
    begin
        TextMenu[1] := '';
        TextMenu[2] := 'Tarif PKP Ledger Entries';
        TextMenu[3] := 'Payroll Ledger Entries';
        TextMenu[4] := 'Detailed Payroll Ledger Entries';
        TextMenu[5] := 'THR Ledger Entries';
        TextMenu[6] := 'Overtime Ledger Entries';
        TextMenu[7] := 'Test Toolkit';
    end;


}