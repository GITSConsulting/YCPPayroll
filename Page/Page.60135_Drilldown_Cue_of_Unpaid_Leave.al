page 60135 "Drilldown Cue of Unpaid Leave"
{
    Caption = 'Unpaid Leave List';
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Leave Request";
    SourceTableView = where("Leave Type" = const(Unpaid));
    Editable = false;
    CardPageId = "Unpaid Leave Request";
    DataCaptionFields = "No.";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                }
                field(EmployeeName; EmployeeName)
                {
                    Caption = 'Employee Name';
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
                field("Approver ID"; Rec."Approver ID")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    trigger
    OnAfterGetRecord()
    begin
        EmployeeName := Rec.GetEmployeeName(true);
    end;

    var
        EmployeeName: Text;
}