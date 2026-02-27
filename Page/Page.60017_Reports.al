page 60017 Reports
{
    PageType = List;
    ShowFilter = false;
    LinksAllowed = false;
    PopulateAllFields = true;
    UsageCategory = Lists;
    //ApplicationArea = all;

    layout
    {
        area(Content)
        {

            field(TextMenu1; TextMenu[1])
            {
                ShowCaption = false;
                ApplicationArea = all;
            }

            /*
            field(TextMenu2; TextMenu[2])
            {
                ApplicationArea = all;
                ShowCaption = false;
                trigger
                OnDrillDown()
                begin
                    Report.Run(60000);
                end;
            }
            */

            //field(TextMenu3; TextMenu[3])
            //{
            //    ApplicationArea = all;
            //    ShowCaption = false;
            //    trigger
            //    OnDrillDown()
            //    begin
            //        Report.Run(60001);
            //    end;
            //}

            // fadhil 
            // field(TextMenu4; TextMenu[4])
            // {
            //     ApplicationArea = all;
            //     ShowCaption = false;
            //     trigger
            //     OnDrillDown()
            //     begin
            //         Report.Run(65005);
            //     end;
            // }
            // field(TextMenu5; TextMenu[5])
            // {
            //     ApplicationArea = all;
            //     ShowCaption = false;
            //     trigger
            //     OnDrillDown()
            //     begin
            //         Report.Run(65006);
            //     end;
            // }
            // field(TextMenu6; TextMenu[6])
            // {
            //     ApplicationArea = all;
            //     ShowCaption = false;
            //     trigger
            //     OnDrillDown()
            //     begin
            //         Report.Run(65008);
            //     end;
            // }
        }
    }

    var
        TextMenu: Array[10] of text;

    trigger
    OnOpenPage()
    begin
        TextMenu[1] := '';
        TextMenu[2] := 'Payslip';
        TextMenu[3] := 'Formulir 1721 A1';
        // fadhil
        TextMenu[4] := 'Clearance';
        TextMenu[5] := 'Exit Questionnaire';
        TextMenu[6] := 'Employee Data';
        TextMenu[7] := 'YCP Salary Report';
    end;


}