page 60051 "Edit Overtime Ledger Entries"
{
    PageType = List;
    //ApplicationArea = All;
    //UsageCategory = Lists;
    SourceTable = "Overtime Ledger Entry";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Reference Date"; Rec."Reference Date")
                {
                    ApplicationArea = all;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                }
                field("Dimension Code"; Rec."Dimension Code")
                {
                    ApplicationArea = all;
                }
                field("Dimension Value"; Rec."Dimension Value")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}