report 60001 "Bukti Potong"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './Report/Report.60001_Bukti_Potong.rdlc';
    WordLayout = './Report/Report.60001_Bukti_Potong.docx';
    DefaultLayout = Word;

    dataset
    {
        dataitem(DataItemEmployee; Employee)
        {
            RequestFilterFields = "No.";

            column(No_; "No.")
            {

            }

            trigger
            OnPreDataItem()
            var
                StrFilter: Text[30];
            begin
                StrFilter := GetFilter("No.");

                if StrFilter = '' then Error('Employee No. is required.');

                if Tahun = Tahun::" " then Error('Year is required.');
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
                    field(Tahun; Tahun)
                    {
                        ApplicationArea = All;
                        Caption = 'Year';
                    }
                }
            }
        }
    }

    var
        Tahun: Enum Tahun;
        TotalGaji: Decimal;


}