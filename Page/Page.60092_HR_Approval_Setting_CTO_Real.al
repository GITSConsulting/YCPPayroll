page 60092 "HR Approval Setting CTO Real"
{
    Caption = 'HR Approval Setting For CTO Realization';
    PageType = ListPart;
    //ApplicationArea = All;
    UsageCategory = Lists;
    AutoSplitKey = true;
    SourceTable = "Approval Chain Setup";
    SourceTableView = where("Document Type" = const("CTO Realization"));

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
        Rec."Document Type" := Rec."Document Type"::"CTO Realization";
        //Rec."Approver Type" := Rec."Approver Type"::"User ID";
    end;
}