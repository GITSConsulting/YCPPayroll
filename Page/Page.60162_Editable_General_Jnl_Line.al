page 60162 "Editable General Jnl. Line"
{
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Gen. Journal Line";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Journal Template Name"; Rec."Journal Template Name")
                {
                    ApplicationArea = all;
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ApplicationArea = all;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = all;
                }
                field(TipeDuit; Rec.TipeDuit)
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