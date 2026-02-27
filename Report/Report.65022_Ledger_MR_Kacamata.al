report 65022 "Ledger MR Kacamata"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './Report/Report.65022_Ledger_MR_Kacamata.rdlc';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem("Medical Reim Ledger Entries"; "Medical Reim Ledger Entries")
        {
            column(LogoCompany; CompanyInformation.Picture) { }
            column(Entry_No_; "Entry No.") { }
            column(Employee_No_; "Employee No.") { }
            column(Amount; Amount) { }
            column(Quantity_2; "Quantity 2") { }
            column(expired_date_optical; "expired date optical") { }
            column(Medical_Type; "Medical Type") { }
            column(Medical_ValueHeader; MedicalValue) { }
            column(Medical_Value; "Medical Value") { }
            column(Document_Date; "Request Approval Date") { }
            column(Request_Approval_Date; "Request Approval Date") { }
            column(Daily_rate___room; "Daily rate - room") { }
            column(frz_Optical; frz_Optical) { }
            column(Document_No_; "Document No.") { }
            column(StartingDate; StartingDate) { }
            column(EndingDate; EndingDate) { }
            column(Description; Description) { }
            column(Employeename; GetEmployeeNamee("Employee No.")) { }
            column(OpeningBalance; getOpeningBalance(StartingDate, "Medical Type", "Daily rate - room")) { }
            column(OpeningBalanceQuantity; getOpeningBalanceQuantity(StartingDate, "Medical Type", "Daily rate - room")) { }
            trigger OnPreDataItem()
            begin
                if (StartingDate = 0D) or (EndingDate = 0D) then
                    Error('Please input Starting Date and Ending Date');
                SetRange("Request Approval Date", StartingDate, EndingDate);
            end;

            trigger OnAfterGetRecord()
            begin
                if ("Medical Type" <> "Medical Type"::Persalinan) and ("Medical Type" <> "Medical Type"::Kacamata) then
                    MedicalValue := '-' else
                    MedicalValue := "Medical Value";

                if "Medical Type" = "Medical Type"::Kacamata then
                    frz_Optical := true else
                    frz_Optical := false;
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
                    field(Tanggal; StartingDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Starting Date';
                    }
                    field(EndingDate; EndingDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Ending Date';
                    }
                }
            }
        }
    }
    var
        MedicalValue: Code[100];
        StartingDate: Date;
        frz_Optical: Boolean;
        EndingDate: Date;
        CompanyInformation: Record "Company Information";

    trigger OnPreReport()
    begin
        CompanyInformation.CalcFields(Picture);
    end;

    local procedure GetEmployeeNamee(EmployeeNo: code[50]): Text
    var
        Employee: Record Employee;
    begin
        if Employee.get(EmployeeNo) then
            exit(Employee.FullName());
    end;

    local procedure getOpeningBalance(StartingDate: Date; MedicalType: Enum "Type Medical"; DailyRate: Boolean): Decimal
    var
        frz_MedicalLedger: Record "Medical Reim Ledger Entries";
        frz_OpeningBalance: Decimal;
    begin
        frz_OpeningBalance := 0;
        frz_MedicalLedger.Reset();
        frz_MedicalLedger.SetRange("Employee No.", "Medical Reim Ledger Entries"."Employee No.");
        frz_MedicalLedger.SetRange("Medical Type", "Medical Reim Ledger Entries"."Medical Type");
        frz_MedicalLedger.SetFilter("Request Approval Date", '< %1', StartingDate);

        if MedicalType = MedicalType::"Rawat Inap" then
            if DailyRate = true then
                frz_MedicalLedger.SetRange("Daily rate - room", true) else begin
                frz_MedicalLedger.SetRange("Rawat Inat Type", "Medical Reim Ledger Entries"."Rawat Inat Type");
                frz_MedicalLedger.SetRange("Daily rate - room", false);
            end;

        if (MedicalType = MedicalType::Kacamata) or (MedicalType = MedicalType::Persalinan) then
            frz_MedicalLedger.SetRange("Medical Value", "Medical Reim Ledger Entries"."Medical Value");


        if frz_MedicalLedger.FindFirst() then
            repeat
                frz_OpeningBalance += frz_MedicalLedger.Amount;
            until frz_MedicalLedger.Next() = 0;

        exit(frz_OpeningBalance);
    end;

    local procedure getOpeningBalanceQuantity(StartingDate: Date; MedicalType: Enum "Type Medical"; DailyRate: Boolean): Decimal
    var
        frz_MedicalLedger: Record "Medical Reim Ledger Entries";
        frz_OpeningBalance: Decimal;
    begin
        frz_OpeningBalance := 0;
        frz_MedicalLedger.Reset();
        frz_MedicalLedger.SetRange("Employee No.", "Medical Reim Ledger Entries"."Employee No.");
        frz_MedicalLedger.SetRange("Medical Type", "Medical Reim Ledger Entries"."Medical Type");
        frz_MedicalLedger.SetFilter("Request Approval Date", '< %1', StartingDate);

        if MedicalType = MedicalType::Kacamata then
            frz_MedicalLedger.SetRange("Medical Value", "Medical Reim Ledger Entries"."Medical Value");
        if DailyRate = true then
            frz_MedicalLedger.SetRange("Daily rate - room", true);

        if frz_MedicalLedger.FindFirst() then
            repeat
                frz_OpeningBalance += frz_MedicalLedger."Quantity 2";
            until frz_MedicalLedger.Next() = 0;

        exit(frz_OpeningBalance);
    end;
}