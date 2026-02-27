page 60094 "HR Approval Monitoring"
{
    PageType = ListPart;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Approval Entry";
    SourceTableView = where("Approval Chain Doc. Type" = filter('CTO Request|CTO Realization|Medical Reimbursement'));
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    Editable = false;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Approval Chain Doc. Type"; Rec."Approval Chain Doc. Type")
                {
                    ApplicationArea = All;
                    Caption = 'Document Type';
                }
                field("Document No."; Rec."Document No.")
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
    OnOpenPage()
    begin
        Rec.SetRange("Sender ID", UserId);
    end;

    trigger
    OnAfterGetRecord()
    begin
        Rec.SetRange("Sender ID", UserId);
    end;
}
