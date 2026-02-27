codeunit 60003 "Leave Management"
{
    procedure PostUnusedLeave(CutiDibayarHeader: Record "Cuti Dibayar Header")
    var
        CutiDibayarLine: Record "Cuti Dibayar Line";
        PostedCutiDibayarHeader: Record "Posted Cuti Dibayar Header";
        PostedCutiDibayarLine: Record "Posted Cuti Dibayar Line";
        Window: Dialog;
        AccrualMgt: Codeunit "Accrual Management";
        Pegawai: Record Employee;
        Window2: Dialog;
        AdvancePostDRE: Codeunit "Advance-Post";
        _GenJnlBatch: Record "Gen. Journal Batch";
        EmployeeDREE: Record Employee;
        AdvanceHeader: Record "Advance Header";
        AdvanceHeader2: Record "Advance Header";
        GenJnlLine: Record "Gen. Journal Line";
        PayrollSetup: Record "Payroll General Setup";
        CairGelondongan: Decimal;
        SisaHangus: Decimal;
        AdaSisaHangus: Boolean;
        SeveranceLedgerEntry: Record "Severance Ledger Entry";
        EntryNo: Integer;
        SummaryOfSeverance: Record "Summary Of Severance";
        EntryNoSummary: Integer;
        DocNoGP: Code[20];
        SudahAdaSummary: Boolean;
        StrDocNoGP: Text;
    begin
        if not Confirm('Proceed posting this document?') then exit;

        Window.Open('Posting unused leave...please wait.');

        SudahAdaSummary := false;
        Clear(StrDocNoGP);

        PostedCutiDibayarHeader.Init();
        PostedCutiDibayarHeader.TransferFields(CutiDibayarHeader);
        PostedCutiDibayarHeader.Insert();

        SummaryOfSeverance.Reset();
        SummaryOfSeverance.SetRange("Document Date", CutiDibayarHeader."Document Date");
        if SummaryOfSeverance.FindFirst() then begin
            EntryNoSummary := SummaryOfSeverance."Entry No.";
            SudahAdaSummary := true;
        end else begin
            SummaryOfSeverance.LockTable();
            SummaryOfSeverance.Reset();
            if SummaryOfSeverance.FindLast() then
                EntryNoSummary := SummaryOfSeverance."Entry No." + 1
            else
                EntryNoSummary := 1;
        end;

        if not SudahAdaSummary then begin
            SummaryOfSeverance.Init();
            SummaryOfSeverance."Entry No." := EntryNoSummary;
            SummaryOfSeverance."Document Date" := CutiDibayarHeader."Document Date";
            SummaryOfSeverance.Insert();
        end;

        CutiDibayarLine.Reset();
        CutiDibayarLine.SetRange("Document No.", CutiDibayarHeader."No.");
        CutiDibayarLine.FindFirst();
        repeat
            AdaSisaHangus := false;
            Clear(SisaHangus);

            Pegawai.Get(CutiDibayarLine."Employee No.");
            Pegawai."MSI_HRIS Severance" := true;

            if CutiDibayarLine."Apply to Old Basic Salary" then
                Pegawai."MSI_HRIS Sevr. Apply to Old" := true;

            Pegawai.Modify();

            CutiDibayarLine.CalcFields("Jumlah Cuti");

            if CutiDibayarLine."Jumlah Cuti" > CutiDibayarLine."Cuti Dibayarkan" then begin
                SisaHangus := CutiDibayarLine."Jumlah Cuti" - CutiDibayarLine."Cuti Dibayarkan";
                AdaSisaHangus := true;
            end else
                SisaHangus := 0;

            CairGelondongan := CairGelondongan + CutiDibayarLine."Cuti Dibayarkan (Value)";

            CreateGPUnusedLeaveSeverance(CutiDibayarLine."Employee No.", CutiDibayarLine."Cuti Dibayarkan (Value)",
            CutiDibayarHeader."Document Date", DocNoGP, true, true);

            //bagian tambahin negatif di accrual, sekaligus tambahin negatif di leave ledger entry
            AccrualMgt.PencairanLeaveAccrual(Pegawai, CutiDibayarHeader."Document Date",
            CutiDibayarLine."Cuti Dibayarkan (Value)", CutiDibayarLine."Cuti Dibayarkan",
            CutiDibayarLine."Document No.", AdaSisaHangus, SisaHangus, DocNoGP,
            CutiDibayarLine."Actual Payment Date");

            StrDocNoGP := StrDocNoGP + '-' + DocNoGP;

            //bagian insert ke severance ledger entry
            SeveranceLedgerEntry.LockTable();
            SeveranceLedgerEntry.Reset();
            if SeveranceLedgerEntry.FindLast() then
                EntryNo := SeveranceLedgerEntry."Entry No." + 1
            else
                EntryNo := 1;

            SeveranceLedgerEntry.Init();
            SeveranceLedgerEntry."Entry No." := EntryNo;
            SeveranceLedgerEntry."Employee No." := CutiDibayarLine."Employee No.";
            SeveranceLedgerEntry."Document Date" := CutiDibayarHeader."Document Date";
            SeveranceLedgerEntry."Unused Leave Doc. No." := CutiDibayarLine."Document No.";
            SeveranceLedgerEntry."Unused Leave Amount" := CutiDibayarLine."Cuti Dibayarkan (Value)";
            SeveranceLedgerEntry."Applied to Old Basic Salary" := CutiDibayarLine."Apply to Old Basic Salary";
            SeveranceLedgerEntry."Sum of Sev. Ledger Entry No." := EntryNoSummary;
            SeveranceLedgerEntry."GP No." := DocNoGP;
            SeveranceLedgerEntry."Basic Salary Used" := CutiDibayarLine."Basic Salary Used";
            SeveranceLedgerEntry."Fix Allowance Used" := CutiDibayarLine."Fix Allowance Used";
            SeveranceLedgerEntry.Insert();

            //bagian pindahin isi line ke posted line
            PostedCutiDibayarLine.Init();
            PostedCutiDibayarLine.TransferFields(CutiDibayarLine);
            CutiDibayarLine.CalcFields("Jumlah Cuti");
            PostedCutiDibayarLine."Jumlah Cuti" := CutiDibayarLine."Jumlah Cuti";
            PostedCutiDibayarLine."Ledger Entry No." := EntryNo;
            PostedCutiDibayarLine."Applied to Old Basic Salary" := CutiDibayarLine."Apply to Old Basic Salary";
            PostedCutiDibayarLine.Insert();
        until CutiDibayarLine.Next() = 0;

        CutiDibayarHeader.Delete(true);

        Window.Close();

        Message('Unused leave %1 successfully posted.\GP %2 was created as well.', PostedCutiDibayarHeader."No.", StrDocNoGP);
    end;


    procedure UpdateGPWithExtraLine(DocNo: Code[20]; Duitnya: Decimal; isTHP: Boolean;
    Pegawai: Record Employee)
    var
        AdvanceHeader: Record "Advance Header";
        LineNo: Integer;
        GenJnlLine: Record "Gen. Journal Line";
        PayrollSetup: Record "Payroll General Setup";
        Akun: Code[20];
        StrDescription: Text;
    begin
        PayrollSetup.Get();
        if isTHP then begin
            PayrollSetup.TestField("Severance THP Acc. No.");
            Akun := PayrollSetup."Severance THP Acc. No.";
            StrDescription := 'Severance payment for ';
        end else begin
            PayrollSetup.TestField("Severance-Unused Tax Acc. No.");
            Akun := PayrollSetup."Severance-Unused Tax Acc. No.";
            StrDescription := 'PPH 21 Final for ';
            Duitnya := -1 * Duitnya;
        end;

        AdvanceHeader.Reset();
        AdvanceHeader.SetRange("Document Type", AdvanceHeader."Document Type"::"General Payment");
        AdvanceHeader.SetRange("No.", DocNo);
        AdvanceHeader.SetRange("Voucher Type", AdvanceHeader."Voucher Type"::" ");
        AdvanceHeader.SetRange(Status, AdvanceHeader.Status::Open);
        AdvanceHeader.FindFirst();

        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", AdvanceHeader."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", AdvanceHeader."Journal Batch Name");
        GenJnlLine.FindLast();
        LineNo := GenJnlLine."Line No." + 1;

        GenJnlLine.Init();

        GenJnlLine.Validate("Journal Template Name", AdvanceHeader."Journal Template Name");
        GenJnlLine.validate("Journal Batch Name", AdvanceHeader."Journal Batch Name");
        GenJnlLine.Validate("Line No.", LineNo);
        GenJnlLine.Validate("Document No.", AdvanceHeader."No.");
        GenJnlLine.Validate("Posting Date", AdvanceHeader."Posting Date");
        GenJnlLine.Validate(Amount, Duitnya);
        GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
        GenJnlLine.Validate("Account No. 2", Akun);
        GenJnlLine.Validate(Description, StrDescription + Pegawai.FullName());

        if isTHP then
            GenJnlLine.TipeDuit := GenJnlLine.TipeDuit::Severance
        else
            GenJnlLine.TipeDuit := GenJnlLine.TipeDuit::"Severance-Unused Tax";

        GenJnlLine.Insert(true);
    end;

    procedure CreateGPUnusedLeaveSeverance(EmployeeNo: Code[20]; Duitnya: Decimal;
    DocDate: Date; var GPDocNo: Code[20]; Unused: Boolean; isTHP: Boolean)
    var
        PayrollSetup: Record "Payroll General Setup";
        AdvanceHeader: Record "Advance Header";
        test: page "General Payment";
        EmployeeDREE: Record Employee;
        AdvanceHeader2: Record "Advance Header";
        _GenJnlBatch: Record "Gen. Journal Batch";
        AdvancePostDRE: Codeunit "Advance-Post";
        GenJnlLine: Record "Gen. Journal Line";
        Pegawai: Record Employee;
        StrDescription: Text;
        Akun: Code[20];
    begin
        EmployeeDREE.Reset();
        EmployeeDREE.SetRange("User ID", UserId);
        EmployeeDREE.FindFirst();

        Pegawai.Get(EmployeeNo);


        AdvanceHeader.Init();
        AdvanceHeader.Validate("Document Type", AdvanceHeader."Document Type"::"General Payment");
        AdvanceHeader.Validate("No.", '');
        AdvanceHeader."Employee No." := EmployeeDREE."No.";
        AdvanceHeader.validate("Shortcut Dimension 1 Code", EmployeeDREE."MSI_HRIS Shortcut Dim Code");

        PayrollSetup.Get();
        if isTHP then begin
            if Unused then begin
                PayrollSetup.TestField("Unused Leave THP Acc. No.");
                Akun := PayrollSetup."Unused Leave THP Acc. No.";
                AdvanceHeader."Disbursement Type" := AdvanceHeader."Disbursement Type"::"Unused Leave THP";
                StrDescription := 'Unused leave/severance payment for ';
            end else begin
                PayrollSetup.TestField("Severance THP Acc. No.");
                Akun := PayrollSetup."Severance THP Acc. No.";
                AdvanceHeader."Disbursement Type" := AdvanceHeader."Disbursement Type"::"Severance THP";
                StrDescription := 'Unused leave/severance payment for ';
            end;
        end else begin
            PayrollSetup.TestField("Severance-Unused Tax Acc. No.");
            Akun := PayrollSetup."Severance-Unused Tax Acc. No.";
            StrDescription := 'TAX severance-unused leave for ';
            AdvanceHeader."Disbursement Type" := AdvanceHeader."Disbursement Type"::"Tax Severance - Unused Leave";
        end;

        AdvanceHeader.Insert(true);

        GPDocNo := AdvanceHeader."No.";

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
        AdvanceHeader2."Journal Description" := 'Unused Leave/Severance payment for ' + Pegawai."First Name";
        AdvanceHeader2.Validate("Posting Date", DocDate);
        AdvanceHeader2.Modify();


        GenJnlLine.Init();
        GenJnlLine.Validate("Journal Template Name", AdvanceHeader2."Journal Template Name");
        GenJnlLine.validate("Journal Batch Name", AdvanceHeader2."Journal Batch Name");
        GenJnlLine.Validate("Line No.", 10000);
        GenJnlLine.Validate("Document No.", AdvanceHeader."No.");
        GenJnlLine.Validate("Posting Date", DocDate);
        GenJnlLine.Validate(Amount, Duitnya);
        GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
        GenJnlLine.Validate("Account No. 2", Akun);
        GenJnlLine.Validate(Description, StrDescription + Pegawai.FullName());

        if isTHP then
            if Unused then
                GenJnlLine.TipeDuit := GenJnlLine.TipeDuit::"Unused Leave"
            else
                GenJnlLine.TipeDuit := GenJnlLine.TipeDuit::Severance
        else
            GenJnlLine.TipeDuit := GenJnlLine.TipeDuit::"Severance-Unused Tax";

        GenJnlLine.Insert(true);
    end;



    procedure PostAccrualCutiDibayar(KodeKuli: Code[20]; TanggalPayroll: Date;
    TotalIncome: Decimal)
    var
        Tukang: Record Employee;
        AccrualCutiDibayarLedger: Record "Sisa Cuti Accrual Ledger Entry";
        Contract: Record "Position Ledger Entry";
        LeaveEligibleLedger: Record "Leave Eligible Ledger Entry";
        BulanTanggalPayroll: Integer;
        TahunTanggalPayroll: Integer;
        AddModifyContract: Page "Add-Modify Contract";
        DuitAccrue: Decimal;
    begin
        BulanTanggalPayroll := Date2DMY(TanggalPayroll, 2);
        TahunTanggalPayroll := Date2DMY(TanggalPayroll, 3);

        Contract.Reset();
        Contract.SetRange("Employee No.", KodeKuli);
        Contract.FindLast();
        Contract.TestField("Contract Start Date");
        Contract.TestField("Contract End Date");

        //Ambil data dari leave eligible. Harus ada
        LeaveEligibleLedger.Reset();
        LeaveEligibleLedger.SetRange("Employee No.", KodeKuli);
        LeaveEligibleLedger.SetRange("Document No.", 'ELIGIBLE');
        LeaveEligibleLedger.SetRange(Type, LeaveEligibleLedger.Type::Positive);
        LeaveEligibleLedger.SetRange("Year Eligible", TahunTanggalPayroll);
        LeaveEligibleLedger.SetRange("Month Eligible", BulanTanggalPayroll);
        LeaveEligibleLedger.SetRange(Reversed, false);
        LeaveEligibleLedger.FindFirst();

        DuitAccrue := (TotalIncome / 21) * LeaveEligibleLedger.Quantity;


    end;

    procedure PostCutiDibayar(CutiDibayarHeader: Record "Cuti Dibayar Header")
    var
        CutiDibayarLine: Record "Cuti Dibayar Line";
        PostedCutiDibayarHeader: Record "Posted Cuti Dibayar Header";
        PostedCutiDibayarLine: Record "Posted Cuti Dibayar Line";
        SisaCutiAccrualLedgerEntry: Record "Sisa Cuti Accrual Ledger Entry";
    begin

    end;


    procedure validateRangeDateRealization(DocNo: Code[20])
    var
        CTORealizeHeader: Record "CTO Realization Header";
        CTOLedgerEntry: Record "CTO Ledger Entry";
        JumlahRec: Integer;
        YangExpired: Integer;
        HarinyaCukup: Boolean;
        DayBalanceAvailable: Integer;
    begin
        YangExpired := 0;
        HarinyaCukup := false;
        DayBalanceAvailable := 0;

        CTORealizeHeader.Get(DocNo);
        CTOLedgerEntry.Reset();
        CTOLedgerEntry.SetRange("Employee No.", CTORealizeHeader."Employee No.");
        CTOLedgerEntry.SetRange("CTO Type", CTOLedgerEntry."CTO Type"::Request);
        CTOLedgerEntry.SetRange("Entry Type", CTOLedgerEntry."Entry Type"::Positive);
        CTOLedgerEntry.SetRange(Reversed, false);
        CTOLedgerEntry.SetRange(Expired, false);
        if CTOLedgerEntry.FindSet() then begin
            JumlahRec := CTOLedgerEntry.Count;
            repeat
                if CTORealizeHeader."Starting Date" >= CTOLedgerEntry."Request Expired Date" then
                    YangExpired := YangExpired + 1
                else
                    DayBalanceAvailable := DayBalanceAvailable + CTOLedgerEntry."Day Balance";
            //if CTORealizeHeader."Total Number of Days" <= CTOLedgerEntry."Day Balance" then
            //HarinyaCukup := true;
            until CTOLedgerEntry.Next() = 0;
        end;

        if JumlahRec = YangExpired then
            Error('The range date you ask is already meet the expiration date of CTO Request.\' +
                  'Please change it accordingly.')
        else
            if DayBalanceAvailable < CTORealizeHeader."Total Number of Days" then
                Error('You have available CTO Requests, but the day balance is not enough.');
    end;

    procedure undoProcessCTOBalance(DocNo: Code[20])
    var
        CTOReqHeader: Record "CTO Request Header";
        CTOReqLine: Record "CTO Request Line";
        CTOLedgEntry: Record "CTO Ledger Entry";
        CTOLedgEntryReversal: Record "CTO Ledger Entry";
        CTOLedgEntry2: Record "CTO Ledger Entry";

        DetailedCTOLedgEntry: Record "Detailed CTO Ledger Entry";
        UpdateDetailedCTOLedgEntry: Record "Detailed CTO Ledger Entry";
        DetailedCTOLedgEntryReversal: Record "Detailed CTO Ledger Entry";
        DetailedCTOLedgEntry2: Record "Detailed CTO Ledger Entry";
        EntryNoDetailed: Integer;

        EntryNo: Integer;
        Window: Dialog;
    begin
        Window.Open('Undoing balance....please wait..');

        CTOReqHeader.Get(DocNo);
        CTOReqHeader."Projected Calculated" := false;
        CTOReqHeader."Projected CTO Balance" := 0;
        CTOReqHeader."Approval Date" := 0D;
        CTOReqHeader."Expired Date" := 0D;
        CTOReqHeader.Status := CTOReqHeader.Status::Open;
        CTOReqHeader.Modify();

        CTOLedgEntry2.LockTable();
        CTOLedgEntry2.Reset();
        if CTOLedgEntry2.FindLast() then
            EntryNo := CTOLedgEntry2."Entry No." + 1
        else
            EntryNo := 1;

        //filter CTO Ledger Entry yg mau di-reverse
        CTOLedgEntry.Reset();
        CTOLedgEntry.SetRange("Document No.", DocNo);
        CTOLedgEntry.SetRange(Reversed, false);
        CTOLedgEntry.SetRange("Reversal Entry", false);
        CTOLedgEntry.FindFirst();

        //create record reversal-nya
        CTOLedgEntryReversal.Init();
        CTOLedgEntryReversal.TransferFields(CTOLedgEntry);
        CTOLedgEntryReversal."Entry No." := EntryNo;
        CTOLedgEntryReversal."Reversal Entry" := true;
        CTOLedgEntryReversal."Entry Type" := CTOLedgEntryReversal."Entry Type"::Negative;
        CTOLedgEntryReversal.Description := 'REVERSAL ENTRY';
        CTOLedgEntryReversal."Day Balance" := -CTOLedgEntry."Day Balance";
        CTOLedgEntryReversal.Insert();

        //filter detail CTO Ledger entry yg mau di-reverse
        DetailedCTOLedgEntry.Reset();
        DetailedCTOLedgEntry.SetRange("CTO Ledger Entry No.", CTOLedgEntry."Entry No.");
        DetailedCTOLedgEntry.SetRange(Reversed, false);
        DetailedCTOLedgEntry.SetRange("Reversal Entry", false);
        DetailedCTOLedgEntry.FindSet();
        repeat
            DetailedCTOLedgEntry2.Reset();
            if DetailedCTOLedgEntry2.FindLast() then
                EntryNoDetailed := DetailedCTOLedgEntry2."Entry No." + 1
            else
                EntryNoDetailed := 1;

            //create record reversal-nya
            DetailedCTOLedgEntryReversal.Init();
            DetailedCTOLedgEntryReversal.TransferFields(DetailedCTOLedgEntry);
            DetailedCTOLedgEntryReversal."Work Description" := 'REVERSAL ENTRY';
            DetailedCTOLedgEntryReversal."Entry No." := EntryNoDetailed;
            DetailedCTOLedgEntryReversal."Reversal Entry" := true;
            DetailedCTOLedgEntryReversal."Duration (Hour)" := -DetailedCTOLedgEntry."Duration (Hour)";
            DetailedCTOLedgEntryReversal."Duration (Minute)" := -DetailedCTOLedgEntry."Duration (Minute)";
            DetailedCTOLedgEntryReversal."Entry Type" := DetailedCTOLedgEntryReversal."Entry Type"::Negative;
            DetailedCTOLedgEntryReversal.Insert();

            //kasi flag record yg sudah kena reverse, kasi tanda dia di-reverse oleh entry yg mana
            UpdateDetailedCTOLedgEntry.Get(DetailedCTOLedgEntry."Entry No.");
            UpdateDetailedCTOLedgEntry.Reversed := true;
            UpdateDetailedCTOLedgEntry."Reversed By Entry No." := EntryNoDetailed;
            UpdateDetailedCTOLedgEntry.Modify();
        until DetailedCTOLedgEntry.Next() = 0;

        CTOLedgEntry.Reversed := true;
        CTOLedgEntry."Reversed By Entry No." := EntryNo;
        CTOLedgEntry.Modify();

        Window.Close();
    end;

    procedure projectedCTOBalance(DocNo: Code[20]; var calculatedBalance: Integer)
    var
        TempCTOReqLine: Record "CTO Request Line" temporary;
        CTOReqLine: Record "CTO Request Line";
        Balance: Integer;
    begin
        //Ngitung summary
        TempCTOReqLine.DeleteAll();

        CTOReqLine.Reset();
        CTOReqLine.SetRange("Document No.", DocNo);
        CTOReqLine.FindSet();
        repeat
            //bikin mekanisme keunikan (select distinct) berdasarkan "Task Date"
            TempCTOReqLine.Reset();
            TempCTOReqLine.SetRange("Document No.", DocNo);
            TempCTOReqLine.SetRange("Task Date", CTOReqLine."Task Date");
            if TempCTOReqLine.IsEmpty then begin
                TempCTOReqLine.Init();
                TempCTOReqLine.TransferFields(CTOReqLine);
                TempCTOReqLine.Insert();
            end;
        until CTOReqLine.Next() = 0;

        //Proses ngitung balance-nya di sini.
        calculatedBalance := 0;
        TempCTOReqLine.Reset();
        TempCTOReqLine.FindSet();
        if TempCTOReqLine.FindFirst() then
            repeat
                Balance := 0;
                CTOReqLine.Reset();
                CTOReqLine.SetRange("Document No.", DocNo);
                CTOReqLine.SetRange("Task Date", TempCTOReqLine."Task Date");
                CTOReqLine.SetCurrentKey("Task Date");
                if CTOReqLine.FindSet() then begin
                    CTOReqLine.CalcSums("Duration (Hour)");
                    if CTOReqLine."Duration (Hour)" >= 4 then
                        Balance := 1;
                end;
                calculatedBalance := calculatedBalance + Balance;
            until TempCTOReqLine.Next() = 0;
    end;


    procedure UndoCTOBalance(PostedCTOReqHeader: Record "Posted CTO Request Header")
    var
        CTOLedgerEntry: Record "CTO Ledger Entry";
        CTOLedgerEntryTarget: Record "CTO Ledger Entry";
        EntryNo: Integer;
        EntryNoSource: Integer;
        Window: Dialog;
    begin
        if not Confirm('Are you sure to undo this CTO Request?') then exit;

        Window.Open('Processing undo...please wait.');

        PostedCTOReqHeader.Reversed := true;
        PostedCTOReqHeader.Modify();

        CTOLedgerEntry.Reset();
        CTOLedgerEntry.SetRange("Document No.", PostedCTOReqHeader."No.");
        CTOLedgerEntry.SetRange("Entry Type", CTOLedgerEntry."Entry Type"::Positive);
        CTOLedgerEntry.SetRange("CTO Type", CTOLedgerEntry."CTO Type"::Request);
        CTOLedgerEntry.SetRange(Reversed, false);
        CTOLedgerEntry.SetRange(Used, false);
        if CTOLedgerEntry.FindFirst() then
            repeat
                CTOLedgerEntryTarget.LockTable();
                CTOLedgerEntryTarget.Reset();
                if CTOLedgerEntryTarget.FindLast() then
                    EntryNo := CTOLedgerEntryTarget."Entry No." + 1
                else
                    EntryNo := 1;

                CTOLedgerEntryTarget.Init();
                CTOLedgerEntryTarget.TransferFields(CTOLedgerEntry);
                CTOLedgerEntryTarget."Entry No." := EntryNo;
                CTOLedgerEntryTarget."Entry Type" := CTOLedgerEntryTarget."Entry Type"::Negative;
                CTOLedgerEntryTarget.Description := 'Reversal entry';
                CTOLedgerEntryTarget."Day Balance" := -CTOLedgerEntry."Day Balance";
                CTOLedgerEntryTarget."Reversal Entry" := true;
                CTOLedgerEntryTarget.Insert();

                CTOLedgerEntry.Reversed := true;
                CTOLedgerEntry."Reversed By Entry No." := EntryNo;
                // fadhil 
                CTOLedgerEntry.Used := true;
                CTOLedgerEntry."Document Use For" := 'REVERSE';
                CTOLedgerEntry.Modify();
            // fadhil //
            until CTOLedgerEntry.Next() = 0;


        Window.Close();

        Message('Undo process done.');
    end;


    procedure createCTOBalance(CTOReqHeader: Record "CTO Request Header")
    var
        CTOReqLine: Record "CTO Request Line";
        CTOLedgEntry: Record "CTO Ledger Entry";
        CTOLedgEntry2: Record "CTO Ledger Entry";

        DetailedCTOLedgEntry: Record "Detailed CTO Ledger Entry";
        DetailedCTOLedgEntry2: Record "Detailed CTO Ledger Entry";
        EntryNoDetailed: Integer;

        PostedCTOReqHeader: Record "Posted CTO Request Header";
        PostedCTOReqLine: Record "Posted CTO Request Line";
        DistinctCTOReqLine: Query "CTO Request Line Distinct";
        TaskID: Integer;

        EntryNo: Integer;
        Window: Dialog;
        DayBalance: Integer;
    begin
        Window.Open('Posting...Please wait..');

        TaskID := 1;

        DistinctCTOReqLine.SetRange(DistinctCTOReqLine.Document_No_, CTOReqHeader."No.");
        DistinctCTOReqLine.Open();
        while DistinctCTOReqLine.Read() do begin

            //if DistinctCTOReqLine.Duration__Hour_ div 4 <> 0 then begin
            if DistinctCTOReqLine.Duration__Hour_ >= 4 then begin

                Clear(DayBalance);

                CTOLedgEntry2.LockTable();
                CTOLedgEntry2.Reset();
                if CTOLedgEntry2.FindLast() then
                    EntryNo := CTOLedgEntry2."Entry No." + 1
                else
                    EntryNo := 1;

                CTOLedgEntry.Init();
                CTOLedgEntry."Entry No." := EntryNo;
                CTOLedgEntry."Entry Type" := CTOLedgEntry."Entry Type"::Positive;
                CTOLedgEntry."Document No." := CTOReqHeader."No.";
                CTOLedgEntry."CTO Type" := CTOLedgEntry."CTO Type"::Request;
                CTOLedgEntry."Document Date" := CTOReqHeader."Document Date";
                CTOLedgEntry."Employee No." := CTOReqHeader."Employee No.";
                CTOLedgEntry."Description" := 'CTO Request of ' +
                CTOReqHeader.NamaEmployee(CTOReqHeader."Employee No.");
                CTOLedgEntry."Request Approval Date" := CTOReqHeader."Approval Date";

                CTOLedgEntry."Request Expired Date" := DistinctCTOReqLine.Task_Date + 30;

                if DistinctCTOReqLine.Duration__Hour_ >= 4 then
                    DayBalance := 1;

                CTOLedgEntry."Day Balance" := DayBalance;

                CTOLedgEntry."Task Date" := DistinctCTOReqLine.Task_Date;
                CTOLedgEntry."Task ID" := TaskID;
                CTOLedgEntry.Insert();

                TaskID := TaskID + 1;
            end;
        end;
        DistinctCTOReqLine.Close();


        PostedCTOReqHeader.Init();
        PostedCTOReqHeader.TransferFields(CTOReqHeader);
        PostedCTOReqHeader.Insert();


        CTOReqLine.Reset();
        CTOReqLine.SetRange("Document No.", CTOReqHeader."No.");
        CTOReqLine.FindSet();
        repeat
            PostedCTOReqLine.Init();
            PostedCTOReqLine.TransferFields(CTOReqLine);
            PostedCTOReqLine.Insert();

            DetailedCTOLedgEntry2.Reset();
            if DetailedCTOLedgEntry2.FindLast() then
                EntryNoDetailed := DetailedCTOLedgEntry2."Entry No." + 1
            else
                EntryNoDetailed := 1;

            DetailedCTOLedgEntry.Init();
            DetailedCTOLedgEntry."Entry No." := EntryNoDetailed;
            DetailedCTOLedgEntry."CTO Ledger Entry No." := EntryNo;
            DetailedCTOLedgEntry."Entry Type" := DetailedCTOLedgEntry."Entry Type"::Positive;
            DetailedCTOLedgEntry."Work Description" := CTOReqLine."Work Description";
            DetailedCTOLedgEntry."Starting Time" := CTOReqLine."Starting Time";
            DetailedCTOLedgEntry."Ending Time" := CTOReqLine."Ending Time";
            DetailedCTOLedgEntry."Task Date" := CTOReqLine."Task Date";
            DetailedCTOLedgEntry."Duration (Hour)" := CTOReqLine."Duration (Hour)";
            DetailedCTOLedgEntry."Duration (Minute)" := CTOReqLine."Duration (Minute)";
            DetailedCTOLedgEntry.Insert();
        until CTOReqLine.Next() = 0;

        CTOReqHeader.Status := CTOReqHeader.Status::Open;
        CTOReqHeader.Modify();
        CTOReqHeader.Delete(true);





        Window.Close();

    end;

    procedure postCTORealization(CTORealizHeader: Record "CTO Realization Header")
    var
        PostedCTORealHeader: Record "Posted CTO Realization Header";
        CTORequestHeader: Record "CTO Request Header";
        CTOLedgEntry: Record "CTO Ledger Entry";
        CTOLedgEntry2: Record "CTO Ledger Entry";
        CTOLedgEntryPostive: Record "CTO Ledger Entry";
        EntryNo: Integer;
        CountDay: Integer;
        DocNo: Code[20];
    begin
        //if not Confirm('Are you sure to post this document?') then exit;
        DocNo := CTORealizHeader."No.";

        PostedCTORealHeader.Init();
        PostedCTORealHeader.TransferFields(CTORealizHeader);
        PostedCTORealHeader.Insert();

        CTOLedgEntry2.LockTable();
        CTOLedgEntry2.Reset();
        if CTOLedgEntry2.FindLast() then
            EntryNo := CTOLedgEntry2."Entry No." + 1
        else
            EntryNo := 1;

        CTOLedgEntry.Init();
        CTOLedgEntry."Entry No." := EntryNo;
        CTOLedgEntry."Employee No." := CTORealizHeader."Employee No.";

        CTOLedgEntry."Entry Type" := CTOLedgEntry."Entry Type"::Negative;
        CTOLedgEntry."Document No." := CTORealizHeader."No.";
        CTOLedgEntry."CTO Type" := CTOLedgEntry."CTO Type"::Realization;
        CTOLedgEntry."Document Date" := CTORealizHeader."Document Date";
        CTOLedgEntry."Employee No." := CTORealizHeader."Employee No.";
        CTOLedgEntry."Description" := 'CTO Realization of ' +
        CTORealizHeader.NamaEmployee(CTORealizHeader."Employee No.");
        CTOLedgEntry."Day Balance" := -CTORealizHeader."Total Number of Days";
        CTOLedgEntry.Insert();

        // fadhil 
        CTOLedgEntryPostive.Reset();
        CTOLedgEntryPostive.SetRange("Employee No.", CTORealizHeader."Employee No.");
        CTOLedgEntryPostive.SetRange("Entry Type", CTOLedgEntryPostive."Entry Type"::Positive);
        CTOLedgEntryPostive.SetRange(Used, false);
        CTOLedgEntryPostive.SetRange(Expired, false);
        if CTOLedgEntryPostive.FindFirst() then
            for CountDay := 1 to CTORealizHeader."Total Number of Days" do begin
                CTOLedgEntryPostive.Used := true;
                CTOLedgEntryPostive."Document Use For" := CTORealizHeader."No.";
                CTOLedgEntryPostive.Modify();
                CTOLedgEntryPostive.Next();
            end;
        // fadhil //


        CTORealizHeader.Delete(true);

        Message('Document %1 posted successfully.', DocNo);
    end;

    procedure UndoCTORealization(PostedCTOReqHeader: Record "Posted CTO Realization Header")
    var
        CTOLedgerEntry: Record "CTO Ledger Entry";
        CTOLedgerEntryPositiveUse: Record "CTO Ledger Entry";
        CTOLedgerEntryTarget: Record "CTO Ledger Entry";
        EntryNo: Integer;
        EntryNoSource: Integer;
        Window: Dialog;
        CountDay: Integer;
    begin
        if not Confirm('Are you sure to undo this CTO Realization?') then exit;

        Window.Open('Processing undo...please wait.');

        PostedCTOReqHeader.Reversed := true;
        PostedCTOReqHeader.Modify();

        CTOLedgerEntry.Reset();
        CTOLedgerEntry.SetRange("Document No.", PostedCTOReqHeader."No.");
        CTOLedgerEntry.SetRange("Entry Type", CTOLedgerEntry."Entry Type"::Negative);
        CTOLedgerEntry.SetRange("CTO Type", CTOLedgerEntry."CTO Type"::Realization);
        CTOLedgerEntry.SetRange(Reversed, false);
        if CTOLedgerEntry.FindFirst() then
            repeat
                for CountDay := 1 to -CTOLedgerEntry."Day Balance" do begin
                    CTOLedgerEntryTarget.LockTable();
                    CTOLedgerEntryTarget.Reset();
                    if CTOLedgerEntryTarget.FindLast() then
                        EntryNo := CTOLedgerEntryTarget."Entry No." + 1
                    else
                        EntryNo := 1;

                    CTOLedgerEntryTarget.Init();
                    CTOLedgerEntryTarget.TransferFields(CTOLedgerEntry);
                    CTOLedgerEntryTarget."Entry No." := EntryNo;
                    CTOLedgerEntryTarget."Entry Type" := CTOLedgerEntryTarget."Entry Type"::Positive;
                    CTOLedgerEntryTarget.Description := 'Reversal entry';
                    CTOLedgerEntryTarget."Day Balance" := 1;
                    CTOLedgerEntryTarget."Reversal Entry" := true;
                    CTOLedgerEntryTarget.Insert();

                    CTOLedgerEntry.Reversed := true;
                    CTOLedgerEntry."Reversed By Entry No." := EntryNo;
                end;
            until CTOLedgerEntry.Next() = 0;


        Window.Close();

        Message('Undo process done.');
    end;

    procedure getCTORequest(CTOReqHeader: Record "CTO Request Header")
    var
        CTOReqLine: Record "CTO Request Line";
        CTORealizHeader: Record "CTO Realization Header";
        CTORealizLine: Record "CTO Realization Line";
    begin
        CTORealizHeader.Init();
        CTORealizHeader.TransferFields(CTOReqHeader);
        CTORealizHeader.Status := CTORealizHeader.Status::Open;
        CTORealizHeader.Insert();

        CTOReqLine.Reset();
        CTOReqLine.SetRange("Document No.", CTOReqHeader."No.");
        CTOReqLine.FindSet();
        repeat
            CTORealizLine.Init();
            CTORealizLine.TransferFields(CTOReqLine);
            CTORealizLine."Starting Time Realization" := CTOReqLine."Starting Time";
            CTORealizLine."Ending Time Realization" := CTOReqLine."Ending Time";
            CTORealizLine."Duration Realization (Day)" := CTOReqLine."Duration (Day)";
            CTORealizLine."Duration Realization (Hour)" := CTOReqLine."Duration (Hour)";
            CTORealizLine."Duration Realization (Minute)" := CTOReqLine."Duration (Minute)";
            CTORealizLine.Insert();
        until CTOReqLine.Next() = 0;

        CTOReqHeader."CTO Realization Processing" := true;
        CTOReqHeader.Modify();
    end;


    procedure CTORequestCheckLine(CTOReqHeader: Record "CTO Request Header")
    var
        CTOReqLine: Record "CTO Request Line";
    begin
        CTOReqHeader.TestField("Document Date");
        CTOReqHeader.TestField("Employee No.");

        CTOReqLine.Reset();
        CTOReqLine.SetRange("Document No.", CTOReqHeader."No.");
        CTOReqLine.FindSet();
        repeat
            CTOReqLine.TestField("Work Description");
            CTOReqLine.TestField("Task Date");
            CTOReqLine.TestField("Starting Time");
            CTOReqLine.TestField("Ending Time");
        until CTOReqLine.Next() = 0;
    end;

    procedure hitungDurasi(startingTime: Time; endingTime: Time;
    var intJam: Integer; var intMenit: Integer)
    var
        Selisih: BigInteger;
    begin
        Selisih := endingTime - startingTime;

        intJam := Selisih div (60 * 60 * 1000);
        intMenit := (Selisih mod (60 * 60 * 1000)) div (60 * 1000);
    end;

    procedure undoPostedLeaveRequest(PostedLeave: Record "Posted Leave Request")
    var
        SourceLeaveLedger: Record "Leave Ledger Entry";
        TargetLeaveLedger: Record "Leave Ledger Entry";

        NoEntry: Integer;
        NoEntryEligible: Integer;

        LeaveLedgerGitu: Record "Leave Ledger Entry";
        EligibleLeaveLedgerGitu: Record "Leave Eligible Ledger Entry";

        SourceEligibleLeaveLedger: Record "Leave Eligible Ledger Entry";
        TargetEligibleLeaveLedger: Record "Leave Eligible Ledger Entry";
    begin
        PostedLeave.TestField(Reversed, false);

        if not confirm('Are you sure to undo this posted leave?') then exit;
        if PostedLeave."Leave Type" <> PostedLeave."Leave Type"::Unpaid then begin

            if PostedLeave."Paid Leave Type" <> PostedLeave."Paid Leave Type"::Sick then begin
                LeaveLedgerGitu.LockTable();
                LeaveLedgerGitu.Reset();
                if LeaveLedgerGitu.FindLast() then
                    NoEntry := LeaveLedgerGitu."Entry No." + 1
                else
                    NoEntry := 1;

                EligibleLeaveLedgerGitu.LockTable();
                EligibleLeaveLedgerGitu.Reset();
                if EligibleLeaveLedgerGitu.FindLast() then
                    NoEntryEligible := EligibleLeaveLedgerGitu."Entry No." + 1
                else
                    NoEntryEligible := 1;

                SourceLeaveLedger.Reset();
                SourceLeaveLedger.SetRange("Leave Type", PostedLeave."Leave Type");
                SourceLeaveLedger.SetRange("Document No.", PostedLeave."No.");
                SourceLeaveLedger.FindFirst();
                SourceLeaveLedger.Reversed := true;
                SourceLeaveLedger."Reversed by Entry No." := NoEntry;
                SourceLeaveLedger.Modify();

                TargetLeaveLedger.Init();
                TargetLeaveLedger.TransferFields(SourceLeaveLedger);
                TargetLeaveLedger."Entry No." := NoEntry;
                TargetLeaveLedger."Reverse Entry" := true;
                TargetLeaveLedger.Type := TargetLeaveLedger.Type::Positive;
                TargetLeaveLedger.Quantity := (SourceLeaveLedger.Quantity) * -1;
                TargetLeaveLedger.Description := 'Reverse transaction for ' + SourceLeaveLedger."Document No.";
                TargetLeaveLedger.Insert();


                SourceEligibleLeaveLedger.Reset();
                SourceEligibleLeaveLedger.SetRange("Leave Type", PostedLeave."Leave Type");
                SourceEligibleLeaveLedger.SetRange("Document No.", PostedLeave."No.");
                SourceEligibleLeaveLedger.FindFirst();
                SourceEligibleLeaveLedger.Reversed := true;
                SourceEligibleLeaveLedger."Reversed by Entry No." := NoEntryEligible;

                TargetEligibleLeaveLedger.Init();
                TargetEligibleLeaveLedger.TransferFields(SourceEligibleLeaveLedger);
                TargetEligibleLeaveLedger."Entry No." := NoEntryEligible;
                TargetEligibleLeaveLedger."Reverse Entry" := true;
                TargetEligibleLeaveLedger.Type := TargetEligibleLeaveLedger.Type::Positive;
                TargetEligibleLeaveLedger.Quantity := (SourceEligibleLeaveLedger.Quantity) * -1;
                TargetEligibleLeaveLedger.Description := 'Reverse transaction for ' + SourceEligibleLeaveLedger."Document No.";
                TargetEligibleLeaveLedger.Insert();
            end;
        end;


        PostedLeave.Reversed := true;
        PostedLeave.Modify();

        Message('Undo successfull for posted leave %1', PostedLeave."No.");
    end;

    procedure PostLeaveSlot(__Emp: Record Employee; Jatah: Decimal)
    var
        __LeaveReq: Record "Leave Request";
    begin
        if not confirm('Proceed with posting leave slot?') then exit;

        InsertLeaveLedgerEntry(__LeaveReq, false, __Emp."No.", Jatah);
        Message('Leave slot for %1 is successfully posted.', __Emp.FullName());
    end;

    procedure PostLeaveSlotEligible(EligiblePeriod: Date; Pegawai: Record Employee)
    begin
        if not confirm('Proceed with posting eligible leave slot?') then exit;
        InsertEligibleLeaveLedgerEntry(EligiblePeriod, Pegawai, false, '', false);
        Message('Eligible leave slot for %1 is successfully posted.', Pegawai.FullName());
    end;

    procedure PostLeaveRequest(LeaveRequest: Record "Leave Request")
    var
        PostedLeaveRequest: Record "Posted Leave Request";
        Kuli: Record Employee;
        isPaid: Boolean;
        isSick: Boolean;
    begin
        //if not confirm('Proceed with posting leave request?') then exit;

        Kuli.Get(LeaveRequest."Employee No.");

        if LeaveRequest."Leave Type" = LeaveRequest."Leave Type"::Paid then begin
            isPaid := true;
            if LeaveRequest."Paid Leave Type" = LeaveRequest."Paid Leave Type"::Sick then
                isSick := true
            else
                isSick := false;
        end else
            isPaid := false;

        if LeaveRequest."Leave Type" <> LeaveRequest."Leave Type"::"Other Attendance" then begin
            if isPaid and (not isSick) then begin
                InsertLeaveLedgerEntry(LeaveRequest, true, '', 0);
                InsertEligibleLeaveLedgerEntry(0D, Kuli, true, LeaveRequest."No.", isPaid);
            end;
        end;

        PostedLeaveRequest.Init();
        PostedLeaveRequest.TransferFields(LeaveRequest);
        PostedLeaveRequest.Insert();

        LeaveRequest.Delete();

        Message('Leave request is successfully posted.');
    end;

    procedure InsertEligibleLeaveLedgerEntry(Period: Date; Pegawai: Record Employee;
    isLeaveRequest: Boolean; DocNo: Code[20]; isPaid: Boolean)
    var
        LeaveEligibleLedgerEntry: Record "Leave Eligible Ledger Entry";
        LeaveEligibleLedgerEntry2: Record "Leave Eligible Ledger Entry";
        EntryNo: Integer;
        TahunEligible: Integer;
        BulanEligible: Integer;
        HariEligible: Integer;
        HiringInfoEntry: Record "Position Ledger Entry";
        LeaveLedgerEntry: Record "Leave Ledger Entry";
        LeaveRequest: Record "Leave Request";
        QuantityEligible: Decimal;

        TahunTanggalResign: Integer;
        BulanTanggalResign: Integer;
        TanggalResign: Integer;

        BulanMulaiContract: Integer;
        TahunMulaiContract: Integer;
        TanggalMulaiContract: Integer;

        BulanSelesaiContract: Integer;
        TahunSelesaiContract: Integer;
        TanggalSelesaiContract: Integer;
    begin
        HiringInfoEntry.Reset();
        HiringInfoEntry.SetRange("Employee No.", Pegawai."No.");
        HiringInfoEntry.FindLast();

        if Period <> 0D then begin
            HariEligible := Date2DMY(Period, 1);
            BulanEligible := Date2DMY(Period, 2);
            TahunEligible := Date2DMY(Period, 3);
        end;

        if not isLeaveRequest then begin
            LeaveLedgerEntry.Reset();
            LeaveLedgerEntry.SetRange("Employee No.", Pegawai."No.");
            LeaveLedgerEntry.SetRange(Type, LeaveLedgerEntry.Type::Positive);
            LeaveLedgerEntry.SetRange("Document No.", 'OBAL');
            LeaveLedgerEntry.SetFilter("Period Start", '<=%1', Period);
            LeaveLedgerEntry.SetFilter("Period End", '>=%1', Period);
            LeaveLedgerEntry.SetRange(Reversed, false);
            if not LeaveLedgerEntry.FindFirst() then
                Error('There is no leave slot opening balance that match with period %1\' +
                'for employee %2 - %3',
                format(Period, 0, '<Month Text> <Year4>'), Pegawai."No.", Pegawai.FullName());
        end;

        LeaveEligibleLedgerEntry2.LockTable();
        LeaveEligibleLedgerEntry2.Reset();
        if LeaveEligibleLedgerEntry2.FindLast() then
            EntryNo := LeaveEligibleLedgerEntry2."Entry No." + 1
        else
            EntryNo := 1;

        LeaveEligibleLedgerEntry.Init();
        LeaveEligibleLedgerEntry."Entry No." := EntryNo;
        LeaveEligibleLedgerEntry."Employee No." := Pegawai."No.";
        if isLeaveRequest then
            LeaveEligibleLedgerEntry."Leave Type" := LeaveEligibleLedgerEntry."Leave Type"::Paid;

        if not isLeaveRequest then begin
            LeaveEligibleLedgerEntry."Posting Date" := Today;
            LeaveEligibleLedgerEntry.Type := LeaveEligibleLedgerEntry.Type::Positive;

            if HiringInfoEntry."Resign Date" <> 0D then begin
                BulanTanggalResign := Date2DMY(HiringInfoEntry."Resign Date", 2);
                TahunTanggalResign := Date2DMY(HiringInfoEntry."Resign Date", 3);

                if (BulanTanggalResign = BulanEligible) and (TahunTanggalResign = TahunEligible) then begin
                    TanggalResign := Date2DMY(HiringInfoEntry."Resign Date", 1);
                    if TanggalResign <= 15 then
                        QuantityEligible := 0.625
                    else
                        QuantityEligible := 1.25;
                end else
                    QuantityEligible := 1.25;
            end else begin
                BulanMulaiContract := Date2DMY(HiringInfoEntry."Contract Start Date", 2);
                TahunMulaiContract := Date2DMY(HiringInfoEntry."Contract Start Date", 3);

                BulanSelesaiContract := Date2DMY(HiringInfoEntry."Contract End Date", 2);
                TahunSelesaiContract := Date2DMY(HiringInfoEntry."Contract End Date", 3);

                //ini bagian awal contract
                if (BulanMulaiContract = BulanEligible) and (TahunMulaiContract = TahunEligible) then begin
                    TanggalMulaiContract := Date2DMY(HiringInfoEntry."Contract Start Date", 1);
                    if TanggalMulaiContract <= 15 then
                        QuantityEligible := 1.25
                    else
                        QuantityEligible := 0.625;
                end else
                    //ini bagian akhir contract
                    if (BulanSelesaiContract = BulanEligible) and
                        (TahunSelesaiContract = TahunEligible) then begin
                        TanggalSelesaiContract := Date2DMY(HiringInfoEntry."Contract End Date", 1);
                        if TanggalSelesaiContract <= 15 then
                            QuantityEligible := 0.625
                        else
                            QuantityEligible := 1.25;
                    end
                    else //ini bagian tengah2 contract
                        QuantityEligible := 1.25;


            end;


            LeaveEligibleLedgerEntry.Quantity := QuantityEligible;
            LeaveEligibleLedgerEntry."Month Eligible" := BulanEligible;
            LeaveEligibleLedgerEntry."Year Eligible" := TahunEligible;
            LeaveEligibleLedgerEntry."Document No." := 'ELIGIBLE';
            LeaveEligibleLedgerEntry.Description := 'Eligible Leave Slot for ' + format(BulanEligible) +
            ' ' + Format(TahunEligible);
            LeaveEligibleLedgerEntry."Hiring Information Entry No." := HiringInfoEntry."Entry No.";
        end else begin
            LeaveRequest.Reset();
            if isPaid then
                LeaveRequest.SetRange("Leave Type", LeaveRequest."Leave Type"::Paid)
            else
                LeaveRequest.SetRange("Leave Type", LeaveRequest."Leave Type"::Unpaid);
            LeaveRequest.SetRange("No.", DocNo);
            LeaveRequest.FindFirst();

            LeaveEligibleLedgerEntry."Posting Date" := LeaveRequest."Posting Date";
            LeaveEligibleLedgerEntry.Type := LeaveEligibleLedgerEntry.Type::Negative;
            LeaveEligibleLedgerEntry.Description := 'Leave request for ' + LeaveRequest."Employee Name";
            LeaveEligibleLedgerEntry."Document No." := LeaveRequest."No.";
            LeaveEligibleLedgerEntry.Quantity := -LeaveRequest."Total Number of Days";
            LeaveEligibleLedgerEntry."Paid Leave Type" := LeaveRequest."Paid Leave Type";
            LeaveEligibleLedgerEntry."Unpaid Leave Type" := LeaveRequest."Unpaid Leave Type";
            LeaveEligibleLedgerEntry."Starting Date" := LeaveRequest."Starting Date";
            LeaveEligibleLedgerEntry."Ending Date" := LeaveRequest."Ending Date";
            LeaveEligibleLedgerEntry."Employee No. Replacement" := LeaveRequest."Employee No. Replacement";
        end;


        LeaveEligibleLedgerEntry.Insert();

    end;

    procedure InsertLeaveLedgerEntry(__LeaveRequest: Record "Leave Request";
    isLeaveReq: Boolean; __EmpNo: Code[20]; JatahCutiTahunan: Decimal)
    var
        LeaveLedgerEntry: Record "Leave Ledger Entry";
        LeaveLedgerEntry2: Record "Leave Ledger Entry";
        Employee: Record Employee;
        EntryNo: Integer;
        EmpNoInsert: Code[20];
        PostingDate: Date;
        LeaveLedgerType: Option Negative,Positive;
        LeaveLedgerDesc: Text[100];
        LeaveLedgerDocNo: Code[20];
        LeaveQty: Decimal;
        DimCode1: Code[10];
        LeaveType: Option ,Paid,Unpaid;
        PaidLeaveType: Option ,Annual,Sick,CTO,Other;
        UnpaidLeaveType: Option ,"Leave Without Pay","Absence Without Pay";
        HiringInfoEntry: Record "Position Ledger Entry";
        NomorEmployee: Code[20];
        YearPeriod: Integer;
        AddModifyContract: Page "Add-Modify Contract";
        CountedMonth: Integer;
        MaxTimesOfAccrual: Integer;
        MaxDisburtion: Integer;
    begin
        if isLeaveReq then
            NomorEmployee := __LeaveRequest."Employee No."
        else
            NomorEmployee := __EmpNo;

        YearPeriod := Date2DMY(Today, 3);

        HiringInfoEntry.Reset();
        HiringInfoEntry.SetRange("Employee No.", NomorEmployee);
        HiringInfoEntry.FindLast();

        LeaveLedgerEntry2.LockTable();
        LeaveLedgerEntry2.Reset();
        if LeaveLedgerEntry2.FindLast() then
            EntryNo := LeaveLedgerEntry2."Entry No." + 1
        else
            EntryNo := 1;


        if isLeaveReq then begin
            Employee.Get(__LeaveRequest."Employee No.");
            EmpNoInsert := __LeaveRequest."Employee No.";
            PostingDate := __LeaveRequest."Posting Date";
            LeaveLedgerType := LeaveLedgerType::Negative;
            LeaveLedgerDesc := 'Leave request for ';
            LeaveQty := -__LeaveRequest."Total Number of Days";
            DimCode1 := __LeaveRequest."Global Dimension 1 Code";
            LeaveLedgerDocNo := __LeaveRequest."No.";
            LeaveType := __LeaveRequest."Leave Type";
            PaidLeaveType := __LeaveRequest."Paid Leave Type";
            UnpaidLeaveType := __LeaveRequest."Unpaid Leave Type";
            LeaveLedgerType := LeaveLedgerType::Negative;
        end else begin
            Employee.Get(__EmpNo);
            EmpNoInsert := __EmpNo;
            PostingDate := Today;
            LeaveLedgerType := LeaveLedgerType::Positive;
            LeaveLedgerDesc := 'OBAL Leave slot for ';
            LeaveQty := JatahCutiTahunan;
            //DimCode1 := blom jelas ini kalo leave slot pake dimension apa
            LeaveType := LeaveType::Paid;
            PaidLeaveType := PaidLeaveType::Annual;
            LeaveLedgerDocNo := 'OBAL';
        end;

        LeaveLedgerDesc := LeaveLedgerDesc + Employee.FullName();

        LeaveLedgerEntry.Init();
        LeaveLedgerEntry."Entry No." := EntryNo;
        LeaveLedgerEntry."Employee No." := EmpNoInsert;
        LeaveLedgerEntry."Posting Date" := PostingDate;
        LeaveLedgerEntry.Type := LeaveLedgerType;

        LeaveLedgerEntry.Description := LeaveLedgerDesc;
        LeaveLedgerEntry.Quantity := LeaveQty;

        LeaveLedgerEntry."Global Dimension 1 Code" := DimCode1;
        LeaveLedgerEntry."Document No." := LeaveLedgerDocNo;

        LeaveLedgerEntry."Leave Type" := LeaveType;

        LeaveLedgerEntry."Paid Leave Type" := PaidLeaveType;
        LeaveLedgerEntry."Unpaid Leave Type" := UnpaidLeaveType;

        LeaveLedgerEntry."Starting Date" := __LeaveRequest."Starting Date";
        LeaveLedgerEntry."Ending Date" := __LeaveRequest."Ending Date";
        LeaveLedgerEntry."Employee No. Replacement" := __LeaveRequest."Employee No. Replacement";
        LeaveLedgerEntry."Hiring Information Entry No." := HiringInfoEntry."Entry No.";
        LeaveLedgerEntry."Year Period" := YearPeriod;

        if not isLeaveReq then begin
            LeaveLedgerEntry."Period Start" := HiringInfoEntry."Contract Start Date";
            LeaveLedgerEntry."Period End" := HiringInfoEntry."Contract End Date";

            //bagian untuk menghitung dan menginput data maksimum leave accrual
            AddModifyContract.CountMonth(HiringInfoEntry."Contract Start Date",
            HiringInfoEntry."Contract End Date", CountedMonth);

            /*
            MaxTimesOfAccrual := 0;
            MaxDisburtion := 0;

            if (CountedMonth >= 4) and (CountedMonth <= 23) then begin
                MaxTimesOfAccrual := 4;
                MaxDisburtion := 5;
            end else
                if (CountedMonth >= 24) and (CountedMonth <= 35) then begin
                    MaxTimesOfAccrual := 8;
                    MaxDisburtion := 10;
                end else
                    if CountedMonth >= 36 then begin
                        MaxTimesOfAccrual := 12;
                        MaxDisburtion := 15;
                    end;
            */

            //LeaveLedgerEntry."Maximum Times of Accrual" := MaxTimesOfAccrual;
            //LeaveLedgerEntry."Maximum Leave Disburtion" := MaxDisburtion;

            LeaveLedgerEntry."Maximum Times of Accrual" := 4;
            LeaveLedgerEntry."Maximum Leave Disburtion" := 5;
        end;

        LeaveLedgerEntry.Insert();
    end;

    procedure UndoLeaveLedgerEntry(SourceLeaveLedgerEntry: Record "Leave Ledger Entry")
    var
        EntryNo: Integer;
        TargetLeaveLedgerEntry: Record "Leave Ledger Entry";
    begin
        if not confirm('Are you sure to undo this leave balance record?') then exit;

        TargetLeaveLedgerEntry.LockTable();
        TargetLeaveLedgerEntry.Reset();
        if TargetLeaveLedgerEntry.FindLast() then
            EntryNo := TargetLeaveLedgerEntry."Entry No." + 1
        else
            EntryNo := 1;


        TargetLeaveLedgerEntry.Init();
        TargetLeaveLedgerEntry.TransferFields(SourceLeaveLedgerEntry);
        TargetLeaveLedgerEntry."Entry No." := EntryNo;
        TargetLeaveLedgerEntry.Type := TargetLeaveLedgerEntry.Type::Negative;
        TargetLeaveLedgerEntry."Reverse Entry" := true;
        TargetLeaveLedgerEntry.Description := 'Reverse Entry';
        TargetLeaveLedgerEntry.Quantity := -SourceLeaveLedgerEntry.Quantity;
        TargetLeaveLedgerEntry.Insert();


        SourceLeaveLedgerEntry.Reversed := true;
        SourceLeaveLedgerEntry."Reversed by Entry No." := EntryNo;
        SourceLeaveLedgerEntry.Modify();


        Message('Successfully undo the leave balance record.');
    end;


    procedure UndoEligibleLeaveLedgerEntry(SourceEligibleLeaveLedgerEntry: Record "Leave Eligible Ledger Entry")
    var
        EntryNo: Integer;
        TargetEligibleLeaveLedgerEntry: Record "Leave Eligible Ledger Entry";
    begin
        if not confirm('Are you sure to undo this eligible leave balance record?') then exit;

        TargetEligibleLeaveLedgerEntry.LockTable();
        TargetEligibleLeaveLedgerEntry.Reset();
        if TargetEligibleLeaveLedgerEntry.FindLast() then
            EntryNo := TargetEligibleLeaveLedgerEntry."Entry No." + 1
        else
            EntryNo := 1;


        TargetEligibleLeaveLedgerEntry.Init();
        TargetEligibleLeaveLedgerEntry.TransferFields(SourceEligibleLeaveLedgerEntry);
        TargetEligibleLeaveLedgerEntry."Entry No." := EntryNo;
        TargetEligibleLeaveLedgerEntry.Type := TargetEligibleLeaveLedgerEntry.Type::Negative;
        TargetEligibleLeaveLedgerEntry."Reverse Entry" := true;
        TargetEligibleLeaveLedgerEntry.Description := 'Reverse Entry';
        TargetEligibleLeaveLedgerEntry.Quantity := -SourceEligibleLeaveLedgerEntry.Quantity;
        TargetEligibleLeaveLedgerEntry.Insert();


        SourceEligibleLeaveLedgerEntry.Reversed := true;
        SourceEligibleLeaveLedgerEntry."Reversed by Entry No." := EntryNo;
        SourceEligibleLeaveLedgerEntry.Modify();


        Message('Successfully undo the eligible leave balance record.');
    end;
}