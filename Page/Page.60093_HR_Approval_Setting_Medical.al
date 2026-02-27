page 60093 "HR Approval Setting Medical"
{
    Caption = 'HR Approval Setting For Medical Reimbursement';
    PageType = ListPart;
    //ApplicationArea = All;
    UsageCategory = Lists;
    AutoSplitKey = true;
    SourceTable = "Approval Chain Setup";
    SourceTableView = where("Document Type" = const("Medical Reimbursement"));

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Approver Type"; Rec."Approver Type")
                {
                    ApplicationArea = all;
                }
                field(ID; Rec.ID)
                {
                    ApplicationArea = All;
                    Caption = 'USER ID';
                }
            }
        }
    }

    trigger
    OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Document Type" := Rec."Document Type"::"Medical Reimbursement";
        //Rec."Approver Type" := Rec."Approver Type"::"User ID";
    end;
}