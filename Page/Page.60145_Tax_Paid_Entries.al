page 60145 "Tax Paid Entries"
{
    PageType = List;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Tax Paid Entry";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                }
                field("Posting Date Payroll"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                }
                field("Tax Paid"; Rec."Tax Paid")
                {
                    ApplicationArea = all;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                }
                field("Disbursement Type"; Rec."Disbursement Type")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}