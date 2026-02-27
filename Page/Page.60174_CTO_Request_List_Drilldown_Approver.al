page 60174 "CTO Request List -DrillApp"
{
    Caption = 'CTO Requests for Approvers';
    PageType = List;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "CTO Request Header";
    Editable = false;
    CardPageId = "CTO Request";


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
                field(Status; Rec.Status)
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
        if Rec.Expired then begin
            Merah := true;
        end else begin
            Merah := false;
        end;
    end;


    var
        Merah: Boolean;
}