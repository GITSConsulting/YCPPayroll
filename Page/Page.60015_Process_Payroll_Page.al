page 60015 "Process Payroll Page"
{
    Caption = 'Process Payroll';
    PageType = Card;
    UsageCategory = Administration;
    //ApplicationArea = all;
    SourceTable = "Process Payroll Setup Table";
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(GENERAL)
            {
                /*
                group("OVERTIME TO BE PROCESSED")
                {
                    field(DocumentNoOvertime; Rec.DocumentNoOvertime)
                    {
                        Caption = 'Document No.';
                        ApplicationArea = all;
                        Editable = false;
                        trigger
                        OnAssistEdit()
                        var
                            GetOvertime: Page "Get Overtime";
                        begin
                            if Rec.PostingDate = 0D then
                                Error('Please pick the posting date first.');

                            PostingStart := CalcDate('<-CM>', Rec.PostingDate);
                            PostingEnd := CalcDate('<CM>', Rec.PostingDate);

                            OvertimeHeader.Reset();
                            OvertimeHeader.SetRange("Reference Date", PostingStart, PostingEnd);
                            OvertimeHeader.SetRange(Status, OvertimeHeader.Status::Released);
                            OvertimeHeader.FindSet();

                            Clear(GetOvertime);
                            Clear(ReferenceDateOvertime);
                            Clear(OvertimeStart);
                            Clear(OvertimeEnd);

                            GetOvertime.SetTableView(OvertimeHeader);
                            GetOvertime.LookupMode(true);

                            if GetOvertime.RunModal() = Action::LookupOK then begin
                                GetOvertime.GetRecord(OvertimeHeader);

                                //validasi kalo yg di-get bukan yg di periode pencairan gaji

                                Rec.DocumentNoOvertime := OvertimeHeader."No.";
                                ReferenceDateOvertime := OvertimeHeader."Reference Date";
                                OvertimeStart := OvertimeHeader."Overtime Start Date";
                                OvertimeEnd := OvertimeHeader."Overtime End Date";
                                OvertimeHeader.Status := OvertimeHeader.Status::"Payroll Process";
                                OvertimeHeader.Modify();
                            end;
                        end;

                        trigger
                        OnDrillDown()
                        begin
                            //
                        end;
                    }
                    field(ReferenceDateOvertime; ReferenceDateOvertime)
                    {
                        Caption = 'Reference Date';
                        ApplicationArea = all;
                        Editable = false;
                    }
                    field(OvertimeStart; OvertimeStart)
                    {
                        ApplicationArea = all;
                        Caption = 'Overtime Start Date';
                        Editable = false;
                    }
                    field(OvertimeEnd; OvertimeEnd)
                    {
                        ApplicationArea = all;
                        Caption = 'Overtime End Date';
                        Editable = false;
                    }
                }
                */
                group("POSTING DATE")
                {
                    group(satu)
                    {
                        ShowCaption = false;
                        field(PostingDate; Rec.PostingDate)
                        {
                            ShowCaption = false;
                            ApplicationArea = all;
                            trigger
                            OnValidate()
                            var
                                BaseCalendarChange: Record "Base Calendar Change";
                            begin
                                BaseCalendarChange.Reset();
                                BaseCalendarChange.SetRange(Date, Rec.PostingDate);
                                if BaseCalendarChange.FindFirst() then
                                    Error('%1 is set as non working date.', Rec.PostingDate);

                                ProsesDate();
                                DateControllerOvertime();

                                if BulanDesember = 12 then
                                    Message('It is December payroll.\' + YearEndStr);
                            end;
                        }
                    }

                    group(dua)
                    {
                        ShowCaption = false;
                        field(PostingDateWords; PostingDateWords)
                        {
                            ShowCaption = false;
                            Editable = false;
                            ApplicationArea = all;
                            Style = StrongAccent;
                            StyleExpr = true;
                        }
                    }
                }
                group("EMPLOYEES RECAP")
                {
                    group(dewa)
                    {
                        ShowCaption = false;
                        field(JumlahInactive; JumlahInactive)
                        {
                            ApplicationArea = all;
                            Editable = false;
                            Caption = 'Inactive Employees';
                        }
                    }
                    group(tolu)
                    {
                        ShowCaption = false;
                        field(NoOfRecords; NoOfRecords)
                        {
                            Caption = 'Employees to be processed for payroll';
                            ApplicationArea = all;
                            Editable = false;
                            Style = StrongAccent;
                            StyleExpr = true;
                        }
                    }
                    group(tobatu)
                    {
                        ShowCaption = false;
                        field(JumlahAll; JumlahAll)
                        {
                            ApplicationArea = all;
                            Editable = false;
                            Caption = 'Total Employees';
                        }
                    }
                }
                group("DATE CONTROLLER")
                {
                    field(DateRange; DateRange)
                    {
                        ShowCaption = false;
                        Editable = false;
                        ApplicationArea = all;
                        MultiLine = true;
                        Style = Unfavorable;
                        StyleExpr = true;
                    }
                    field(YearEndStr; YearEndStr)
                    {
                        ShowCaption = false;
                        Editable = false;
                        ApplicationArea = all;
                        Style = StrongAccent;
                        StyleExpr = true;
                    }
                    field(OvertimeRangeWords; OvertimeRangeWords)
                    {
                        ShowCaption = false;
                        Editable = false;
                        ApplicationArea = all;
                        MultiLine = true;
                        Style = Favorable;
                        StyleExpr = true;
                    }
                }
            }
            part(subform; "Process Payroll Page Subform")
            {
                SubPageLink = "Secondary Key" = field("Primary Key");
                Caption = 'OVERTIME TO BE PROCESSED';
                ApplicationArea = all;
            }
            /*
            part(subform2; "Process Payroll Leave Subform")
            {
                SubPageLink = "Secondary Key" = field("Primary Key");
                Caption = 'CUTI DIBAYARKAN';
                ApplicationArea = all;
            }*/
            part(subform3; "Proc. Pay. Unpaid Leave Subfr.")
            {
                Caption = 'UNPAID LEAVE';
                ApplicationArea = all;
                //SubPageLink = "Secondary Key" = field("Primary Key");
            }
        }
    }



    actions
    {
        area(Processing)
        {
            action(Post)
            {
                ApplicationArea = all;
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    PayrollSetup: Record "Payroll General Setup";
                    StrConfirm: Text[35];
                    EmployeeLocal: Record Employee;
                    EmployeeUser: Record Employee;
                    OvertimeJnlLine: Record "Overtime Journal Line";
                    DimValEmployee: Record "Dimension Value Employee" temporary;
                    PayrollLedgerEntry: Record "Payroll Ledger Entry";


                    AdvanceHeader: Record "Advance Header";
                    AdvanceHeader2: Record "Advance Header";

                    GenJnlLine: Record "Gen. Journal Line";
                    EmployeeGw: Record Employee temporary;
                    EmployeeLebihKurangBayar: Record Employee;
                    EmpContractTerminated: Record Employee;
                    TabelUser: Record User;
                    EmployeeDREE: Record Employee;
                    OvertimeHeader: Record "Overtime Header";
                    OvertimeLine: Record "Overtime Line";
                    PostedOvertimeHeader: Record "Posted Overtime Header";
                    PostedOvertimeLine: Record "Posted Overtime Line";
                    ProcessCutiDibayar: Record "Process Payroll Cuti Dibayar";
                    AdvancePostDRE: Codeunit "Advance-Post";
                    Misc: Codeunit Miscellaneous;

                    _GenJnlBatch: Record "Gen. Journal Batch";
                    StrGetFilters: Text[100];
                    GajiGelondongan: Decimal;
                    Gaji: Decimal;
                    LineNo: Integer;
                    CutiBolos: Decimal;
                    DuitPotonganBolos: Decimal;
                    RegulerSetahun: Decimal;
                    PeriodePenghasilan: Integer;
                    BijabReguler: Decimal;
                    PensiunJHTTHTSetahun: Decimal;
                    JumlahPengurangan: Decimal;
                    PenghasilanNettoSetahun: Decimal;
                    PKPCorrect: Decimal;
                    TarifPPh21Entry: Record "Tarif PPh21 Entry";
                    EmployeeListHR: Page "Employee List HR";
                    EmployeeHitung: Record Employee;
                    TotalIncomeForTHR: Decimal;
                    THRAccruaLedgerEntry: Record "THR Accrual Ledger Entry";
                    THRAccrueAmount: Decimal;
                    EntryNoTHRAccrue: Integer;


                    SeveranceAccrueAmount: Decimal;
                    EntryNoSeveranceAccrue: Integer;
                    AccrualMgt: Codeunit "Accrual Management";

                    SisaCutiAccrueAmount: Decimal;
                    SisaCutiAccrualLedgerEntry: Record "Sisa Cuti Accrual Ledger Entry";
                    EntryNoSisaCutiAccrue: Integer;
                    MonthNoKe: Integer;
                    ContractDetail: Record "Contract Detail";
                    KotakProgress1: Dialog;
                    KotakProgress2: Dialog;
                    Contract: Record "Position Ledger Entry";
                    KuliBangunan: Record Employee;
                begin
                    if Rec.PostingDate = 0D then
                        Error('Please fill the posting date.');

                    if not Lanjut then
                        Error('Please adjust the posting date accordingly.');

                    //Cek dulu jika ada entrian overtime. Kalo ada, user harus ambil data dulu
                    if ProcessPayrollSetupLine.IsEmpty then begin
                        OvertimeHeader.Reset();
                        //OvertimeHeader.SetRange("Reference Date", StartingDateLalu, TengahBulanSekarang);
                        OvertimeHeader.SetRange("Reference Date", StartingDateLalu, EndingDateLalu);
                        OvertimeHeader.SetRange(Status, OvertimeHeader.Status::Released);
                        if OvertimeHeader.FindSet() then
                            Error('There are eligible overtime document, \' +
                                  'Click suggest overtime data so it can be included with the process.');
                    end;

                    //Cek dulu jika ada antrian unconditional leave. Kalo ada, user harus ambil data dulu
                    if ProcessUnpaidLeave.IsEmpty then begin
                        UnpaidLeave.Reset();
                        UnpaidLeave.SetRange("Leave Type", UnpaidLeave."Leave Type"::Unpaid);
                        UnpaidLeave.SetRange(Reversed, false);
                        //UnpaidLeave.SetFilter("Starting Date", '>=%1', StartingDateLalu);
                        //UnpaidLeave.SetFilter("Ending Date", '<=%1', EndingDateLalu);
                        //UnpaidLeave.SetRange(Status, UnpaidLeave.Status::Released);
                        UnpaidLeave.SetRange(Processed, false);
                        if UnpaidLeave.FindSet() then
                            Error('There are unpaid leave documents, \' +
                                  'Click suggest unpaid leave data so it can be included with the process.');
                    end;


                    PayrollSetup.Get();

                    StrConfirm := 'Continue to proceed payroll post?';

                    if not Confirm(StrConfirm) then exit;

                    EmployeeGlobal.Reset();
                    EmployeeGlobal.SetRange(Status, EmployeeGlobal.Status::Active);
                    EmployeeGlobal.SetFilter("First Name", '<>MSI');
                    EmployeeGlobal.FindFirst();


                    LineCount := 1;
                    NoOfRecords := EmployeeGlobal.COUNT;

                    KotakProgress1.Open('Processing salary components for employee #1######');

                    Clear(DimValEmployee);
                    Clear(EmployeeGw);

                    REPEAT
                        KotakProgress1.Update(1, EmployeeGlobal."No.");
                        //KotakProgress1.Update(2, EmployeeGlobal."No.");

                        if not isTHR then begin
                            //proses payroll biasa
                            PayrollPost.LoopThroughEmployee(EmployeeGlobal, Post, Rec.PostingDate, false, false);
                            //proses kosongin table overtime journal line, kalo ada isinya
                            //terhadap employee yg sedang looping.
                            OvertimeJnlLine.Reset();
                            OvertimeJnlLine.SetRange("Employee No.", EmployeeGlobal."No.");
                            OvertimeJnlLine.SetRange("Posting Date", Rec.PostingDate);
                            if OvertimeJnlLine.FindSet() then
                                OvertimeJnlLine.DeleteAll();
                        end else begin
                            //proses THR
                            PayrollPost.LoopThroughEmployee(EmployeeGlobal, Post, Rec.PostingDate, true, true);

                            EmployeeLocal.Get(EmployeeGlobal."No.");
                            EmployeeLocal."MSI_HRIS THR Amount Processed" := EmployeeLocal."MSI_HRIS THR Amount";
                            EmployeeLocal."MSI_HRIS THR Amount" := 0;
                            EmployeeLocal.Modify(true);
                        end;

                        EmployeeGw.Init();
                        EmployeeGw.TransferFields(EmployeeGlobal);
                        EmployeeGw.Insert(true);

                        LineCount := LineCount + 1;
                    UNTIL EmployeeGlobal.Next() = 0;

                    KotakProgress1.Close();

                    //Create Payroll Processed Entry
                    Misc.CreatePayrollProcessedEntry(Rec.PostingDate, PayrollProcessedEntryNo,
                    YearEndProcess);

                    //ngitung gaji gelondongan
                    GajiGelondongan := 0;
                    TaxPerMonthGelondongan := 0;
                    GelondonganBPJSTK := 0;


                    KotakProgress2.Open('Processing payroll and tax for employee #1######');
                    LineCount := 1;

                    EmployeeGw.SetRange("Date Filter", Rec.PostingDate);  //<< lupa bagian ini, harus assign date filter
                    EmployeeGw.FindFirst();
                    repeat
                        KotakProgress2.Update(1, EmployeeGw."No.");

                        Clear(TaxPerMonth);
                        Clear(BiayaJabatan);
                        Clear(TotalIncome);
                        clear(GrossIncome);

                        Clear(PeriodePenghasilan);
                        Clear(RegulerSetahun);
                        Clear(BijabReguler);
                        Clear(PensiunJHTTHTSetahun);
                        Clear(JumlahPengurangan);
                        Clear(PenghasilanNettoSetahun);
                        Clear(PKPCorrect);
                        Clear(TotalIncomeForTHR);

                        Clear(THRAccrueAmount);
                        Clear(EntryNoTHRAccrue);

                        Clear(SeveranceAccrueAmount);
                        Clear(EntryNoSeveranceAccrue);

                        clear(SisaCutiAccrueAmount);
                        Clear(EntryNoSisaCutiAccrue);
                        Clear(LessOverDeductTax);
                        Clear(IuranPensiunTHTJHT);
                        Clear(UnpaidLeaveDeduction);
                        Clear(TakeHomePay);
                        Clear(NetSalary);


                        PayrollLedgerEntry.Reset();
                        PayrollLedgerEntry.SetRange("Employee No.", EmployeeGw."No.");
                        PayrollLedgerEntry.SetRange("Posting Date", Rec.PostingDate);
                        if PayrollLedgerEntry.FindFirst() then begin

                            EmployeeGw.CalcFields("MSI_HRIS Total Allowance");
                            EmployeeGw.CalcFields("MSI_HRIS Total Deduction");
                            EmployeeGw.CalcFields("MSI_HRIS PPh 21");
                            EmployeeGw.CalcFields("MSI_HRIS Overtime Processed");
                            EmployeeGw.CalcFields("MSI_HRIS Bijab Reguler");
                            EmployeeGw.CalcFields("MSI_HRIS PTKP Baru");
                            EmployeeGw.CalcFields("MSI_HRIS Overtime");

                            EmployeeGw.CalcFields("MSI_HRIS Total Allowance Fix");
                            EmployeeGw.CalcFields("MSI_HRIS Total Allownc. NonFix");
                            EmployeeGw.CalcFields("MSI_HRIS Total Deduction Taxed");
                            EmployeeGw.CalcFields("MSI_HRIS PTKP Baru");
                            EmployeeGw.CalcFields("MSI_HRIS Total Allowance Taxed");

                            EmployeeGw.CalcFields("MSI_HRIS BPJS Kesehatan Staff");

                            EmployeeGw.CalcFields("MSI_HRIS BPJS TK Paid by YCP");
                            EmployeeGw.CalcFields("MSI_HRIS BPJS TK YCP Staff");

                            GelondonganBPJSTK := GelondonganBPJSTK + (EmployeeGw."MSI_HRIS BPJS TK YCP Staff" * -1);

                            TotalIncome := EmployeeGw."MSI_HRIS Basic Salary" + EmployeeGw."MSI_HRIS Total Allowance Fix" +
                                            EmployeeGw."MSI_HRIS Total Allownc. NonFix" + EmployeeGw."Adjustment Prorate" +
                                            EmployeeGw."MSI_HRIS Overtime";

                            TotalIncomeForTHR := EmployeeGw."MSI_HRIS Basic Salary" + EmployeeGw."MSI_HRIS Total Allowance Fix";

                            //"MSI_HRIS Total Allowance Taxed" adalah TotalPremiumTaxed yang dibulatkan, 
                            //spt di employee list.
                            GrossIncome := TotalIncome + round(EmployeeGw."MSI_HRIS Total Allowance Taxed", 1, '=');

                            //Periode Penghasilan tadinya ini
                            //PostPayroll.HitungBulanKerja(EmployeeGw, PeriodePenghasilan, Rec.PostingDate);
                            ContractDetail.GetPeriodePenghasilan(EmployeeGw, Rec.PostingDate, PeriodePenghasilan);

                            RegulerSetahun := GrossIncome * PeriodePenghasilan;
                            PostPayroll.GetBiayaJabatan(BiayaJabatan, GrossIncome, true);

                            //Bijab reguler dibulatkan
                            BijabReguler := round(BiayaJabatan * PeriodePenghasilan, 1, '=');

                            //"MSI_HRIS Total Deduction Taxed" adalah IuranPensiunTHTJHT yang dibulatkan,
                            //spt di employee list.
                            PensiunJHTTHTSetahun := (round(EmployeeGw."MSI_HRIS Total Deduction Taxed", 1, '=')
                            * PeriodePenghasilan) * -1;

                            JumlahPengurangan := BijabReguler + PensiunJHTTHTSetahun;
                            PenghasilanNettoSetahun := RegulerSetahun - JumlahPengurangan;

                            if (PenghasilanNettoSetahun - EmployeeGw."MSI_HRIS PTKP Baru" > 0) then
                                PKPCorrect := round(PenghasilanNettoSetahun - EmployeeGw."MSI_HRIS PTKP Baru", 1000, '<')
                            else
                                PKPCorrect := 0;

                            PostedUnpaidLeave.Reset();
                            PostedUnpaidLeave.SetRange("Employee No.", EmployeeGw."No.");
                            PostedUnpaidLeave.SetRange("Payroll Ledger Entry No.",
                            PayrollLedgerEntry."Entry No.");
                            if PostedUnpaidLeave.FindFirst() then
                                UnpaidLeaveDeduction := round(PostedUnpaidLeave."Salary Deduction", 1, '=');

                            PayrollLedgerEntry."Total Income" := TotalIncome;
                            PayrollLedgerEntry."Gross Income" := GrossIncome;
                            PayrollLedgerEntry."Periode Penghasilan" := PeriodePenghasilan;
                            PayrollLedgerEntry."Reguler Setahun" := RegulerSetahun;
                            PayrollLedgerEntry."Biaya Jabatan" := BiayaJabatan;
                            PayrollLedgerEntry."Bijab Reguler" := BijabReguler;
                            PayrollLedgerEntry."Pensiun JHT THT Setahun" := PensiunJHTTHTSetahun;
                            PayrollLedgerEntry."Jumlah Pengurangan" := JumlahPengurangan;
                            PayrollLedgerEntry."Penghasilan Netto Setahun" := PenghasilanNettoSetahun;
                            PayrollLedgerEntry."PKP Correct" := PKPCorrect;
                            PayrollLedgerEntry."Basic Salary" := EmployeeGw."MSI_HRIS Basic Salary";
                            PayrollLedgerEntry."Other Deduction" := EmployeeGw."MSI_HRIS Other Deduction";
                            PayrollLedgerEntry."Adjustment Prorate" := EmployeeGw."Adjustment Prorate";

                            PayrollLedgerEntry."Tanggal 20 Processed" := true;
                            PayrollLedgerEntry."Payroll Processed Entry No." := PayrollProcessedEntryNo;

                            if EmployeeGw."MSI_HRIS Last Payroll" then begin
                                PayrollLedgerEntry."Last Payroll" := true;
                                PayrollLedgerEntry."Last Payroll Date" := EmployeeGw."MSI_HRIS Last Payroll Date";
                                PayrollLedgerEntry."Less/Over Deduct Tax" := EmployeeGw."MSI_HRIS Less/Over Deduct Tax";
                            end;

                            PayrollLedgerEntry.Modify();


                            //proses hitung dan insert ke tabel pph
                            TarifPPh21Entry.Reset();
                            TarifPPh21Entry.SetRange("Employee No.", EmployeeGw."No.");
                            TarifPPh21Entry.SetRange("Posting Date Payroll", Rec.PostingDate);
                            if not TarifPPh21Entry.FindFirst() then
                                EmployeeListHR.HitungTaxLagi(EmployeeGw."No.", PayrollLedgerEntry."PKP Correct",
                                Rec.PostingDate);

                            EmployeeGw.CalcFields("MSI_HRIS Tax Per Year");

                            if not EmployeeGw."MSI_HRIS Last Payroll" then
                                if PeriodePenghasilan <> 0 then
                                    TaxPerMonth := Round(EmployeeGw."MSI_HRIS Tax Per Year" / PeriodePenghasilan, 1)
                                else
                                    TaxPerMonth := 0
                            else
                                TaxPerMonth := EmployeeGw."MSI_HRIS Less/Over Deduct Tax";

                            TaxPerMonthGelondongan := TaxPerMonthGelondongan + TaxPerMonth;

                            IuranPensiunTHTJHT := round(EmployeeGw."MSI_HRIS Total Deduction Taxed");

                            NetSalary := round(TotalIncome +
                            EmployeeGw."MSI_HRIS BPJS Kesehatan Staff" + IuranPensiunTHTJHT - TaxPerMonth, 1, '=');

                            //Message('No=%1 TotalIncome=%2 BPJSKesStaff=%3 IuranPensiunJHTTHT=%4 TaxPermonth=%5 taxPerYear=%6',
                            //EmployeeGw."No.", TotalIncome, EmployeeGw."MSI_HRIS BPJS Kesehatan Staff",
                            //IuranPensiunTHTJHT, TaxPerMonth, EmployeeGw."MSI_HRIS Tax Per Year");

                            TakeHomePay := round(NetSalary - UnpaidLeaveDeduction - EmployeeGw."MSI_HRIS Other Deduction", 1, '=');

                            GajiGelondongan := GajiGelondongan + TakeHomePay;


                            //nol-kan adjustment prorate dan other deduction di employee
                            KuliBangunan.Get(EmployeeGw."No.");
                            KuliBangunan."Adjustment Prorate" := 0;
                            KuliBangunan."Adjstmt. Prorate Entered Date" := 0D;
                            //KuliBangunan."MSI_HRIS Other Deduction" := 0;
                            KuliBangunan.Modify();

                            //inactive employee yg contract-nya selesai 
                            if EmployeeGw."Inactive Status" =
                            EmployeeGw."Inactive Status"::"Contract Terminated" then begin
                                EmpContractTerminated.Get(EmployeeGw."No.");
                                EmpContractTerminated.Status := EmpContractTerminated.Status::Inactive;
                                EmpContractTerminated.Modify(true);
                            end;

                            //inactive employee yg resign
                            if EmployeeGw."Inactive Status" =
                            EmployeeGw."Inactive Status"::Resigned then begin
                                EmpContractTerminated.Get(EmployeeGw."No.");
                                EmpContractTerminated.Status := EmpContractTerminated.Status::Inactive;
                                EmpContractTerminated.Modify(true);
                            end;

                            //THRAccrueAmount := 1 / 12 * TotalIncomeForTHR;
                            //SeveranceAccrueAmount := 1 / 12 * TotalIncomeForTHR;
                            //SisaCutiAccrueAmount := (TotalIncomeForTHR / 21) * 1.25;

                            //Accrual for Severance
                            //AccrualMgt.PencandanganSeverance(EmployeeGw, Rec.PostingDate,
                            //SeveranceAccrueAmount, PayrollLedgerEntry."Entry No.");

                        end;


                        LineCount := LineCount + 1;
                    until EmployeeGw.Next() = 0;

                    KotakProgress2.Close();

                    Window.Open('Creating general payment...please wait.');

                    PayrollSetup.TestField("Global Dimension 1 Code");
                    PayrollSetup.TestField("Global Dimension 2 Code");
                    PayrollSetup.TestField("Salary Expense Acc. No.");

                    if not isTHR then begin
                        EmployeeDREE.Reset();

                        EmployeeDREE.SetRange("User ID", UserId);

                        EmployeeDREE.FindFirst();

                        //Create General Payment
                        AdvanceHeader.Init();
                        AdvanceHeader.Validate("Document Type", AdvanceHeader."Document Type"::"General Payment");
                        AdvanceHeader.Validate("No.", '');
                        AdvanceHeader."Employee No." := EmployeeDREE."No.";
                        AdvanceHeader.validate("Shortcut Dimension 1 Code", EmployeeDREE."MSI_HRIS Shortcut Dim Code");
                        AdvanceHeader."Disbursement Type" := AdvanceHeader."Disbursement Type"::Salary;
                        AdvanceHeader.Insert(true);


                        AdvanceHeader2.get(AdvanceHeader2."Document Type"::"General Payment",
                        AdvanceHeader."No.");
                        if not _GenJnlBatch.GET(AdvancePostDRE.GetTemplateInitial,
                            AdvancePostDRE.GetBatchInitial(AdvanceHeader)) THEN BEGIN
                            _GenJnlBatch.INIT;
                            _GenJnlBatch."Journal Template Name" := AdvancePostDRE.GetTemplateInitial;
                            _GenJnlBatch.Name := AdvancePostDRE.GetBatchInitial(AdvanceHeader);
                            _GenJnlBatch.INSERT;
                        end;

                        AdvanceHeader2."Journal Template Name" := AdvancePostDRE.GetTemplateInitial;
                        AdvanceHeader2."Journal Batch Name" := _GenJnlBatch.Name;

                        AdvanceHeader2."Journal Description" := 'Payroll for ' +
                        Format(Rec.PostingDate, 0, '<Day> <Month Text> <Year>');

                        AdvanceHeader2.Validate("Posting Date", Rec.PostingDate);
                        AdvanceHeader2."Disbursement Type" := AdvanceHeader2."Disbursement Type"::Salary;
                        AdvanceHeader2.Modify();


                        GenJnlLine.Init();
                        GenJnlLine.Validate("Journal Template Name", AdvanceHeader2."Journal Template Name");
                        GenJnlLine.validate("Journal Batch Name", AdvanceHeader2."Journal Batch Name");
                        GenJnlLine.Validate("Line No.", 10000);
                        GenJnlLine.Validate("Document No.", AdvanceHeader."No.");
                        GenJnlLine.Validate("Posting Date", Rec.PostingDate);
                        GenJnlLine.Validate(Amount, GajiGelondongan);
                        //GenJnlLine.Validate("Global Dimension 1 Code", PayrollSetup."Global Dimension 1 Code");
                        //GenJnlLine.Validate("Global Dimension 2 Code", PayrollSetup."Global Dimension 2 Code");
                        GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
                        GenJnlLine.Validate("Account No. 2", PayrollSetup."Salary Expense Acc. No.");
                        GenJnlLine.Validate(Description, 'Payroll for ' + Format(Rec.PostingDate));
                        GenJnlLine.Validate("Global Dimension 1 Code", PayrollSetup."Global Dimension 1 Code");
                        GenJnlLine.TipeDuit := GenJnlLine.TipeDuit::Salary;
                        GenJnlLine.Insert(true);



                        //Create General Payment for TAX
                        PayrollSetup.TestField("Tax Account No.");

                        AdvanceHeaderTax.Init();
                        AdvanceHeaderTax.Validate("Document Type", AdvanceHeaderTax."Document Type"::"General Payment");
                        AdvanceHeaderTax.Validate("No.", '');
                        AdvanceHeaderTax."Employee No." := EmployeeDREE."No.";
                        AdvanceHeaderTax.validate("Shortcut Dimension 1 Code", EmployeeDREE."MSI_HRIS Shortcut Dim Code");
                        AdvanceHeaderTax."Disbursement Type" := AdvanceHeaderTax."Disbursement Type"::"Tax Payroll - THR";
                        AdvanceHeaderTax.Insert(true);

                        Clear(_GenJnlBatch);
                        Clear(AdvancePostDRE);

                        AdvanceHeader3.get(AdvanceHeader3."Document Type"::"General Payment",
                        AdvanceHeaderTax."No.");
                        if not _GenJnlBatch.GET(AdvancePostDRE.GetTemplateInitial,
                            AdvancePostDRE.GetBatchInitial(AdvanceHeaderTax)) THEN BEGIN
                            _GenJnlBatch.INIT;
                            _GenJnlBatch."Journal Template Name" := AdvancePostDRE.GetTemplateInitial;
                            _GenJnlBatch.Name := AdvancePostDRE.GetBatchInitial(AdvanceHeaderTax);
                            _GenJnlBatch.INSERT;
                        end;

                        AdvanceHeader3."Journal Template Name" := AdvancePostDRE.GetTemplateInitial;
                        AdvanceHeader3."Journal Batch Name" := _GenJnlBatch.Name;

                        AdvanceHeader3."Journal Description" := 'Taxes Payroll for ' +
                        Format(Rec.PostingDate, 0, '<Day> <Month Text> <Year>');

                        AdvanceHeader3.Validate("Posting Date", Rec.PostingDate);
                        AdvanceHeader3.Modify();


                        GenJnlLineTax.Init();
                        GenJnlLineTax.Validate("Journal Template Name", AdvanceHeader3."Journal Template Name");
                        GenJnlLineTax.validate("Journal Batch Name", AdvanceHeader3."Journal Batch Name");
                        GenJnlLineTax.Validate("Line No.", 10000);
                        GenJnlLineTax.Validate("Document No.", AdvanceHeaderTax."No.");
                        GenJnlLineTax.Validate("Posting Date", Rec.PostingDate);
                        GenJnlLineTax.Validate(Amount, TaxPerMonthGelondongan);
                        GenJnlLineTax.Validate("Account Type", GenJnlLineTax."Account Type"::"G/L Account");
                        GenJnlLineTax.Validate("Account No. 2", PayrollSetup."Tax Account No.");
                        GenJnlLineTax.Validate(Description, 'Tax Payroll for ' + Format(Rec.PostingDate));
                        GenJnlLineTax.Validate("Global Dimension 1 Code", PayrollSetup."Global Dimension 1 Code");
                        GenJnlLineTax.TipeDuit := GenJnlLine.TipeDuit::"Tax Payroll";
                        GenJnlLineTax.Insert(true);



                        //Create General Payment for BPJS TK
                        PayrollSetup.TestField("Charg. BPJS TK Acc. No.");

                        AdvanceHeaderBPJSTK.Init();
                        AdvanceHeaderBPJSTK.Validate("Document Type", AdvanceHeaderBPJSTK."Document Type"::"General Payment");
                        AdvanceHeaderBPJSTK.Validate("No.", '');
                        AdvanceHeaderBPJSTK."Employee No." := EmployeeDREE."No.";
                        AdvanceHeaderBPJSTK.validate("Shortcut Dimension 1 Code", EmployeeDREE."MSI_HRIS Shortcut Dim Code");
                        AdvanceHeaderBPJSTK."Disbursement Type" := AdvanceHeaderBPJSTK."Disbursement Type"::"BPJS TK";
                        AdvanceHeaderBPJSTK.Insert(true);

                        Clear(_GenJnlBatch);
                        Clear(AdvancePostDRE);


                        AdvanceHeader4.get(AdvanceHeader4."Document Type"::"General Payment",
                        AdvanceHeaderBPJSTK."No.");
                        if not _GenJnlBatch.GET(AdvancePostDRE.GetTemplateInitial,
                            AdvancePostDRE.GetBatchInitial(AdvanceHeaderBPJSTK)) THEN BEGIN
                            _GenJnlBatch.INIT;
                            _GenJnlBatch."Journal Template Name" := AdvancePostDRE.GetTemplateInitial;
                            _GenJnlBatch.Name := AdvancePostDRE.GetBatchInitial(AdvanceHeaderBPJSTK);
                            _GenJnlBatch.INSERT;
                        end;

                        AdvanceHeader4."Journal Template Name" := AdvancePostDRE.GetTemplateInitial;
                        AdvanceHeader4."Journal Batch Name" := _GenJnlBatch.Name;

                        AdvanceHeader4."Journal Description" := 'BPJS Ketenagakerjaan Premium for ' +
                        Format(Rec.PostingDate, 0, '<Month Text> <Year4>');

                        AdvanceHeader4.Validate("Posting Date", Rec.PostingDate);
                        AdvanceHeader4.Modify();


                        GenJnlLineBPJSTK.Init();
                        GenJnlLineBPJSTK.Validate("Journal Template Name", AdvanceHeader4."Journal Template Name");
                        GenJnlLineBPJSTK.validate("Journal Batch Name", AdvanceHeader4."Journal Batch Name");
                        GenJnlLineBPJSTK.Validate("Line No.", 10000);
                        GenJnlLineBPJSTK.Validate("Document No.", AdvanceHeaderBPJSTK."No.");
                        GenJnlLineBPJSTK.Validate("Posting Date", Rec.PostingDate);
                        GenJnlLineBPJSTK.Validate(Amount, GelondonganBPJSTK);
                        GenJnlLineBPJSTK.Validate("Account Type", GenJnlLineBPJSTK."Account Type"::"G/L Account");
                        GenJnlLineBPJSTK.Validate("Account No. 2", PayrollSetup."Charg. BPJS TK Acc. No.");
                        GenJnlLineBPJSTK.Validate(Description, 'BPJS Ketenagakerjaan Premium for ' + Format(Rec.PostingDate, 0, '<Month Text> <Year4>'));
                        GenJnlLineBPJSTK.Validate("Global Dimension 1 Code", PayrollSetup."Global Dimension 1 Code");
                        GenJnlLineBPJSTK.TipeDuit := GenJnlLine.TipeDuit::"BPJS TK";
                        GenJnlLineBPJSTK.Insert(true);



                        PayrollProcessEntryDRE.Get(Rec.PostingDate);
                        PayrollProcessEntryDRE."GP Document No." := AdvanceHeader."No.";
                        PayrollProcessEntryDRE."GP For Tax" := AdvanceHeaderTax."No.";
                        PayrollProcessEntryDRE."GP For BPJS TK" := AdvanceHeaderBPJSTK."No.";
                        PayrollProcessEntryDRE.Modify();
                    end;

                    ProcessPayrollSetupLine.Reset();
                    if ProcessPayrollSetupLine.FindSet() then begin
                        repeat
                            OvertimeHeader.Get(ProcessPayrollSetupLine.LineDocNoOvertime);

                            OvertimeHeader.Status := OvertimeHeader.Status::Open;
                            OvertimeHeader.Modify();

                            PostedOvertimeHeader.Init();
                            PostedOvertimeHeader.TransferFields(OvertimeHeader);
                            PostedOvertimeHeader."Payroll Date" := Rec.PostingDate;
                            PostedOvertimeHeader.Insert();

                            OvertimeLine.Reset();
                            OvertimeLine.SetRange("Document No.", OvertimeHeader."No.");
                            OvertimeLine.FindSet();
                            repeat
                                PostedOvertimeLine.Init();
                                PostedOvertimeLine.TransferFields(OvertimeLine);
                                PostedOvertimeLine.Insert();
                            until OvertimeLine.Next() = 0;

                            OvertimeHeader.Delete(true);
                        until ProcessPayrollSetupLine.Next() = 0;
                    end;

                    TanggalJgnLupa := Rec.PostingDate;
                    Rec.PostingDate := 0D;
                    Rec.Modify();


                    ProcessPayrollSetupLine.DeleteAll();

                    //hapus isi tabel subform untuk cuti dibayar
                    ProcessCutiDibayar.DeleteAll();

                    Window.CLOSE;

                    if not isTHR then
                        Message('Payroll process period: %1\With %2 employee is completed.' +
                                '\GP %3 was created for payroll.\GP %4 was created for the tax.' +
                                '\GP %5 was created for BPJS TK.',
                                 FORMAT(TanggalJgnLupa, 0, '<Day> <Month Text> <Year>'), NoOfRecords,
                                 PayrollProcessEntryDRE."GP Document No.",
                                 PayrollProcessEntryDRE."GP For Tax",
                                 PayrollProcessEntryDRE."GP For BPJS TK")
                    else
                        Message('THR process period: %1\With %2 employee is completed.',
                                 FORMAT(TanggalJgnLupa, 0, '<Day> <Month Text> <Year>'), NoOfRecords);

                    CurrPage.Close();

                    EmployeeListHR.Run();
                end;
            }
            action("Suggest Overtime Data")
            {
                Image = CopyToTask;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger
                OnAction()
                var
                    ProcessPayrollSetupLine2: Record "Proc. Payroll Setup Line Table";
                    ProcessLineNo: Integer;
                    YangDiSuggest: Integer;
                begin
                    Rec.TestField(PostingDate);

                    if not Lanjut then
                        Error('Please fix the posting date so it can be eligible for process.');

                    OvertimeHeader.Reset();
                    //OvertimeHeader.SetRange("Reference Date", StartingDateLalu, TengahBulanSekarang);
                    OvertimeHeader.SetRange("Reference Date", StartingDateLalu, EndingDateLalu);
                    OvertimeHeader.SetRange(Status, OvertimeHeader.Status::Released);
                    OvertimeHeader.FindSet();
                    YangDiSuggest := OvertimeHeader.Count;
                    repeat
                        ProcessPayrollSetupLine2.Reset();
                        if ProcessPayrollSetupLine2.FindLast() then
                            ProcessLineNo := ProcessPayrollSetupLine2."Line No." + 1
                        else
                            ProcessLineNo := 1;

                        ProcessPayrollSetupLine.Init();
                        ProcessPayrollSetupLine."Secondary Key" := '';
                        ProcessPayrollSetupLine."Line No." := ProcessLineNo;
                        ProcessPayrollSetupLine.LineDocNoOvertime := OvertimeHeader."No.";
                        ProcessPayrollSetupLine.Insert();
                    until OvertimeHeader.Next() = 0;


                    OvertimeHeader.Reset();
                    //OvertimeHeader.SetRange("Reference Date", StartingDateLalu, TengahBulanSekarang);
                    OvertimeHeader.SetRange("Reference Date", StartingDateLalu, EndingDateLalu);
                    OvertimeHeader.SetRange(Status, OvertimeHeader.Status::Released);
                    OvertimeHeader.FindSet();
                    repeat
                        OvertimeHeader.Status := OvertimeHeader.Status::"Payroll Process";
                        OvertimeHeader.Modify();
                    until OvertimeHeader.Next() = 0;

                    CurrPage.Update();
                    Message('%1 overtime suggested.', YangDiSuggest);
                end;
            }
            action("Suggest Unpaid Leave Data")
            {
                Image = CopyToTask;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger
                OnAction()
                var
                    ProcessUnpaidLeaveLine: Record "Process Payroll Unpaid Leave";
                    ProcessLineNo: Integer;
                    YangDiSuggest: Integer;
                begin
                    Rec.TestField(PostingDate);

                    //Misc.CheckCalendar(StartingDateLalu, ProcessLineNo, YangDiSuggest);

                    if not Lanjut then
                        Error('Please fix the posting date so it can be eligible for process.');


                    UnpaidLeave.Reset();
                    UnpaidLeave.SetRange("Leave Type", UnpaidLeave."Leave Type"::Unpaid);
                    //UnpaidLeave.SetFilter("Starting Date", '>=%1', StartingDateLalu);
                    //UnpaidLeave.SetFilter("Ending Date", '<=%1', EndingDateLalu);
                    //UnpaidLeave.SetRange(Status, UnpaidLeave.Status::Released);
                    UnpaidLeave.SetRange(Processed, false);
                    UnpaidLeave.SetRange(Reversed, false);
                    YangDiSuggest := UnpaidLeave.Count;
                    if UnpaidLeave.FindSet() then
                        repeat
                            ProcessUnpaidLeaveLine.Reset();
                            if ProcessUnpaidLeaveLine.FindLast() then
                                ProcessLineNo := ProcessUnpaidLeaveLine."Line No." + 1
                            else
                                ProcessLineNo := 1;

                            ProcessUnpaidLeaveLine.Init();
                            ProcessUnpaidLeaveLine."Secondary Key" := '';
                            ProcessUnpaidLeaveLine."Line No." := ProcessLineNo;
                            ProcessUnpaidLeaveLine."Employee No." := UnpaidLeave."Employee No.";
                            ProcessUnpaidLeaveLine."Starting Date" := UnpaidLeave."Starting Date";
                            ProcessUnpaidLeaveLine."Ending Date" := UnpaidLeave."Ending Date";
                            ProcessUnpaidLeaveLine."Total Number of Days" := UnpaidLeave."Total Number of Days";
                            ProcessUnpaidLeaveLine."Document No." := UnpaidLeave."No.";
                            ProcessUnpaidLeaveLine."Salary Deduction" := UnpaidLeave."Salary Deduction";
                            ProcessUnpaidLeaveLine.Insert();
                        //ProcessUnpaidLeaveLine.Modify();

                        until UnpaidLeave.Next() = 0;

                    CurrPage.Update();
                    Message('%1 unpaid leave suggested.', YangDiSuggest);
                end;
            }
            action("Clear Overtime Data")
            {
                ApplicationArea = all;
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger
                OnAction()
                begin
                    if not Confirm('Are you sure to clear all overtime data?') then exit;

                    ProcessPayrollSetupLine.FindFirst();
                    repeat
                        OvertimeHeader.Get(ProcessPayrollSetupLine.LineDocNoOvertime);
                        OvertimeHeader.Status := OvertimeHeader.Status::Released;
                        OvertimeHeader.Modify();
                    until ProcessPayrollSetupLine.Next() = 0;

                    ProcessPayrollSetupLine.DeleteAll();
                    CurrPage.Update();
                end;
            }
            action("Clear Unpaid Leave Data")
            {
                ApplicationArea = all;
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger
                OnAction()
                var
                    ProcessPayrollUnpaidLeave: Record "Process Payroll Unpaid Leave";
                begin
                    if not Confirm('Are you sure to clear all unpaid leave data?') then exit;
                    if not ProcessPayrollUnpaidLeave.IsEmpty then
                        ProcessPayrollUnpaidLeave.DeleteAll();
                end;
            }

        }
    }

    trigger
    OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert()
        end;


        DateControllerOvertime();
        ProsesDate();

        if isTHR then
            CurrPage.Caption('THR Process Page')
        else
            CurrPage.Caption('Payroll Process');

        clear(JumlahAll);
        Clear(JumlahInactive);

        EmployeeGlobal.Reset();
        EmployeeGlobal.SetRange(Status, EmployeeGlobal.Status::Active);
        EmployeeGlobal.SetFilter("First Name", '<>MSI');
        EmployeeGlobal.FindFirst();
        NoOfRecords := EmployeeGlobal.Count;

        EmployeeAll.Reset();
        EmployeeAll.FindSet();
        JumlahAll := EmployeeAll.Count;

        EmployeeInactive.Reset();
        EmployeeInactive.SetFilter(Status, '1|2');
        if EmployeeInactive.FindSet() then
            JumlahInactive := EmployeeInactive.Count
        else
            JumlahInactive := 0;
    end;


    trigger
    OnQueryClosePage(CloseAction: Action): Boolean
    var
        EmployeeListHR: page "Employee List HR";
    begin
        if not Post then begin
            if not confirm('Exit without post?') then error('')
        end;

        EmployeeListHR.Run();
    end;


    procedure DateControllerOvertime()
    begin
        if Rec.PostingDate <> 0D then begin
            BulanLalu := CalcDate('<-1M>', Rec.PostingDate);
            BulanLalu := CalcDate('-CM', BulanLalu);

            //StartingDateLalu := BulanLalu + 15;
            StartingDateLalu := CalcDate('-CM', BulanLalu);
            EndingDateLalu := CalcDate('CM', BulanLalu);

            //TengahBulanSekarang := CalcDate('<-CM + 14D>', Rec.PostingDate);

            OvertimeRangeWords := 'Overtime date eligible to be processed for this month is between ' +
                                  Format(StartingDateLalu, 0, '<Day> <Month Text> <Year4>') + ' and ' +
                                  //Format(TengahBulanSekarang, 0, '<Day> <Month Text> <Year4>');
                                  Format(EndingDateLalu, 0, '<Day> <Month Text> <Year4>');
        end;
    end;

    procedure ProsesDate()
    begin
        Misc.CalculateDates(Rec.PostingDate, StartingDate, EndingDate);

        if Rec.PostingDate <> 0D then begin
            /*if (Rec.PostingDate < StartingDate) or (Rec.PostingDate > EndingDate) then begin
                Lanjut := false;
                PostingDateWords := 'You picked ' +
                                    format(Rec.PostingDate, 0, '<Day> <Month Text> <Year4>');

                DateRange := 'Eligible date to process this should be between ' +
                             format(StartingDate, 0, '<Day> <Month Text> <Year4>') + ', until ' +
                             format(EndingDate, 0, '<Day> <Month Text> <Year4>');
            end else begin*/
            Lanjut := true;
            PostingDateWords := 'Posting date is okay';
            DateRange := 'Please proceed...';

            BulanDesember := Date2DMY(Rec.PostingDate, 2);
            if BulanDesember = 12 then begin
                YearEndProcess := true;
                YearEndStr := 'This process will trigger the year end tax calculation.';
            end else begin
                YearEndProcess := false;
                YearEndStr := '';
            end

            //end
        end
        else begin
            Lanjut := false;
            PostingDateWords := 'You have not pick the posting date.';
            DateRange := '';
        end;
    end;

    var
        OtherDeduction: Decimal;
        AdvanceHeaderBPJSTK: Record "Advance Header";
        AdvanceHeader4: Record "Advance Header";
        GenJnlLineBPJSTK: Record "Gen. Journal Line";
        GelondonganBPJSTK: Decimal;


        AdvanceHeaderTax: Record "Advance Header";
        AdvanceHeader3: Record "Advance Header";
        GenJnlLineTax: Record "Gen. Journal Line";
        TaxPerMonthGelondongan: Decimal;
        TanggalJgnLupa: Date;
        PayrollProcessEntryDRE: Record "Payroll Processed Entry";
        YearEndStr: Text;
        BulanDesember: Integer;
        YearEndProcess: Boolean;
        PostedUnpaidLeave: Record "Posted Leave Request";
        UnpaidLeaveDeduction: Decimal;
        IuranPensiunTHTJHT: Decimal;
        TakeHomePay: Decimal;
        NetSalary: Decimal;
        LessOverDeductTax: Decimal;
        ProcessUnpaidLeave: Record "Process Payroll Unpaid Leave";
        UnpaidLeave: Record "Posted Leave Request";

        PostPayroll: Codeunit "Payroll Post";

        TaxPerMonth: Decimal;
        BiayaJabatan: Decimal;
        TotalIncome: Decimal;
        GrossIncome: Decimal;

        ProcessPayrollSetupLine: Record "Proc. Payroll Setup Line Table";
        OvertimeHeader: Record "Overtime Header";
        OvertimeRangeWords: Text;
        StartingDateLalu: Date;
        EndingDateLalu: Date;
        BulanLalu: Date;
        Lanjut: Boolean;
        Misc: Codeunit Miscellaneous;
        PayrollProcessedEntryNo: Integer;
        PostingDateWords: Text;
        DateRange: Text;
        StartingDate: Date;
        EndingDate: Date;
        Post: Boolean;
        EmployeeGlobal: Record Employee;
        EmployeeAll: Record Employee;
        EmployeeInactive: Record Employee;
        JumlahAll: Integer;
        JumlahInactive: Integer;
        PayrollPost: Codeunit "Payroll Post";

        Window: Dialog;
        RefPostingState: Option string,"Preparing employee","Posting payroll";
        LineCount: Integer;
        NoOfRecords: Integer;
        CUProgressBar: Codeunit "Progress Bar";
        Bar: Integer;
        EmployeeNo: array[10000] of code[20];
        i: Integer;
        ProgressBar: Label 'Preparing employee @2@@@@@@@@@@@@@@@@@@';
        ProgressBar2: Label 'Posting payroll #1##############\\#2############################\\@3@@@@@@@@@@@@@@@@@@';
        isTHR: Boolean;

    procedure GetSelectedEmployee(VAR EmployeeLocal: Record Employee; ApakahTHR: Boolean)
    begin
        isTHR := ApakahTHR;

        EmployeeLocal.FINDFIRST;

        Window.OPEN(ProgressBar);

        LineCount := 0;
        NoOfRecords := EmployeeLocal.COUNT;

        REPEAT
            LineCount := LineCount + 1;
            EmployeeNo[LineCount] := EmployeeLocal."No.";
            Bar := ROUND(100 * (100 * (LineCount / NoOfRecords)), 1);
            Window.UPDATE(2, Bar);
            EmployeeGlobal.INIT;
            EmployeeGlobal.TRANSFERFIELDS(EmployeeLocal);
            EmployeeGlobal.INSERT;
        UNTIL EmployeeLocal.NEXT = 0;

        Window.CLOSE;
    end;

    procedure UpdatePostingState(PostingState: Integer; LineNo: Integer)
    begin
        Window.UPDATE(3, STRSUBSTNO('%1 (%2)', GetPostingStateMsg(PostingState), LineNo));
    end;

    procedure UpdateDialog(PostingState: Integer; LineNo: Integer; TotalLinesQty: Integer)
    begin
        UpdatePostingState(PostingState, LineNo);
        Window.UPDATE(2, GetProgressBarValue(PostingState, LineNo, TotalLinesQty));
    end;

    procedure GetPostingStateMsg(PostingState: Integer): Text
    begin
        CASE PostingState OF
            RefPostingState::"Preparing employee":
                EXIT('Preparing employee');
            RefPostingState::"Posting payroll":
                EXIT('Posting payroll');
        END;
    end;

    procedure GetProgressBarValue(PostingState: Integer; LineNo: Integer; TotalLinesQty: Integer): Integer
    begin
        EXIT(ROUND(100 * CalcProgressPercent(PostingState, GetNumberOfPostingStages, LineNo, TotalLinesQty), 1));
    end;

    procedure CalcProgressPercent(PostingState: Integer; NumberOfPostingStates: Integer; LineNo: Integer; TotalLinesQty: Integer): Decimal
    begin
        EXIT(100 / NumberOfPostingStates * (PostingState + LineNo / TotalLinesQty));
    end;

    local procedure GetNumberOfPostingStages(): Integer
    begin
        EXIT(1);
    end;
}