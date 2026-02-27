page 60016 "Tarif PKP Ledger Entries"
{
    Caption = 'Income Tax Ledger Entries';
    PageType = List;
    SourceTable = "Tarif PKP Ledger Entry";
    UsageCategory = Lists;
    //ApplicationArea = all;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
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
                field("Owed PPh 21"; Rec."Owed PPh 21")
                {
                    Caption = 'Yearly Tax 21';
                    ApplicationArea = all;
                }
                field("Amount Used"; Rec."Amount Used")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}