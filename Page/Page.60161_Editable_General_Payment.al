page 60161 "Editable General Payment"
{
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Advance Header";
    SourceTableView = where("Document Type" = const("General Payment"),
    Status = const(Open));

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = all;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
                field("Voucher Type"; Rec."Voucher Type")
                {
                    ApplicationArea = all;
                }
                field("Disbursement Type"; Rec."Disbursement Type")
                {
                    ApplicationArea = all;
                }
                field("Delete via HR"; Rec."Delete via HR")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}