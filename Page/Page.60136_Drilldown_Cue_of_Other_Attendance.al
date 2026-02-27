page 60136 "Drilldown Cue of Other Attnd."
{
    Caption = 'Other Attendance List';
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Leave Request";
    SourceTableView = where("Leave Type" = const("Other Attendance"));
    Editable = false;
    CardPageId = "Other Attendance Request";
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