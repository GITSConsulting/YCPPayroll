page 60052 "Edit Tarif PKP Ledger Entries"
{
    PageType = List;
    SourceTable = "Tarif PKP Ledger Entry";
    //UsageCategory = Lists;
    //ApplicationArea = all;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                }
                field("Used Percentage"; Rec."Used Percentage")
                {
                    ApplicationArea = all;
                }
                field(PPh21; Rec.PPh21)
                {
                    ApplicationArea = all;
                }
                field("Amount Used"; Rec."Amount Used")
                {
                    ApplicationArea = all;
                }
                field("Yearly PKP"; Rec."Yearly PKP")
                {
                    ApplicationArea = all;
                }
                field("Owed PPh 21"; Rec."Owed PPh 21")
                {
                    ApplicationArea = all;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}