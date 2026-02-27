page 60119 "Cuti Dibayar List"
{
    Caption = 'Unused Annual Leave Payments';
    PageType = List;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Cuti Dibayar Header";
    CardPageId = "Cuti Dibayar";
    Editable = false;
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
                }
                field("Document Date"; Rec."Document Date")
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