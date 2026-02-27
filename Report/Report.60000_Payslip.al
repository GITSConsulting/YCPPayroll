report 60000 Payslip
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './Report/Report.60000_Payslip.rdlc';
    WordLayout = './Report/Report.60000_Payslip.docx';
    DefaultLayout = Word;

    dataset
    {
        dataitem(DataItemEmployee; Employee)
        {
            RequestFilterFields = "No.";

            column(TotalGaji; TotalGaji)
            {

            }
            column(MSI_HRIS_Total_Allowance; "MSI_HRIS Total Allowance")
            {

            }
            column(MSI_HRIS_Total_Deduction; "MSI_HRIS Total Deduction")
            {

            }
            column(MSI_HRIS_PPh_21; "MSI_HRIS PPh 21")
            {

            }
            column(MSI_HRIS_Basic_Salary; "MSI_HRIS Basic Salary")
            {

            }
            column(MSI_HRIS_Overtime_Processed; "MSI_HRIS Overtime Processed")
            {

            }
            column(LogoCompany; CompanyInformation.Picture)
            {

            }
            column(Tanggal; Format(Tanggal, 0, '<Day> <Month Text> <Year4>'))
            {

            }
            column(No_; "No.")
            {

            }
            column(First_Name; "First Name")
            {

            }
            column(Last_Name; "Last Name")
            {

            }
            dataitem(Allowance; "Detailed Payroll Ledger Entry")
            {
                DataItemLink = "Employee No." = FIELD("No.");
                DataItemTableView = WHERE(Type = CONST(Allowance));

                column(Allowance_Desc; Description)
                {

                }
                column(Allowance_Amount; Amount)
                {

                }
                trigger
                OnPreDataItem()
                begin
                    SetRange("Posting Date", Tanggal);
                end;

            }
            dataitem(Deduction; "Detailed Payroll Ledger Entry")
            {
                DataItemLink = "Employee No." = FIELD("No.");
                DataItemTableView = WHERE(Type = CONST(Deduction));

                column(Deduction_Desc; Description)
                {

                }
                column(Deduction_Amount; Amount)
                {

                }
                trigger
                OnPreDataItem()
                begin
                    SetRange("Posting Date", Tanggal);
                end;
            }
            trigger
            OnAfterGetRecord()
            begin
                SetRange("Date Filter", Tanggal);
                CalcFields("MSI_HRIS Total Allowance");
                CalcFields("MSI_HRIS Total Deduction");
                CalcFields("MSI_HRIS PPh 21");
                CalcFields("MSI_HRIS Overtime Processed");

                TotalGaji := "MSI_HRIS Basic Salary" + "MSI_HRIS Total Allowance" +
                "MSI_HRIS Overtime Processed" + "MSI_HRIS Total Deduction" - "MSI_HRIS PPh 21";
            end;

            trigger
            OnPreDataItem()
            var
                StrFilter: Text[30];
            begin
                StrFilter := GetFilter("No.");

                if StrFilter = '' then Error('Employee No. is required.');
                if Tanggal = 0D then Error('Posting date is required.');
            end;


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
                    field(Tanggal; Tanggal)
                    {
                        ApplicationArea = All;
                        Caption = 'Posting Date';
                    }
                }
            }
        }
    }

    var
        Tanggal: Date;
        CompanyInformation: Record "Company Information";
        TotalGaji: Decimal;

    trigger
    OnPreReport()
    begin
        CompanyInformation.CalcFields(Picture);
    end;

}