report 60002 "Generate UMK"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Filter")
                {
                    field(SalaryLower; gSalaryLower)
                    {
                        ApplicationArea = All;
                        Caption = 'Salary Lower Limit';
                    }
                    field(SalaryUpper; gSalaryUpper)
                    {
                        ApplicationArea = All;
                        Caption = 'Salary Upper Limit';
                    }
                }
            }
        }
    }

    procedure GetSalaryRecord(var SalaryLower: Decimal; var SalaryUpper: Decimal)
    begin
        SalaryLower := gSalaryLower;
        SalaryUpper := gSalaryUpper;
    end;

    var
        gSalaryLower, gSalaryUpper : Decimal;


}