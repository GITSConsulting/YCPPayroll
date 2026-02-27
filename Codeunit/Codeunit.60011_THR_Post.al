codeunit 60011 "THR Post"
{
    procedure GetTarifNPWPTHR(EmployeeNPWP: Record Employee;
                                 TariffPPh21THR: Record "Tariff THR Setup"): Decimal;
    begin
        if EmployeeNPWP."MSI_HRIS NPWP No." <> '' then begin
            TariffPPh21THR.TestField("% Tariff");
            exit(TariffPPh21THR."% Tariff")
        end else begin
            TariffPPh21THR.TestField("% Tariff Non NPWP");
            exit(TariffPPh21THR."% Tariff Non NPWP");
        end;
    end;


    procedure HitungTaxTHR(KodeEmp: Code[20]; NetPKP: Decimal; PostingDateGajian: Date);
    var
        TarifPPh21THRSetup: Record "Tariff THR Setup";
        Selesai: Boolean;
        PayrollPost: Codeunit "Payroll Post";
        _TarifYangDipake: Decimal;
        TempTax: Decimal;
        Monyet: Record Employee;
        TarifPPh21THREntry: Record "Tarif PPh21 THR Entry";
    begin
        Monyet.Get(KodeEmp);

        TarifPPh21THRSetup.Reset();
        TarifPPh21THRSetup.FindFirst();
        repeat
            _TarifYangDipake := GetTarifNPWPTHR(Monyet, TarifPPh21THRSetup);

            if (TarifPPh21THRSetup."Upper Limit" <> 0) and
                (TarifPPh21THRSetup."Nilai Pengali Tarif" < NetPKP) then begin
                TarifPPh21THREntry.InsertTarifPPh21THREntry(Monyet, TarifPPh21THRSetup."Nilai Pengali Tarif",
                _TarifYangDipake, PostingDateGajian);
                NetPKP := NetPKP - TarifPPh21THRSetup."Nilai Pengali Tarif";
            end else begin
                TarifPPh21THREntry.InsertTarifPPh21THREntry(Monyet, NetPKP, _TarifYangDipake,
                PostingDateGajian);
                Selesai := true;
            end;

        until (Selesai) or (TarifPPh21THRSetup.Next() = 0);
    end;

    procedure LoopEmployeeForTHR(var PegawaiTHR: Record Employee; PostingDateTHR: Date;
    LastPayrollDate: Date; Tipe: Option " ","With Muslim Disbursement","With Non Muslim Disbursement","Compensation";
    var StrGPDocNo: Text; var StrGPTaxDocNo: Text)
    var
        THRAccrualLedgerEntry: Record "THR Accrual Ledger Entry";
        HiringInformation: Record "Position Ledger Entry";
        TanggalPencairanTHRKompensasi: Date;
        ContractDetail: Record "Contract Detail";
        EntryNoTHRAccrual: Integer;

        PayrollLedgerEntryLink: Record "Payroll Ledger Entry";
        EmployeeLastPayroll: Record Employee;
        BulanPayrollTerakhir: Integer;
        PayrollProcessedEntry: Record "Payroll Processed Entry";
        TaxPerYearLastPayroll: Decimal;
        NetTHR: Decimal;
        THRTax: Decimal;
        PajakPegawai: Record Employee;
        DisbursementDate: Date;
        DescDisbursement: Text;
        ReversePegawai: Record Employee;
        SisaTHRHangus: Decimal;
    begin
        PegawaiTHR.FindFirst();
        Clear(THRGelondongan);
        Clear(THRTaxGelondongan);

        repeat
            Clear(PeriodePenghasilan);
            Clear(BiayaJabatanWithTHR);
            Clear(GrossIncomeWithTHR);
            Clear(RegulerSetahunWithTHR);
            Clear(JumlahPenguranganWithTHR);
            Clear(BijabRegulerWithTHR);
            Clear(PenghasilanNettoSetahunWithTHR);
            Clear(PKPWithTHR);
            Clear(PKPCorrectTHR);
            Clear(TanggalPencairanTHRKompensasi);
            Clear(TaxPerYearLastPayroll);
            Clear(NetTHR);
            Clear(THRTax);


            TanggalPencairanTHRKompensasi := PostingDateTHR;

            //Tadinya pake ini
            //PostPayroll.HitungBulanKerja(PegawaiTHR, PeriodePenghasilan, LastPayrollDate);
            ContractDetail.GetPeriodePenghasilan(PegawaiTHR, LastPayrollDate, PeriodePenghasilan);

            if PegawaiTHR."MSI_HRIS Termination Status" = 0 then
                PegawaiTHR.TestField("THR Amount");

            PayrollLedgerEntry.Reset();
            PayrollLedgerEntry.SetRange("Posting Date", LastPayrollDate);
            PayrollLedgerEntry.SetRange("Employee No.", PegawaiTHR."No.");
            PayrollLedgerEntry.FindFirst();

            GrossIncomeWithTHR := PayrollLedgerEntry."Gross Income" + PegawaiTHR."THR Amount";
            RegulerSetahunWithTHR := (PayrollLedgerEntry."Gross Income" * PeriodePenghasilan) +
                                     PegawaiTHR."THR Amount";
            // PostPayroll.GetBiayaJabatan(BiayaJabatanWithTHR, RegulerSetahunWithTHR, false);
            PostPayroll.GetBiayaJabatanVersiFadhil(BiayaJabatanWithTHR, RegulerSetahunWithTHR, PeriodePenghasilan, true);
            BijabRegulerWithTHR := BiayaJabatanWithTHR * PeriodePenghasilan;
            JumlahPenguranganWithTHR := BiayaJabatanWithTHR + PayrollLedgerEntry."Pensiun JHT THT Setahun";
            PenghasilanNettoSetahunWithTHR := RegulerSetahunWithTHR - JumlahPenguranganWithTHR;

            PegawaiTHR.CalcFields("MSI_HRIS PTKP Baru");
            if (PenghasilanNettoSetahunWithTHR - PegawaiTHR."MSI_HRIS PTKP Baru" > 0) then
                PKPCorrectTHR := Round(PenghasilanNettoSetahunWithTHR - PegawaiTHR."MSI_HRIS PTKP Baru",
                1000, '<')
            else
                PKPCorrectTHR := 0;

            THRLedgerEntry.LockTable();
            THRLedgerEntry.Reset();
            if THRLedgerEntry.FindLast() then
                EntryNo := THRLedgerEntry."Entry No." + 1
            else
                EntryNo := 1;


            if Tipe = Tipe::Compensation then begin
                //Jika kompensasi, posting date thr bukan dari THRDate tapi dari tanggal kontrak berakhir
                HiringInformation.Reset();
                HiringInformation.SetRange("Employee No.", PegawaiTHR."No.");
                HiringInformation.FindLast();
                HiringInformation.TestField("Contract End Date");

                if HiringInformation."Resign Date" <> 0D then
                    PostingDateTHR := HiringInformation."Resign Date"
                else
                    PostingDateTHR := HiringInformation."Contract End Date";
            end;


            THRLedgerEntry.Init();
            THRLedgerEntry."Entry No." := EntryNo;
            THRLedgerEntry."Employee No." := PegawaiTHR."No.";
            THRLedgerEntry."Posting Date" := PostingDateTHR;
            THRLedgerEntry."THR Amount" := PegawaiTHR."THR Amount";
            THRLedgerEntry."Payroll Ledger Entry No." := PayrollLedgerEntry."Entry No.";
            THRLedgerEntry.LoS := PegawaiTHR."MSI_HRIS THR LoS";
            THRLedgerEntry."Calc. LoS" := PegawaiTHR."MSI_HRIS THR Calc. LoS";

            if PegawaiTHR."MSI_HRIS Termination Status" = 0 then begin
                THRLedgerEntry."Reguler Setahun With THR" := RegulerSetahunWithTHR;
                THRLedgerEntry."Gross Income With THR" := GrossIncomeWithTHR;
                // fadhil edit 
                THRLedgerEntry."Biaya Jabatan With THR" := BiayaJabatanWithTHR;
                // fadhil edit tutup
                THRLedgerEntry."Bijab Reguler With THR" := BijabRegulerWithTHR;
                THRLedgerEntry."Jumlah Pengurangan With THR" := JumlahPenguranganWithTHR;
                THRLedgerEntry."Penghasilan Netto Setahun THR" := PenghasilanNettoSetahunWithTHR;
                THRLedgerEntry."PKP Correct THR" := PKPCorrectTHR;
            end;

            if PegawaiTHR."MSI_HRIS Last Payroll" then begin
                THRLedgerEntry."Last Payroll" := true;
                THRLedgerEntry."Last Payroll Date" := PegawaiTHR."MSI_HRIS Last Payroll Date";
                THRLedgerEntry."Less/Over Deduct Tax" := PegawaiTHR."MSI_HRIS Less/Over Deduct Tax";
            end;

            Clear(DisbursementDate);

            case Tipe of
                1:
                    Begin
                        THRLedgerEntry."Disbursement Type" := 1;
                        THRLedgerEntry."Disbursement Date" := PostingDateTHR;
                        DisbursementDate := PostingDateTHR;
                        DescDisbursement := 'Muslim Disbursement';
                    end;
                2:
                    begin
                        THRLedgerEntry."Disbursement Type" := 2;
                        THRLedgerEntry."Disbursement Date" := PostingDateTHR;
                        DisbursementDate := PostingDateTHR;
                        DescDisbursement := 'Non Muslim Disbursement';
                    end;
                3:
                    begin
                        THRLedgerEntry."Disbursement Type" := 3;
                        THRLedgerEntry."Disbursement Date" := TanggalPencairanTHRKompensasi;
                        DisbursementDate := TanggalPencairanTHRKompensasi;
                        DescDisbursement := 'Compensation Disbursement';
                    end;
            end;

            if PegawaiTHR."MSI_HRIS THR Apply to Old" then begin
                PegawaiTHR.TestField("MSI_HRIS Old Basic Salary");
                THRLedgerEntry."Basic Salary" := PegawaiTHR."MSI_HRIS Old Basic Salary";
                THRLedgerEntry."Applied to Old Basic Salary" := true;
            end else
                THRLedgerEntry."Basic Salary" := PegawaiTHR."MSI_HRIS Basic Salary";

            THRLedgerEntry.Insert();


            //hitung dan entry pajak
            if PegawaiTHR."MSI_HRIS Termination Status" = 0 then begin
                TarifPPh21THREntry.Reset();
                TarifPPh21THREntry.SetRange("Employee No.", PegawaiTHR."No.");
                TarifPPh21THREntry.SetRange("Posting Date THR", PostingDateTHR);
                if not TarifPPh21THREntry.FindFirst() then
                    HitungTaxTHR(PegawaiTHR."No.", PKPCorrectTHR, PostingDateTHR);
            end;

            PegawaiTHR."MSI_HRIS Los Newly Calc." := false;
            PegawaiTHR."MSI_HRIS THR LoS" := 0;
            PegawaiTHR."MSI_HRIS THR Calc. LoS" := 0;
            PegawaiTHR.Modify();

            PayrollLedgerEntryLink.Get(PayrollLedgerEntry."Entry No.");

            EmployeeLastPayroll.Reset();
            EmployeeLastPayroll.SetRange("No.", PegawaiTHR."No.");
            EmployeeLastPayroll.SetRange("Date Filter", PayrollLedgerEntryLink."Posting Date");
            EmployeeLastPayroll.FindFirst();

            EmployeeLastPayroll.CalcFields("MSI_HRIS Tax Per Year");
            EmployeeLastPayroll.CalcFields("MSI_HRIS Total Allowance Fix");
            EmployeeLastPayroll.CalcFields("MSI_HRIS Tax Per Year End");

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

            PajakPegawai.Reset();
            PajakPegawai.SetRange("No.", PegawaiTHR."No.");
            PajakPegawai.SetRange("Date Filter", PostingDateTHR);
            PajakPegawai.FindFirst();
            PajakPegawai.CalcFields("MSI_HRIS Tax Per Year THR");

            if not PegawaiTHR."MSI_HRIS Last Payroll" then begin
                if PajakPegawai."MSI_HRIS Tax Per Year THR" > 0 then
                    THRTax := PajakPegawai."MSI_HRIS Tax Per Year THR" - TaxPerYearLastPayroll
                else
                    THRTax := 0;
            end else
                THRTax := 0;

            NetTHR := round(THRLedgerEntry."THR Amount" - THRTax, 1, '=');

            THRGelondongan := THRGelondongan + NetTHR;
            THRTaxGelondongan := THRTaxGelondongan + THRTax;


            //insert inputan negatif di thr accrual
            THRAccrualLedgerEntry.LockTable();
            THRAccrualLedgerEntry.Reset();
            if THRAccrualLedgerEntry.FindLast() then
                EntryNoTHRAccrual := THRAccrualLedgerEntry."Entry No." + 1
            else
                EntryNoTHRAccrual := 1;

            THRAccrualLedgerEntry.Init();
            THRAccrualLedgerEntry."Entry No." := EntryNoTHRAccrual;
            THRAccrualLedgerEntry."Employee No." := PegawaiTHR."No.";
            THRAccrualLedgerEntry."Payroll Date" := PayrollLedgerEntry."Posting Date";
            THRAccrualLedgerEntry."Accrual Amount" := -PegawaiTHR."THR Amount";
            THRAccrualLedgerEntry."Payroll Ledger Entry No." := PayrollLedgerEntry."Entry No.";
            THRAccrualLedgerEntry."Entry Type" := THRAccrualLedgerEntry."Entry Type"::Negative;
            THRAccrualLedgerEntry."THR Ledger Entry No." := EntryNo;
            THRAccrualLedgerEntry."Disbursement Date" := PostingDateTHR;
            THRAccrualLedgerEntry.Description := DescDisbursement;
            THRAccrualLedgerEntry."Net THR" := NetTHR;
            THRAccrualLedgerEntry.Insert();


        //Untuk reverse THR Accrual jika masih ada sisa
        /*
        if PegawaiTHR."MSI_HRIS Last Payroll" then begin
            SisaTHRHangus := 0;

            ReversePegawai.Get(PegawaiTHR."No.");
            ReversePegawai.CalcFields("MSI_HRIS THR Accrual");
            SisaTHRHangus := ReversePegawai."MSI_HRIS THR Accrual";

            THRAccrualLedgerEntry.LockTable();
            THRAccrualLedgerEntry.Reset();
            if THRAccrualLedgerEntry.FindLast() then
                EntryNoTHRAccrual := THRAccrualLedgerEntry."Entry No." + 1
            else
                EntryNoTHRAccrual := 1;

            THRAccrualLedgerEntry.Init();
            THRAccrualLedgerEntry."Entry No." := EntryNoTHRAccrual;
            THRAccrualLedgerEntry."Employee No." := ReversePegawai."No.";
            THRAccrualLedgerEntry."Payroll Date" := PayrollLedgerEntry."Posting Date";
            THRAccrualLedgerEntry."Accrual Amount" := -SisaTHRHangus;
            THRAccrualLedgerEntry."Payroll Ledger Entry No." := PayrollLedgerEntry."Entry No.";
            THRAccrualLedgerEntry."Entry Type" := THRAccrualLedgerEntry."Entry Type"::Negative;
            THRAccrualLedgerEntry."THR Ledger Entry No." := EntryNo;
            THRAccrualLedgerEntry.Description := 'Sisa THR Hangus';
            THRAccrualLedgerEntry."Hangus Reversed" := true;
            THRAccrualLedgerEntry.Insert();
        end;
        */

        until PegawaiTHR.Next() = 0;

        EmployeeDREE.Reset();
        EmployeeDREE.SetRange("User ID", UserId);
        EmployeeDREE.FindFirst();

        //PayrollProcessedEntry.TestField("GP Document No.");

        if Tipe = Tipe::Compensation then begin
            PayrollProcessedEntry."THR Compensation Exist" := true;
            TanggalPencairanTHRKompensasi := Today;
            DeskripsiTHR := 'THR Compensation for ';
            DeskripsiTaxTHR := 'Tax THR Compensation for '
        end else begin
            PayrollProcessedEntry."THR Regular Exist" := true;
            PayrollProcessedEntry."THR Regular Posting Date" := TanggalPencairanTHRKompensasi;
            DeskripsiTHR := 'THR Regular for ';
            DeskripsiTaxTHR := 'Tax THR Regular for ';
        end;

        GPAvailable := false;

        PayrollSetup.Get();
        PayrollSetup.TestField("THR THP Acc. No.");
        PayrollSetup.TestField("Global Dimension 1 Code");
        PayrollSetup.TestField("THR Tax Acc. No.");

        //Jurnal THR jika ada GP, maka tambah line di GP tersebut
        if PayrollProcessedEntry."GP Document No." <> '' then
            if AdvanceHeaderCheck.Get(AdvanceHeaderCheck."Document Type"::"General Payment",
               PayrollProcessedEntry."GP Document No.") then
                if AdvanceHeaderCheck.Status = AdvanceHeaderCheck.Status::Open then begin
                    GPAvailable := true;

                    GenJnlLineTambahLine.Reset();
                    GenJnlLineTambahLine.SetRange("Journal Template Name", AdvanceHeaderCheck."Journal Template Name");
                    GenJnlLineTambahLine.SetRange("Journal Batch Name", AdvanceHeaderCheck."Journal Batch Name");
                    if GenJnlLineTambahLine.FindLast() then
                        LineNoTambah := GenJnlLineTambahLine."Line No." + 1
                    else
                        LineNoTambah := 1;

                    GenJnlLineTambahLine.Init();
                    GenJnlLineTambahLine.Validate("Journal Template Name", AdvanceHeaderCheck."Journal Template Name");
                    GenJnlLineTambahLine.validate("Journal Batch Name", AdvanceHeaderCheck."Journal Batch Name");
                    GenJnlLineTambahLine.Validate("Line No.", LineNoTambah);
                    GenJnlLineTambahLine.Validate("Document No.", AdvanceHeaderCheck."No.");
                    GenJnlLineTambahLine.Validate("Posting Date", TanggalPencairanTHRKompensasi);
                    GenJnlLineTambahLine.Validate(Amount, THRGelondongan);
                    GenJnlLineTambahLine.Validate("Account Type", GenJnlLineTambahLine."Account Type"::"G/L Account");
                    GenJnlLineTambahLine.Validate("Account No. 2", PayrollSetup."THR THP Acc. No.");
                    GenJnlLineTambahLine.Validate(Description, DeskripsiTHR +
                    Format(TanggalPencairanTHRKompensasi, 0, '<Day> <Month Text> <Year>'));

                    if Tipe = Tipe::Compensation then
                        GenJnlLineTambahLine.TipeDuit := GenJnlLineTambahLine.TipeDuit::"THR Compensation"
                    else
                        GenJnlLineTambahLine.TipeDuit := GenJnlLineTambahLine.TipeDuit::THR;
                    GenJnlLineTambahLine.Validate("Global Dimension 1 Code", PayrollSetup."Global Dimension 1 Code");
                    GenJnlLineTambahLine.Insert(true);

                    StrGPDocNo := 'And the general payment ' + PayrollProcessedEntry."GP Document No." + ' is updated with THR transaction';
                end;


        //Jurnal THR jika tidak ada GP, maka bikin GP sendiri
        if not GPAvailable then begin
            //Create General Payment
            AdvanceHeader.Init();
            AdvanceHeader.Validate("Document Type", AdvanceHeader."Document Type"::"General Payment");
            AdvanceHeader.Validate("No.", '');
            AdvanceHeader."Employee No." := EmployeeDREE."No.";
            AdvanceHeader.validate("Shortcut Dimension 1 Code", EmployeeDREE."MSI_HRIS Shortcut Dim Code");
            AdvanceHeader."Disbursement Type" := AdvanceHeader."Disbursement Type"::THR;
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
            AdvanceHeader2."Journal Description" := 'THR for ' + Format(PostingDateTHR);
            AdvanceHeader2.Validate("Posting Date", PostingDateTHR);
            AdvanceHeader2.Modify();


            GenJnlLine.Init();
            GenJnlLine.Validate("Journal Template Name", AdvanceHeader2."Journal Template Name");
            GenJnlLine.validate("Journal Batch Name", AdvanceHeader2."Journal Batch Name");
            GenJnlLine.Validate("Line No.", 10000);
            GenJnlLine.Validate("Document No.", AdvanceHeader."No.");
            GenJnlLine.Validate("Posting Date", TanggalPencairanTHRKompensasi);
            GenJnlLine.Validate(Amount, THRGelondongan);
            GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
            GenJnlLine.Validate("Account No. 2", PayrollSetup."THR THP Acc. No.");

            GenJnlLine.Validate(Description,
            DeskripsiTHR + Format(TanggalPencairanTHRKompensasi, 0, '<Day> <Month Text> <Year>'));

            if Tipe = Tipe::Compensation then
                GenJnlLine.TipeDuit := GenJnlLine.TipeDuit::"THR Compensation"
            else
                GenJnlLine.TipeDuit := GenJnlLine.TipeDuit::THR;

            GenJnlLine.Validate("Global Dimension 1 Code", PayrollSetup."Global Dimension 1 Code");
            GenJnlLine.Insert(true);

            StrGPDocNo := 'And a general payment ' + AdvanceHeader."No." + ' is created.';
        end;

        Clear(AdvanceHeaderCheck);
        Clear(GenJnlLineTambahLine);

        GPTaxAvailable := false;

        //Jurnal PAJAK THR jika ada GP, maka tambah line di GP tersebut
        if PayrollProcessedEntry."GP For Tax" <> '' then
            if AdvanceHeaderCheck.Get(AdvanceHeaderCheck."Document Type"::"General Payment",
            PayrollProcessedEntry."GP For Tax") then
                if AdvanceHeaderCheck.Status = AdvanceHeaderCheck.Status::Open then begin
                    GPTaxAvailable := true;

                    GenJnlLineTambahLine.Reset();
                    GenJnlLineTambahLine.SetRange("Journal Template Name", AdvanceHeaderCheck."Journal Template Name");
                    GenJnlLineTambahLine.SetRange("Journal Batch Name", AdvanceHeaderCheck."Journal Batch Name");
                    if GenJnlLineTambahLine.FindLast() then
                        LineNoTambah := GenJnlLineTambahLine."Line No." + 1
                    else
                        LineNoTambah := 1;

                    GenJnlLineTambahLine.Init();
                    GenJnlLineTambahLine.Validate("Journal Template Name", AdvanceHeaderCheck."Journal Template Name");
                    GenJnlLineTambahLine.validate("Journal Batch Name", AdvanceHeaderCheck."Journal Batch Name");
                    GenJnlLineTambahLine.Validate("Line No.", LineNoTambah);
                    GenJnlLineTambahLine.Validate("Document No.", AdvanceHeaderCheck."No.");
                    GenJnlLineTambahLine.Validate("Posting Date", TanggalPencairanTHRKompensasi);
                    GenJnlLineTambahLine.Validate(Amount, THRTaxGelondongan);
                    GenJnlLineTambahLine.Validate("Account Type", GenJnlLineTambahLine."Account Type"::"G/L Account");
                    GenJnlLineTambahLine.Validate("Account No. 2", PayrollSetup."THR Tax Acc. No.");
                    GenJnlLineTambahLine.Validate(Description, DeskripsiTaxTHR +
                    Format(TanggalPencairanTHRKompensasi, 0, '<Day> <Month Text> <Year>'));

                    if Tipe = Tipe::Compensation then
                        GenJnlLineTambahLine.TipeDuit := GenJnlLineTambahLine.TipeDuit::"Tax THR Compensation"
                    else
                        GenJnlLineTambahLine.TipeDuit := GenJnlLineTambahLine.TipeDuit::"Tax THR";

                    GenJnlLineTambahLine.Validate("Global Dimension 1 Code", PayrollSetup."Global Dimension 1 Code");
                    GenJnlLineTambahLine.Insert(true);

                    StrGPTaxDocNo := '\With the general payment tax ' + PayrollProcessedEntry."GP For Tax" + ' is updated with tax THR transaction';
                end;


        Clear(AdvanceHeader);
        Clear(AdvanceHeader2);
        Clear(GenJnlLine);
        Clear(AdvancePostDRE);
        clear(_GenJnlBatch);

        //Jurnal PAJAK THR jika tidak ada GP, maka bikin GP sendiri
        if not GPTaxAvailable then begin
            //Create General Payment
            AdvanceHeader.Init();
            AdvanceHeader.Validate("Document Type", AdvanceHeader."Document Type"::"General Payment");
            AdvanceHeader.Validate("No.", '');
            AdvanceHeader."Employee No." := EmployeeDREE."No.";
            AdvanceHeader.validate("Shortcut Dimension 1 Code", EmployeeDREE."MSI_HRIS Shortcut Dim Code");
            AdvanceHeader."Disbursement Type" := AdvanceHeader."Disbursement Type"::"Tax Payroll - THR";
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
            AdvanceHeader2."Journal Description" := 'THR tax for ' + Format(PostingDateTHR);
            AdvanceHeader2.Validate("Posting Date", PostingDateTHR);
            AdvanceHeader2.Modify();


            GenJnlLine.Init();
            GenJnlLine.Validate("Journal Template Name", AdvanceHeader2."Journal Template Name");
            GenJnlLine.validate("Journal Batch Name", AdvanceHeader2."Journal Batch Name");
            GenJnlLine.Validate("Line No.", 10000);
            GenJnlLine.Validate("Document No.", AdvanceHeader."No.");
            GenJnlLine.Validate("Posting Date", TanggalPencairanTHRKompensasi);
            GenJnlLine.Validate(Amount, THRTaxGelondongan);
            GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
            GenJnlLine.Validate("Account No. 2", PayrollSetup."THR Tax Acc. No.");

            GenJnlLine.Validate(Description,
            DeskripsiTaxTHR + Format(TanggalPencairanTHRKompensasi, 0, '<Day> <Month Text> <Year>'));

            if Tipe = Tipe::Compensation then
                GenJnlLine.TipeDuit := GenJnlLine.TipeDuit::"Tax THR Compensation"
            else
                GenJnlLine.TipeDuit := GenJnlLine.TipeDuit::"Tax THR";

            GenJnlLine.Validate("Global Dimension 1 Code", PayrollSetup."Global Dimension 1 Code");
            GenJnlLine.Insert(true);

            StrGPTaxDocNo := '\And a general payment THR Tax ' + AdvanceHeader."No." + ' is created.';
        end;

        if ProcessTHRSetupTable.Get() then begin
            ProcessTHRSetupTable.PostingDate := 0D;
            ProcessTHRSetupTable.Modify();
        end;

        if ProcessTHRCompensation.Get() then begin
            ProcessTHRCompensation.PostingDate := 0D;
            ProcessTHRCompensation.Modify();
        end;
    end;

    var
        THRTaxGelondongan: Decimal;
        DeskripsiTHR: Text;
        DeskripsiTaxTHR: Text;
        GenJnlLineTambahLine: Record "Gen. Journal Line";
        LineNoTambah: Integer;
        GPAvailable: Boolean;
        GPTaxAvailable: Boolean;
        AdvanceHeaderCheck: Record "Advance Header";
        PayrollSetup: Record "Payroll General Setup";
        THRGelondongan: Decimal;
        AdvancePostDRE: Codeunit "Advance-Post";
        _GenJnlBatch: Record "Gen. Journal Batch";
        EmployeeDREE: Record Employee;
        AdvanceHeader: Record "Advance Header";
        AdvanceHeader2: Record "Advance Header";
        GenJnlLine: Record "Gen. Journal Line";
        ProcessTHRSetupTable: Record "Process THR Setup Table";
        ProcessTHRCompensation: Record "Process THR Compensation Table";
        UpdateLoS: Record Employee;
        THRLedgerEntry: Record "THR Ledger Entry";
        PayrollLedgerEntry: Record "Payroll Ledger Entry";
        TarifPPh21THREntry: Record "Tarif PPh21 THR Entry";
        PostPayroll: Codeunit "Payroll Post";
        PeriodePenghasilan: Integer;
        EntryNo: Integer;
        BiayaJabatanWithTHR: Decimal;
        GrossIncomeWithTHR: Decimal;
        RegulerSetahunWithTHR: Decimal;
        BijabRegulerWithTHR: Decimal;
        JumlahPenguranganWithTHR: Decimal;
        PenghasilanNettoSetahunWithTHR: Decimal;
        PKPWithTHR: Decimal;
        PKPCorrectTHR: Decimal;
}