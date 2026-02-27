page 60122 "Employee Severance List"
{
    PageType = Worksheet;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Employee;
    SourceTableView = where(Status = const(Active),
    "First Name" = filter('<>MSI'), "MSI_HRIS Severance" = const(true));
    CardPageId = "Employee Card HR";
    Caption = 'Employee Severance';
    PromotedActionCategories = 'Processing';
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
                field(Displaying; Displaying)
                {
                    ApplicationArea = all;
                    ShowCaption = false;
                    Editable = false;
                }
            }
            repeater(GroupName)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
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
                    Editable = false;
                }
                field("Last Name"; Rec."Last Name")
                {
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
                field("MSI_HRIS Sevr. Apply to Old"; Rec."MSI_HRIS Sevr. Apply to Old")
                {
                    ApplicationArea = all;

                    trigger
                    OnValidate()
                    begin
                        if ProcessedFinished then
                            Error('You cannot edit this line. Process already finished');

                        if UnusedLeaveDocNo <> '' then
                            if Rec."MSI_HRIS Sevr. Apply to Old" <> xRec."MSI_HRIS Sevr. Apply to Old" then
                                Error('This line is already processed the unused leave. You cannot change it.');
                    end;
                }
                field(UnusedLeaveDocNo; UnusedLeaveDocNo)
                {
                    Caption = 'Unused Leave Document No.';
                    Editable = false;
                    ApplicationArea = all;
                }
                field(SeveranceLoS; SeveranceLoS)
                {
                    Caption = 'Severance LoS';
                    ApplicationArea = all;
                    Editable = false;
                    DecimalPlaces = 7 : 7;
                }
                field(CalcLoS; CalcLoS)
                {
                    Editable = false;
                    ApplicationArea = all;
                    Caption = 'Severance Calc. Based on LoS';
                    DecimalPlaces = 7 : 7;
                }
                field(SeveranceAmount; SeveranceAmount)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Severance Amount';
                }
                field(UnusedLeaveAmount; UnusedLeaveAmount)
                {
                    Caption = 'Unused Leave Amount';
                    Editable = false;
                    ApplicationArea = all;
                }
                field(TotalAmount; TotalAmount)
                {
                    Editable = false;
                    ApplicationArea = all;
                    Caption = 'Total Amount';
                }
                field("MSI_HRIS Tax Severance Leave"; Rec."MSI_HRIS Tax Severance Leave")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field(Nett; Nett)
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field(GPNo; GPNo)
                {
                    Caption = 'GP No.';
                    Editable = false;
                    ApplicationArea = all;
                    trigger OnDrillDown()
                    var
                        PayrollProcessedEntries: page "Payroll Processed Entries";
                    begin
                        PayrollProcessedEntries.ShowGPDocument(GPNo);
                    end;
                }
                field("MSI_HRIS Actual Payment Date"; Rec."MSI_HRIS Actual Payment Date")
                {
                    ApplicationArea = all;

                    trigger
                    OnValidate()
                    begin
                        if ProcessedFinished then
                            Error('You cannot edit this line. Process already finished');

                        if UnusedLeaveDocNo <> '' then
                            if Rec."MSI_HRIS Sevr. Apply to Old" <> xRec."MSI_HRIS Sevr. Apply to Old" then
                                Error('This line is already processed the unused leave. You cannot change it.');
                    end;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Process Severance")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Process;
                ApplicationArea = all;

                trigger OnAction();
                var
                    ProcessSeverancePage: page "Process Severance Page";
                    AdaLeaveWoi: Boolean;
                    UnusedLeaveDocWoi: Code[20];
                    DocDateWoi: Date;
                begin
                    SeveranceLedgerEntry.Reset();
                    if SeveranceLedgerEntry.FindLast() then begin
                        if SeveranceLedgerEntry."Unused Leave Doc. No." <> '' then begin
                            AdaLeaveWoi := true;
                            DocDateWoi := SeveranceLedgerEntry."Document Date";
                            UnusedLeaveDocWoi := SeveranceLedgerEntry."Unused Leave Doc. No.";
                        end;
                    end;

                    ProcessSeverancePage.setAdakahLeave(AdaLeaveWoi, UnusedLeaveDocWoi, DocDateWoi);
                    ProcessSeverancePage.Run();
                    CurrPage.Close();
                end;
            }
            action("Clear Transaction")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = DeleteRow;
                ApplicationArea = all;

                trigger OnAction();
                var
                    StrConfirm: Text;
                    EmployeeClear: Record Employee;
                    SeveranceLedgerClear: Record "Severance Ledger Entry";
                    AccrualHapusNegatif: Record "Severance Accrual Ledger Entry";
                    Kontrak: Record "Position Ledger Entry";
                    Window: Dialog;
                    EmployeeSeveranceList: Page "Employee Severance List";
                    GenJnlLine: Record "Gen. Journal Line";
                    PayrollSetup: Record "Payroll General Setup";
                    AdvanceHeader: Record "Advance Header";
                    PostedCutiDibayar: page "Posted Cuti Dibayar";
                    AdaLeave: Boolean;
                    SummaryOfSeverance: Record "Summary Of Severance";
                    PPhSeveranceUnused: Record "Tarif PPh21 Sevr. Leave Entry";
                    test: Codeunit 50014;
                begin
                    StrConfirm := 'This process will clear severance transaction on ' +
                                   format(TanggalFilter, 0, '<Day> <Month Text> <Year>') +
                                   ', and return the accrual data to employee.\Are you sure to continue?';

                    if not Confirm(StrConfirm) then exit;

                    CurrPage.Close();

                    Window.Open('Clearing data, please wait...');

                    AdaLeave := false;

                    EmployeeClear.Reset();
                    EmployeeClear.SetRange(Status, EmployeeClear.Status::Active);
                    EmployeeClear.SetFilter("First Name", '<>MSI');
                    EmployeeClear.SetRange("MSI_HRIS Severance", true);
                    if EmployeeClear.FindSet() then
                        repeat
                            Kontrak.Reset();
                            Kontrak.SetRange("Employee No.", EmployeeClear."No.");
                            Kontrak.FindLast();

                            SeveranceLedgerClear.Reset();
                            SeveranceLedgerClear.SetRange("Employee No.", EmployeeClear."No.");
                            SeveranceLedgerClear.SetRange("Document Date", TanggalFilter);
                            if SeveranceLedgerClear.FindSet() then
                                repeat
                                    if not SeveranceLedgerClear.Finished then
                                        Error('Severance for employee %1 on %2 has not been processed yet.',
                                        SeveranceLedgerClear."Employee No.", SeveranceLedgerClear."Posting Date");

                                    if not PostedCutiDibayar.GeneralPaymentIsOpen(SeveranceLedgerClear."GP No.") then
                                        Error('GP %1 is already processed. You cannot clear this transaction.',
                                        SeveranceLedgerClear."GP No.");

                                    if SeveranceLedgerClear."Unused Leave Doc. No." = '' then
                                        SeveranceLedgerClear.Delete()
                                    else begin
                                        AdaLeave := true;

                                        SeveranceLedgerClear."Posting Date" := 0D;
                                        SeveranceLedgerClear."Severance Amount" := 0;
                                        SeveranceLedgerClear."Severance LoS" := 0;
                                        SeveranceLedgerClear."Calc. LoS" := 0;
                                        SeveranceLedgerClear."Severance Reason" := '';
                                        SeveranceLedgerClear."Total Hari LoS Severance" := 0;
                                        SeveranceLedgerClear."Contract Entry No." := 0;
                                        SeveranceLedgerClear."Tahun Posting" := 0;
                                        SeveranceLedgerClear."Bulan Posting" := 0;
                                        SeveranceLedgerClear.Finished := false;
                                        SeveranceLedgerClear."Applied to Old Basic Salary" := false;
                                        SeveranceLedgerClear.Modify();


                                        AdvanceHeader.Get(AdvanceHeader."Document Type"::"General Payment",
                                        SeveranceLedgerClear."GP No.");
                                        GenJnlLine.Reset();
                                        GenJnlLine.SetRange("Journal Template Name", AdvanceHeader."Journal Template Name");
                                        GenJnlLine.SetRange("Journal Batch Name", AdvanceHeader."Journal Batch Name");
                                        GenJnlLine.SetFilter(TipeDuit, '4|10');
                                        if GenJnlLine.FindSet() then begin
                                            GenJnlLine.ModifyAll("Delete via HR", true);
                                            GenJnlLine.DeleteAll(true);
                                        end;
                                    end;

                                    PPhSeveranceUnused.Reset();
                                    PPhSeveranceUnused.SetRange("Severance Ledger Entry No.", SeveranceLedgerClear."Entry No.");
                                    if PPhSeveranceUnused.FindSet() then
                                        PPhSeveranceUnused.DeleteAll();


                                until SeveranceLedgerClear.Next() = 0;

                            if not AdaLeave then begin
                                SummaryOfSeverance.Reset();
                                SummaryOfSeverance.SetRange("Document Date", TanggalFilter);
                                if SummaryOfSeverance.FindSet() then
                                    SummaryOfSeverance.DeleteAll();
                            end;

                            AccrualHapusNegatif.Reset();
                            AccrualHapusNegatif.SetRange("Employee No.", EmployeeClear."No.");
                            AccrualHapusNegatif.SetRange("Entry Type", AccrualHapusNegatif."Entry Type"::Negative);
                            AccrualHapusNegatif.SetRange("Disbursement Date", TanggalFilter);
                            if AccrualHapusNegatif.FindFirst() then
                                AccrualHapusNegatif.Delete();

                        until EmployeeClear.Next() = 0;


                    Window.Close();
                    Message('Severance data for date %1 successfully cleared.',
                    format(TanggalFilter, 0, '<Day> <Month Text> <Year>'));

                    EmployeeSeveranceList.Run();
                end;
            }
        }
    }

    trigger
    OnAfterGetRecord()
    begin
        ContractStart := 0D;
        ContractEnd := 0D;
        EndingDateCalculation := 0D;
        ResignDate := 0D;
        TotalHariLoSSev := 0;
        //AdaLeave := false;
        UnusedLeaveDocNo := '';
        UnusedLeaveAmount := 0;
        TotalAmount := 0;
        Nett := 0;
        GPNo := '';
        AppliedToOld := false;
        ProcessedFinished := false;


        SeveranceLedgerEntry.Reset();
        if SeveranceLedgerEntry.FindLast() then
            Rec.SetRange("Date Filter", SeveranceLedgerEntry."Document Date")
        else begin
            StrTanggalFilter := Rec.GetFilter("Date Filter");
            if StrTanggalFilter <> '' then
                Evaluate(TanggalFilter, StrTanggalFilter);
        end;

        Displaying := 'Displaying data of severance & unused leave document date: ' +
                      Format(TanggalFilter, 0, '<Day> <Month Text> <Year>');

        FindStartAndEnd(Rec."No.", ContractStart, ContractEnd, EndingDateCalculation,
        ResignDate, HiringEntryNo);

        Rec.SetRange("Date Filter", ContractEnd);
        Rec.CalcFields("MSI_HRIS Tax Severance Leave");

        SeveranceLedgerEntry.Reset();
        SeveranceLedgerEntry.SetRange("Employee No.", Rec."No.");
        SeveranceLedgerEntry.SetRange("Document Date", TanggalFilter);
        if SeveranceLedgerEntry.FindFirst() then begin
            if SeveranceLedgerEntry."Unused Leave Doc. No." <> '' then begin
                AdaLeave := true;
                DocumentDate := SeveranceLedgerEntry."Document Date";
            end;

            SeveranceReason := SeveranceLedgerEntry."Severance Reason";
            TotalHariLoSSev := SeveranceLedgerEntry."Total Hari LoS Severance";
            SeveranceLoS := SeveranceLedgerEntry."Severance LoS";
            CalcLoS := SeveranceLedgerEntry."Calc. LoS";
            SeveranceAmount := SeveranceLedgerEntry."Severance Amount";
            AppliedToOld := SeveranceLedgerEntry."Applied to Old Basic Salary";
            UnusedLeaveAmount := SeveranceLedgerEntry."Unused Leave Amount";
            UnusedLeaveDocNo := SeveranceLedgerEntry."Unused Leave Doc. No.";
            GPNo := SeveranceLedgerEntry."GP No.";
            ProcessedFinished := SeveranceLedgerEntry.Finished;

            TotalAmount := SeveranceAmount + UnusedLeaveAmount;
            Nett := TotalAmount - Rec."MSI_HRIS Tax Severance Leave";
        end;
    end;

    trigger
    OnOpenPage()
    begin
        AdaLeave := false;
        DocumentDate := 0D;

        SeveranceLedgerEntry.Reset();
        if SeveranceLedgerEntry.FindLast() then begin
            TanggalFilter := SeveranceLedgerEntry."Document Date";
            Displaying := 'Displaying data of severance & unused leave document date: ' +
                          Format(TanggalFilter, 0, '<Day> <Month Text> <Year>');
            Rec.SetRange("Date Filter", TanggalFilter);

            if SeveranceLedgerEntry."Unused Leave Doc. No." <> '' then begin
                AdaLeave := true;
                DocumentDate := SeveranceLedgerEntry."Document Date";
                UnusedLeaveDocNo := SeveranceLedgerEntry."Unused Leave Doc. No.";
            end;
        end;
    end;

    var
        ProcessedFinished: Boolean;
        GPNo: Code[20];
        TotalAmount: Decimal;
        Nett: Decimal;
        AdaLeave: Boolean;
        DocumentDate: Date;
        AppliedToOld: Boolean;
        UnusedLeaveAmount: Decimal;
        UnusedLeaveDocNo: Code[20];
        HiringEntryNo: Integer;
        SeveranceAmount: Decimal;
        TanggalFilter: Date;
        StrTanggalFilter: Text;
        InputTHRDateCalc: page "Input THR Date for Calculation";
        TotalHariLoSSev: Integer;

        SeveranceLedgerEntry: Record "Severance Ledger Entry";
        ContractStart: Date;
        ContractEnd: Date;
        ResignDate: Date;
        EndingDateCalculation: Date;

        SeveranceLoS: Decimal;
        CalcLoS: Decimal;
        SeveranceReason: Text;
        Displaying: Text;


    procedure FindStartAndEnd(NoPegawai: Code[20]; var xContractStart: Date; var xContractEnd: Date;
    var xEndingDateCalculation: Date; var xResignDate: Date; var xEntryNo: Integer)
    var
        PositionLedgerEntry: Record "Position Ledger Entry";
    begin
        PositionLedgerEntry.Reset();
        PositionLedgerEntry.SetRange("Employee No.", NoPegawai);
        PositionLedgerEntry.FindLast();
        xContractStart := PositionLedgerEntry."Contract Start Date";
        xContractEnd := PositionLedgerEntry."Contract End Date";
        xResignDate := PositionLedgerEntry."Resign Date";

        if xContractEnd <> 0D then
            xEndingDateCalculation := xContractEnd + 1;

        if xResignDate <> 0D then
            xEndingDateCalculation := xResignDate + 1;
    end;
}