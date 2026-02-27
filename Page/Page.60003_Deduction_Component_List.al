page 60003 "Deduction Component List"
{
    PageType = List;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Deduction Component";
    CardPageId = "Deduction Component Card";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Kode; Rec.Kode)
                {
                    ApplicationArea = all;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = all;
                }
                field(Value; Rec.Value)
                {
                    ApplicationArea = all;
                }
                field("Value Type"; Rec."Value Type")
                {
                    ApplicationArea = all;
                }
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
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ApplicationArea = all;
                }
                field("Deduction Indirect"; Rec."Deduction Indirect")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Genereate Salary Limit")
            {
                ApplicationArea = all;
                Caption = 'Generate Salary Limit';
                Image = UpdateUnitCost;
                //RunObject = page "Deduction Component Card";

                trigger OnAction()
                var
                    _GenerateUMKReport: Report "Generate UMK";
                    _SalaryLower, _SalaryUpper : Decimal;
                begin
                    _GenerateUMKReport.RunModal();
                    _GenerateUMKReport.GetSalaryRecord(_SalaryLower, _SalaryUpper);
                    if Rec.FindSet() then
                        repeat
                            if _SalaryLower <> 0 then
                                Rec."Salary Lower Limit" := _SalaryLower;
                            if _SalaryUpper <> 0 then
                                Rec."Salary Upper Limit" := _SalaryUpper;
                            Rec.Modify();
                        until Rec.Next() = 0;
                end;
            }
        }
    }
}