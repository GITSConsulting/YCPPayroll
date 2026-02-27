report 65025 "Accrual Severence"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './Report/Report.65025_Accrual_Severance.rdlc';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem(Employee; Employee)
        {
            column(No_; "No.") { }
            column(FullName; FullName) { }
        }

    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Filter")
                {
                    field(Tanggal; frz_StartingDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Starting Date';
                    }
                    field(EndingDate; frz_EndingDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Ending Date';
                    }
                }
            }
        }
    }
    var
        frz_StartingDate: Date;
        frz_EndingDate: Date;
        CompanyInformation: Record "Company Information";

    trigger OnPreReport()
    begin
        CompanyInformation.CalcFields(Picture);
    end;

}