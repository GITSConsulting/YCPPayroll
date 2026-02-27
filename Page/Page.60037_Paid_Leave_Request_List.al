page 60037 "Paid Leave Request List"
{
    Caption = 'Annual Leave Requests';
    PageType = List;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Leave Request";
    // SourceTableView = where("Leave Type" = const(Paid));
    SourceTableView = where("Leave Type" = const(Paid), "Document Type" = const("Paid Leave"));
    Editable = false;
    CardPageId = "Paid Leave Request";
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
                field("Posting Date"; rec."Posting Date")
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    Visible = false;
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
        Clear(EmployeeName);
        EmployeeName := Rec.GetEmployeeName(true);
    end;

    trigger OnOpenPage()
    var
        frz_CodeUnit: Codeunit "User Setup Custome";
    begin
        if frz_CodeUnit.AttendanceAdminCheck(UserId) = false then
            rec.SetFilter("Employee No.", frz_CodeUnit.GetEmployeeNo(UserId));
    end;

    var
        EmployeeName: Text;
}