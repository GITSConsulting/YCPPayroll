page 60090 "HR Approval Setting CTO Req."
{
    Caption = 'HR Approval Setting For CTO Request';
    PageType = ListPart;
    //ApplicationArea = All;
    UsageCategory = Lists;
    AutoSplitKey = true;
    SourceTable = "Approval Chain Setup";
    SourceTableView = where("Document Type" = const("CTO Request"));

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
                field("Able to Undo CTO Request"; Rec."Able to Undo CTO Request")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    trigger
    OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Document Type" := Rec."Document Type"::"CTO Request";
        //Rec."Approver Type" := Rec."Approver Type"::"User ID";
    end;
}