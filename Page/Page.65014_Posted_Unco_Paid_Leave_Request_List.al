page 65014 "Post Uncon Leave Req List"
{
    Caption = 'Posted Others Paid Leave Requests';
    PageType = List;
    // ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Posted Unco Leave Request";
    Editable = false;
    CardPageId = "Posted Uncon Leave Request";
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
                    Style = Unfavorable;
                    StyleExpr = Merah;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                    Style = Unfavorable;
                    StyleExpr = Merah;
                }
                field(EmployeeName; EmployeeName)
                {
                    Caption = 'Employee Name';
                    ApplicationArea = all;
                    Style = Unfavorable;
                    StyleExpr = Merah;
                }
                field("Posting Date"; rec."Posting Date")
                {
                    ApplicationArea = all;
                }

            }
        }
    }

    trigger
    OnAfterGetRecord()
    begin
        if Rec.Reversed then Merah := true else Merah := false;
        Employee.Get(Rec."Employee No.");
        EmployeeName := Employee.FullName();
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
        Employee: Record Employee;
        EmployeeName: Text;
        Merah: Boolean;
}