report 65030 "Payroll Slip TDP"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './Report/Report.65030_Payroll_SlipTDP.rdlc';
    DefaultLayout = RDLC;
    dataset
    {
        dataitem(Employee; Employee)
        {
            column(LogoCompany; CompanyInformation.Picture) { }
            column(No_; "No.") { }
            column(UnpaidLeaveDeduction; UnpaidLeaveDeduction) { }
            column(Notesnya; Notesnya) { }
            column(Nomor_Rekening_Bank; "Nomor Rekening Bank") { }
            column(Nama_Pemilik_Rekening; "Nama Pemilik Rekening") { }
            column(Nama_Bank_Tujuan; "Nama Bank Tujuan") { }
            column(kode; "MSI_HRIS PTKP Kode") { }
            column(MSI_HRIS_PTKP_Kode; "MSI_HRIS PTKP Kode") { }
            column(totalKeluarga; totalKeluarga) { }
            column(First_Name; FullName()) { }
            column(Last_Name; "Last Name") { }
            column(Job_Title; "Job Title") { }
            column(Division_Code; divisionName) { }
            column(Office_Location_Code; Locationnya) { }
            column(Employment_Date; JoinDate) { }
            column(ID_No_; "ID No.") { }
            column(npwp; "MSI_HRIS NPWP No.") { }
            column(Bank_Account_No_; "Bank Account No.") { }
            column(MSI_HRIS_Basic_Salary; BasicSalary) { }
            column(tarifPPH; tarifPPH) { }
            column(Adjustment_Prorate; frz_adjustmentProrate) { }
            column(Tanggal; Tanggal) { }
            column(totalAmountOvertime; totalAmountOvertime) { }
            // column(TotalIncome; "MSI_HRIS Basic Salary" + "Detailed Payroll Ledger Entry".Amount) { }
            column(TotalIncome; TotalIncome) { }
            column(TaxPerYear; TaxPerYear) { }
            column(NetYearlyPKP; NetYearlyPKP) { }
            column(TotalIncomee; TotalIncome) { }
            column(totalAllowance; totalAllowance) { }
            column(totalDeduction; totalDeduction) { }
            column(SalaryAfterTax; SalaryAfterTax) { }
            column(DuitPotonganBolos; DuitPotonganBolos) { }
            column(MSI_HRIS_THR_Amount; Round(THRAmount, 1, '='))
            {
                // DecimalPlaces = 0 : 0;
            }
            column(THRTax; THRTax) { }
            column(TaxPerMonth; TaxPerMonth) { }
            column(THRTaxMines; round(THRTax, 1, '=')) { }
            column(TaxPerMonthMines; round(TaxPerMonth, 1, '=')) { }
            column(PayOtherDeduction; round(PayOtherDeduction, 1, '=')) { }
            column(PayUpperLimitKesehatan; PayUpperLimitKesehatan) { }
            column(PayUpperLimitPensiun; PayUpperLimitPensiun) { }
            column(BPJS_KES_JKT; _BPJS_KES_JKT) { }
            column(JHT_JKT; _JHT_JKT) { }
            column(JP_JKT2; _JP_JKT2) { }
            column(BPJS_KES_JKT_YCP; _BPJS_KES_JKT_YCP) { }
            column(JHT_JKT_YCP; _JHT_JKT_YCP) { }
            column(JKK_JKT_YCP_2; _JKK_JKT_YCP_2) { }
            column(JKM_JKT_YCP_2; _JKM_JKT_YCP_2) { }
            column(JP_JKT_YCP_2; _JP_JKT_YCP_2) { }
            column(JSHK_YCP; _JSHK_YCP) { }
            column(BPJS_KES_JKT_YCP_Limit; _BPJS_KES_JKT_YCP_Limit) { }
            column(JP_JKT_YCP_2_Limit; JP_JKT_YCP_2_Limit) { }

            dataitem("Detailed Payroll Ledger Entry"; "Detailed Payroll Ledger Entry")
            {
                DataItemLink = "Employee No." = field("No.");
                column(Employee_No_1; "Employee No.") { }
                column(Entry_No_allowance; "Entry No.") { }
                column(Description; Description) { }
                column(Amount; round(Amount * -1, 1, '=')) { }
                trigger OnPreDataItem()
                begin
                    SetRange("Detailed Payroll Ledger Entry".Type, "Detailed Payroll Ledger Entry".Type::Deduction);
                    SetRange("Posting Date", CalcDate('-CM', Tanggal), CalcDate('CM', Tanggal));
                    SetRange("Paid by Employee", true);
                    SetRange(Taxed, false);
                end;
            }
            dataitem("Detailed Payroll Ledger Entry2"; "Detailed Payroll Ledger Entry")
            {
                DataItemLink = "Employee No." = field("No.");
                column(Employee_No_DEDUCTION; "Employee No.") { }
                column(Entry_No_allowance_DEDUCTION; "Entry No.") { }
                column(Description_DEDUCTION; Description) { }
                column(Amount_DEDUCTION; round(Amount * -1, 1, '=')) { }
                trigger OnPreDataItem()
                begin
                    SetRange("Detailed Payroll Ledger Entry2".Type, "Detailed Payroll Ledger Entry".Type::Deduction);
                    SetRange("Posting Date", CalcDate('-CM', Tanggal), CalcDate('CM', Tanggal));
                    SetRange(Taxed, true);
                end;
            }
            dataitem("Detailed Payroll Ledger Entry 2"; "Detailed Payroll Ledger Entry")
            {
                DataItemLink = "Employee No." = field("No.");
                column(Employee_No_2; "Employee No.") { }
                column(Entry_No_dedaction; "Entry No.") { }
                column(Description_allow; Description) { }
                column(Amount_allow; Amount) { }
                trigger OnPreDataItem()
                begin
                    SetRange("Detailed Payroll Ledger Entry 2".Type, "Detailed Payroll Ledger Entry 2".Type::Allowance);
                    SetRange("Posting Date", CalcDate('-CM', Tanggal), CalcDate('CM', Tanggal));
                    SetRange("Allowance Type", "Allowance Type"::Fix);
                end;
            }
            dataitem("Detailed Payroll Ledger Entry NON FIX ALLOWANCE"; "Detailed Payroll Ledger Entry")
            {
                DataItemLink = "Employee No." = field("No.");
                column(Employee_No_NON_FIX; "Employee No.") { }
                column(Entry_No_dedaction_NON_FIX; "Entry No.") { }
                column(Description_allow_NON_FIX; Description) { }
                column(Amount_allow_NON_FIX; round(Amount, 1, '=')) { }
                trigger OnPreDataItem()
                begin
                    SetRange("Detailed Payroll Ledger Entry NON FIX ALLOWANCE".Type, "Detailed Payroll Ledger Entry NON FIX ALLOWANCE".Type::Allowance);
                    SetRange("Posting Date", CalcDate('-CM', Tanggal), CalcDate('CM', Tanggal));
                    SetRange("Allowance Type", "Allowance Type"::"Non Fix");
                end;
            }
            dataitem("Overtime Ledger Entry"; "Overtime Ledger Entry")
            {
                DataItemLink = "Employee No." = field("No.");
                column(Entry_No_; "Entry No.") { }
                column(Employee_No_; "Employee No.") { }
                column(Reference_Date; "Reference Date") { }
                column(Amount_Overtime; Amount) { }
                trigger OnPreDataItem()
                begin
                    SetRange("Payroll Posting Date", CalcDate('-CM', Tanggal), CalcDate('CM', Tanggal));
                end;
            }
            trigger OnAfterGetRecord()
            var
                // overtime
                overtimeNo: Code[20];
                detailPayLedgerKES: Record "Detailed Payroll Ledger Entry";
                detailPayLedgerJHT: Record "Detailed Payroll Ledger Entry";
                detailPayLedger: Record "Detailed Payroll Ledger Entry";
                detailPayLedger2: Record "Detailed Payroll Ledger Entry";
                _detailPayLedgerpaidYCP, _detailPayLedgerpaidEmp : Record "Detailed Payroll Ledger Entry";
                payrollLedgerEntry: Record "Payroll Ledger Entry";
                payrollLedgerEntry_2: Record "Payroll Ledger Entry";
                UnpaidLeaveRequest: Record "Posted Leave Request";
                PostedUnpaidLeave: Record "Posted Leave Request";
                PPH21ENTRY: Record "Tarif PPh21 Entry";
                THRENTRY: Record "Tarif PPh21 THR Entry";
                totalPTKP: Decimal;
                totalBolos: Integer;
                taxPERYEARNEW: Decimal;
                taxTHRPERYEAR: Decimal;
                THRLedgerEntry: Record "THR Ledger Entry";
                DimensionValue: Record "Dimension Value";
                PositionLedgerEntry: Record "Position Ledger Entry";
                DimensionValue_2: Record "Dimension Value";
                PayrollGeneralSetup: Record "Payroll General Setup";
                _AllowanceComponent: Record "Allowance Component";
            begin
                PayrollGeneralSetup.Get();
                DimensionValue_2.Reset();
                DimensionValue_2.SetRange(Code, "MSI_HRIS Department");
                DimensionValue_2.SetRange("Dimension Code", PayrollGeneralSetup.Department);
                if DimensionValue_2.FindFirst() then
                    divisionName := DimensionValue_2.Name;

                _detailPayLedgerpaidYCP.Reset();
                _detailPayLedgerpaidYCP.SetRange("Employee No.", "No.");
                _detailPayLedgerpaidYCP.SetRange("Paid by Employee", false);
                _detailPayLedgerpaidYCP.SetRange("Posting Date", CalcDate('-CM', Tanggal), CalcDate('CM', Tanggal));
                _detailPayLedgerpaidYCP.SetRange(Type, _detailPayLedgerpaidYCP.Type::Allowance);
                if _detailPayLedgerpaidYCP.FindSet() then
                    repeat
                        if _detailPayLedgerpaidYCP."Component Code" = 'BPJS_KES_JKT_YCP' then
                            _BPJS_KES_JKT_YCP := _detailPayLedgerpaidYCP.Amount;
                        if _detailPayLedgerpaidYCP."Component Code" = 'JHT_JKT_YCP' then
                            _JHT_JKT_YCP := _detailPayLedgerpaidYCP.Amount;
                        if _detailPayLedgerpaidYCP."Component Code" = 'JKK_JKT_YCP' then
                            _JKK_JKT_YCP_2 := _detailPayLedgerpaidYCP.Amount;
                        if _detailPayLedgerpaidYCP."Component Code" = 'JKM_JKT_YCP' then
                            _JKM_JKT_YCP_2 := _detailPayLedgerpaidYCP.Amount;
                        if _detailPayLedgerpaidYCP."Component Code" = 'JP_JKT_YCP' then
                            _JP_JKT_YCP_2 := _detailPayLedgerpaidYCP.Amount;
                        if _detailPayLedgerpaidYCP."Component Code" = 'JSHK_YCP' then
                            _JSHK_YCP := _detailPayLedgerpaidYCP.Amount;
                    until _detailPayLedgerpaidYCP.Next() = 0;

                _detailPayLedgerpaidEmp.Reset();
                _detailPayLedgerpaidEmp.SetRange("Employee No.", "No.");
                _detailPayLedgerpaidEmp.SetRange("Paid by Employee", true);
                _detailPayLedgerpaidEmp.SetRange("Posting Date", CalcDate('-CM', Tanggal), CalcDate('CM', Tanggal));
                _detailPayLedgerpaidEmp.SetRange(Type, _detailPayLedgerpaidEmp.Type::Deduction);
                if _detailPayLedgerpaidEmp.FindSet() then
                    repeat
                        if _detailPayLedgerpaidEmp."Component Code" = 'BPJS_KES_JKT' then
                            _BPJS_KES_JKT := abs(_detailPayLedgerpaidEmp.Amount);
                        if _detailPayLedgerpaidEmp."Component Code" = 'JHT_JKT' then
                            _JHT_JKT := abs(_detailPayLedgerpaidEmp.Amount);
                        if _detailPayLedgerpaidEmp."Component Code" = 'JP_JKT_2' then
                            _JP_JKT2 := abs(_detailPayLedgerpaidEmp.Amount);
                    until _detailPayLedgerpaidEmp.Next() = 0;

                detailPayLedgerKES.Reset();
                detailPayLedgerKES.SetRange("Employee No.", "No.");
                detailPayLedgerKES.SetRange(Type, detailPayLedgerKES.Type::Deduction);
                detailPayLedgerKES.SetRange("Posting Date", CalcDate('-CM', Tanggal), CalcDate('CM', Tanggal));
                detailPayLedgerKES.SetFilter("Component Code", '*KES*');
                detailPayLedgerKES.SetFilter("Salary Upper Limit", '<> %1', 0);
                if detailPayLedgerKES.FindFirst() then
                    PayUpperLimitKesehatan := detailPayLedgerKES."Salary Upper Limit";

                detailPayLedgerJHT.Reset();
                detailPayLedgerJHT.SetRange("Employee No.", "No.");
                detailPayLedgerJHT.SetRange(Type, detailPayLedgerJHT.Type::Deduction);
                detailPayLedgerJHT.SetRange("Posting Date", CalcDate('-CM', Tanggal), CalcDate('CM', Tanggal));
                detailPayLedgerJHT.SetFilter("Component Code", '*JP*');
                detailPayLedgerJHT.SetFilter("Salary Upper Limit", '<> %1', 0);
                if detailPayLedgerJHT.FindFirst() then
                    PayUpperLimitPensiun := detailPayLedgerJHT."Salary Upper Limit";

                PositionLedgerEntry.Reset();
                PositionLedgerEntry.SetRange("Employee No.", "No.");
                if PositionLedgerEntry.FindFirst() then
                    JoinDate := PositionLedgerEntry."Contract Start Date";

                DimensionValue.Reset();
                DimensionValue.SetRange(Code, "Office Location Code");
                if DimensionValue.FindFirst() then
                    Locationnya := DimensionValue.Name;

                taxPERYEAR := 0;
                PPH21ENTRY.Reset();
                PPH21ENTRY.SetRange("Employee No.", "No.");
                PPH21ENTRY.SetRange("Posting Date Payroll", CalcDate('-CM', Tanggal), CalcDate('CM', Tanggal));
                if PPH21ENTRY.FindFirst() then
                    repeat
                        taxPERYEARNEW += PPH21ENTRY.Tax;
                    until PPH21ENTRY.Next() = 0;

                THRENTRY.Reset();
                THRENTRY.SetRange("Employee No.", "No.");
                THRENTRY.SetRange("Posting Date THR", CalcDate('-CM', Tanggal), CalcDate('CM', Tanggal));
                if THRENTRY.FindFirst() then
                    repeat
                        taxTHRPERYEAR += THRENTRY.Tax;
                    until THRENTRY.Next() = 0;

                // nyari jumlah bolos 
                AwalBulanLalu := CalcDate('-CM', CalcDate('-1M', Tanggal));
                AkhirBulanLalu := CalcDate('CM', CalcDate('-1M', Tanggal));
                UnpaidLeaveRequest.Reset();
                UnpaidLeaveRequest.SetRange("Leave Type", UnpaidLeaveRequest."Leave Type"::Unpaid);
                UnpaidLeaveRequest.SetRange("Employee No.", Employee."No.");
                UnpaidLeaveRequest.SetFilter("Starting Date", '>= %1', AwalBulanLalu);
                UnpaidLeaveRequest.SetFilter("Ending Date", '<= %1', AkhirBulanLalu);
                UnpaidLeaveRequest.SetRange(Reversed, false);
                UnpaidLeaveRequest.SetCurrentKey("Leave Type", "Employee No.", "Starting Date", "Ending Date", Reversed);
                if UnpaidLeaveRequest.FindSet() then begin
                    UnpaidLeaveRequest.CalcSums("Total Number of Days");
                    UnpaidLeaveRequest.CalcSums("Salary Deduction");

                    CutiBolos := UnpaidLeaveRequest."Total Number of Days";
                    DuitPotonganBolos := UnpaidLeaveRequest."Salary Deduction";
                end else begin
                    CutiBolos := 0;
                    DuitPotonganBolos := 0;
                end;

                fromDate := CalcDate('-CM', Tanggal);
                toDate := CalcDate('CM', tanggal);
                // kode keluarga///////////////////////////////////////////////////////////////////////////
                recEmployeeLine.SetRange("Employee No.", Employee."No.");
                if recEmployeeLine.FindFirst() then begin
                    if recEmployeeLine.Relationship = recEmployeeLine.Relationship::Daughter then
                        kode_mulu := 'K/'
                    else
                        kode_mulu := 'TK/';

                    if recEmployeeLine.Dependent = true then
                        totalKeluarga := recEmployeeLine.Count;
                end;
                // tarif pph //////////////////////////////////////////////////////////////////////////////
                tarifPPH := 0;
                tarif := 0;
                recPKP.Reset();
                recPKP.SetRange("Employee No.", Employee."No.");
                recPKP.SetRange("Posting Date", fromDate, toDate);
                if recPKP.FindFirst() then
                    tarifPPH := recPKP.PPh21;
                ////////overtime///////////////////////////////////////////////////////////////////////////
                totalAmountOvertime := 0;
                "Overtime Ledger Entry".SetRange("Employee No.", Employee."No.");
                "Overtime Ledger Entry".SetRange("Reference Date", CalcDate('-CM', Tanggal), CalcDate('CM', Tanggal));
                if "Overtime Ledger Entry".FindFirst() then begin
                    repeat
                        totalAmountOvertime += "Overtime Ledger Entry".Amount;
                    until "Overtime Ledger Entry".Next = 0;
                end;
                ////////overtime///////////////////////////////////////////////////////////////////////////
                totalDeduction := 0;
                detailPayLedger.Reset();
                detailPayLedger.SetRange("Employee No.", "No.");
                detailPayLedger.SetRange(Type, detailPayLedger.Type::Deduction);
                detailPayLedger.SetRange("Posting Date", CalcDate('-CM', Tanggal), CalcDate('CM', Tanggal));
                if detailPayLedger.FindFirst() then
                    repeat
                        totalDeduction := totalDeduction + detailPayLedger.Amount;
                    until detailPayLedger.Next = 0;

                totalAllowance := 0;
                detailPayLedger2.Reset();
                detailPayLedger2.SetRange("Employee No.", "No.");
                detailPayLedger2.SetRange(Type, detailPayLedger2.Type::Allowance);
                detailPayLedger2.SetRange("Posting Date", CalcDate('-CM', Tanggal), CalcDate('CM', Tanggal));
                if detailPayLedger2.FindFirst() then
                    repeat
                        totalAllowance := totalAllowance + detailPayLedger2.Amount;
                    until detailPayLedger2.Next = 0;

                totalPTKP := 0;
                THRAmount := 0;

                THRLedgerEntry.Reset();
                THRLedgerEntry.SetRange("Employee No.", "No.");
                THRLedgerEntry.SetRange("Posting Date", CalcDate('-CM', Tanggal), CalcDate('CM', Tanggal));
                if THRLedgerEntry.FindFirst() then
                    repeat
                        THRAmount += THRLedgerEntry."THR Amount";
                    until THRLedgerEntry.Next() = 0;

                if not Employee."MSI_HRIS Last Payroll" then begin
                    if taxTHRPERYEAR > 0 then
                        THRTax := taxTHRPERYEAR - taxPERYEARNEW
                    else
                        THRTax := 0;
                end else
                    THRTax := 0;

                TaxPerYear := 0;
                PayOtherDeduction := 0;
                frz_adjustmentProrate := 0;
                payrollLedgerEntry_2.Reset();
                payrollLedgerEntry_2.SetRange("Employee No.", "No.");
                payrollLedgerEntry_2.SetRange("Posting Date", CalcDate('-CM', Tanggal), CalcDate('CM', Tanggal));
                if payrollLedgerEntry_2.FindFirst() then
                    repeat
                        PayOtherDeduction += payrollLedgerEntry_2."Other Deduction";
                        frz_adjustmentProrate += payrollLedgerEntry_2."Adjustment Prorate";
                    until payrollLedgerEntry_2.Next() = 0;

                PayrollLedgerEntry.Reset();
                PayrollLedgerEntry.SetRange("Employee No.", "No.");
                PayrollLedgerEntry.SetRange("Posting Date", CalcDate('-CM', Tanggal), CalcDate('CM', Tanggal));
                if PayrollLedgerEntry.FindSet() then begin
                    // Employee."Date Filter" := Tanggal;
                    Employee.CalcFields("MSI_HRIS Total Allowance");
                    Employee.CalcFields("MSI_HRIS Total Deduction");
                    Employee.CalcFields("MSI_HRIS Total Allowance Taxed");
                    Employee.CalcFields("MSI_HRIS Total Deduction Taxed");
                    Employee.CalcFields("MSI_HRIS PPh 21");
                    Employee.CalcFields("MSI_HRIS Overtime Processed");
                    Employee.CalcFields("MSI_HRIS Bijab Reguler");
                    //Employee.CalcFields("MSI_HRIS PTKP");
                    Employee.CalcFields("MSI_HRIS PTKP Baru");
                    Employee.CalcFields("MSI_HRIS Overtime");
                    Employee.CalcFields("MSI_HRIS THR Ledger");

                    Employee.CalcFields("MSI_HRIS Total Allowance Fix");
                    Employee.CalcFields("MSI_HRIS Total Allownc. NonFix");
                    Employee.CalcFields("MSI_HRIS BPJS Kesehatan Staff");

                    TotalPremiumTaxed := round(Employee."MSI_HRIS Total Allowance Taxed", 1, '=');
                    IuranPensiunTHTJHT := round(Employee."MSI_HRIS Total Deduction Taxed");

                    PostedUnpaidLeave.Reset();
                    PostedUnpaidLeave.SetRange("Employee No.", Employee."No.");
                    PostedUnpaidLeave.SetRange("Payroll Ledger Entry No.",
                    PayrollLedgerEntry."Entry No.");
                    if PostedUnpaidLeave.FindFirst() then
                        UnpaidLeaveDeduction := round(PostedUnpaidLeave."Salary Deduction", 1, '=');


                    TotalIncome := PayrollLedgerEntry."Total Income";
                    GrossIncome := PayrollLedgerEntry."Gross Income";
                    RegulerSetahun := PayrollLedgerEntry."Reguler Setahun";
                    BiayaJabatan := PayrollLedgerEntry."Biaya Jabatan";
                    BijabReguler := PayrollLedgerEntry."Bijab Reguler";
                    PensiunJHTTHTSetahun := PayrollLedgerEntry."Pensiun JHT THT Setahun";
                    JumlahPengurangan := PayrollLedgerEntry."Jumlah Pengurangan";
                    PenghasilanNettoSetahun := PayrollLedgerEntry."Penghasilan Netto Setahun";
                    PKPCorrect := PayrollLedgerEntry."PKP Correct";
                    LessOverDeductTax := PayrollLedgerEntry."Less/Over Deduct Tax";

                    Employee.CalcFields("MSI_HRIS Tax Per Year");

                    if not Employee."MSI_HRIS Last Payroll" then
                        if PayrollLedgerEntry."Periode Penghasilan" <> 0 then
                            TaxPerMonth := Round(taxPERYEARNEW /
                                                    PayrollLedgerEntry."Periode Penghasilan", 1)
                        else
                            TaxPerMonth := 0
                    else
                        TaxPerMonth := LessOverDeductTax;

                    NetSalary := round(TotalIncome + Employee."MSI_HRIS BPJS Kesehatan Staff" +
                    IuranPensiunTHTJHT - TaxPerMonth, 1, '=');

                    TakeHomePay := round(NetSalary - UnpaidLeaveDeduction, 1, '=');

                    UangPisahShouldBePaid := Employee."Uang Pisah" - UangPisahTax;
                    BasicSalary := PayrollLedgerEntry."Basic Salary";

                end else begin
                    if Employee."MSI_HRIS Los Newly Calc." then
                        THRAmount := Employee."THR Amount"
                    else
                        THRAmount := 0;
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
                    BasicSalary := Employee."MSI_HRIS Basic Salary";
                end;
            end;

            trigger OnPreDataItem()
            var
                userSetupHRIS: Record "User Setup HRIS";
                _AllowanceComponent: Record "Allowance Component";
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

                _AllowanceComponent.SetRange("Kode", 'BPJS_KES_JKT_YCP');
                if _AllowanceComponent.FindFirst() then
                    _BPJS_KES_JKT_YCP_Limit := _AllowanceComponent."Salary Upper Limit";
                _AllowanceComponent.Reset();
                _AllowanceComponent.SetRange("Kode", 'JP_JKT_YCP_2');
                if _AllowanceComponent.FindFirst() then
                    JP_JKT_YCP_2_Limit := _AllowanceComponent."Salary Upper Limit";
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
                group("Notes")
                {
                    field(Notesnya; Notesnya)
                    {
                        ShowCaption = false;
                        ApplicationArea = All;
                        MultiLine = true;
                    }

                }
            }
        }
    }

    var
        frz_adjustmentProrate: Decimal;
        Notesnya: Text;
        AwalBulanLalu: date;
        AkhirBulanLalu: date;
        _BPJS_KES_JKT_YCP, _JHT_JKT_YCP, _JKK_JKT_YCP_2, _JKM_JKT_YCP_2, _JP_JKT_YCP_2, _JSHK_YCP : Decimal;
        _BPJS_KES_JKT, _JHT_JKT, _JP_JKT2, JP_JKT_YCP_2_Limit, _BPJS_KES_JKT_YCP_Limit : Decimal;
        // filter
        Tanggal: Date;
        fromDate: Date;
        toDate: Date;
        totalDeduction: Decimal;
        totalAllowance: Decimal;
        // g1
        CompanyInformation: Record "Company Information";
        // g2
        recEmployeeLine: Record "Employee Family Entry";
        totalKeluarga: Integer;

        BijabReguler: Decimal;
        kode_mulu: text;
        // pajak
        recPKP: Record "Tarif PKP Ledger Entry";
        tarif: Decimal;
        tarifPPH: Decimal;

        // overtime
        recOvertime: Record "Posted Overtime Header";
        recOvertimeLine: Record "Posted Overtime Line";
        totalAmountOvertime: Decimal;
        PayrollLedgerEntry: Record "Payroll Ledger Entry";
        PostingPayrollPage: page "Process Payroll Page";
        NggaAktif: Boolean;
        InactiveStatus: Boolean;
        SalaryBeforeTax: Decimal;
        TaxPerMonth: Decimal;
        PostPayroll: Codeunit "Payroll Post";
        BiayaJabatan: Decimal;
        TotalIncome: Decimal;
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
        CutiBolos: Decimal;
        DuitPotonganBolos: Decimal;
        TotalPremiumTaxed: Decimal;
        IuranPensiunTHTJHT: Decimal;
        UnpaidLeaveDeduction: Decimal;
        RegulerSetahun: Decimal;
        LessOverDeductTax: Decimal;
        PensiunJHTTHTSetahun: Decimal;
        JumlahPengurangan: Decimal;
        PenghasilanNettoSetahun: Decimal;
        PKPCorrect: Decimal;
        NetSalary: Decimal;
        TakeHomePay: Decimal;
        BasicSalary: Decimal;
        THRAmount: decimal;
        PayOtherDeduction: decimal;
        PayUpperLimitKesehatan: decimal;
        PayUpperLimitPensiun: decimal;
        Locationnya: Text;
        JoinDate: Date;
        divisionName: Text;


    trigger
    OnPreReport()
    begin
        CompanyInformation.CalcFields(Picture);
    end;
    // fadhil
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