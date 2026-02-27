page 65011 "Uncon Paid Leave Request List"
{
    Caption = 'Others Paid Leave Requests';
    PageType = List;
    // ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Unconditional Leave Request";
    SourceTableView = where("Document Type" = const("Unconditional Leave"));
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
                field(EmployeeName; rec."Employee Name")
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
                }
                field("Approver ID"; Rec."Approver ID")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        EmployeeName := Rec.GetEmployeeName(true);
    end;

    trigger OnOpenPage()
    var
        frz_CodeUnit: Codeunit "User Setup Custome";
    begin
        if frz_CodeUnit.AttendanceAdminCheck(UserId) = false then begin
            frz_CodeUnit.ModuleNotReady();
            rec.SetFilter("Employee No.", frz_CodeUnit.GetEmployeeNo(UserId));
        end;
    end;

    var
        EmployeeName: Text;
}