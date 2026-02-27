page 60154 "Leave Request Menu USER"
{
    PageType = List;
    ShowFilter = false;
    LinksAllowed = false;
    PopulateAllFields = true;
    UsageCategory = Lists;
    //ApplicationArea = all;
    Caption = 'Leave Requests';

    layout
    {
        area(Content)
        {
            field(TextMenu1; TextMenu[1])
            {
                ShowCaption = false;
                ApplicationArea = all;
            }
            group(LEAVE)
            {
                field(TextMenu2; TextMenu[2])
                {
                    ApplicationArea = all;
                    ShowCaption = false;
                    trigger
                    OnDrillDown()
                    begin
                        Page.Run(60037);
                    end;
                }
                field(TextMenu3; TextMenu[3])
                {
                    ApplicationArea = all;
                    ShowCaption = false;
                    trigger
                    OnDrillDown()
                    begin
                        page.Run(60038);
                    end;
                }
                field(TextMenu9; TextMenu[9])
                {
                    ApplicationArea = all;
                    ShowCaption = false;
                    trigger
                    OnDrillDown()
                    begin
                        page.Run(65011);
                    end;
                }
                field(TextMenu4; TextMenu[4])
                {
                    ApplicationArea = all;
                    ShowCaption = false;
                    trigger
                    OnDrillDown()
                    begin
                        page.Run(60044);
                    end;
                }
                field(TextMenu5; TextMenu[5])
                {
                    ApplicationArea = all;
                    ShowCaption = false;
                    trigger
                    OnDrillDown()
                    begin
                        page.Run(60042);
                    end;
                }
                field(TextMenu10; TextMenu[10])
                {
                    ApplicationArea = all;
                    ShowCaption = false;
                    trigger
                    OnDrillDown()
                    begin
                        page.Run(65014);
                    end;
                }
            }
            group("COMPENSATORY TIME OFF")
            {
                field(TextMenu6; TextMenu[6])
                {
                    ApplicationArea = all;
                    ShowCaption = false;
                    trigger
                    OnDrillDown()
                    begin
                        page.Run(60072);
                    end;
                }
                field(TextMenu7; TextMenu[7])
                {
                    ApplicationArea = all;
                    ShowCaption = false;
                    trigger
                    OnDrillDown()
                    begin
                        page.Run(60075);
                    end;
                }
                field(TextMenu13; TextMenu[13])
                {
                    ApplicationArea = all;
                    ShowCaption = false;
                    trigger
                    OnDrillDown()
                    begin
                        page.Run(60128);
                    end;
                }
                field(TextMenu8; TextMenu[8])
                {
                    ApplicationArea = all;
                    ShowCaption = false;
                    trigger
                    OnDrillDown()
                    begin
                        page.Run(60079);
                    end;
                }
            }
            // group("UNCONDITIONAL LEAVE REQUESTS")
            // {
            // }
            group("OTHER ATTENDANCE")
            {
                field(TextMenu111; TextMenu[14])
                {
                    ApplicationArea = all;
                    ShowCaption = false;
                    trigger
                    OnDrillDown()
                    begin
                        page.Run(65030);
                    end;
                }
                field(TextMenu122; TextMenu[15])
                {
                    ApplicationArea = all;
                    ShowCaption = false;
                    trigger
                    OnDrillDown()
                    begin
                        page.Run(65032);
                    end;
                }
            }
        }
    }
    var
        TextMenu: Array[20] of text;

    trigger
    OnOpenPage()
    begin
        TextMenu[1] := '';
        TextMenu[2] := 'Annual Leave Requests';
        TextMenu[3] := 'Unpaid Leave Requests';
        TextMenu[4] := 'Posted Annual Leave Requests';
        TextMenu[5] := 'Posted Unpaid Leave Requests';

        //TextMenu[11] := 'Unused Annual Leave Payments';
        //TextMenu[12] := 'Posted - Unused Annual Leave Payments';
        //TextMenu[16] := 'Monthly Eligible Leave - Post Batch';

        TextMenu[6] := 'CTO Requests';
        TextMenu[13] := 'Posted CTO Requests';
        TextMenu[7] := 'CTO Realizations';
        TextMenu[8] := 'Posted CTO Realizations';

        TextMenu[9] := 'Others Paid Leave Requests';
        TextMenu[10] := 'Posted Others Paid Leave Requests';

        TextMenu[14] := 'Other Attendance Requests';
        TextMenu[15] := 'Posted Other Attendance Requests';
    end;
}