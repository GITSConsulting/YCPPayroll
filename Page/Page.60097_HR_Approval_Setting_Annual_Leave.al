page 60097 "HR Approval Setting Ann. Leave"
{
    Caption = 'HR Approval Setting For Leave';
    PageType = ListPart;
    //ApplicationArea = All;
    UsageCategory = Lists;
    AutoSplitKey = true;
    SourceTable = "Approval Chain Setup";
    SourceTableView = where("Document Type" = const("Annual Leave"));

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
        Rec."Document Type" := Rec."Document Type"::"Annual Leave";
        //Rec."Approver Type" := Rec."Approver Type"::"User ID";
    end;
}