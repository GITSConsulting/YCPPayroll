report 65002 "Payroll Slip Big"
{
    Caption = 'Salary Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './Report/Report.65002_Payroll_Slip_Big.rdlc';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = sorting("No.");
            column(LogoCompany; CompanyInformation.Picture) { }
            column(no_urut; no_urut) { }
            column(No_; "No.") { }
            column(Tanggal; Tanggal) { }
            column(First_Name; "First Name") { }
            column(kode; kode) { }
            column(totalKeluarga; totalKeluarga) { }
            column(Employment_Date; "Employment Date") { }
            column(MSI_HRIS_Basic_Salary; "MSI_HRIS Basic Salary") { }
            column(Last_Name; "Last Name") { }
            column(Job_Title; "Job Title") { }
            column(THR_Amount; "THR Amount") { }
            column(Office_Location_Code; "Office Location Code") { }
            column(ID_No_; "ID No.") { }
            column(Division_Code; "Division Code") { }
            column(Middle_Name; "Middle Name") { }
            column(fullNama; fullNama) { }
            column(totalIncome; totalIncome) { }
            column(totalDeduction; totalDeduction) { }
            column(tarifPPH; tarifPPH) { }
            column(Gross_Income; GrossIncome) { }
            // column(Gross_Income; totalIncome + "MSI_HRIS Basic Salary" + overtime) { }
            column(totalOvertime; totalOvertime) { }
            column(SalaryAfterTax; SalaryAfterTax) { }
            column(SalaryBeforeTax; SalaryBeforeTax) { }
            column(SalaryBeforeTaxInclTHR; SalaryBeforeTaxInclTHR) { }
            column(totalAllowance; totalAllowance) { }
            column(GrossIncIncludingTHR; GrossIncIncludingTHR) { }
            column(BiayaJabatan; BiayaJabatan) { }
            column(YearlyIncomeInclTHR; YearlyIncomeInclTHR) { }
            column(YearlyIncome; YearlyIncome) { }
            column(totalPTKP; totalPTKP) { }
            column(NetYearlyPKP; NetYearlyPKP) { }
            column(NetYearlyPKPInclTHRRoundedDown; NetYearlyPKPInclTHRRoundedDown) { }
            column(NetYearlyPKPInclTHR; NetYearlyPKPInclTHR) { }
            column(TaxPerYear; TaxPerYear) { }
            column(UangPisahTax; UangPisahTax) { }
            column(THRTax; THRTax) { }
            column(TaxPerMonth; TaxPerMonth) { }
            dataitem("Detailed Payroll Ledger Entry"; "Detailed Payroll Ledger Entry")
            {
                DataItemLink = "Employee No." = field("No.");
                // DataItemTableView = sorting("Employee No.");
                column(Employee_No_1; "Employee No.") { }
                column(Description; Description) { }
                column(Amount; Amount) { }
                column(Posting_Date; "Posting Date") { }
                column(amountBPJS; amountBPJS) { }
                column(amountJP; amountJP) { }
                column(amountBPJSTK; amountBPJSTK) { }
                column(amountAllowBPJS; amountAllowBPJS) { }
                column(amountAllowJSHK; amountAllowJSHK) { }
                column(amountAllowJP; amountAllowJP) { }
                column(amountAllowJKK; amountAllowJKK) { }
                column(amountAllowJKM; amountAllowJKM) { }
                column(amountAllowJHT; amountAllowJHT) { }
                // column(totalIncome; totalIncome) { }
                // column(totalDeduction; totalDeduction) { }
                // trigger OnPreDataItem()
                // begin
                //     SetRange("Posting Date", 20210325D);
                // end;

                trigger OnAfterGetRecord()
                begin
                    if "Detailed Payroll Ledger Entry".Type = "Detailed Payroll Ledger Entry".Type::Deduction then begin
                        // if "Detailed Payroll Ledger Entry"."Component Code" = 'BPJS_KES 1%' then begin
                        //     amountBPJS := "Detailed Payroll Ledger Entry".Amount;
                        // end;
                        // if "Detailed Payroll Ledger Entry"."Component Code" = 'JP' then begin
                        //     amountJP := "Detailed Payroll Ledger Entry".Amount;
                        // end;
                        // if "Detailed Payroll Ledger Entry"."Component Code" = 'BPJS_TK (JHT) 2%' then begin
                        //     amountBPJSTK := "Detailed Payroll Ledger Entry".Amount;
                        // end;
                        // totalIncome := totalIncome + "Detailed Payroll Ledger Entry".Amount;
                    end;
                    if "Detailed Payroll Ledger Entry".Type = "Detailed Payroll Ledger Entry".Type::Allowance then begin
                        // if "Detailed Payroll Ledger Entry"."Component Code" = 'BPJS_KES 4%' then begin
                        //     amountAllowBPJS := "Detailed Payroll Ledger Entry".Amount;
                        // end;
                        // if "Detailed Payroll Ledger Entry"."Component Code" = 'JSHK' then begin
                        //     amountAllowJSHK := "Detailed Payroll Ledger Entry".Amount;
                        // end;
                        // if "Detailed Payroll Ledger Entry"."Component Code" = 'JP' then begin
                        //     amountAllowJP := "Detailed Payroll Ledger Entry".Amount;
                        // end;
                        // if "Detailed Payroll Ledger Entry"."Component Code" = 'JKK' then begin
                        //     amountAllowJKK := "Detailed Payroll Ledger Entry".Amount;
                        // end;
                        // if "Detailed Payroll Ledger Entry"."Component Code" = 'JKM' then begin
                        //     amountAllowJKM := "Detailed Payroll Ledger Entry".Amount;
                        // end;
                        // if "Detailed Payroll Ledger Entry"."Component Code" = 'JHT' then begin
                        //     amountAllowJKM := "Detailed Payroll Ledger Entry".Amount;
                        // end;
                        // totalDeduction := totalDeduction + "Detailed Payroll Ledger Entry".Amount;
                    end;
                end;
            }
            dataitem("Deduction Component"; "Deduction Component")
            {
                column(titleDeduc; Name) { }
                column(KodeDeduction; Kode) { }
                column(amountDeduc; amountDeduc) { }
                trigger OnAfterGetRecord()
                begin
                    amountDeduc := 0;
                    detDeduction.Reset();
                    detDeduction.SetRange("Posting Date", Tanggal);
                    detDeduction.SetRange("Component Code", Kode);
                    detDeduction.SetRange(Type, detDeduction.Type::Deduction);
                    detDeduction.SetRange("Employee No.", Employee."No.");
                    if detDeduction.FindFirst() then
                        amountDeduc := detDeduction.Amount;
                end;
            }
            dataitem("Allowance Component"; "Allowance Component")
            {
                column(titleAllow; Name) { }
                column(KodeAllowance; Kode) { }
                column(amountAllow; amountAllow) { }
                trigger OnAfterGetRecord()
                begin
                    amountAllow := 0;
                    alloDeduction.Reset();
                    alloDeduction.SetRange("Posting Date", Tanggal);
                    alloDeduction.SetRange("Component Code", Kode);
                    alloDeduction.SetRange(Type, detDeduction.Type::Allowance);
                    alloDeduction.SetRange("Employee No.", Employee."No.");
                    if alloDeduction.FindFirst() then
                        amountAllow := alloDeduction.Amount;
                end;
            }
            trigger OnPreDataItem()
            begin
                if Tanggal = 0D then error('Posting Date Can`t be empty');
            end;

            trigger OnAfterGetRecord()
            var
                recLedgerEntryOvertime: Record "Overtime Ledger Entry";
                fromDate: Date;
                toDate: date;
                detailPayLedger2: Record "Detailed Payroll Ledger Entry";
                payrollLedgerEntry: Record "Payroll Ledger Entry";
            begin
                fromDate := CalcDate('-CM', Tanggal);
                toDate := CalcDate('CM', Tanggal);
                // no urut
                no_urut += 1;
                // get overtime 
                totalOvertime := 0;
                recLedgerEntryOvertime.Reset();
                recLedgerEntryOvertime.SetRange("Employee No.", "No.");
                recLedgerEntryOvertime.SetRange("Reference Date", fromDate, toDate);
                if recLedgerEntryOvertime.FindFirst() then begin
                    repeat
                        totalOvertime := totalOvertime + recLedgerEntryOvertime.Amount;
                    until recLedgerEntryOvertime.Next = 0;
                end;
                // total income 
                // totalIncome := 0;
                // recIncome.Reset();
                // recIncome.SetRange("Employee No.", Employee."No.");
                // recIncome.SetRange(Type, recIncome.Type::Allowance);
                // recIncome.SetRange("Posting Date", tanggal);
                // if recIncome.FindFirst() then begin
                //     repeat
                //         totalIncome := totalIncome + recIncome.Amount;
                //     until recIncome.Next = 0;
                // end;
                // total deduction 
                totalDeduction := 0;
                recDeduction.Reset();
                recDeduction.SetRange("Employee No.", Employee."No.");
                recDeduction.SetRange(Type, recDeduction.Type::Deduction);
                recDeduction.SetRange("Posting Date", tanggal);
                if recDeduction.FindFirst() then begin
                    repeat
                        totalDeduction := totalDeduction + recDeduction.Amount;
                    until recDeduction.Next = 0;
                end;
                // kode tax status 
                recEmployeeLine.SetRange("Employee No.", Employee."No.");
                if recEmployeeLine.FindFirst() then begin
                    if recEmployeeLine.Relationship = recEmployeeLine.Relationship::Daughter then begin
                        kode := 'K/';
                    end else begin
                        kode := 'TK/';
                    end;

                    if recEmployeeLine.Dependent = true then begin
                        totalKeluarga := recEmployeeLine.Count;
                    end;
                end;
                // tarif pph 
                tarifPPH := 0;
                tarif := 0;
                recPKP.Reset();
                recPKP.SetRange("Employee No.", Employee."No.");
                recPKP.SetRange("Posting Date", tanggal);
                if recPKP.FindFirst() then begin
                    repeat
                        tarif := tarif + recPKP."Owed PPh 21";
                    until recPKP.Next = 0;
                    tarifPPH := tarif / 12;
                end;
                // ambil fullname 
                if "Middle Name" = '' then begin
                    fullNama := Employee."First Name" + ' ' + Employee."Last Name";
                end else begin
                    fullNama := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
                end;

                totalAllowance := 0;
                detailPayLedger2.Reset();
                detailPayLedger2.SetRange("Employee No.", "No.");
                detailPayLedger2.SetRange(Type, detailPayLedger2.Type::Allowance);
                detailPayLedger2.SetRange("Posting Date", Tanggal);
                if detailPayLedger2.FindFirst() then
                    repeat
                        totalAllowance := totalAllowance + detailPayLedger2.Amount;
                    until detailPayLedger2.Next = 0;

                totalPTKP := 0;
                payrollLedgerEntry.Reset();
                payrollLedgerEntry.SetRange("Employee No.", "No.");
                payrollLedgerEntry.SetRange("Posting Date", Tanggal);
                if payrollLedgerEntry.FindFirst() then
                    totalPTKP := payrollLedgerEntry.PTKP;

                totalAmountOvertime := 0;
                rec_OvertimeLedEntry.SetRange("Employee No.", Employee."No.");
                rec_OvertimeLedEntry.SetRange("Reference Date", Tanggal);
                if rec_OvertimeLedEntry.FindFirst() then begin
                    repeat
                        totalAmountOvertime += rec_OvertimeLedEntry.Amount;
                    until rec_OvertimeLedEntry.Next = 0;
                end;
                // DETAIL DEDUCTION 
                // detDeduction.Reset();
                // detDeduction.SetRange("Excel Report", true);
                // if detDeduction.FindFirst() then
                //     repeat
                //         titleDeduc := detDeduction.Name;
                //     until detDeduction.Next = 0;

                // NYOLONG KODE PAK ANDRIE
                TaxPerYear := 0;
                PayrollLedgerEntry.Reset();
                PayrollLedgerEntry.SetRange("Employee No.", "No.");
                PayrollLedgerEntry.SetRange("Posting Date", Tanggal);
                if PayrollLedgerEntry.FindSet() then begin

                    TotalIncome := "MSI_HRIS Basic Salary" + "MSI_HRIS Total Allowance" + "THR Amount" +
                                    "Adjustment Prorate" + "MSI_HRIS Overtime" + totalAllowance + totalAmountOvertime;

                    GrossIncIncludingTHR := TotalIncome;

                    GrossIncome := GrossIncIncludingTHR - "THR Amount";

                    PostPayroll.GetBiayaJabatan(BiayaJabatan, GrossIncome, true);

                    SalaryBeforeTaxInclTHR := GrossIncIncludingTHR + totalDeduction;

                    SalaryBeforeTax := SalaryBeforeTaxInclTHR - "THR Amount";

                    YearlyIncomeInclTHR := ((GrossIncIncludingTHR - "THR Amount" - BiayaJabatan) * 12) + "THR Amount";
                    YearlyIncome := YearlyIncomeInclTHR - "THR Amount";

                    NetYearlyPKPInclTHR := YearlyIncomeInclTHR - "MSI_HRIS PTKP" - totalPTKP;

                    NetYearlyPKP := YearlyIncome - totalPTKP;

                    NetYearlyPKPInclTHRRoundedDown := Round(NetYearlyPKPInclTHR, 1000, '<');
                    NetYearlyPKPRoundedDown := Round(NetYearlyPKP, 1000, '<');

                    HitungTax(Employee, NetYearlyPKPInclTHRRoundedDown, TaxPerYearInclTHR);
                    HitungTax(Employee, NetYearlyPKPRoundedDown, TaxPerYear);

                    HitungTax(Employee, "Uang Pisah", UangPisahTax);
                    TaxPerMonth := TaxPerYear / 12;

                    THRTax := TaxPerYearInclTHR - TaxPerYear;

                    SalaryAfterTax := SalaryBeforeTax - TaxPerMonth - THRTax + "THR Amount";
                    UangPisahShouldBePaid := "Uang Pisah" - UangPisahTax;

                end else begin
                    SalaryBeforeTax := 0;
                    TaxPerMonth := 0;
                    TotalIncome := 0;
                    GrossIncIncludingTHR := 0;
                    GrossIncome := 0;
                    SalaryBeforeTaxInclTHR := 0;
                    SalaryBeforeTax := 0;
                    YearlyIncome := 0;
                    YearlyIncomeInclTHR := 0;
                    NetYearlyPKP := 0;
                    NetYearlyPKPInclTHR := 0;
                    NetYearlyPKPInclTHRRoundedDown := 0;
                    NetYearlyPKPRoundedDown := 0;
                    TaxPerYearInclTHR := 0;
                    TaxPerYear := 0;
                    THRTax := 0;
                    UangPisahTax := 0;
                    SalaryAfterTax := 0;
                    UangPisahShouldBePaid := 0;
                end;
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
        totalPTKP: Decimal;
        // overtime var
        rec_OvertimeLedEntry: Record "Overtime Ledger Entry";
        recOvertime: Record "Posted Overtime Header";
        recOvertimeLine: Record "Posted Overtime Line";
        totalAmountOvertime: Decimal;
        no_urut: Integer;
        fullNama: Text;
        // g1
        recEmployeeLine: Record "Employee Family Entry";
        kode: text;
        totalKeluarga: Integer;
        // g2
        Tanggal: Date;
        CompanyInformation: Record "Company Information";
        TotalGaji: Decimal;
        // g3
        amountBPJSTK: Decimal;
        amountBPJS: Decimal;
        amountJP: Decimal;
        // g4
        amountAllowBPJS: Decimal;
        amountAllowJSHK: Decimal;
        amountAllowJP: Decimal;
        amountAllowJKK: Decimal;
        amountAllowJKM: Decimal;
        amountAllowJHT: Decimal;
        //g5
        recIncome: Record "Detailed Payroll Ledger Entry";
        recDeduction: Record "Detailed Payroll Ledger Entry";
        detDeduction: Record "Detailed Payroll Ledger Entry";
        alloDeduction: Record "Detailed Payroll Ledger Entry";
        // titleDeduc: text;
        amountDeduc: Decimal;
        amountAllow: Decimal;
        totalIncome: Decimal;
        Income: Decimal;
        deduction: Decimal;
        totalDeduction: Decimal;
        overtime: Decimal;
        // g6
        recPKP: Record "Tarif PKP Ledger Entry";
        tarif: Decimal;
        tarifPPH: Decimal;
        // g7 
        totalOvertime: Decimal;
        // var pak andrie
        SalaryBeforeTax: Decimal;
        TaxPerMonth: Decimal;
        PostPayroll: Codeunit "Payroll Post";
        BiayaJabatan: Decimal;
        // TotalIncome: Decimal;
        GrossIncIncludingTHR: Decimal;
        GrossIncome: Decimal;
        SalaryBeforeTaxInclTHR: Decimal;
        YearlyIncomeInclTHR: Decimal;
        YearlyIncome: Decimal;
        NetYearlyPKPInclTHR: Decimal;
        NetYearlyPKP: Decimal;
        NetYearlyPKPInclTHRRoundedDown: Decimal;
        NetYearlyPKPRoundedDown: Decimal;
        TaxPerYearInclTHR: Decimal;
        TaxPerYear: Decimal;
        THRTax: Decimal;
        UangPisahTax: Decimal;
        SalaryAfterTax: Decimal;
        UangPisahShouldBePaid: Decimal;
        PayrollLedgerEntry: Record "Payroll Ledger Entry";
        totalAllowance: Decimal;

    trigger
    OnPreReport()
    begin
        CompanyInformation.CalcFields(Picture);
    end;

    procedure HitungTax(EmpGitu: Record Employee; NetPKP: Decimal; var _DuitPPh21: Decimal);
    var
        TarifPPh21Setup: Record "Tariff PPh 21 Setup";
        Selesai: Boolean;
        PayrollPost: Codeunit "Payroll Post";
        _TarifYangDipake: Decimal;
        TempTax: Decimal;

    begin
        Clear(_DuitPPh21);

        TarifPPh21Setup.Reset();
        TarifPPh21Setup.FindFirst();
        repeat
            _TarifYangDipake := PayrollPost.GetTarifNPWP(EmpGitu, TarifPPh21Setup);
            Clear(TempTax);

            if (TarifPPh21Setup."Upper Limit" <> 0) and (TarifPPh21Setup."Upper Limit" < NetPKP) then begin
                TempTax := (_TarifYangDipake / 100) * TarifPPh21Setup."Upper Limit";
                NetPKP := NetPKP - TarifPPh21Setup."Upper Limit";
            end else begin
                TempTax := (_TarifYangDipake / 100) * NetPKP;
                Selesai := true;
            end;

            _DuitPPh21 := _DuitPPh21 + TempTax;
        until (Selesai) or (TarifPPh21Setup.Next() = 0);
    end;

}