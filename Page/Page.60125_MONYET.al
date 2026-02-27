page 60125 MONYET
{
    PageType = Worksheet;
    SourceTable = Employee;
    UsageCategory = Lists;
    CardPageId = "Employee Card HR";
    PromotedActionCategories = 'Processing';
    //ModifyAllowed = false;
    //Editable = false;
    RefreshOnActivate = true;


    layout
    {
        area(Content)
        {
            group(atas)
            {
                ShowCaption = false;
                field(Displaying; Displaying)
                {
                    ApplicationArea = all;
                    ShowCaption = false;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field(HariBulanLalu; HariBulanLalu)
                {
                    ShowCaption = false;
                    ApplicationArea = all;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field(HariKerjaBulanLalu; HariKerjaBulanLalu)
                {
                    ShowCaption = false;
                    ApplicationArea = all;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field(HariLiburBulanLalu; HariLiburBulanLalu)
                {
                    ShowCaption = false;
                    ApplicationArea = all;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = true;

                    trigger
                    OnDrillDown()
                    var
                        HRSetup: Record "Payroll General Setup";
                        NonWorkingDates: Page "Non Working Dates";
                        BaseCalendarChange: Record "Base Calendar Change";
                    begin
                        HRSetup.Get();
                        HRSetup.TestField("Base Calendar Code");
                        BaseCalendarChange.Reset();
                        BaseCalendarChange.SetRange("Base Calendar Code", HRSetup."Base Calendar Code");
                        BaseCalendarChange.SetRange(Date, AwalBulanLalu, AkhirBulanLalu);
                        if BaseCalendarChange.FindSet() then begin
                            NonWorkingDates.SetTableView(BaseCalendarChange);
                            NonWorkingDates.Run();
                        end;
                    end;
                }
            }
            repeater(Group)
            {

                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                    StyleExpr = NggaAktif;
                    Editable = false;

                    trigger
                    OnDrillDown()
                    var
                        PegawaiHR: Record Employee;
                        CardPegawaiHR: page "Employee Card HR";
                    begin
                        CardPegawaiHR.SetRecord(Rec);
                        CardPegawaiHR.Run();
                    end;
                }
                field("First Name"; Rec."First Name")
                {
                    ApplicationArea = all;
                    Style = Unfavorable;
                    StyleExpr = NggaAktif;
                    Editable = false;
                }
                field("Last Name"; Rec."Last Name")
                {
                    ApplicationArea = all;
                    Style = Unfavorable;
                    StyleExpr = NggaAktif;
                    Editable = false;
                }
                field("MSI_HRIS PTKP Kode"; Rec."MSI_HRIS PTKP Kode")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Kode PTKP';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                /*
                field("Inactive Status"; Rec."Inactive Status")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = InactiveStatus;
                }
                field("MSI_HRIS Leave Balance"; Rec."MSI_HRIS Leave Balance")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Kehadiran; Kehadiran)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Attendance a Month Before';
                    trigger
                    OnAssistEdit()
                    var
                        EmployeeAbsenceLine: Record "Employee Absence Line";
                        PageAbsenceLine: Page "Employee Absence Lines";
                    begin
                        Clear(PageAbsenceLine);
                        EmployeeAbsenceLine.Reset();
                        EmployeeAbsenceLine.SetRange("Employee No.", Rec."No.");
                        EmployeeAbsenceLine.SetRange(Date, AwalBulanLalu, AkhirBulanLalu);
                        if EmployeeAbsenceLine.FindFirst() then begin
                            PageAbsenceLine.LookupMode(true);
                            PageAbsenceLine.SetTableView(EmployeeAbsenceLine);
                            PageAbsenceLine.Run();
                        end;
                    end;
                }
                field(KehadiranSekarang; KehadiranSekarang)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Attendance This Month';
                    trigger
                    OnAssistEdit()
                    var
                        EmployeeAbsenceLine: Record "Employee Absence Line";
                        PageAbsenceLine: Page "Employee Absence Lines";
                    begin
                        Clear(PageAbsenceLine);
                        EmployeeAbsenceLine.Reset();
                        EmployeeAbsenceLine.SetRange("Employee No.", Rec."No.");
                        EmployeeAbsenceLine.SetRange(Date, AwalBulanSekarang, AkhirBulanSekarang);
                        if EmployeeAbsenceLine.FindFirst() then begin
                            PageAbsenceLine.LookupMode(true);
                            PageAbsenceLine.SetTableView(EmployeeAbsenceLine);
                            PageAbsenceLine.Run();
                        end;
                    end;
                }
                field(CutiBolos; CutiBolos)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Unpaid Leave a Month Before';

                    trigger
                    OnAssistEdit()
                    var
                        UnpaidLeaveRequest: Record "Posted Leave Request";
                        ListUnpaidLeave: page "Posted Unpaid Leave Drilldown";
                    begin
                        //bingung, ambil dari unpaid atau postednya
                        //besok kerjain

                        UnpaidLeaveRequest.Reset();
                        UnpaidLeaveRequest.SetRange("Leave Type", UnpaidLeaveRequest."Leave Type"::Unpaid);
                        UnpaidLeaveRequest.SetRange("Employee No.", Rec."No.");
                        UnpaidLeaveRequest.SetFilter("Starting Date", '>=%1', AwalBulanLalu);
                        UnpaidLeaveRequest.SetFilter("Ending Date", '<=%1', AkhirBulanLalu);
                        if UnpaidLeaveRequest.FindFirst() then begin
                            ListUnpaidLeave.LookupMode(true);
                            ListUnpaidLeave.SetTableView(UnpaidLeaveRequest);
                            ListUnpaidLeave.Run();
                        end;
                    end;
                }
                field(DuitPotonganBolos; DuitPotonganBolos)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Salary Deduction a Month Before';
                    trigger
                    OnAssistEdit()
                    var
                        UnpaidLeaveRequest: Record "Posted Leave Request";
                        ListUnpaidLeave: page "Posted Unpaid Leave Drilldown";
                    begin
                        //bingung, ambil dari unpaid atau postednya
                        //besok kerjain

                        UnpaidLeaveRequest.Reset();
                        UnpaidLeaveRequest.SetRange("Leave Type", UnpaidLeaveRequest."Leave Type"::Unpaid);
                        UnpaidLeaveRequest.SetRange("Employee No.", Rec."No.");
                        UnpaidLeaveRequest.SetFilter("Starting Date", '>=%1', AwalBulanLalu);
                        UnpaidLeaveRequest.SetFilter("Ending Date", '<=%1', AkhirBulanLalu);
                        UnpaidLeaveRequest.SetRange(Reversed, false);
                        if UnpaidLeaveRequest.FindFirst() then begin
                            ListUnpaidLeave.LookupMode(true);
                            ListUnpaidLeave.SetTableView(UnpaidLeaveRequest);
                            ListUnpaidLeave.Run();
                        end;
                    end;
                }
                field(LeaveValue; Rec.LeaveValue())
                {
                    Caption = 'Leave Balance (Value)';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(BayarkanCuti; BayarkanCuti)
                {
                    Caption = 'Bayarkan Cuti';
                    ApplicationArea = all;
                    trigger
                    OnDrillDown()
                    begin
                        Rec.TestField(Status, Rec.Status::Active);

                        if Rec.LeaveValue() <= 0 then
                            Error('There is no leave value balance for employee %1',
                            Rec.FullName());

                        if not Rec."Bayarkan Cuti" then
                            Rec."Bayarkan Cuti" := true
                        else
                            if not (Rec."Inactive Status" = Rec."Inactive Status"::Resigned) then
                                Rec."Bayarkan Cuti" := false
                            else
                                Error('Employee % is set to resigned. The leave will be paid.');

                        CurrPage.Update();
                    end;
                }
                */
                field(PeriodePenghasilan; PeriodePenghasilan)
                {
                    Caption = 'Periode Penghasilan';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Basic Salary"; Rec."MSI_HRIS Basic Salary")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("MSI_HRIS Total Allowance Fix"; Rec."MSI_HRIS Total Allowance Fix")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("MSI_HRIS Total Allownc. NonFix"; Rec."MSI_HRIS Total Allownc. NonFix")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("THR Amount"; Rec."THR Amount")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Adjustment Prorate"; Rec."Adjustment Prorate")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                /*
                field("Uang Pisah"; Rec."Uang Pisah")
                {
                    Caption = 'Uang Pisah/Pesangon';
                    ApplicationArea = all;
                    Editable = false;
                }
                */
                field("MSI_HRIS Overtime"; Rec."MSI_HRIS Overtime")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                /*
                field("Cuti Dibayar"; Rec."Cuti Dibayar")
                {
                    Caption = 'Paid Annual Leave';
                    ApplicationArea = all;
                    Editable = false;
                }
                */
                field(TotalIncome; TotalIncome)
                {
                    Caption = 'Total Income';
                    ApplicationArea = all;
                    Editable = false;
                }
                /*
                field("MSI_HRIS Allowance Tangg. YCP"; Rec."MSI_HRIS Allowance Tangg. YCP")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                */

                /*
                field("Total Allowance"; Rec."MSI_HRIS Total Allowance")
                {
                    Caption = 'Total Premium YCP Portion';
                    ApplicationArea = all;
                    Editable = false;
                    Visible = false;
                }
                */
                field(TotalPremiumTaxed; TotalPremiumTaxed)
                {
                    Caption = 'Total Premium Taxed';
                    ApplicationArea = all;
                    Editable = false;
                    DecimalPlaces = 0 : 0;
                }
                field("MSI_HRIS Total Allowance Taxed"; Rec."MSI_HRIS Total Allowance Taxed")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                /*
                field(GrossIncIncludingTHR; GrossIncIncludingTHR)
                {
                    Caption = 'Gross Income incl. THR';
                    Editable = false;
                    ApplicationArea = all;
                }
                */
                field(GrossIncome; GrossIncome)
                {
                    Caption = 'Gross Income';
                    Editable = false;
                    ApplicationArea = all;
                    //DecimalPlaces = 0 : 0;
                }

                /*
                field("MSI_HRIS Deduction Paid Empl."; Rec."MSI_HRIS Deduction Paid Empl.")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Total Deduction"; Rec."MSI_HRIS Total Deduction")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                */

                field(IuranPensiunTHTJHT; IuranPensiunTHTJHT)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Iuran Pensiun atau Iuran THT/JHT';
                    DecimalPlaces = 0 : 0;
                }

                field("MSI_HRIS Total Deduction Taxed"; Rec."MSI_HRIS Total Deduction Taxed")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Iuran Pensiun atau Iuran THT/JHT';
                    DecimalPlaces = 0 : 0;
                }
                field(RegulerSetahun; RegulerSetahun)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Reguler Setahun';
                }
                /*
                field(SalaryBeforeTaxInclTHR; SalaryBeforeTaxInclTHR)
                {
                    Caption = 'Salary Before Tax incl. THR';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(SalaryBeforeTax; SalaryBeforeTax)
                {
                    Caption = 'Salary Before Tax';
                    ApplicationArea = all;
                    Editable = false;
                }
                */

                /*
                field(BiayaJabatan; BiayaJabatan)
                {
                    Caption = 'Biaya Jabatan';
                    ApplicationArea = all;
                    Editable = false;
                }
                */
                field(BijabReguler; BijabReguler)
                {
                    Editable = false;
                    ApplicationArea = all;
                    Caption = 'Bijab Reguler';
                    DecimalPlaces = 0 : 0;
                }
                field(PensiunJHTTHTSetahun; PensiunJHTTHTSetahun)
                {
                    Caption = 'Iuran Pensiun atau Iuran THT/JHT Setahun';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(JumlahPengurangan; JumlahPengurangan)
                {
                    Caption = 'Jumlah Pengurangan';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(PenghasilanNettoSetahun; PenghasilanNettoSetahun)
                {
                    Caption = 'Penghasilan Netto Setahun/Disetahunkan';
                    ApplicationArea = all;
                    Editable = false;
                }
                /*
                field(YearlyIncomeInclTHR; YearlyIncomeInclTHR)
                {
                    Caption = 'Yearly Income incl. THR';
                    ApplicationArea = all;
                    Editable = false;
                }
                
                field(GrossIncomeForTax; GrossIncomeForTax)
                {
                    Caption = 'Gross Income for Tax';
                    ApplicationArea = all;
                    Editable = false;
                }*/


                /*
                field(YearlyIncomeCorrect; YearlyIncomeCorrect)
                {
                    Caption = 'Yearly Income';
                    ApplicationArea = all;
                    Editable = false;
                }*/
                field("MSI_HRIS PTKP Baru"; Rec."MSI_HRIS PTKP Baru")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                /*
                field(NetYearlyPKPInclTHR; NetYearlyPKPInclTHR)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Net Yearly PKP incl. THR';
                }
                */

                field(PKPCorrect; PKPCorrect)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'PKP';
                }
                /*
                field(NetYearlyPKPInclTHRRoundedDown; NetYearlyPKPInclTHRRoundedDown)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Net Yearly PKP incl. THR (Rounded Down)';
                }
                field(NetYearlyPKPRoundedDown; NetYearlyPKPRoundedDown)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Net Yearly PKP (Rounded Down)';
                }
                field(TaxPerYearInclTHR; TaxPerYearInclTHR)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Tax Per Year incl. THR';
                }
                field(THRTax; THRTax)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'THR Tax';
                }
                field(UangPisahTax; UangPisahTax)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Uang Pisah Tax';
                    Visible = false;
                }
                */
                field("MSI_HRIS Tax Per Year"; Rec."MSI_HRIS Tax Per Year")
                {
                    ApplicationArea = all;
                    Editable = false;
                }

                field(TaxPerMonth; TaxPerMonth)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Tax Per Month';
                }
                field("MSI_HRIS BPJS Kesehatan Staff"; Rec."MSI_HRIS BPJS Kesehatan Staff")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("MSI_HRIS Last Payroll"; Rec."MSI_HRIS Last Payroll")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(NetSalary; NetSalary)
                {
                    Caption = 'Nett Salary';
                    ApplicationArea = all;
                    Editable = false;
                    DecimalPlaces = 0 : 0;
                }
                /*
                field(SalaryAfterTax; SalaryAfterTax)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Salary After Tax';
                }
                */
                /*
                field(UangPisahShouldBePaid; UangPisahShouldBePaid)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Uang Pisah/Pesangon Should Be Paid';
                    Visible = false;
                }
                */
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Process Payroll")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = CalculateCost;
                ApplicationArea = all;

                trigger OnAction();
                var
                    EmployeeActive: Record Employee;
                    ProcessPayrollCutiDibayar: Record "Process Payroll Cuti Dibayar";
                    Windows: Dialog;
                    LineNo: Integer;
                begin
                    //CurrPage.SetSelectionFilter(EmployeeSelected);
                    /*
                    EmployeeActive.Reset();
                    EmployeeActive.SetRange(Status, EmployeeActive.Status::Active);
                    EmployeeActive.FindSet();

                    PostingPayrollPage.GetSelectedEmployee(EmployeeActive, false);
                    PostingPayrollPage.LookupMode(true);*/
                    Windows.Open('Preparing...');
                    ProcessPayrollCutiDibayar.DeleteAll();

                    EmployeeActive.Reset();
                    EmployeeActive.SetRange("Bayarkan Cuti", true);
                    if EmployeeActive.FindSet() then
                        repeat
                            ProcessPayrollCutiDibayar.Reset();
                            if ProcessPayrollCutiDibayar.FindLast() then
                                LineNo := LineNo + ProcessPayrollCutiDibayar."Line No."
                            else
                                LineNo := 1;

                            ProcessPayrollCutiDibayar.Init();
                            ProcessPayrollCutiDibayar."Secondary Key" := '';
                            ProcessPayrollCutiDibayar."Line No." := LineNo;
                            ProcessPayrollCutiDibayar."Employee No." := EmployeeActive."No.";
                            EmployeeActive.CalcFields("MSI_HRIS Leave Balance");
                            ProcessPayrollCutiDibayar."Leave Balance" := EmployeeActive."MSI_HRIS Leave Balance";
                            ProcessPayrollCutiDibayar."Leave Balance (Value)" := EmployeeActive.LeaveValue();
                            ProcessPayrollCutiDibayar.Insert();
                        until EmployeeActive.Next() = 0;

                    Windows.Close();
                    PostingPayrollPage.Run();
                    //CurrPage.Update();
                end;
            }
            action("Set Pay Leave for All Eligible")
            {
                Image = PaymentDays;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = all;
                Visible = false;

                trigger
                OnAction()
                var
                    EmployeeCekCuti: Record Employee;
                begin
                    EmployeeCekCuti.Reset();
                    EmployeeCekCuti.SetFilter("MSI_HRIS Leave Balance", '>0');
                    EmployeeCekCuti.SetRange(Status, EmployeeCekCuti.Status::Active);
                    if EmployeeCekCuti.FindSet() then
                        EmployeeCekCuti.ModifyAll("Bayarkan Cuti", true);
                    CurrPage.Update();
                end;
            }
            // fadhil
            action("Salary Report")
            {
                Visible = false;
                Image = Print;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ApplicationArea = all;
                trigger OnAction()
                begin
                    Report.run(Report::"Payroll Slip Big", true, false);
                end;
            }
            // fadhil
            action("Undo Set Pay Leave")
            {
                Image = Undo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = all;
                Visible = false;

                trigger
                OnAction()
                var
                    EmployeeCekCuti: Record Employee;
                begin
                    EmployeeCekCuti.Reset();
                    EmployeeCekCuti.SetFilter("MSI_HRIS Leave Balance", '>0');
                    EmployeeCekCuti.SetRange(Status, EmployeeCekCuti.Status::Active);
                    EmployeeCekCuti.SetRange("Inactive Status", EmployeeCekCuti."Inactive Status"::"--");
                    if EmployeeCekCuti.FindSet() then
                        EmployeeCekCuti.ModifyAll("Bayarkan Cuti", false);
                    CurrPage.Update();
                end;
            }
            action("Clear Transaction")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Delete;
                ApplicationArea = all;
                //Visible = false;

                trigger
                OnAction()
                var
                    PayrollLedgerEntry: Record "Payroll Ledger Entry";
                    Detailed: Record "Detailed Payroll Ledger Entry";
                    TarifPPh21Entry: Record "Tarif PPh21 Entry";
                    overtime: Record "Overtime Ledger Entry";
                    tarif: Record "Tarif PKP Ledger Entry";
                    GenPayment: Record "Advance Header";
                    PayrollProcessedEntry: Record "Payroll Processed Entry";

                    OvertimeHeader: Record "Overtime Header";
                    OvertimeLine: Record "Overtime Line";

                    PostedOvertimeHeader: Record "Posted Overtime Header";
                    PostedOvertimeLine: Record "Posted Overtime Line";

                    THRAccrualLedger: Record "THR Accrual Ledger Entry";
                    SeveranceAccrualLedger: Record "Severance Accrual Ledger Entry";
                    SisaCutiDibayarAccrualLedger: Record "Sisa Cuti Accrual Ledger Entry";

                    EmployeeLast: Record Employee;
                begin
                    if not confirm('Continue to clear payrol transaction for date ' +
                        format(TanggalFilter, 0, '<Day> <Month Text> <Year4>') + '?') then
                        exit;

                    EmployeeLast.Reset();
                    EmployeeLast.SetRange("MSI_HRIS Last Payroll", true);
                    if EmployeeLast.FindFirst() then
                        repeat
                            EmployeeLast."MSI_HRIS Last Payroll" := false;
                            EmployeeLast."MSI_HRIS Less/Over Deduct Tax" := 0;
                            EmployeeLast."MSI_HRIS Last Payroll Date" := 0D;
                            EmployeeLast.Modify(true);
                        until EmployeeLast.Next() = 0;

                    EmployeeLast.Reset();
                    EmployeeLast.setfilter("MSI_HRIS Less/Over Deduct Tax", '<>0');
                    if EmployeeLast.FindFirst() then
                        repeat
                            EmployeeLast."MSI_HRIS Last Payroll" := false;
                            EmployeeLast."MSI_HRIS Less/Over Deduct Tax" := 0;
                            EmployeeLast."MSI_HRIS Last Payroll Date" := 0D;
                            EmployeeLast.Modify(true);
                        until EmployeeLast.Next() = 0;


                    PayrollLedgerEntry.Reset();
                    PayrollLedgerEntry.SetRange("Posting Date", TanggalFilter);
                    if PayrollLedgerEntry.FindSet() then
                        PayrollLedgerEntry.DeleteAll();

                    TarifPPh21Entry.Reset();
                    TarifPPh21Entry.SetRange("Posting Date Payroll", TanggalFilter);
                    if TarifPPh21Entry.FindSet() then
                        TarifPPh21Entry.DeleteAll();

                    Detailed.Reset();
                    Detailed.SetRange("Posting Date", TanggalFilter);
                    if Detailed.FindSet() then
                        Detailed.DeleteAll();

                    overtime.Reset();
                    overtime.SetRange("Payroll Posting Date", TanggalFilter);
                    if overtime.FindSet() then
                        overtime.DeleteAll();

                    tarif.Reset();
                    tarif.SetRange("Posting Date", TanggalFilter);
                    if tarif.FindSet() then
                        tarif.DeleteAll();

                    GenPayment.Reset();
                    GenPayment.SetRange("Document Type", GenPayment."Document Type"::"General Payment");
                    GenPayment.SetRange("Posting Date", TanggalFilter);
                    GenPayment.SetRange(Status, GenPayment.Status::Open);
                    if GenPayment.FindFirst() then
                        repeat
                            GenPayment.Delete(true);
                        until GenPayment.Next() = 0;

                    PayrollProcessedEntry.Reset();
                    PayrollProcessedEntry.SetRange("Posting Date Salary", TanggalFilter);
                    if PayrollProcessedEntry.FindSet() then
                        PayrollProcessedEntry.DeleteAll();


                    //pindahin isi posted overtime ke dokumen overtime biasa.
                    PostedOvertimeHeader.Reset();
                    PostedOvertimeHeader.SetRange("Payroll Date", TanggalFilter);
                    if PostedOvertimeHeader.FindFirst() then
                        repeat
                            OvertimeHeader.Init();
                            OvertimeHeader.TransferFields(PostedOvertimeHeader);
                            OvertimeHeader.Status := OvertimeHeader.Status::Released;
                            OvertimeHeader.Insert();

                            PostedOvertimeLine.Reset();
                            PostedOvertimeLine.SetRange("Document No.", PostedOvertimeHeader."No.");
                            if PostedOvertimeLine.FindFirst() then
                                repeat
                                    OvertimeLine.Init();
                                    OvertimeLine.TransferFields(PostedOvertimeLine);
                                    OvertimeLine.Insert();
                                until PostedOvertimeLine.Next() = 0;
                        until PostedOvertimeHeader.Next() = 0;


                    //hapusin postednya
                    PostedOvertimeHeader.Reset();
                    PostedOvertimeHeader.SetRange("Payroll Date", TanggalFilter);
                    if PostedOvertimeHeader.FindFirst() then
                        repeat
                            PostedOvertimeHeader.Delete(true);
                        until PostedOvertimeHeader.Next() = 0;


                    THRAccrualLedger.Reset();
                    THRAccrualLedger.SetRange("Payroll Date", TanggalFilter);
                    if THRAccrualLedger.FindSet() then
                        THRAccrualLedger.DeleteAll();

                    SeveranceAccrualLedger.Reset();
                    SeveranceAccrualLedger.SetRange("Payroll Date", TanggalFilter);
                    if SeveranceAccrualLedger.FindSet() then
                        SeveranceAccrualLedger.DeleteAll();

                    SisaCutiDibayarAccrualLedger.Reset();
                    SisaCutiDibayarAccrualLedger.SetRange("Payroll Date", TanggalFilter);
                    if SisaCutiDibayarAccrualLedger.FindSet() then
                        SisaCutiDibayarAccrualLedger.DeleteAll();

                    Message('Done.');
                end;
            }
            action("Calculate Income Tax")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = TaxPayment;
                ApplicationArea = all;
                Visible = false;

                trigger
                OnAction()
                begin
                    HitungTaxLagi(Rec."No.", PKPCorrect, TanggalFilter);
                    Message('Done.');
                end;
            }

        }
    }

    var
        CutiBolos: Decimal;
        Kehadiran: Integer;
        KehadiranSekarang: Integer;
        DuitPotonganBolos: Decimal;
        ShowWithInactive: Boolean;
        BayarkanCuti: Boolean;
        //Gaji: Decimal;
        StrTanggalFilter: Text[30];
        TanggalFilter: date;
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
        Misc: Codeunit Miscellaneous;
        StartingLalu: Date;
        AwalBulanLalu: Date;
        AkhirBulanLalu: Date;
        AwalBulanSekarang: Date;
        AkhirBulanSekarang: Date;
        Displaying: Text[100];
        HariBulanLalu: Text[100];
        HariKerjaBulanLalu: Text[100];
        HariLiburBulanLalu: Text[100];
        JumlahHari: Integer;
        JumlahHariKerja: Integer;
        JumlahHariLibur: Integer;
        AdjustmentProRateDRE: Decimal;
        EmployeeKurangKehadiran: Integer;
        GrossIncomeForTax: Decimal;
        YearlyIncomeCorrect: Decimal;
        Pengurang: Decimal;
        PositionLedgerEntry: Record "Position Ledger Entry";
        PeriodePenghasilan: Integer;
        RegulerSetahun: Decimal;
        BijabReguler: Decimal;
        PensiunJHTTHTSetahun: Decimal;
        IuranPensiunTHTJHT: Decimal;
        JumlahPengurangan: Decimal;
        PenghasilanNettoSetahun: Decimal;
        PKPCorrect: Decimal;
        TarifPPh21Entry: Record "Tarif PPh21 Entry";
        LessOverDeductTax: Decimal;
        TotalPremiumTaxed: Decimal;
        NetSalary: Decimal;

    trigger
    OnAfterGetRecord()
    var
        EmployeeAttendance: Record Employee;
        EmployeeAttendanceSekarang: Record Employee;
    begin
        clear(SalaryBeforeTax);
        Clear(TaxPerMonth);
        //Clear(Gaji);
        Clear(BiayaJabatan);
        Clear(TotalIncome);
        Clear(GrossIncIncludingTHR);
        clear(GrossIncome);
        Clear(SalaryBeforeTax);
        Clear(SalaryBeforeTaxInclTHR);
        Clear(YearlyIncome);
        Clear(YearlyIncomeInclTHR);
        Clear(NetYearlyPKP);
        Clear(NetYearlyPKPInclTHR);
        Clear(NetYearlyPKPInclTHRRoundedDown);
        clear(NetYearlyPKPRoundedDown);
        Clear(TaxPerYearInclTHR);
        clear(TaxPerYear);
        Clear(THRTax);
        clear(SalaryAfterTax);
        Clear(UangPisahShouldBePaid);
        Clear(CutiBolos);
        Clear(Kehadiran);
        clear(KehadiranSekarang);
        clear(DuitPotonganBolos);
        Clear(AdjustmentProRateDRE);
        Clear(EmployeeKurangKehadiran);
        Clear(GrossIncomeForTax);
        Clear(YearlyIncomeCorrect);
        Clear(Pengurang);
        Clear(PeriodePenghasilan);
        Clear(RegulerSetahun);
        Clear(BijabReguler);
        Clear(PensiunJHTTHTSetahun);
        Clear(JumlahPengurangan);
        Clear(PenghasilanNettoSetahun);
        Clear(PKPCorrect);
        Clear(LessOverDeductTax);
        Clear(TotalPremiumTaxed);
        Clear(NetSalary);

        if Rec."Bayarkan Cuti" then
            BayarkanCuti := true
        else
            BayarkanCuti := false;

        StrTanggalFilter := Rec.GetFilter("Date Filter");
        Evaluate(TanggalFilter, StrTanggalFilter);

        Displaying := 'Displaying data for payroll date = ' +
        FORMAT(TanggalFilter, 0, '<Day> <Month Text> <Year4>');

        if TanggalFilter <> 0D then begin
            StartingLalu := CalcDate('<-1M>', TanggalFilter);
            //nyari data bolos
            Rec.UnpaidLeave(StartingLalu, CutiBolos, DuitPotonganBolos);

            //nyari kehadiran employee
            EmployeeAttendance.Get(Rec."No.");
            AwalBulanLalu := CalcDate('-CM', StartingLalu);
            AkhirBulanLalu := CalcDate('CM', StartingLalu);

            Misc.CheckCalendar(AwalBulanLalu, JumlahHari, JumlahHariLibur);

            HariBulanLalu := 'Total days from ' + FORMAT(AwalBulanLalu, 0, '<Day> <Month Text> <Year4>')
            + ' to ' + FORMAT(AkhirBulanLalu, 0, '<Day> <Month Text> <Year4>') + ' = ' +
            format(JumlahHari);

            HariKerjaBulanLalu := 'Total working days from ' + FORMAT(AwalBulanLalu, 0, '<Day> <Month Text> <Year4>')
            + ' to ' + FORMAT(AkhirBulanLalu, 0, '<Day> <Month Text> <Year4>') + ' = ' +
            format(JumlahHari - JumlahHariLibur);

            HariLiburBulanLalu := 'Total non-working days from ' + FORMAT(AwalBulanLalu, 0, '<Day> <Month Text> <Year4>')
            + ' to ' + FORMAT(AkhirBulanLalu, 0, '<Day> <Month Text> <Year4>') + ' = ' +
            format(JumlahHariLibur);

            EmployeeAttendance.SetRange("Date Filter", AwalBulanLalu, AkhirBulanLalu);
            EmployeeAttendance.CalcFields(Attendance);
            Kehadiran := EmployeeAttendance.Attendance;

            AwalBulanSekarang := CalcDate('-CM', Today);
            AkhirBulanSekarang := CalcDate('CM', Today);

            EmployeeAttendanceSekarang.Get(Rec."No.");
            EmployeeAttendanceSekarang.SetRange("Date Filter", AwalBulanSekarang, AkhirBulanSekarang);
            EmployeeAttendanceSekarang.CalcFields(Attendance);
            KehadiranSekarang := EmployeeAttendanceSekarang.Attendance;

            PostPayroll.HitungBulanKerja(EmployeeAttendanceSekarang, PeriodePenghasilan, TanggalFilter);

            if Rec.Status = Rec.Status::Active then
                if DuitPotonganBolos <> 0 then
                    AdjustmentProRateDRE := Rec."MSI_HRIS Basic Salary" - DuitPotonganBolos;
        end;


        PayrollLedgerEntry.Reset();
        PayrollLedgerEntry.SetRange("Employee No.", Rec."No.");
        PayrollLedgerEntry.SetRange("Posting Date", TanggalFilter);
        if PayrollLedgerEntry.FindSet() then begin
            Rec.CalcFields("MSI_HRIS Total Allowance");
            Rec.CalcFields("MSI_HRIS Total Deduction");
            Rec.CalcFields("MSI_HRIS Total Allowance Taxed");
            Rec.CalcFields("MSI_HRIS Total Deduction Taxed");
            Rec.CalcFields("MSI_HRIS PPh 21");
            Rec.CalcFields("MSI_HRIS Overtime Processed");
            Rec.CalcFields("MSI_HRIS Bijab Reguler");
            //Rec.CalcFields("MSI_HRIS PTKP");
            Rec.CalcFields("MSI_HRIS PTKP Baru");
            Rec.CalcFields("MSI_HRIS Overtime");
            Rec.CalcFields("MSI_HRIS THR Ledger");


            Rec.CalcFields("MSI_HRIS Total Allowance Fix");
            Rec.CalcFields("MSI_HRIS Total Allownc. NonFix");
            Rec.CalcFields("MSI_HRIS BPJS Kesehatan Staff");

            TotalPremiumTaxed := round(Rec."MSI_HRIS Total Allowance Taxed", 1, '=');
            IuranPensiunTHTJHT := round(rec."MSI_HRIS Total Deduction Taxed");

            /*
            TotalIncome := Rec."MSI_HRIS Basic Salary" + Rec."MSI_HRIS Total Allowance Fix" +
                            Rec."MSI_HRIS Total Allownc. NonFix" + Rec."Adjustment Prorate" +
                            Rec."MSI_HRIS Overtime";

            GrossIncome := TotalIncome + Rec."MSI_HRIS Total Allowance Taxed";

            RegulerSetahun := GrossIncome * PeriodePenghasilan;

            PostPayroll.GetBiayaJabatan(BiayaJabatan, GrossIncome, true);

            BijabReguler := BiayaJabatan * PeriodePenghasilan;
            PensiunJHTTHTSetahun := (Rec."MSI_HRIS Total Deduction Taxed" * PeriodePenghasilan) * -1;

            JumlahPengurangan := BijabReguler + PensiunJHTTHTSetahun;
            PenghasilanNettoSetahun := RegulerSetahun - JumlahPengurangan;

            if (PenghasilanNettoSetahun - Rec."MSI_HRIS PTKP Baru" > 0) then
                PKPCorrect := round(PenghasilanNettoSetahun - Rec."MSI_HRIS PTKP Baru", 1000, '<')
            else
                PKPCorrect := 0;
            */
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

            Rec.CalcFields("MSI_HRIS Tax Per Year");

            if not Rec."MSI_HRIS Last Payroll" then
                TaxPerMonth := Round(Rec."MSI_HRIS Tax Per Year" /
                                        PayrollLedgerEntry."Periode Penghasilan", 1)
            else
                TaxPerMonth := LessOverDeductTax;

            NetSalary := round(TotalIncome + Rec."MSI_HRIS BPJS Kesehatan Staff" +
            IuranPensiunTHTJHT - TaxPerMonth, 1, '=');

            //tadinya Total Deduction Biasa. Diganti jadi Total Deduction Taxed
            //SalaryBeforeTaxInclTHR := GrossIncIncludingTHR + Rec."MSI_HRIS Total Deduction";
            //SalaryBeforeTax := SalaryBeforeTaxInclTHR - Rec."THR Amount";

            //field baru, karena yearly income ngaco
            //GrossIncomeForTax := GrossIncome + Rec."MSI_HRIS Total Deduction Taxed" - BiayaJabatan;

            //ini katanya ngaco
            //YearlyIncome := YearlyIncomeInclTHR - Rec."THR Amount";

            //diganti yearlyincomecorrect
            //YearlyIncomeCorrect := GrossIncomeForTax * 12;

            //tadinya ini
            //YearlyIncomeInclTHR := ((GrossIncIncludingTHR - Rec."THR Amount" - BiayaJabatan) * 12) + Rec."THR Amount";
            //diganti yg ini
            //YearlyIncomeInclTHR := YearlyIncomeCorrect + Rec."THR Amount";

            //HitungTax(Rec, Rec."Uang Pisah", UangPisahTax);

            //new condition. If PKP is smaller than PTKP, then tax should be zero

            //THRTax := TaxPerYearInclTHR - TaxPerYear;

            //SalaryAfterTax := SalaryBeforeTax - TaxPerMonth - THRTax + Rec."THR Amount" +
            //(Rec."MSI_HRIS Total Allowance" - Rec."MSI_HRIS Total Allowance Taxed") - Rec."MSI_HRIS Less/Over Deduct Tax2";

            //SalaryAfterTax := Round(SalaryAfterTax, 1);

            //Pengurang := ((Rec."MSI_HRIS Total Deduction" + Rec."MSI_HRIS Total Deduction Taxed") * -1) +
            //TaxPerMonth;

            //SalaryAfterTax := (BasicSalaryDRE + (Rec."MSI_HRIS Total Allowance" - Rec."MSI_HRIS Total Allowance Taxed") +
            //Rec."MSI_HRIS Overtime" + Rec."MSI_HRIS THR Ledger") - Pengurang;

            UangPisahShouldBePaid := Rec."Uang Pisah" - UangPisahTax;

        end else begin
            //Gaji := 0;
            //NetPTKP := 0;
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


        if Rec.Status <> Rec.Status::Active then
            NggaAktif := true
        else
            NggaAktif := false;

        if (Rec."Inactive Status" = Rec."Inactive Status"::"Contract Terminated") or
            (Rec."Inactive Status" = Rec."Inactive Status"::Resigned) then
            InactiveStatus := true
        else
            InactiveStatus := false;
    end;

    trigger
    OnOpenPage()
    var
        PayrollLedgerEntry: Record "Payroll Ledger Entry";
    begin
        /*
        if not ShowWithInactive then
            Rec.SetRange(status, Rec.Status::Active)
        else
            Rec.SetFilter(Status, '0|1');
        */

        PayrollLedgerEntry.Reset();
        PayrollLedgerEntry.SetCurrentKey("Posting Date");
        if PayrollLedgerEntry.FindLast() then begin
            Rec.SetFilter("Date Filter", format(PayrollLedgerEntry."Posting Date"));
        end;

        StrTanggalFilter := Rec.GetFilter("Date Filter");
        Evaluate(TanggalFilter, StrTanggalFilter);

        Displaying := 'Displaying data for payroll date: ' +
        FORMAT(TanggalFilter, 0, '<Day> <Month Text> <Year>');
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

            //InsertTarifPPh21Entry(EmpGitu, TempTax);

            _DuitPPh21 := _DuitPPh21 + TempTax;
        until (Selesai) or (TarifPPh21Setup.Next() = 0);
    end;


    procedure HitungTaxLagi(KodeEmp: Code[20]; NetPKP: Decimal; PostingDateGajian: Date);
    var
        TarifPPh21Setup: Record "Tariff PPh 21 Setup";
        Selesai: Boolean;
        PayrollPost: Codeunit "Payroll Post";
        _TarifYangDipake: Decimal;
        TempTax: Decimal;
        Monyet: Record Employee;
        TarifPPh21Entry: Record "Tarif PPh21 Entry";
    begin
        Monyet.Get(KodeEmp);

        TarifPPh21Setup.Reset();
        TarifPPh21Setup.FindFirst();
        repeat
            _TarifYangDipake := PayrollPost.GetTarifNPWP(Monyet, TarifPPh21Setup);

            if (TarifPPh21Setup."Upper Limit" <> 0) and
                (TarifPPh21Setup."Nilai Pengali Tarif" < NetPKP) then begin
                TarifPPh21Entry.InsertTarifPPh21Entry(Monyet, TarifPPh21Setup."Nilai Pengali Tarif",
                _TarifYangDipake, PostingDateGajian);
                NetPKP := NetPKP - TarifPPh21Setup."Nilai Pengali Tarif";
            end else begin
                TarifPPh21Entry.InsertTarifPPh21Entry(Monyet, NetPKP, _TarifYangDipake,
                PostingDateGajian);
                Selesai := true;
            end;

        until (Selesai) or (TarifPPh21Setup.Next() = 0);
    end;
}