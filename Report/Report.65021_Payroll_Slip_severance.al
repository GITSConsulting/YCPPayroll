report 65021 "Payroll Slip Severance"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './Report/Report.65021_Payroll_Slip_severance.rdlc';
    DefaultLayout = RDLC;
    dataset
    {
        dataitem(Employee; Employee)
        {
            column(LogoCompany; CompanyInformation.Picture) { }
            column(Acknowledged_by_name; Acknowledged_by_name) { }
            column(Acknowledged_by_divisi; Acknowledged_by_divisi) { }
            column(Prepared_by_name; Prepared_by_name) { }
            column(Prepared_by_divisi; Prepared_by_divisi) { }
            column(Approved_by_name; Approved_by_name) { }
            column(Approved_by_divisi; Approved_by_divisi) { }
            column(No_; "No.") { }
            column(Tax_Status; "Tax Status") { }
            column(Notesnya; Notesnya) { }
            column(Nomor_Rekening_Bank; "Nomor Rekening Bank") { }
            column(Nama_Pemilik_Rekening; "Nama Pemilik Rekening") { }
            column(Nama_Bank_Tujuan; "Nama Bank Tujuan") { }
            column(kode; "MSI_HRIS PTKP Kode") { }
            column(MSI_HRIS_PTKP_Kode; "MSI_HRIS PTKP Kode") { }
            column(First_Name; FullName()) { }
            column(Last_Name; "Last Name") { }
            column(Job_Title; "Job Title") { }
            column(Office_Location_Code; Locationnya) { }
            column(Employment_Date; JoinDate) { }
            column(Division_Code; divisionName) { }
            column(npwp; "MSI_HRIS NPWP No.") { }
            column(Bank_Account_No_; "Bank Account No.") { }
            column(Tanggal; Tanggal) { }
            column(Severance_LoS; Severance_LoS) { }
            column(Severance_Amount; Severance_Amount) { }
            column(unusedAnnualLeave; unusedAnnualLeave) { }
            column(unusedAnnualLeaveValue; unusedAnnualLeaveValue) { }
            column(EndDate; EndDate) { }
            column(PPH21Amount; PPH21Amount) { }
            column(AmountInWords; AmountInWords) { }
            column(AmountInWordsIndo; AmountInWordsIndo) { }
            column(frz_BasicSalaryLedgerSeverence; frz_BasicSalaryLedgerSeverence) { }
            column(frz_AllowanceLedgerSeverence; frz_AllowanceLedgerSeverence) { }
            column(frz_TotalSeparation_Payment; frz_TotalSeparation_Payment) { }
            column(frz_Total_Unused_Annual_Leave; frz_Total_Unused_Annual_Leave) { }
            column(frz_TotalDeduction; frz_TotalDeduction) { }
            column(frz_TotalIncome; frz_TotalIncome) { }
            column(frz_TakeHomePay; frz_TakeHomePay) { }
            column(frz_totalDailyRate; frz_totalDailyRate) { }
            column(frz_paymentDate; frz_paymentDate) { }
            trigger OnAfterGetRecord()
            var
                frz_SeveranceLedger: Record "Severance Ledger Entry";
                frz_CutiDiBayarLine: Record "Posted Cuti Dibayar Line";
                frz_PPHseverenceEntry: Record "Tarif PPh21 Sevr. Leave Entry";
                DimensionValue: Record "Dimension Value";
                PositionLedgerEntry: Record "Position Ledger Entry";
                DimensionValue_2: Record "Dimension Value";
                PayrollGeneralSetup: Record "Payroll General Setup";
            begin
                Severance_LoS := 0;
                Severance_Amount := 0;
                unusedAnnualLeave := 0;
                unusedAnnualLeaveValue := 0;
                PPH21Amount := 0;
                frz_BasicSalaryLedgerSeverence := 0;
                frz_AllowanceLedgerSeverence := 0;
                frz_Total_Unused_Annual_Leave := 0;
                frz_TotalSeparation_Payment := 0;
                // Locationnya
                DimensionValue.Reset();
                DimensionValue.SetRange(Code, "Office Location Code");
                if DimensionValue.FindFirst() then
                    Locationnya := DimensionValue.Name;
                // divisionnya 
                PayrollGeneralSetup.Get();
                DimensionValue_2.Reset();
                DimensionValue_2.SetRange(Code, "MSI_HRIS Department");
                DimensionValue_2.SetRange("Dimension Code", PayrollGeneralSetup.Department);
                if DimensionValue_2.FindFirst() then
                    divisionName := DimensionValue_2.Name;
                // cari severence ledger
                frz_SeveranceLedger.Reset();
                frz_SeveranceLedger.SetRange("Employee No.", Employee."No.");
                frz_SeveranceLedger.SetRange("Posting Date", CalcDate('-CM', Tanggal), CalcDate('CM', Tanggal));
                if frz_SeveranceLedger.FindLast() then begin
                    // cari joindate
                    JoinDate := frz_SeveranceLedger."Contract Start Date";
                    EndDate := frz_SeveranceLedger."Contract End Date";

                    Severance_LoS := frz_SeveranceLedger."Severance LoS";
                    Severance_Amount := frz_SeveranceLedger."Basic Salary Used" + frz_SeveranceLedger."Fix Allowance Used";
                    frz_BasicSalaryLedgerSeverence := frz_SeveranceLedger."Basic Salary Used";
                    frz_AllowanceLedgerSeverence := frz_SeveranceLedger."Fix Allowance Used";
                    frz_TotalSeparation_Payment := Round(Severance_LoS * Severance_Amount, 1, '=');
                    frz_paymentDate := frz_SeveranceLedger."Actual Payment Date";
                    // cari unused leave
                    frz_CutiDiBayarLine.Reset();
                    frz_CutiDiBayarLine.SetRange("Employee No.", Employee."No.");
                    frz_CutiDiBayarLine.SetRange("Document No.", frz_SeveranceLedger."Unused Leave Doc. No.");
                    if frz_CutiDiBayarLine.FindFirst() then begin
                        unusedAnnualLeave := frz_CutiDiBayarLine."Cuti Dibayarkan";
                        unusedAnnualLeaveValue := round(frz_CutiDiBayarLine."Cuti Dibayarkan (Value)", 1, '=');
                    end;
                    // unused leave tutup
                end;
                // cari severence PPH
                frz_PPHseverenceEntry.Reset();
                frz_PPHseverenceEntry.SetRange("Employee No.", Employee."No.");
                frz_PPHseverenceEntry.SetRange("Posting Date", frz_CutiDiBayarLine."Contract End Date");
                if frz_PPHseverenceEntry.FindLast() then begin
                    repeat
                        PPH21Amount += frz_PPHseverenceEntry.tax;
                    until frz_PPHseverenceEntry.Next() = 0;
                end;
                // Total nya
                PPH21Amount := Round(PPH21Amount, 1, '=');
                if unusedAnnualLeave > 0 then
                    frz_totalDailyRate := unusedAnnualLeaveValue / unusedAnnualLeave;
                // frz_TotalIncome := Round(frz_BasicSalaryLedgerSeverence + frz_AllowanceLedgerSeverence, 1, '=');
                frz_TotalIncome := Round(frz_TotalSeparation_Payment + unusedAnnualLeaveValue, 1, '=');
                frz_TotalDeduction := round(PPH21Amount, 1, '=');
                frz_TakeHomePay := round(frz_TotalIncome - frz_TotalDeduction, 1, '=');
                // english text 
                Saying.FormatNoText(SayingTotalDuit, frz_TakeHomePay, 'IDR');
                AmountInWords := SayingTotalDuit[1];
                // indonesia text 
                SayingIndo.FormatNoText(SayingTotalDuitIndo, frz_TakeHomePay, '');
                AmountInWordsIndo := SayingTotalDuitIndo[1];
            end;

            trigger OnPreDataItem()
            var
                userSetupHRIS: Record "User Setup HRIS";
                employee: Record Employee;
            begin
                userSetupHRIS.Reset();
                userSetupHRIS.SetRange("User ID", UserId);
                if userSetupHRIS.FindFirst() then begin
                    if userSetupHRIS."Admin Attendance" = false then
                        Error('The month must be before the current month');
                end else begin
                    if CalcDate('-CM', Tanggal) >= CalcDate('-CM', Today) then
                        Error('The month must be before the current month');
                end;

                employee.Reset();
                employee.SetRange("No.", Prepared_by);
                if employee.FindFirst() then begin
                    Prepared_by_name := employee.FullName();
                    Prepared_by_divisi := employee."Job Title";
                end;
                employee.Reset();
                employee.SetRange("No.", acknowledged_by);
                if employee.FindFirst() then begin
                    Acknowledged_by_name := employee.FullName();
                    Acknowledged_by_divisi := employee."Job Title";
                end;
                employee.Reset();
                employee.SetRange("No.", Approved_by);
                if employee.FindFirst() then begin
                    Approved_by_name := employee.FullName();
                    Approved_by_divisi := employee."Job Title";
                end;


            end;
        }
    }

    requestpage
    {
        SaveValues = true;
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
                group("Signature")
                {
                    field(Prepared_by; Prepared_by)
                    {
                        ApplicationArea = All;
                        Caption = 'Prepared by';
                        TableRelation = Employee where(Status = const(Active));
                    }
                    field(Acknowledged_by; Acknowledged_by)
                    {
                        ApplicationArea = All;
                        Caption = 'Acknowledged by';
                        TableRelation = Employee where(Status = const(Active));
                    }
                    field(Approved_by; Approved_by)
                    {
                        ApplicationArea = All;
                        Caption = 'Approved by';
                        TableRelation = Employee where(Status = const(Active));
                    }
                }
            }
        }
    }

    var
        divisionName: Text;
        frz_totalDailyRate: Decimal;
        frz_TakeHomePay: Decimal;
        frz_TotalDeduction: Decimal;
        frz_TotalIncome: Decimal;
        frz_Total_Unused_Annual_Leave: Decimal;
        frz_TotalSeparation_Payment: Decimal;
        frz_BasicSalaryLedgerSeverence: Decimal;
        frz_AllowanceLedgerSeverence: Decimal;
        Saying: Codeunit "Saying English";
        AmountInWords: Text;
        SayingTotalDuit: array[2] of Text[80];
        SayingIndo: Codeunit "Saying Indonesia";
        AmountInWordsIndo: Text;
        SayingTotalDuitIndo: array[2] of Text[250];
        EndDate: Date;
        PPH21Amount: Decimal;
        Severance_LoS: Decimal;
        Severance_Amount: Decimal;
        unusedAnnualLeave: Decimal;
        unusedAnnualLeaveValue: Decimal;
        Notesnya: Text;
        Tanggal: Date;
        CompanyInformation: Record "Company Information";
        Locationnya: Text;
        JoinDate: Date;
        Prepared_by: Code[50];
        Acknowledged_by: Code[50];
        Approved_by: Code[50];
        Prepared_by_name: Text;
        Acknowledged_by_name: Text;
        Approved_by_name: Text;
        Prepared_by_divisi: Text;
        Acknowledged_by_divisi: Text;
        Approved_by_divisi: Text;
        frz_paymentDate: Date;


    trigger OnPreReport()
    begin
        CompanyInformation.CalcFields(Picture);
    end;
}