codeunit 60013 "Accrual Management"
{
    procedure AmbilHangusUntukReverse(NoPegawai: Code[20]; Opsi: Option Severance,THR,Leave;
    YangDicairkan: Decimal; var Sisa: Decimal; DocNo: Code[20])
    var
        THRAccrualLedgerEntry: Record "THR Accrual Ledger Entry";
        LeaveAccrualLedgerEntry: Record "Sisa Cuti Accrual Ledger Entry";
        Employee: Record Employee;
        DuitExisting: Decimal;
        EntryNo: Integer;
        ChargingHeader: Record "Employee Charging Header";
        TanggalPosting: Date;
        TanggalPostingCharging: Date;
        BulanAkhirContract: Integer;
        TahunAkhirContract: Integer;
        BulanCharging: Integer;
        TahunCharging: Integer;
        Expiring: Boolean;
        ContractBerakhir: Record "Position Ledger Entry";
        //    BulanNggaDiperpanjang: Integer;
        //    TahunNggaDiperpanjang: Integer;
        NggaDiperpanjang: Boolean;
        SisaYgDirecord: Decimal;
        EmployeeSisaCuti: Record Employee;
        HabisSisaCuti: Boolean;
        CutiTidakDicairkan: Boolean;
        LeaveAccrual: Record "Sisa Cuti Accrual Ledger Entry";
        Perpanjang: Boolean;
    begin
        Clear(BulanAkhirContract);
        Clear(TahunAkhirContract);
        Clear(BulanCharging);
        Clear(TahunCharging);
        Clear(SisaYgDirecord);
        //    Clear(BulanNggaDiperpanjang);
        //    Clear(TahunNggaDiperpanjang);

        NggaDiperpanjang := false;
        Expiring := false;
        HabisSisaCuti := false;
        CutiTidakDicairkan := false;

        Employee.Get(NoPegawai);

        ChargingHeader.Get(DocNo);
        TanggalPosting := ChargingHeader."Posting Date";
        TanggalPostingCharging := ChargingHeader."Posting Date Charging";

        Contract.Reset();
        Contract.SetCurrentKey("Contract End Date");
        Contract.SetRange("Employee No.", NoPegawai);
        Contract.SetFilter("Contract Start Date", '<=%1', TanggalPostingCharging);
        Contract.SetFilter("Contract End Date", '>=%1', TanggalPostingCharging);
        Contract.FindFirst();
        BulanAkhirContract := Date2DMY(Contract."Contract End Date", 2);
        TahunAkhirContract := Date2DMY(Contract."Contract End Date", 3);


        if Opsi = Opsi::Leave then begin
            EmployeeSisaCuti.Get(NoPegawai);
            EmployeeSisaCuti.CalcFields("MSI_HRIS Leave Balance");
            if EmployeeSisaCuti."MSI_HRIS Leave Balance" = 0 then
                HabisSisaCuti := true;

            LeaveAccrual.Reset();
            LeaveAccrual.SetRange("Employee No.", NoPegawai);
            LeaveAccrual.SetRange("Payroll Date", Contract."Contract Start Date",
            Contract."Contract End Date");
            LeaveAccrual.SetRange("Entry Type", LeaveAccrual."Entry Type"::Negative);
            LeaveAccrual.SetFilter(Description, '*Disbursement*');
            if not LeaveAccrual.FindFirst() then
                CutiTidakDicairkan := true;
        end;

        //ContractBerakhir.Reset();
        //ContractBerakhir.SetRange("Employee No.", NoPegawai);
        //ContractBerakhir.FindLast();
        //    BulanNggaDiperpanjang := Date2DMY(ContractBerakhir."Contract End Date", 2);
        //    TahunNggaDiperpanjang := Date2DMY(ContractBerakhir."Contract End Date", 3);


        //    if (BulanAkhirContract = BulanNggaDiperpanjang) and (TahunAkhirContract = TahunNggaDiperpanjang) then
        //        NggaDiperpanjang := true;
        NggaDiperpanjang := not Employeediperpanjang(Employee, TanggalPostingCharging, Perpanjang);

        BulanCharging := Date2DMY(TanggalPostingCharging, 2);
        TahunCharging := Date2DMY(TanggalPostingCharging, 3);

        if (TahunAkhirContract = TahunCharging) and (BulanAkhirContract = BulanCharging) then
            Expiring := true;
        ContractBerakhir.Reset();
        ContractBerakhir.SetRange("Employee No.", NoPegawai);
        ContractBerakhir.SetRange("Contract End Date", CalcDate('-CM', TanggalPostingCharging), CalcDate('+CM', TanggalPostingCharging));
        if ContractBerakhir.FindFirst() then
            Expiring := true;
        Employee.SetRange("Date Filter", Contract."Contract Start Date", Contract."Contract End Date");

        if Expiring or (Contract."Resign Date" <> 0D) then
            case Opsi of
                Opsi::Leave:
                    begin
                        if Expiring or (HabisSisaCuti and CutiTidakDicairkan) or
                           (Contract."Resign Date" <> 0D) then begin

                            Employee.CalcFields("Cuti Dibayar Accrual");
                            DuitExisting := Employee."Cuti Dibayar Accrual";

                            if DuitExisting > 0 then begin

                                Sisa := DuitExisting;

                                //if (NoPegawai = 'E0055') or (NoPegawai = 'E0070') then
                                //Message('Sisa = %1 Peg=%2', Sisa, NoPegawai);

                                LeaveAccrualLedgerEntry.LockTable();
                                LeaveAccrualLedgerEntry.Reset();
                                if LeaveAccrualLedgerEntry.FindLast() then
                                    EntryNo := LeaveAccrualLedgerEntry."Entry No." + 1
                                else
                                    EntryNo := 1;

                                if Sisa > 0 then
                                    SisaYgDirecord := Sisa * -1
                                else begin
                                    SisaYgDirecord := Sisa;
                                    Sisa := Sisa * -1;
                                end;

                                LeaveAccrualLedgerEntry.Init();
                                LeaveAccrualLedgerEntry."Entry No." := EntryNo;
                                LeaveAccrualLedgerEntry."Document No." := DocNo;
                                LeaveAccrualLedgerEntry."Employee No." := NoPegawai;
                                LeaveAccrualLedgerEntry."Payroll Date" := TanggalPosting;
                                LeaveAccrualLedgerEntry."Accrual Amount" := SisaYgDirecord;
                                LeaveAccrualLedgerEntry.Description := 'Sisa cuti hangus ';
                                LeaveAccrualLedgerEntry."Period Start" := Contract."Contract Start Date";
                                LeaveAccrualLedgerEntry."Period End" := Contract."Contract End Date";
                                LeaveAccrualLedgerEntry."Entry Type" := LeaveAccrualLedgerEntry."Entry Type"::Negative;
                                //LeaveAccrualLedgerEntry.Quantity := -Qty;
                                LeaveAccrualLedgerEntry."Hangus Reversed" := true;
                                LeaveAccrualLedgerEntry.Insert();
                            end;
                        end;
                    end;
                Opsi::Severance:
                    begin
                        if (Contract."Resign Date" <> 0D) or NggaDiperpanjang then begin

                            Employee.CalcFields("MSI_HRIS Total Severance Accr.");
                            DuitExisting := Employee."MSI_HRIS Total Severance Accr.";


                            if (YangDicairkan <> 0) or (DuitExisting > 0) then begin

                                if DuitExisting > YangDicairkan then
                                    Sisa := DuitExisting - YangDicairkan
                                else
                                    Sisa := DuitExisting;

                                SeveranceAccruaLedgerEntry.LockTable();
                                SeveranceAccruaLedgerEntry.Reset();
                                if SeveranceAccruaLedgerEntry.FindLast() then
                                    EntryNo := SeveranceAccruaLedgerEntry."Entry No." + 1
                                else
                                    EntryNo := 1;

                                if Sisa > 0 then
                                    SisaYgDirecord := Sisa * -1
                                else begin
                                    SisaYgDirecord := Sisa;
                                    Sisa := Sisa * -1;
                                end;


                                SeveranceAccruaLedgerEntry.Init();
                                SeveranceAccruaLedgerEntry."Entry No." := EntryNo;
                                SeveranceAccruaLedgerEntry."Document No." := DocNo;
                                SeveranceAccruaLedgerEntry."Employee No." := NoPegawai;
                                SeveranceAccruaLedgerEntry."Payroll Date" := TanggalPosting;
                                SeveranceAccruaLedgerEntry."Entry Type" := SeveranceAccruaLedgerEntry."Entry Type"::Negative;
                                SeveranceAccruaLedgerEntry."Accrual Amount" := SisaYgDirecord;
                                SeveranceAccruaLedgerEntry.Description := 'Sisa Uang Pisah Hangus';
                                SeveranceAccruaLedgerEntry."Hangus Reversed" := true;
                                SeveranceAccruaLedgerEntry.Insert();

                                //if NoPegawai = 'E0009' then
                                //Message('Sisa = %1', Sisa);
                            end;
                        end;
                    end;
                Opsi::THR:
                    begin
                        if (Contract."Resign Date" <> 0D) or NggaDiperpanjang then begin

                            Employee.CalcFields("MSI_HRIS THR Accrual");
                            DuitExisting := Employee."MSI_HRIS THR Accrual";

                            if (YangDicairkan <> 0) or (DuitExisting > 0) then begin

                                if DuitExisting > YangDicairkan then
                                    Sisa := DuitExisting - YangDicairkan
                                else
                                    Sisa := DuitExisting;

                                THRAccrualLedgerEntry.LockTable();
                                THRAccrualLedgerEntry.Reset();
                                if THRAccrualLedgerEntry.FindLast() then
                                    EntryNo := THRAccrualLedgerEntry."Entry No." + 1
                                else
                                    EntryNo := 1;

                                if Sisa > 0 then
                                    SisaYgDirecord := Sisa * -1
                                else begin
                                    SisaYgDirecord := Sisa;
                                    Sisa := Sisa * -1;
                                end;

                                THRAccrualLedgerEntry.Init();
                                THRAccrualLedgerEntry."Entry No." := EntryNo;
                                THRAccrualLedgerEntry."Employee No." := NoPegawai;
                                THRAccrualLedgerEntry."Document No." := DocNo;
                                THRAccrualLedgerEntry."Payroll Date" := TanggalPosting;
                                THRAccrualLedgerEntry."Accrual Amount" := SisaYgDirecord;
                                THRAccrualLedgerEntry."Entry Type" := THRAccrualLedgerEntry."Entry Type"::Negative;
                                THRAccrualLedgerEntry.Description := 'Sisa THR Hangus';
                                THRAccrualLedgerEntry."Hangus Reversed" := true;
                                THRAccrualLedgerEntry."Charging Processed" := true;
                                THRAccrualLedgerEntry.Insert();
                            end;
                        end;
                    end;
            end;
    end;



    procedure PencairanLeaveAccrual(Kuli: Record Employee; PostingDate: Date;
    DuitCair: Decimal; Qty: Decimal; DocNo: Code[20]; isAdaSisaHangus: Boolean; Hangus: Decimal;
    GPDocNo: Code[20]; ActualPaymentDate: Date)
    var
        EntryNo: Integer;
        LeaveLedgerEntry: Record "Leave Ledger Entry";
        EntryNo2: Integer;
        EligibleLeaveLedgerEntry: Record "Leave Eligible Ledger Entry";
        EligibleEntryNo: Integer;
    begin
        Contract.Reset();
        Contract.SetRange("Employee No.", Kuli."No.");
        Contract.FindLast();

        LeaveAccrualLedgerEntry.LockTable();
        LeaveAccrualLedgerEntry.Reset();
        if LeaveAccrualLedgerEntry.FindLast() then
            EntryNo := LeaveAccrualLedgerEntry."Entry No." + 1
        else
            EntryNo := 1;

        LeaveAccrualLedgerEntry.Init();
        LeaveAccrualLedgerEntry."Entry No." := EntryNo;
        LeaveAccrualLedgerEntry."Document No." := DocNo;
        LeaveAccrualLedgerEntry."Employee No." := Kuli."No.";
        LeaveAccrualLedgerEntry."Payroll Date" := PostingDate;
        LeaveAccrualLedgerEntry."Accrual Amount" := -DuitCair;
        LeaveAccrualLedgerEntry.Description := 'Disbursement for ' + Format(PostingDate, 0, '<Day> <Month Text> <Year>');
        LeaveAccrualLedgerEntry."Period Start" := Contract."Contract Start Date";
        LeaveAccrualLedgerEntry."Period End" := Contract."Contract End Date";
        LeaveAccrualLedgerEntry."Entry Type" := LeaveAccrualLedgerEntry."Entry Type"::Negative;
        LeaveAccrualLedgerEntry.Quantity := -Qty;
        LeaveAccrualLedgerEntry."Payment Delayed" := true;
        LeaveAccrualLedgerEntry."Actual Payment Date" := ActualPaymentDate;
        LeaveAccrualLedgerEntry."GP No." := GPDocNo;
        LeaveAccrualLedgerEntry.Insert();
        //        Message('tes insert sisa cuti accrual entry no %1', LeaveAccrualLedgerEntry."Entry No.");
        LeaveLedgerEntry.LockTable();
        LeaveLedgerEntry.Reset();
        if LeaveLedgerEntry.FindLast() then
            EntryNo2 := LeaveLedgerEntry."Entry No." + 1
        else
            EntryNo2 := 1;

        EligibleLeaveLedgerEntry.LockTable();
        EligibleLeaveLedgerEntry.Reset();
        if EligibleLeaveLedgerEntry.FindLast() then
            EligibleEntryNo := EligibleLeaveLedgerEntry."Entry No." + 1
        else
            EligibleEntryNo := 1;

        LeaveLedgerEntry.Init();
        LeaveLedgerEntry."Entry No." := EntryNo2;
        LeaveLedgerEntry."Employee No." := Kuli."No.";
        LeaveLedgerEntry.Type := LeaveLedgerEntry.Type::Negative;
        LeaveLedgerEntry.Quantity := -Qty;
        LeaveLedgerEntry."Posting Date" := PostingDate;
        LeaveLedgerEntry.Description := 'Annual leave disbursement';
        LeaveLedgerEntry."Document No." := DocNo;
        LeaveLedgerEntry.Insert();

        EligibleLeaveLedgerEntry.Init();
        EligibleLeaveLedgerEntry."Entry No." := EligibleEntryNo;
        EligibleLeaveLedgerEntry."Employee No." := Kuli."No.";
        EligibleLeaveLedgerEntry.Type := EligibleLeaveLedgerEntry.Type::Negative;
        EligibleLeaveLedgerEntry.Quantity := -Qty;
        EligibleLeaveLedgerEntry."Posting Date" := PostingDate;
        EligibleLeaveLedgerEntry.Description := 'Annual leave disbursement';
        EligibleLeaveLedgerEntry."Document No." := DocNo;
        EligibleLeaveLedgerEntry.Insert();

        if isAdaSisaHangus then begin
            EntryNo2 := EntryNo2 + 1;
            LeaveLedgerEntry.Init();
            LeaveLedgerEntry."Entry No." := EntryNo2;
            LeaveLedgerEntry."Employee No." := Kuli."No.";
            LeaveLedgerEntry.Type := LeaveLedgerEntry.Type::Negative;
            LeaveLedgerEntry.Quantity := -Hangus;
            LeaveLedgerEntry."Posting Date" := PostingDate;
            LeaveLedgerEntry.Description := 'Cuti hangus';
            LeaveLedgerEntry."Document No." := DocNo;
            LeaveLedgerEntry.Insert();

            EligibleEntryNo := EligibleEntryNo + 1;
            EligibleLeaveLedgerEntry.Init();
            EligibleLeaveLedgerEntry."Entry No." := EligibleEntryNo;
            EligibleLeaveLedgerEntry."Employee No." := Kuli."No.";
            EligibleLeaveLedgerEntry.Type := EligibleLeaveLedgerEntry.Type::Negative;
            EligibleLeaveLedgerEntry.Quantity := -Hangus;
            EligibleLeaveLedgerEntry."Posting Date" := PostingDate;
            EligibleLeaveLedgerEntry.Description := 'Cuti hangus';
            EligibleLeaveLedgerEntry."Document No." := DocNo;
            EligibleLeaveLedgerEntry.Insert();
        end;
    end;

    procedure PencairanSeveranceAccrual(Kuli: Record Employee; PostingDate: Date;
    DuitCair: Decimal; SevLedgerEntryNo: Integer)
    var
        AdvanceHeader: Record "Advance Header";
        AdvanceHeader2: Record "Advance Header";
        EmployeeDREE: Record Employee;
        _GenJnlBatch: Record "Gen. Journal Batch";
        AdvancePostDRE: Codeunit "Advance-Post";
        GenJnlLine: Record "Gen. Journal Line";
        CabutDariKantor: Boolean;
        Selisih: Decimal;
    begin
        CabutDariKantor := false;
        Selisih := 0;

        PayrollSetup.Get();
        PayrollSetup.TestField("Salary Expense Acc. No.");
        PayrollSetup.TestField("Sevr. Income Acc. No.");

        Contract.Reset();
        Contract.SetRange("Employee No.", Kuli."No.");
        Contract.FindLast();
        if Contract."Resign Date" <> 0D then
            if Contract."Resign Date" <= today then begin
                CabutDariKantor := true;
                Kuli.CalcFields("MSI_HRIS Total Severance Accr.");
                if Kuli."MSI_HRIS Total Severance Accr." > DuitCair then
                    Selisih := Kuli."MSI_HRIS Total Severance Accr." - DuitCair;
            end;

        SeveranceAccruaLedgerEntry.LockTable();
        SeveranceAccruaLedgerEntry.Reset();
        if SeveranceAccruaLedgerEntry.FindLast() then
            EntryNo := SeveranceAccruaLedgerEntry."Entry No." + 1
        else
            EntryNo := 1;

        SeveranceAccruaLedgerEntry.Init();
        SeveranceAccruaLedgerEntry."Entry No." := EntryNo;
        SeveranceAccruaLedgerEntry."Entry Type" := SeveranceAccruaLedgerEntry."Entry Type"::Negative;
        SeveranceAccruaLedgerEntry."Employee No." := Kuli."No.";
        SeveranceAccruaLedgerEntry."Disbursement Date" := PostingDate;
        SeveranceAccruaLedgerEntry."Accrual Amount" := -DuitCair;
        SeveranceAccruaLedgerEntry.Description := 'Disbursement for ' + Kuli.FullName();
        SeveranceAccruaLedgerEntry.Insert();


        EmployeeDREE.Reset();
        EmployeeDREE.SetRange("User ID", UserId);
        EmployeeDREE.FindFirst();

        //Create General Payment
        AdvanceHeader.Init();
        AdvanceHeader.Validate("Document Type", AdvanceHeader."Document Type"::"General Payment");
        AdvanceHeader.Validate("No.", '');
        AdvanceHeader."Employee No." := EmployeeDREE."No.";
        AdvanceHeader.validate("Shortcut Dimension 1 Code", EmployeeDREE."MSI_HRIS Shortcut Dim Code");
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
        AdvanceHeader2."Journal Description" := 'Severance GP for ' + Kuli.FullName();
        AdvanceHeader2.Validate("Posting Date", PostingDate);
        AdvanceHeader2.Modify();


        GenJnlLine.Init();
        GenJnlLine.Validate("Journal Template Name", AdvanceHeader2."Journal Template Name");
        GenJnlLine.validate("Journal Batch Name", AdvanceHeader2."Journal Batch Name");
        GenJnlLine.Validate("Line No.", 10000);
        GenJnlLine.Validate("Document No.", AdvanceHeader."No.");
        GenJnlLine.Validate("Posting Date", PostingDate);
        GenJnlLine.Validate(Amount, DuitCair);
        GenJnlLine.Validate("Global Dimension 1 Code", PayrollSetup."Global Dimension 1 Code");
        GenJnlLine.Validate("Global Dimension 2 Code", PayrollSetup."Global Dimension 2 Code");
        GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
        GenJnlLine.Validate("Account No. 2", PayrollSetup."Salary Expense Acc. No.");
        GenJnlLine."Severance Ledger Entry No." := SevLedgerEntryNo;
        GenJnlLine.Insert(true);

        if CabutDariKantor and (Kuli."MSI_HRIS Total Severance Accr." > DuitCair) then begin
            GenJnlLine.Init();
            GenJnlLine.Validate("Journal Template Name", AdvanceHeader2."Journal Template Name");
            GenJnlLine.validate("Journal Batch Name", AdvanceHeader2."Journal Batch Name");
            GenJnlLine.Validate("Line No.", 20000);
            GenJnlLine.Validate("Document No.", AdvanceHeader."No.");
            GenJnlLine.Validate("Posting Date", PostingDate);
            GenJnlLine.Validate(Amount, -Selisih);
            GenJnlLine.Validate("Global Dimension 1 Code", PayrollSetup."Global Dimension 1 Code");
            GenJnlLine.Validate("Global Dimension 2 Code", PayrollSetup."Global Dimension 2 Code");
            GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
            GenJnlLine.Validate("Account No. 2", PayrollSetup."Sevr. Income Acc. No.");
            GenJnlLine.Insert(true);
        end;

    end;

    procedure PencadanganLeave(Pegawai: Record Employee; PostingDate: Date;
    Amount: Decimal; PayrollLedgerEntryNo: Integer; DocNo: Code[20])
    var
        LeaveAccrualLedgerEntry: Record "Sisa Cuti Accrual Ledger Entry";
        EntryNo: Integer;
        Maxnya: Integer;
        JumlahYangAda: Integer;
    begin
        Contract.Reset();
        Contract.SetRange("Employee No.", Pegawai."No.");
        Contract.FindLast();

        LeaveAccrualLedgerEntry.LockTable();
        LeaveAccrualLedgerEntry.Reset();
        if LeaveAccrualLedgerEntry.FindLast() then
            EntryNo := LeaveAccrualLedgerEntry."Entry No." + 1
        else
            EntryNo := 1;

        AmbilMaxAccrual(Pegawai."No.", PostingDate, Maxnya);
        JumlahAccrual(Pegawai, PostingDate, JumlahYangAda);

        if JumlahYangAda < Maxnya then begin
            LeaveAccrualLedgerEntry.Init();
            LeaveAccrualLedgerEntry."Entry No." := EntryNo;
            LeaveAccrualLedgerEntry."Employee No." := Pegawai."No.";
            LeaveAccrualLedgerEntry."Document No." := DocNo;
            LeaveAccrualLedgerEntry."Payroll Date" := PostingDate;
            LeaveAccrualLedgerEntry."Accrual Amount" := Amount;
            LeaveAccrualLedgerEntry."Payroll Ledger Entry No." := PayrollLedgerEntryNo;
            LeaveAccrualLedgerEntry.Description := 'Accrual for ' + Format(PostingDate, 0, '<Day> <Month Text> <Year>');
            LeaveAccrualLedgerEntry."Period Start" := Contract."Contract Start Date";
            LeaveAccrualLedgerEntry."Period End" := Contract."Contract End Date";
            LeaveAccrualLedgerEntry."Entry Type" := LeaveAccrualLedgerEntry."Entry Type"::Positive;
            LeaveAccrualLedgerEntry.Quantity := 1.25;
            LeaveAccrualLedgerEntry.Insert();
        end;
    end;

    procedure Employeediperpanjang(Pegawai: Record Employee; PostingDate: Date; var diperpanjang: Boolean): Boolean
    var
        kontrak: Record "Position Ledger Entry";
        tgl: Date;
    begin
        diperpanjang := false;
        kontrak.SetRange("Employee No.", Pegawai."No.");
        kontrak.SetRange("Contract End Date", CalcDate('-CM', PostingDate), CalcDate('+1M', PostingDate));
        if kontrak.FindFirst() then begin
            tgl := kontrak."Contract End Date";
            kontrak.SetRange("Contract End Date");
            kontrak.SetRange("Contract Start Date", CalcDate('+1D', tgl));
            if kontrak.FindFirst() then
                diperpanjang := true;
        end;
        exit(diperpanjang)
    end;

    procedure PencadanganLeavePerpanjang(Pegawai: Record Employee; PostingDate: Date;
    Amount: Decimal; PayrollLedgerEntryNo: Integer; DocNo: Code[20])
    var
        LeaveAccrualLedgerEntry: Record "Sisa Cuti Accrual Ledger Entry";
        EntryNo: Integer;
        Maxnya: Integer;
        JumlahYangAda: Integer;

    begin
        Contract.Reset();
        Contract.SetRange("Employee No.", Pegawai."No.");
        Contract.FindLast();

        LeaveAccrualLedgerEntry.LockTable();
        LeaveAccrualLedgerEntry.Reset();
        if LeaveAccrualLedgerEntry.FindLast() then
            EntryNo := LeaveAccrualLedgerEntry."Entry No." + 1
        else
            EntryNo := 1;

        LeaveAccrualLedgerEntry.Init();
        LeaveAccrualLedgerEntry."Entry No." := EntryNo;
        LeaveAccrualLedgerEntry."Employee No." := Pegawai."No.";
        LeaveAccrualLedgerEntry."Document No." := DocNo;
        LeaveAccrualLedgerEntry."Payroll Date" := PostingDate;
        LeaveAccrualLedgerEntry."Accrual Amount" := Amount;
        LeaveAccrualLedgerEntry."Payroll Ledger Entry No." := PayrollLedgerEntryNo;
        LeaveAccrualLedgerEntry.Description := 'Accrual for ' + Format(PostingDate, 0, '<Day> <Month Text> <Year>');
        LeaveAccrualLedgerEntry."Period Start" := Contract."Contract Start Date";
        LeaveAccrualLedgerEntry."Period End" := Contract."Contract End Date";
        LeaveAccrualLedgerEntry."Entry Type" := LeaveAccrualLedgerEntry."Entry Type"::Positive;
        LeaveAccrualLedgerEntry.Quantity := 1.25;
        LeaveAccrualLedgerEntry.Insert();
    end;

    procedure JumlahAccrual(Pegawai: Record Employee; PostingDateCharging: Date; var Jumlahnya: Integer);
    var
        LeaveAccrualCocok: Record "Sisa Cuti Accrual Ledger Entry";
    begin
        Contract.Reset();
        Contract.SetCurrentKey("Contract End Date");
        Contract.SetRange("Employee No.", Pegawai."No.");
        Contract.SetFilter("Contract Start Date", '<=%1', PostingDateCharging);
        Contract.SetFilter("Contract End Date", '>=%1', PostingDateCharging);
        Contract.FindFirst();

        LeaveAccrualCocok.Reset();
        LeaveAccrualCocok.SetRange("Employee No.", Pegawai."No.");
        LeaveAccrualCocok.SetRange("Entry Type", LeaveAccrualCocok."Entry Type"::Positive);
        LeaveAccrualCocok.SetFilter("Period Start", '<=%1', Contract."Contract Start Date");
        LeaveAccrualCocok.SetFilter("Period End", '>=%1', Contract."Contract End Date");
        if LeaveAccrualCocok.FindSet() then begin
            Jumlahnya := LeaveAccrualCocok.Count;
            //if Pegawai."No." = 'E0016' then
            //Message('Masa iya sih = %1', Jumlahnya);
        end else
            Jumlahnya := 0;

    end;

    procedure AmbilMaxAccrual(KodeKuli: Code[20]; TanggalPencadangan: Date; var MaxAccrual: Integer)
    var
        LeaveLedgerEntry: Record "Leave Ledger Entry";
    begin
        //if KodeKuli = 'E0004' then
        //Error('tanggal=%1', Format(TanggalPencadangan, 0, '<Day> <Month Text> <Year4>'));

        LeaveLedgerEntry.Reset();
        LeaveLedgerEntry.SetRange("Employee No.", KodeKuli);
        LeaveLedgerEntry.SetRange(Type, LeaveLedgerEntry.Type::Positive);
        LeaveLedgerEntry.SetRange("Document No.", 'OBAL');
        LeaveLedgerEntry.SetFilter("Period Start", '<=%1', TanggalPencadangan);
        LeaveLedgerEntry.SetFilter("Period End", '>=%1', TanggalPencadangan);
        LeaveLedgerEntry.SetRange(Reversed, false);
        if not LeaveLedgerEntry.FindFirst() then
            Error('There is no leave slot opening balance that match with date %1, for employee %2.',
            format(TanggalPencadangan, 0, '<Day> <Month Text> <Year4>'), KodeKuli)
        else
            MaxAccrual := LeaveLedgerEntry."Maximum Times of Accrual";
    end;

    procedure PencandanganSeverance(Pegawai: Record Employee; PostingDate: Date;
    Amount: Decimal; PayrollLedgerEntryNo: Integer; DocNo: Code[20])
    begin
        Contract.Reset();
        Contract.SetRange("Employee No.", Pegawai."No.");
        Contract.FindLast();

        SeveranceAccruaLedgerEntry.LockTable();
        SeveranceAccruaLedgerEntry.Reset();
        if SeveranceAccruaLedgerEntry.FindLast() then
            EntryNo := SeveranceAccruaLedgerEntry."Entry No." + 1
        else
            EntryNo := 1;

        SeveranceAccruaLedgerEntry.Init();
        SeveranceAccruaLedgerEntry."Entry No." := EntryNo;
        SeveranceAccruaLedgerEntry."Document No." := DocNo;
        SeveranceAccruaLedgerEntry."Entry Type" := SeveranceAccruaLedgerEntry."Entry Type"::Positive;
        SeveranceAccruaLedgerEntry."Employee No." := Pegawai."No.";
        SeveranceAccruaLedgerEntry."Payroll Date" := PostingDate;
        SeveranceAccruaLedgerEntry."Accrual Amount" := Amount;
        SeveranceAccruaLedgerEntry."Payroll Ledger Entry No." := PayrollLedgerEntryNo;
        //SeveranceAccruaLedgerEntry."Contract Entry No." := Contract."Entry No.";
        SeveranceAccruaLedgerEntry.Description := 'Accrual for ' + Format(PostingDate, 0, '<Day> <Month Text> <Year>');
        SeveranceAccruaLedgerEntry.Insert();

        //CreateJournalAccrual(0, Pegawai, Amount, PostingDate);
    end;

    procedure PencandanganTHR(Pegawai: Record Employee; PostingDate: Date; Amount: Decimal;
    PayrollLedgerEntryNo: Integer; DocNo: Code[20])
    var
        THRAccruaLedgerEntry: Record "THR Accrual Ledger Entry";
        EntryNo: Integer;
    begin
        THRAccruaLedgerEntry.LockTable();
        THRAccruaLedgerEntry.Reset();
        if THRAccruaLedgerEntry.FindLast() then
            EntryNo := THRAccruaLedgerEntry."Entry No." + 1
        else
            EntryNo := 1;

        THRAccruaLedgerEntry.Init();
        THRAccruaLedgerEntry."Entry No." := EntryNo;
        THRAccruaLedgerEntry."Document No." := DocNo;
        THRAccruaLedgerEntry."Employee No." := Pegawai."No.";
        THRAccruaLedgerEntry."Payroll Date" := PostingDate;
        THRAccruaLedgerEntry."Accrual Amount" := Amount;
        THRAccruaLedgerEntry."Payroll Ledger Entry No." := PayrollLedgerEntryNo;
        THRAccruaLedgerEntry."Entry Type" := THRAccruaLedgerEntry."Entry Type"::Positive;
        THRAccruaLedgerEntry.Description := 'Accrual for ' + Format(PostingDate, 0, '<Day> <Month Text> <Year4>');
        THRAccruaLedgerEntry.Insert();
    end;


    procedure PencandanganSafetySecurityWelfare(Pegawai: Record Employee; PostingDate: Date; Amount: Decimal;
    PayrollLedgerEntryNo: Integer; SafetySecurity: Boolean; DocNo: Code[20])
    var
        SafeSecWelfareAccrualLedger: Record "SS Welfare Accr. Ledger Entry";
        EntryNo: Integer;
    begin
        SafeSecWelfareAccrualLedger.LockTable();
        SafeSecWelfareAccrualLedger.Reset();

        if SafetySecurity then
            SafeSecWelfareAccrualLedger.SetRange("Entry Type",
            SafeSecWelfareAccrualLedger."Entry Type"::"Safety & Security")
        else
            SafeSecWelfareAccrualLedger.SetRange("Entry Type",
            SafeSecWelfareAccrualLedger."Entry Type"::Welfare);

        if SafeSecWelfareAccrualLedger.FindLast() then
            EntryNo := SafeSecWelfareAccrualLedger."Entry No." + 1
        else
            EntryNo := 1;

        SafeSecWelfareAccrualLedger.Init();

        if SafetySecurity then
            SafeSecWelfareAccrualLedger."Entry Type" := SafeSecWelfareAccrualLedger."Entry Type"::"Safety & Security"
        else
            SafeSecWelfareAccrualLedger."Entry Type" := SafeSecWelfareAccrualLedger."Entry Type"::Welfare;

        SafeSecWelfareAccrualLedger."Entry No." := EntryNo;
        SafeSecWelfareAccrualLedger."Employee No." := Pegawai."No.";
        SafeSecWelfareAccrualLedger."Payroll Date" := PostingDate;
        SafeSecWelfareAccrualLedger."Accrual Amount" := Amount;
        SafeSecWelfareAccrualLedger."Payroll Ledger Entry No." := PayrollLedgerEntryNo;
        SafeSecWelfareAccrualLedger."Document No." := DocNo;
        SafeSecWelfareAccrualLedger.Description := 'Accrual for ' + Format(PostingDate, 0, '<Day> <Month Text> <Year4>');
        SafeSecWelfareAccrualLedger.Insert();
    end;


    local procedure CreateJournalAccrual(AccrualType: Option Severance,Leave,THR;
    Suruhan: Record Employee; Duit: Decimal; PostingDate: Date)
    var
        GenJnlLine: Record "Gen. Journal Line";
        JnlTemplateName: Code[10];
        JnlBatchName: Code[10];
        DebitAccountNo: Code[20];
        CreditAccountNo: Code[20];
        LineNo: Integer;
        StrAccr: Text;
    begin
        PayrollSetup.Get();

        case AccrualType of
            AccrualType::Severance:
                begin
                    PayrollSetup.TestField("Jnl. Template Name Sev. Accr.");
                    PayrollSetup.TestField("Jnl. Batch Name Sev. Accr.");
                    PayrollSetup.TestField("Sevr. Accr. Debit Acc. No.");
                    PayrollSetup.TestField("Sevr. Accr. Credit Acc. No.");

                    JnlTemplateName := PayrollSetup."Jnl. Template Name Sev. Accr.";
                    JnlBatchName := PayrollSetup."Jnl. Batch Name Sev. Accr.";
                    DebitAccountNo := PayrollSetup."Sevr. Accr. Debit Acc. No.";
                    CreditAccountNo := PayrollSetup."Sevr. Accr. Credit Acc. No.";
                    StrAccr := 'Severance';
                end;
            AccrualType::Leave:
                begin
                    PayrollSetup.TestField("Jnl. Template Name Leave Accr.");
                    PayrollSetup.TestField("Jnl. Batch Name Leave Accr.");
                    PayrollSetup.TestField("Leave Accr. Debit Acc. No.");
                    PayrollSetup.TestField("Leave Accr. Credit Acc. No.");

                    JnlTemplateName := PayrollSetup."Jnl. Template Name Leave Accr.";
                    JnlBatchName := PayrollSetup."Jnl. Batch Name Leave Accr.";
                    DebitAccountNo := PayrollSetup."Leave Accr. Debit Acc. No.";
                    CreditAccountNo := PayrollSetup."Leave Accr. Credit Acc. No.";
                    StrAccr := 'Leave';
                end;
            AccrualType::THR:
                begin
                    PayrollSetup.TestField("Jnl. Template Name THR Accr.");
                    PayrollSetup.TestField("Jnl. Batch Name THR Accr.");
                    PayrollSetup.TestField("THR Accr. Debit Acc. No.");
                    PayrollSetup.TestField("THR Accr. Credit Acc. No.");

                    JnlTemplateName := PayrollSetup."Jnl. Template Name THR Accr.";
                    JnlBatchName := PayrollSetup."Jnl. Batch Name THR Accr.";
                    DebitAccountNo := PayrollSetup."THR Accr. Debit Acc. No.";
                    CreditAccountNo := PayrollSetup."THR Accr. Credit Acc. No.";

                    StrAccr := 'THR'
                end;
        end;


        GenJnlLine.LockTable();
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", JnlTemplateName);
        GenJnlLine.SetRange("Journal Batch Name", JnlBatchName);
        if GenJnlLine.FindLast() then
            LineNo := GenJnlLine."Line No." + 1
        else
            LineNo := 1;

        GenJnlLine.Init();
        GenJnlLine.Validate("Journal Template Name", JnlTemplateName);
        GenJnlLine.Validate("Journal Batch Name", JnlBatchName);
        GenJnlLine.Validate("Line No.", LineNo);
        GenJnlLine.Validate("Posting Date", PostingDate);
        GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
        GenJnlLine.Validate("Account No.", DebitAccountNo);
        GenJnlLine.Validate(Description, StrAccr + ' Accrual of ' + Suruhan.FullName());
        GenJnlLine.Validate(Amount, Duit);
        GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
        GenJnlLine.Validate("Bal. Account No.", CreditAccountNo);
        GenJnlLine.Insert(true);
    end;

    var
        PayrollSetup: Record "Payroll General Setup";
        Contract: Record "Position Ledger Entry";
        SeveranceAccruaLedgerEntry: Record "Severance Accrual Ledger Entry";
        LeaveAccrualLedgerEntry: Record "Sisa Cuti Accrual Ledger Entry";
        EntryNo: Integer;
}