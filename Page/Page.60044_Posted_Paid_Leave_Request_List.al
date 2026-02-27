page 60044 "Posted Paid Leave Request List"
{
    Caption = 'Posted Annual Leave Requests';
    PageType = List;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Posted Leave Request";
    SourceTableView = where("Leave Type" = const(Paid));
    Editable = false;
    CardPageId = "Posted Paid Leave Request";
    DataCaptionFields = "No.";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

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
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = all;
                    Style = Unfavorable;
                    StyleExpr = Merah;
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
        if frz_CodeUnit.AttendanceAdminCheck(UserId) = false then
            rec.SetFilter("Employee No.", frz_CodeUnit.GetEmployeeNo(UserId));
    end;

    var
        Employee: Record Employee;
        EmployeeName: Text;
        Merah: Boolean;
}