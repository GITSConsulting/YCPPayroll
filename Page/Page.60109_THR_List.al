page 60109 "THR List"
{
    PageType = Worksheet;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Employee;
    CardPageId = "Employee Card HR";
    Caption = '13th Salary (THR)';
    PromotedActionCategories = 'Processing';
    SourceTableView = where("First Name" = filter('<>MSI'));
    InsertAllowed = false;
    DeleteAllowed = false;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            group(atas)
            {
                ShowCaption = false;
                field(FilterList; FilterList)
                {
                    Caption = 'Filter By THR Type';
                    ApplicationArea = all;
                    Style = Strong;
                    StyleExpr = true;

                    trigger
                    OnValidate()
                    var
                        TanggalDre: Date;
                    begin
                        case FilterList of
                            FilterList::All:
                                begin
                                    Rec.Reset();
                                    if not Rec.FindSet() then
                                        Error('There is no data with such filter')
                                    else
                                        Rec.FindSet();

                                    LinkTHRDanPayroll(Rec, FilterList, TanggalDre);
                                    TanggalPayrollTerakhir := TanggalDre;

                                    CurrPage.Update(false);
                                end;
                            FilterList::"All Active":
                                begin
                                    Rec.Reset();
                                    Rec.SetRange(Status, Rec.Status::Active);
                                    Rec.SetFilter("First Name", '<>MSI');
                                    if not Rec.FindSet() then
                                        Error('There is no data with such filter')
                                    else
                                        Rec.FindSet();

                                    LinkTHRDanPayroll(Rec, FilterList, TanggalDre);
                                    TanggalPayrollTerakhir := TanggalDre;

                                    CurrPage.Update(false);
                                end;
                            FilterList::"Muslim THR":
                                begin
                                    Rec.Reset();
                                    Rec.SetRange(Status, Rec.Status::Active);
                                    Rec.SetRange("With Muslim THR Disbursement", true);
                                    Rec.SetFilter("First Name", '<>MSI');
                                    if not Rec.FindSet() then
                                        Error('There is no data with such filter')
                                    else
                                        Rec.FindSet();

                                    LinkTHRDanPayroll(Rec, FilterList, TanggalDre);
                                    TanggalPayrollTerakhir := TanggalDre;

                                    CurrPage.Update(false);
                                end;
                            FilterList::"Non-Muslim THR":
                                begin
                                    Rec.Reset();
                                    Rec.SetRange(Status, Rec.Status::Active);
                                    Rec.SetRange("With Muslim THR Disbursement", false);
                                    Rec.SetFilter("First Name", '<>MSI');
                                    if not Rec.FindSet() then
                                        Error('There is no data with such filter')
                                    else
                                        Rec.FindSet();

                                    LinkTHRDanPayroll(Rec, FilterList, TanggalDre);
                                    TanggalPayrollTerakhir := TanggalDre;

                                    CurrPage.Update(false);
                                end;
                            FilterList::"THR Compensation":
                                begin
                                    Rec.Reset();
                                    Rec.SetRange(Status, Rec.Status::Active);
                                    Rec.SetRange("MSI_HRIS THR Compensation", true);
                                    Rec.SetFilter("First Name", '<>MSI');
                                    if not Rec.FindSet() then
                                        Error('There is no data with such filter')
                                    else
                                        Rec.FindSet();

                                    LinkTHRDanPayroll(Rec, FilterList, TanggalDre);
                                    TanggalPayrollTerakhir := TanggalDre;

                                    CurrPage.Update(false);
                                end;
                        end;


                        if TanggalPayrollTerakhir = 0D then begin
                            PayrollLedgerEntryUmum.Reset();
                            PayrollLedgerEntryUmum.FindLast();
                            TanggalPayrollTerakhir := PayrollLedgerEntryUmum."Posting Date";
                        end;

                        PayrollBaselineDate := 'Monthly payroll date as baseline: ' +
                        Format(TanggalPayrollTerakhir, 0, '<Day> <Month Text> <Year4>');
                        OnOpen := false;
                    end;
                }
                field("Date Filter"; Rec."Date Filter")
                {
                    ApplicationArea = all;
                    Caption = 'Filter THR Date';

                    trigger
                    OnValidate()
                    begin

                    end;
                }
                field(PayrollBaselineDate; PayrollBaselineDate)
                {
                    ApplicationArea = all;
                    ShowCaption = false;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                /*
                field(DisplayingTHR; DisplayingTHR)
                {
                    ApplicationArea = all;
                    ShowCaption = false;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = true;
                }


                field(TanggalFilterAtas; TanggalFilterAtas)
                {
                    Style = Strong;
                    StyleExpr = true;
                    Caption = 'Filter by THR Date';
                    ApplicationArea = all;
                    trigger
                    OnValidate()
                    begin
                        Rec.SetRange("Date Filter", TanggalFilterAtas);

                        if TanggalFilterAtas <> 0D then
                            DisplayingTHR := 'Displaying data for THR date: ' +
                            FORMAT(TanggalFilterAtas, 0, '<Day> <Month Text> <Year>')
                        else
                            DisplayingTHR := 'There is no THR data yet.';


                        CurrPage.Update();
                    end;
                }*/
            }
            repeater(GroupName)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = Muslim;

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
                    Style = StrongAccent;
                    StyleExpr = Muslim;
                    Editable = false;
                }
                field("Last Name"; Rec."Last Name")
                {
                    ApplicationArea = all;
                    Style = StrongAccent;
                    StyleExpr = Muslim;
                    Editable = false;
                }
                field("With Muslim THR Disbursement"; Rec."With Muslim THR Disbursement")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(AppliedtoOldBasicSalary; AppliedtoOldBasicSalary)
                {
                    Caption = 'Applied to Old Basic Salary';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(ContractStart; ContractStart)
                {
                    Caption = 'Contract Start Date';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(ContractEnd; ContractEnd)
                {
                    Caption = 'Contract End Date';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(EndingDateCalculation; EndingDateCalculation)
                {
                    Caption = 'Ending Date Calculation';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(LastTHRDate2; LastTHRDate2)
                {
                    Caption = 'Last THR Date';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(PeriodePenghasilan; PeriodePenghasilan)
                {
                    Caption = 'Periode Penghasilan';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(BasicSalary; BasicSalary)
                {
                    Caption = 'Basic Salary';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(TotalAllowanceFixPayroll; TotalAllowanceFixPayroll)
                {
                    Caption = 'Total Allowance (Fix)';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(TotalIncome; TotalIncome)
                {
                    Caption = 'Total Income';
                    Editable = false;
                    ApplicationArea = all;
                }
                field(TotalHariLengthOfService; Rec.TotalHariLengthOfService)
                {
                    Caption = 'Total Hari Length of Service';
                    ApplicationArea = all;
                    Editable = false;

                }
                field(LoS; LoS)
                {
                    Caption = 'THR LoS';
                    ApplicationArea = all;
                    Editable = false;
                    DecimalPlaces = 7 : 7;
                }
                field(CalcLoS; CalcLoS)
                {
                    Caption = 'THR Calc. Based on LoS';
                    ApplicationArea = all;
                    Editable = false;
                    DecimalPlaces = 7 : 7;
                }
                field(THRAmount; THRAmount)
                {
                    Caption = 'THR Amount';
                    Editable = false;
                    ApplicationArea = all;
                }
                field(GrossIncomeBiasa; GrossIncomeBiasa)
                {
                    Editable = false;
                    ApplicationArea = all;
                    Caption = 'Gross Income';
                }
                /*
                field(GrossIncomeWithTHR; GrossIncomeWithTHR)
                {
                    Editable = false;
                    ApplicationArea = all;
                    Caption = 'Gross Income with THR';
                }
                */
                field(RegulerSetahunWithTHR; RegulerSetahunWithTHR)
                {
                    Caption = 'Reguler Setahun with THR';
                    ApplicationArea = all;
                    Editable = false;
                }

                field(BiayaJabatanWithTHR; BiayaJabatanWithTHR)
                {
                    Caption = 'Biaya Jabatan with THR';
                    ApplicationArea = all;
                    Editable = false;
                }
                /*
                field(BijabRegulerWithTHR; BijabRegulerWithTHR)
                {
                    Caption = 'Bijab Reguler with THR';
                    ApplicationArea = all;
                    Editable = false;
                }
                */
                field(JumlahPenguranganWithTHR; JumlahPenguranganWithTHR)
                {
                    Caption = 'Jumlah Pengurangan with THR';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(PenghasilanNettoSetahunWithTHR; PenghasilanNettoSetahunWithTHR)
                {
                    Caption = 'Penghasilan Netto Setahun/Disetahunkan with THR';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("MSI_HRIS PTKP Baru"; Rec."MSI_HRIS PTKP Baru")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(PKPCorrectTHR; PKPCorrectTHR)
                {
                    Caption = 'PKP With THR';
                    ApplicationArea = all;
                    Editable = false;
                }

                field(TaxPerYearLastPayroll; TaxPerYearLastPayroll)
                {
                    Caption = 'Tax Per Year Last Payroll';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("MSI_HRIS Tax Per Year THR"; Rec."MSI_HRIS Tax Per Year THR")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field(THRTax; THRTax)
                {
                    Caption = 'THR Tax';
                    Editable = false;
                    ApplicationArea = all;
                }
                field(NetTHR; NetTHR)
                {
                    Caption = 'Net THR';
                    Editable = false;
                    ApplicationArea = all;
                    //DecimalPlaces = 0 : 0;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Process (With Muslim Disbursement)")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = CalculateCost;
                ApplicationArea = all;

                trigger OnAction();
                var
                    PayrollTerakhir: Record "Payroll Ledger Entry";
                begin
                    PayrollTerakhir.FindLast();

                    ProcessTHRPage.checkIsMuslim(true, PayrollTerakhir."Posting Date");
                    ProcessTHRPage.Run();
                    CurrPage.Update();
                end;
            }
            action("Process (With Non Muslim Disbursement)")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = CalculateCost;
                ApplicationArea = all;

                trigger OnAction();
                var
                    PayrollTerakhir: Record "Payroll Ledger Entry";
                begin
                    PayrollTerakhir.FindLast();

                    ProcessTHRPage.checkIsMuslim(false, PayrollTerakhir."Posting Date");
                    ProcessTHRPage.Run();
                    CurrPage.Update();
                end;
            }
            action("Process (THR Compensation)")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = CalculateCost;
                ApplicationArea = all;

                trigger OnAction()
                var
                    ProcessTHRCompensation: Page "Process THR Compensation Page";
                    PayrollTerakhir: Record "Payroll Ledger Entry";
                begin
                    PayrollTerakhir.FindLast();

                    ProcessTHRCompensation.SetTanggalTerakhirPayroll(PayrollTerakhir."Posting Date");
                    ProcessTHRCompensation.Run();
                    CurrPage.Close();
                end;
            }
            action("Calculate THR Amount")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = CalculateCalendar;
                ApplicationArea = all;

                trigger
                OnAction()
                var
                    THRDateCalcPage: page "Input THR Date for Calculation";
                    PayrollTerakhir: Record "Payroll Ledger Entry";
                begin
                    PayrollTerakhir.FindLast();

                    THRDateCalcPage.TanggalGajianTerakhir(PayrollTerakhir."Posting Date",
                    FilterList);
                    //THRDateCalcPage.LookupMode := true;
                    if THRDateCalcPage.RunModal() = Action::OK then
                        CurrPage.Update();
                end;
            }
            action("Clear Calculated THR")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Delete;
                ApplicationArea = all;

                trigger OnAction()
                var
                    EmployeeClearTHR: Record Employee;
                    Window: Dialog;
                begin
                    if not Confirm('This will clear all THR Amount, THR LoS, and THR Calc LoS. Proceed?') then exit;

                    Window.Open('Clearing, please wait..');
                    EmployeeClearTHR.Reset();
                    EmployeeClearTHR.SetRange(Status, EmployeeClearTHR.Status::Active);
                    EmployeeClearTHR.FindFirst();
                    repeat
                        if EmployeeClearTHR."MSI_HRIS Termination Status" <> 0 then begin
                            EmployeeClearTHR."MSI_HRIS Termination Status" := 0;
                            EmployeeClearTHR."Termination Date" := 0D;
                        end;

                        EmployeeClearTHR."MSI_HRIS THR LoS" := 0;
                        EmployeeClearTHR."MSI_HRIS THR Calc. LoS" := 0;
                        EmployeeClearTHR."THR Amount" := 0;
                        EmployeeClearTHR."MSI_HRIS Los Newly Calc." := false;
                        EmployeeClearTHR.Modify();
                    until EmployeeClearTHR.Next() = 0;
                    Window.Close();

                    Message('THR data cleared.');
                end;
            }
            action("Clear Transaction For This Date")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Delete;
                ApplicationArea = all;

                trigger OnAction()
                var
                    EmployeeResigned: Record Employee;
                    ProcessTHRSetup: Record "Process THR Setup Table";
                    ProcessTHRCompensation: Record "Process THR Compensation Table";
                    StrConfirm: Text;
                    Window: Dialog;
                    THRList: page "THR List";
                    PegawaiKompensasi: Record Employee;
                    StrAkhir: Text;
                    THRAccrualLedgerEntry: Record "THR Accrual Ledger Entry";
                    AdvanceHeader: Record "Advance Header";
                    GenJnlLine: Record "Gen. Journal Line";
                    PayrollProcessedEntry: Record "Payroll Processed Entry";
                    PayrollLedgerEntryNo: Integer;
                    PayrollLedgerEntryCheck: Record "Payroll Ledger Entry";
                begin
                    if FilterList = FilterList::"THR Compensation" then begin
                        StrConfirm := 'This process will delete the last transaction of THR Compensation for the displayed employees,\' +
                                      'and an entry in general payment if it exist.\' +
                                      'Are you sure to continue?';

                        StrAkhir := 'THR Compensation data successfully cleared.'
                    end else
                        if (FilterList = FilterList::"Muslim THR") or
                           (FilterList = FilterList::"Non-Muslim THR") then begin
                            StrConfirm := 'Continue to clear THR transaction for ' +
                            Format(TanggalFilterTHR, 0, '<Day> <Month Text> <Year4>') + ' ?';

                            StrAkhir := 'Data for ' + Format(TanggalFilterTHR, 0, '<Day> <Month Text> <Year4>') +
                            ' successfully cleared.';
                        end else
                            Error('Please choose the type of THR first.');

                    if not confirm(StrConfirm) then exit;

                    CurrPage.Close();

                    Window.Open('Clearing data, please wait..');

                    SingleInstance.SetFilterList(FilterList);

                    if not (FilterList = FilterList::"THR Compensation") then begin
                        THRLedgerEntry.reset;
                        THRLedgerEntry.SetRange("Opening Balance", false);
                        THRLedgerEntry.SetRange("Posting Date", TanggalFilterTHR);
                        if THRLedgerEntry.FindSet() then begin
                            PayrollLedgerEntryNo := THRLedgerEntry."Payroll Ledger Entry No.";
                            // THRLedgerEntry.DeleteAll();
                        end;

                        PegawaiKompensasi.Reset();
                        PegawaiKompensasi.SetRange(Status, PegawaiKompensasi.Status::Active);
                        PegawaiKompensasi.SetFilter("First Name", '<> MSI');
                        PegawaiKompensasi.SetRange("MSI_HRIS THR Compensation", false);
                        if PegawaiKompensasi.FindSet() then
                            repeat
                                THRLedgerEntry.Reset();
                                THRLedgerEntry.SetRange("Employee No.", PegawaiKompensasi."No.");
                                THRLedgerEntry.SetRange("Opening Balance", false);
                                if FilterList = FilterList::"Muslim THR" then
                                    THRLedgerEntry.SetRange("Disbursement Type", THRLedgerEntry."Disbursement Type"::"With Muslim Disbursement");
                                if FilterList = FilterList::"Non-Muslim THR" then
                                    THRLedgerEntry.SetRange("Disbursement Type", THRLedgerEntry."Disbursement Type"::"With Non Muslim Disbursement");
                                THRLedgerEntry.SetRange("Posting Date", TanggalFilterTHR);
                                if THRLedgerEntry.FindLast() then begin
                                    THRAccrualLedgerEntry.Reset();
                                    THRAccrualLedgerEntry.SetRange("Employee No.", PegawaiKompensasi."No.");
                                    THRAccrualLedgerEntry.SetRange("THR Ledger Entry No.", THRLedgerEntry."Entry No.");
                                    THRAccrualLedgerEntry.SetRange("Entry Type", THRAccrualLedgerEntry."Entry Type"::Negative);
                                    if THRAccrualLedgerEntry.FindFirst() then begin
                                        THRAccrualLedgerEntry.Delete();
                                    end;

                                    // PayrollLedgerEntryNo := THRLedgerEntry."Payroll Ledger Entry No.";
                                    THRLedgerEntry.Delete();
                                end;

                            until PegawaiKompensasi.Next() = 0;

                        TarifPPh21THREntry.Reset();
                        TarifPPh21THREntry.SetRange("Posting Date THR", TanggalFilterTHR);
                        if TarifPPh21THREntry.FindSet() then
                            TarifPPh21THREntry.DeleteAll();
                    end else begin
                        PegawaiKompensasi.Reset();
                        PegawaiKompensasi.SetRange(Status, PegawaiKompensasi.Status::Active);
                        PegawaiKompensasi.SetFilter("First Name", '<> MSI');
                        PegawaiKompensasi.SetRange("MSI_HRIS THR Compensation", true);
                        if PegawaiKompensasi.FindSet() then
                            repeat
                                THRLedgerEntry.Reset();
                                THRLedgerEntry.SetRange("Employee No.", PegawaiKompensasi."No.");
                                THRLedgerEntry.SetRange("Disbursement Type", THRLedgerEntry."Disbursement Type"::Compensation);
                                if THRLedgerEntry.FindLast() then begin
                                    THRAccrualLedgerEntry.Reset();
                                    THRAccrualLedgerEntry.SetRange("Employee No.", PegawaiKompensasi."No.");
                                    THRAccrualLedgerEntry.SetRange("THR Ledger Entry No.", THRLedgerEntry."Entry No.");
                                    THRAccrualLedgerEntry.SetRange("Entry Type", THRAccrualLedgerEntry."Entry Type"::Negative);
                                    if THRAccrualLedgerEntry.FindFirst() then begin
                                        THRAccrualLedgerEntry.Delete();
                                    end;

                                    PayrollLedgerEntryNo := THRLedgerEntry."Payroll Ledger Entry No.";
                                    THRLedgerEntry.Delete();

                                    TarifPPh21THREntry.Reset();
                                    TarifPPh21THREntry.SetRange("Employee No.", PegawaiKompensasi."No.");
                                    TarifPPh21THREntry.SetRange("Posting Date THR", THRLedgerEntry."Posting Date");
                                    if TarifPPh21THREntry.FindSet() then
                                        TarifPPh21THREntry.DeleteAll();
                                end;

                            until PegawaiKompensasi.Next() = 0;
                    end;

                    //Hapus GP THR
                    PayrollLedgerEntryCheck.Get(PayrollLedgerEntryNo);
                    PayrollProcessedEntry.Get(PayrollLedgerEntryCheck."Posting Date");
                    if PayrollProcessedEntry."GP Document No." <> '' then begin
                        AdvanceHeader.Reset();
                        AdvanceHeader.SetRange("Document Type", AdvanceHeader."Document Type"::"General Payment");
                        AdvanceHeader.SetRange("No.", PayrollProcessedEntry."GP Document No.");
                        AdvanceHeader.SetRange("Voucher Type", AdvanceHeader."Voucher Type"::" ");
                        if AdvanceHeader.FindFirst() then
                            if AdvanceHeader.Status = AdvanceHeader.Status::Open then begin
                                GenJnlLine.Reset();
                                GenJnlLine.SetRange("Journal Template Name", AdvanceHeader."Journal Template Name");
                                GenJnlLine.SetRange("Journal Batch Name", AdvanceHeader."Journal Batch Name");
                                if FilterList = FilterList::"THR Compensation" then
                                    GenJnlLine.SetRange(TipeDuit, GenJnlLine.TipeDuit::"THR Compensation")
                                else
                                    GenJnlLine.SetRange(TipeDuit, GenJnlLine.TipeDuit::THR);
                                if GenJnlLine.FindFirst() then begin
                                    GenJnlLine."Delete via HR" := true;
                                    GenJnlLine.Modify();

                                    GenJnlLine.Delete(true);
                                end;
                            end else
                                Error('General payment %1 is already processed. You cannot delete this transaction.',
                                PayrollProcessedEntry."GP Document No.")
                        else
                            Error('General payment %1 is already processed. You cannot delete this transaction.',
                            PayrollProcessedEntry."GP Document No.");
                    end;

                    //Hapus GP Tax THR
                    if PayrollProcessedEntry."GP For Tax" <> '' then begin
                        AdvanceHeader.Reset();
                        AdvanceHeader.SetRange("Document Type", AdvanceHeader."Document Type"::"General Payment");
                        AdvanceHeader.SetRange("No.", PayrollProcessedEntry."GP For Tax");
                        AdvanceHeader.SetRange("Voucher Type", AdvanceHeader."Voucher Type"::" ");
                        if AdvanceHeader.FindFirst() then
                            if AdvanceHeader.Status = AdvanceHeader.Status::Open then begin
                                GenJnlLine.Reset();
                                GenJnlLine.SetRange("Journal Template Name", AdvanceHeader."Journal Template Name");
                                GenJnlLine.SetRange("Journal Batch Name", AdvanceHeader."Journal Batch Name");
                                if FilterList = FilterList::"THR Compensation" then
                                    GenJnlLine.SetRange(TipeDuit, GenJnlLine.TipeDuit::"Tax THR Compensation")
                                else
                                    GenJnlLine.SetRange(TipeDuit, GenJnlLine.TipeDuit::"Tax THR");

                                if GenJnlLine.FindFirst() then begin
                                    GenJnlLine."Delete via HR" := true;
                                    GenJnlLine.Modify();

                                    GenJnlLine.Delete(true);
                                end;
                            end else
                                Error('General payment tax %1 is already processed. You cannot delete this transaction.',
                                PayrollProcessedEntry."GP For Tax")
                        else
                            Error('General payment tax %1 is already processed. You cannot delete this transaction.',
                            PayrollProcessedEntry."GP For Tax");
                    end;


                    EmployeeResigned.Reset();
                    EmployeeResigned.SetRange(Status, Rec.Status::Active);
                    EmployeeResigned.SetFilter("MSI_HRIS Termination Status", '<>0');
                    if EmployeeResigned.FindSet() then begin
                        EmployeeResigned.ModifyAll("MSI_HRIS Termination Status", 0);
                        EmployeeResigned.ModifyAll("Termination Date", 0D);
                    end;

                    if ProcessTHRSetup.Get() then
                        ProcessTHRSetup.Delete();

                    if ProcessTHRCompensation.Get() then
                        ProcessTHRCompensation.Delete();


                    Message(StrAkhir);

                    THRList.Run();
                end;
            }
            action("Show Historical THR Data")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = History;
                ApplicationArea = all;

                trigger OnAction()
                var
                    THRLedgerEntry: Record "THR Ledger Entry";
                    HistoricalTHR: page "THR Ledger Entries USER VIEW";
                begin
                    Clear(HistoricalTHR);
                    THRLedgerEntry.Reset();
                    THRLedgerEntry.SetRange("Employee No.", Rec."No.");
                    THRLedgerEntry.FindSet();

                    HistoricalTHR.SetTableView(THRLedgerEntry);
                    HistoricalTHR.Run();
                end;
            }
        }
    }


    trigger
    OnAfterGetRecord()
    var
        EmployeeLastPayroll: Record Employee;
        ResignDate: Date;
        Pilihan: Integer;
        ContractDetail: Record "Contract Detail";
        PayrollProcessedEntry: Record "Payroll Processed Entry";
        BulanPayrollTerakhir: Integer;
        PayrollLedgerEntryLink: Record "Payroll Ledger Entry";
    begin
        Clear(PeriodePenghasilan);
        Clear(Muslim);
        Clear(RegulerSetahunWithTHR);
        Clear(GrossIncomeWithTHR);
        Clear(BiayaJabatanWithTHR);
        Clear(BijabRegulerWithTHR);
        Clear(JumlahPenguranganWithTHR);
        Clear(PenghasilanNettoSetahunWithTHR);
        Clear(PTKP);
        Clear(PKPWithTHR);
        Clear(TaxPerYearLastPayroll);
        Clear(GrossIncomeBiasa);
        Clear(PKPCorrectTHR);
        Clear(NetTHR);
        Clear(TotalIncome);
        Clear(TotalAllowanceFixPayroll);
        Clear(LessOverDeductTax);
        Clear(TaxPerYearTHR);
        Clear(LoS);
        Clear(CalcLoS);
        Clear(THRAmount);
        Clear(BasicSalary);



        //TanggalFilterTHR := TanggalFilterAtas;

        //Message('tanggalatas=%1 tanggalfilterTHR=%2', TanggalFilterAtas, TanggalFilterTHR);

        ContractStart := 0D;
        ContractEnd := 0D;
        EndingDateCalculation := 0D;
        LastTHRDate := 0D;
        ResignDate := 0D;
        LastTHRDate2 := 0D;

        AmbilLastHRDate2(Rec, LastTHRDate2);

        case FilterList of
            FilterList::"Muslim THR":
                Pilihan := 2;
            FilterList::"Non-Muslim THR":
                Pilihan := 3;
            FilterList::"THR Compensation":
                Pilihan := 4;
            else
                Pilihan := 0;
        end;


        PositionLedgerEntry.Reset();
        PositionLedgerEntry.SetRange("Employee No.", Rec."No.");
        if PositionLedgerEntry.FindLast() then begin
            ContractStart := PositionLedgerEntry."Contract Start Date";
            ContractEnd := PositionLedgerEntry."Contract End Date";
            ResignDate := PositionLedgerEntry."Resign Date";

            if ContractEnd <> 0D then
                EndingDateCalculation := ContractEnd + 1;

            if ResignDate <> 0D then
                EndingDateCalculation := ResignDate + 1;
        end;


        if Rec."With Muslim THR Disbursement" then
            Muslim := true
        else
            Muslim := false;


        DataTHRTerbaru(Rec, LastTHRLedgerEntry, Pilihan);
        if not LastTHRLedgerEntry.IsEmpty then begin
            LastTHRDate := LastTHRLedgerEntry."Posting Date";
            TanggalFilterTHR := LastTHRDate;
            Rec.SetRange("Date Filter", LastTHRDate);
        end;


        PayrollLedgerEntry.Reset();
        PayrollLedgerEntry.SetRange("Posting Date", TanggalPayrollTerakhir);
        PayrollLedgerEntry.SetRange("Employee No.", Rec."No.");
        if PayrollLedgerEntry.FindFirst() then begin
            //Tadinya pake ini
            //PostPayroll.HitungBulanKerja(Rec, PeriodePenghasilan, TanggalPayrollTerakhir);
            ContractDetail.GetPeriodePenghasilan(Rec, TanggalPayrollTerakhir, PeriodePenghasilan);

            GrossIncomeBiasa := PayrollLedgerEntry."Gross Income";
        end;

        if Rec."MSI_HRIS Los Newly Calc." then begin
            LoS := Rec."MSI_HRIS THR LoS";
            CalcLoS := Rec."MSI_HRIS THR Calc. LoS";
        end;

        if TanggalFilterTHR <> 0D then begin
            THRLedgerEntry.Reset();
            THRLedgerEntry.SetRange("Employee No.", Rec."No.");
            THRLedgerEntry.SetRange("Posting Date", TanggalFilterTHR);

            case Pilihan of
                2:
                    THRLedgerEntry.SetRange("Disbursement Type", THRLedgerEntry."Disbursement Type"::"With Muslim Disbursement");
                3:
                    THRLedgerEntry.SetRange("Disbursement Type", THRLedgerEntry."Disbursement Type"::"With Non Muslim Disbursement");
                4:
                    THRLedgerEntry.SetRange("Disbursement Type", THRLedgerEntry."Disbursement Type"::Compensation);
            end;

            THRLedgerEntry.SetRange(OBAL, false);
            if THRLedgerEntry.FindFirst() then begin


                PayrollLedgerEntryLink.Get(THRLedgerEntry."Payroll Ledger Entry No.");

                EmployeeLastPayroll.Reset();
                EmployeeLastPayroll.SetRange("No.", Rec."No.");
                EmployeeLastPayroll.SetRange("Date Filter", PayrollLedgerEntryLink."Posting Date");
                EmployeeLastPayroll.FindFirst();

                EmployeeLastPayroll.CalcFields("MSI_HRIS Tax Per Year");
                EmployeeLastPayroll.CalcFields("MSI_HRIS Total Allowance Fix");
                EmployeeLastPayroll.CalcFields("MSI_HRIS Tax Per Year End");

                TotalAllowanceFixPayroll := EmployeeLastPayroll."MSI_HRIS Total Allowance Fix";

                BulanPayrollTerakhir := Date2DMY(PayrollLedgerEntryLink."Posting Date", 2);
                PayrollProcessedEntry.Get(PayrollLedgerEntryLink."Posting Date");

                if BulanPayrollTerakhir <> 12 then
                    TaxPerYearLastPayroll := EmployeeLastPayroll."MSI_HRIS Tax Per Year"
                else begin
                    if PayrollProcessedEntry."Year End Process" <>
                       PayrollProcessedEntry."Year End Process"::Processed then
                        Error('The year end PPh 21 must be completed before you can process THR.');

                    TaxPerYearLastPayroll := EmployeeLastPayroll."MSI_HRIS Tax Per Year End";
                end;


                Rec.CalcFields("MSI_HRIS Tax Per Year");
                Rec.CalcFields("MSI_HRIS Tax Per Year THR");
                //TaxPerYearTHR := 

                LoS := THRLedgerEntry.LoS;
                CalcLoS := THRLedgerEntry."Calc. LoS";
                BasicSalary := THRLedgerEntry."Basic Salary";

                GrossIncomeWithTHR := THRLedgerEntry."Gross Income With THR";
                RegulerSetahunWithTHR := THRLedgerEntry."Reguler Setahun With THR";
                BiayaJabatanWithTHR := THRLedgerEntry."Biaya Jabatan With THR";
                BijabRegulerWithTHR := THRLedgerEntry."Bijab Reguler With THR";
                JumlahPenguranganWithTHR := THRLedgerEntry."Jumlah Pengurangan With THR";
                PenghasilanNettoSetahunWithTHR := THRLedgerEntry."Penghasilan Netto Setahun THR";
                PKPCorrectTHR := THRLedgerEntry."PKP Correct THR";
                PKPWithTHR := THRLedgerEntry."PKP With THR";
                LessOverDeductTax := THRLedgerEntry."Less/Over Deduct Tax";

                if not Rec."MSI_HRIS Last Payroll" then begin
                    if Rec."MSI_HRIS Tax Per Year THR" > 0 then
                        THRTax := Rec."MSI_HRIS Tax Per Year THR" - TaxPerYearLastPayroll
                    else
                        THRTax := 0;
                end else
                    THRTax := 0;

                if Rec."MSI_HRIS Los Newly Calc." then
                    THRAmount := Rec."THR Amount"
                else
                    THRAmount := THRLedgerEntry."THR Amount";

                NetTHR := round(THRAmount - THRTax, 1, '=');

                TotalIncome := BasicSalary + Rec."MSI_HRIS Total Allowance Fix";

                if THRLedgerEntry."Applied to Old Basic Salary" then
                    AppliedtoOldBasicSalary := true
                else
                    AppliedtoOldBasicSalary := false;

            end else begin
                TaxPerYearTHR := 0;
                GrossIncomeWithTHR := 0;
                RegulerSetahunWithTHR := 0;
                BiayaJabatanWithTHR := 0;
                BijabRegulerWithTHR := 0;
                JumlahPenguranganWithTHR := 0;
                PenghasilanNettoSetahunWithTHR := 0;
                PKPCorrectTHR := 0;
                PKPWithTHR := 0;
                LessOverDeductTax := 0;

                if Rec."MSI_HRIS Los Newly Calc." then
                    THRAmount := Rec."THR Amount"
                else
                    THRAmount := 0;

                if Rec."MSI_HRIS THR LoS" <> 0 then begin
                    LoS := Rec."MSI_HRIS THR LoS";
                    CalcLoS := Rec."MSI_HRIS THR Calc. LoS";
                end else begin
                    LoS := 0;
                    CalcLoS := 0;
                end;

                if Rec."MSI_HRIS THR Apply to Old" then begin
                    BasicSalary := Rec."MSI_HRIS Old Basic Salary";
                    AppliedtoOldBasicSalary := true;
                end else begin
                    BasicSalary := Rec."MSI_HRIS Basic Salary";
                    AppliedtoOldBasicSalary := false;
                end;

                THRTax := 0;
                NetTHR := 0;
                TotalIncome := 0;
                TotalAllowanceFixPayroll := 0;
            end;
        end;

    end;

    trigger
    OnOpenPage()
    var
        OnOpenTHRLedg: Record "THR Ledger Entry";
        Payrollnya: Record "Payroll Ledger Entry";
        FilterListSingleInstance: Option All,"All Active","Muslim THR","Non-Muslim THR","THR Compensation";
    begin
        OnOpen := true;

        if OnOpen then begin
            //dre
            Rec.SetRange(Status, Rec.Status::Active);

            SingleInstance.GetFilterList(FilterListSingleInstance);

            case FilterListSingleInstance of
                2:  //muslim
                    begin
                        FilterList := FilterList::"Muslim THR";
                        Rec.SetRange("With Muslim THR Disbursement", true);
                        Rec.SetFilter("First Name", '<>MSI');
                    end;
                3:  //non muslim
                    begin
                        FilterList := FilterList::"Non-Muslim THR";
                        Rec.SetRange("With Muslim THR Disbursement", false);
                        Rec.SetFilter("First Name", '<>MSI');
                    end;
                4:  //compensation
                    begin
                        FilterList := FilterList::"THR Compensation";
                        Rec.SetRange("MSI_HRIS THR Compensation", true);
                        Rec.SetFilter("First Name", '<>MSI');
                    end;
                else begin
                        FilterList := FilterList::"Muslim THR";
                        Rec.SetRange("With Muslim THR Disbursement", true);
                        Rec.SetFilter("First Name", '<>MSI');
                    end;
            end;

            if Rec.FindSet() then;

            case FilterListSingleInstance of
                2:
                    DataTHRTerbaru(Rec, OnOpenTHRLedg, 2); //muslim
                3:
                    DataTHRTerbaru(Rec, OnOpenTHRLedg, 3); //non muslim
                4:
                    DataTHRTerbaru(Rec, OnOpenTHRLedg, 4); //compensation
                else
                    DataTHRTerbaru(Rec, OnOpenTHRLedg, 2);
            end;

            if not OnOpenTHRLedg.IsEmpty then begin
                if Payrollnya.Get(OnOpenTHRLedg."Payroll Ledger Entry No.") then
                    TanggalPayrollTerakhir := Payrollnya."Posting Date";
            end;

            if TanggalPayrollTerakhir = 0D then begin
                PayrollLedgerEntryUmum.Reset();
                PayrollLedgerEntryUmum.FindLast();
                TanggalPayrollTerakhir := PayrollLedgerEntryUmum."Posting Date";
            end;

            if TanggalPayrollTerakhir <> 0D then
                PayrollBaselineDate := 'Monthly payroll date as baseline: ' +
                Format(TanggalPayrollTerakhir, 0, '<Day> <Month Text> <Year4>')
            else
                PayrollBaselineDate := 'There is no monthly payroll data.';
        end;

    end;


    procedure AmbilLastHRDate2(Nyet: Record Employee; var Tanggalnye: Date)
    var
        DataTHRTerbaru: Record "THR Ledger Entry";
    begin
        DataTHRTerbaru.Reset();
        DataTHRTerbaru.SetRange("Employee No.", Nyet."No.");
        if DataTHRTerbaru.FindLast() then
            Tanggalnye := DataTHRTerbaru."Posting Date"
        else
            Tanggalnye := 0D;
    end;


    procedure DataTHRTerbaru(Kuli: Record Employee; var DataTHRnya: Record "THR Ledger Entry";
    Jenisnya: Option All,"All Active","Muslim THR","Non-Muslim THR","THR Compensation")
    begin
        DataTHRnya.Reset();
        case Jenisnya of
            Jenisnya::"Muslim THR":
                DataTHRnya.SetRange("Disbursement Type", DataTHRnya."Disbursement Type"::"With Muslim Disbursement");
            Jenisnya::"Non-Muslim THR":
                DataTHRnya.SetRange("Disbursement Type", DataTHRnya."Disbursement Type"::"With Non Muslim Disbursement");
            Jenisnya::"THR Compensation":
                DataTHRnya.SetRange("Disbursement Type", DataTHRnya."Disbursement Type"::Compensation);
            else
                DataTHRnya.SetRange("Disbursement Type", DataTHRnya."Disbursement Type"::" ");
        end;
        DataTHRnya.SetRange("Employee No.", Kuli."No.");
        DataTHRnya.SetRange(OBAL, false);
        if DataTHRnya.FindLast() then;
    end;

    var
        AppliedtoOldBasicSalary: Boolean;
        SingleInstance: Codeunit SingleInstanceDRE;
        PayrollLedgerEntryUmum: Record "Payroll Ledger Entry";
        OnOpen: Boolean;
        BasicSalary: Decimal;
        Muslim: Boolean;
        PeriodePenghasilan: Integer;
        PayrollLedgerEntry: Record "Payroll Ledger Entry";
        THRLedgerEntry: Record "THR Ledger Entry";
        TarifPPh21THREntry: Record "Tarif PPh21 THR Entry";
        PositionLedgerEntry: Record "Position Ledger Entry";
        PostPayroll: Codeunit "Payroll Post";
        TotalAllowanceFixPayroll: Decimal;
        TanggalPayrollTerakhir: Date;
        PayrollBaselineDate: Text;
        RegulerSetahunWithTHR: Decimal;
        GrossIncomeWithTHR: Decimal;
        GrossIncomeBiasa: Decimal;
        BiayaJabatanWithTHR: Decimal;
        BijabRegulerWithTHR: Decimal;
        JumlahPenguranganWithTHR: Decimal;
        PenghasilanNettoSetahunWithTHR: Decimal;
        PTKP: Decimal;
        PKPWithTHR: Decimal;
        ProcessTHRPage: Page "Process THR Page";
        DisplayingTHR: Text;
        StrTanggalFilterTHR: Text;
        TanggalFilterTHR: Date;
        THRTax: Decimal;
        LessOverDeductTax: Decimal;
        TaxPerYearLastPayroll: Decimal;
        PKPCorrectTHR: Decimal;
        NetTHR: Decimal;
        TotalIncome: Decimal;
        ContractStart: Date;
        ContractEnd: Date;
        EndingDateCalculation: Date;
        LastTHRDate: Date;
        LastTHRLedgerEntry: Record "THR Ledger Entry";
        FilterList: Option All,"All Active","Muslim THR","Non-Muslim THR","THR Compensation";
        TaxPerYearTHR: Decimal;
        LoS: Decimal;
        CalcLoS: Decimal;
        TanggalFilterAtas: Date;
        THRAmount: Decimal;
        LastTHRDate2: Date;

    local procedure LinkTHRDanPayroll(Nyet: Record Employee;
    Filternye: Integer; var PayrollDate: Date)
    var
        OnAfterTHRLedg: Record "THR Ledger Entry";
        PayrollOnAfter: Record "Payroll Ledger Entry";
    begin
        DataTHRTerbaru(Nyet, OnAfterTHRLedg, Filternye);
        if not OnAfterTHRLedg.IsEmpty then begin
            if PayrollOnAfter.Get(OnAfterTHRLedg."Payroll Ledger Entry No.") then
                PayrollDate := PayrollOnAfter."Posting Date";
        end;
    end;
}