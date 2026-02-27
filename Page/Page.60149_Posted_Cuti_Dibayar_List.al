page 60149 "Posted Cuti Dibayar List"
{
    Caption = 'Posted Unused Annual Leave Payments';
    PageType = List;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Posted Cuti Dibayar Header";
    CardPageId = "Posted Cuti Dibayar";
    Editable = false;
    ModifyAllowed = false;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Document Date")
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}