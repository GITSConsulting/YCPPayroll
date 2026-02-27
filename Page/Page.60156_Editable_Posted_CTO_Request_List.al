page 60156 "Editable Posted CTO Req. List"
{
    PageType = List;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Posted CTO Request Header";

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
                field(NamaEmployee; Rec.NamaEmployee(Rec."Employee No."))
                {
                    Caption = 'Employee Name';
                    ApplicationArea = all;
                    Style = Unfavorable;
                    StyleExpr = Merah;
                }
                field("Posting Date"; Rec."Document Date")
                {
                    ApplicationArea = all;
                    Style = Unfavorable;
                    StyleExpr = Merah;
                }
                field("Approver ID"; Rec."Approver ID")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Expired; Rec.Expired)
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
        if Rec.Reversed then begin
            Merah := true;
        end else begin
            Merah := false;
        end;
    end;

    trigger OnOpenPage()
    var
        frz_CodeUnit: Codeunit "User Setup Custome";
    begin
        if frz_CodeUnit.AttendanceAdminCheck(UserId) = false then
            rec.SetFilter("Employee No.", frz_CodeUnit.GetEmployeeNo(UserId));
    end;

    var
        Merah: Boolean;
}