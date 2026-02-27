page 60137 "Drilldown Cue of Uncond. Leave"
{
    Caption = 'Unconditional Leave List';
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Unconditional Leave Request";
    Editable = false;
    CardPageId = "Unconditional Leave Request";
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