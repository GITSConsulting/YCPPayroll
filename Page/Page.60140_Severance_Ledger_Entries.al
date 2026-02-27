page 60140 "Severance Ledger Entries"
{
    PageType = List;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Severance Ledger Entry";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
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
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                }
                field("Severance LoS"; Rec."Severance LoS")
                {
                    ApplicationArea = all;
                }
                field("Calc. LoS"; Rec."Calc. LoS")
                {
                    ApplicationArea = all;
                }

                field("Severance Amount"; Rec."Severance Amount")
                {
                    ApplicationArea = all;
                }
                field("Unused Leave Amount"; Rec."Unused Leave Amount")
                {
                    ApplicationArea = all;
                }
                field("Unused Leave Doc. No."; Rec."Unused Leave Doc. No.")
                {
                    ApplicationArea = all;
                }
                field("Applied to Old Basic Salary"; Rec."Applied to Old Basic Salary")
                {
                    ApplicationArea = all;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = all;
                }
                field("GP No."; Rec."GP No.")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}