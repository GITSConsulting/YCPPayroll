page 60155 "Attendance Menu USER"
{
    PageType = List;
    ShowFilter = false;
    LinksAllowed = false;
    PopulateAllFields = true;
    UsageCategory = Lists;
    // ApplicationArea = all;
    Caption = 'HR - Attendance';

    layout
    {
        area(Content)
        {
            field(TextMenu2; TextMenu[2])
            {
                ApplicationArea = all;
                ShowCaption = false;
                trigger OnDrillDown()
                begin
                    Page.Run(65017);
                end;
            }
            //field(TextMenu4; TextMenu[4])
            //{
            //    ApplicationArea = all;
            //    ShowCaption = false;
            //    trigger
            //    OnDrillDown()
            //    begin
            //        page.Run(65025);
            //    end;
            //}
            field(TextMenu5; TextMenu[5])
            {
                ApplicationArea = all;
                ShowCaption = false;
                trigger
                OnDrillDown()
                begin
                    page.Run(65025);
                end;
            }
            field(TextMenu6; TextMenu[6])
            {
                ApplicationArea = all;
                ShowCaption = false;
                trigger
                OnDrillDown()
                begin
                    page.Run(65074);
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
        TextMenu[2] := 'Attendance';
        //TextMenu[4] := 'Shift Schedules';
        TextMenu[5] := 'Shift Guard';
        TextMenu[6] := 'Shift Office Helper';
    end;
}