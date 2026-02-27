page 60011 "MSI Payroll Setup"
{
    PageType = List;
    ShowFilter = false;
    LinksAllowed = false;
    PopulateAllFields = true;
    UsageCategory = Lists;
    //ApplicationArea = all;
    Caption = 'Payroll Setup';

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
                    Page.Run(60010);
                end;
            }

            field(TextMenu5; TextMenu[5])
            {
                ApplicationArea = all;
                ShowCaption = false;
                trigger
                OnDrillDown()
                begin
                    page.Run(60098);
                end;
            }
            field(TextMenu6; TextMenu[6])
            {
                ApplicationArea = all;
                ShowCaption = false;
                trigger
                OnDrillDown()
                begin
                    page.Run(60099);
                end;
            }
            field(TextMenu7; TextMenu[7])
            {
                ApplicationArea = all;
                ShowCaption = false;
                trigger
                OnDrillDown()
                begin
                    page.Run(60106);
                end;
            }
            field(TextMenu8; TextMenu[8])
            {
                ApplicationArea = all;
                ShowCaption = false;
                trigger
                OnDrillDown()
                begin
                    page.Run(65027);
                end;
            }
            field(TextMenu9; TextMenu[9])
            {
                ApplicationArea = all;
                ShowCaption = false;
                trigger
                OnDrillDown()
                begin
                    page.Run(60147);
                end;
            }
            field(TextMenu3; TextMenu[3])
            {
                ApplicationArea = all;
                ShowCaption = false;
                trigger
                OnDrillDown()
                begin
                    page.Run(60012);
                end;
            }
            field(TextMenu4; TextMenu[4])
            {
                ApplicationArea = all;
                ShowCaption = false;
                trigger
                OnDrillDown()
                begin
                    page.Run(60091);
                end;
            }
            field(TextMenu10; TextMenu[10])
            {
                ApplicationArea = all;
                ShowCaption = false;
                trigger
                OnDrillDown()
                begin
                    page.Run(65028);
                end;
            }
            field(TextMenu11; TextMenu[11])
            {
                ApplicationArea = all;
                ShowCaption = false;
                trigger
                OnDrillDown()
                begin
                    page.Run(65075);
                end;
            }
        }
    }
    var
        TextMenu: Array[11] of text;

    trigger
    OnOpenPage()
    begin
        TextMenu[1] := '';
        TextMenu[2] := 'Tariff PPh 21 Setup';
        TextMenu[3] := 'Other Setup';
        TextMenu[4] := 'Approval Chain Setup';
        TextMenu[5] := 'Tariff PPh THR Setup';
        TextMenu[6] := 'Tariff PPh Severance Setup';
        TextMenu[7] := 'PTKP Setup';
        TextMenu[8] := 'User Setup HRIS';
        TextMenu[9] := 'Accounting Setup';
        TextMenu[10] := 'Master Leave';
        TextMenu[11] := 'Clock Schedule Per-Period';
    end;


}