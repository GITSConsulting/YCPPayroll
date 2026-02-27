page 60131 "Edit Posted Unpaid Leave Req."
{
    Caption = 'Editable Posted Unpaid Leave Requests';
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Posted Leave Request";
    SourceTableView = where("Leave Type" = const(Unpaid));
    CardPageId = "Posted Unpaid Leave Request";

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
                    Visible = false;
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

    var
        Employee: Record Employee;
        EmployeeName: Text;
        Merah: Boolean;

}