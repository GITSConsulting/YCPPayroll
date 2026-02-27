page 60002 "Deduction Component Card"
{
    PageType = Card;
    //ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Deduction Component";
    DataCaptionExpression = Rec.Name;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Kode; Rec.Kode)
                {
                    ApplicationArea = All;

                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = all;
                }
                field("Value Type"; Rec."Value Type")
                {
                    ApplicationArea = all;
                }
                field("Value"; Rec."Value")
                {
                    ApplicationArea = all;
                }
                /*
                field("Mandatory For Tax"; Rec."Mandatory For Tax")
                {
                    ApplicationArea = all;
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ApplicationArea = all;
                }
                */
                field("Excel Report"; Rec."Excel Report")
                {
                    ApplicationArea = all;
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ApplicationArea = all;
                }
                field("Accounting Entry"; Rec."Accounting Entry")
                {
                    ApplicationArea = all;
                }
                field(Taxed; Rec.Taxed)
                {
                    ApplicationArea = all;
                }
            }
            group("Age Restriction")
            {
                field("Age Restricted"; Rec."Age Restricted")
                {
                    ApplicationArea = all;
                }
                field("Age Lower Limit"; Rec."Age Lower Limit")
                {
                    ApplicationArea = all;
                }
                field("Age Upper Limit"; Rec."Age Upper Limit")
                {
                    ApplicationArea = all;
                }
            }
            group("Salary Restriction")
            {
                field("Salary Restricted"; Rec."Salary Restricted")
                {
                    ApplicationArea = all;
                }
                field("Salary Lower Limit"; Rec."Salary Lower Limit")
                {
                    ApplicationArea = all;
                }
                field("Salary Upper Limit"; Rec."Salary Upper Limit")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}