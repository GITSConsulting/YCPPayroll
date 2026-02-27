page 60001 "Allowance Component Card"
{
    PageType = Card;
    //ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Allowance Component";
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
                field("Allowance Type"; Rec."Allowance Type")
                {
                    ApplicationArea = all;
                }
                field("Value Type"; Rec."Value Type")
                {
                    ApplicationArea = all;
                    trigger
                    OnValidate()
                    begin
                        //if "Value Type" = "Value Type"::Amount then
                        //    EksprAutoFormat := '<precision,0:0><standard format,0>'
                        //else
                        //    EksprAutoFormat := '<precision,2:2><standard format,0>';
                    end;

                }
                field("Value"; Rec."Value")
                {
                    ApplicationArea = all;
                    //AutoFormatType = 10;
                    //AutoFormatExpression = '<precision,0:0><standard format,0>';
                    //AutoFormatExpression = EksprAutoFormat;

                    trigger
                    OnValidate()
                    begin
                        Rec.Validate("Value Type");

                        //if Rec."Value Type" = Rec."Value Type"::Amount then
                        //    EksprAutoFormat := '<precision,0:0><standard format,0>'
                        //else
                        //    EksprAutoFormat := '<precision,2:2><standard format,0>';
                    end;
                }
                /*
                field("G/L Account No."; "G/L Account No.")
                {
                    ApplicationArea = all;
                }
                field("Mandatory for Tax"; Rec."Mandatory for Tax")
                {
                    ApplicationArea = all;
                }*/
                field("Indirect Income"; Rec."Indirect Income")
                {
                    ApplicationArea = all;
                }
                field("Deduction Code"; Rec."Deduction Code")
                {
                    ApplicationArea = all;
                }
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

    var
        EksprAutoFormat: Text[50];

    trigger
    OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if (Rec."Indirect Income") and (Rec."Deduction Code" = '') then
            if not confirm('This allowance is an indirect income, so you must fill the deduction code \\' +
                            'Are you sure to leave it blank?') then
                Error('');
    end;
}