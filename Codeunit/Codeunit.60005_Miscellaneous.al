Codeunit 60005 "Miscellaneous"
{
    procedure CancelCharging(DocNo: Code[20])
    var
        PostedEmployeeChargingHeader: Record "Posted Employee Charg. Header";
        PostedEmpChargingLine: Record "Posted Employee Charging Line";
        EmpChargingHeader: Record "Employee Charging Header";
        EmpChargingLine: Record "Employee Charging Line";
        PayrollProcessedEntry: Record "Payroll Processed Entry";
        GenJnlLine: Record "Gen. Journal Line";

        SeveranceAccrual: Record "Severance Accrual Ledger Entry";
        THRAccrual: Record "THR Accrual Ledger Entry";
        LeaveAccrual: Record "Sisa Cuti Accrual Ledger Entry";
        SSWelfareAccrual: Record "SS Welfare Accr. Ledger Entry";

        Window: Dialog;
        Window2: Dialog;
        Window3: Dialog;
    begin
        PayrollSetup.Get();
        PayrollSetup.TestField("Journal Template Name");
        PayrollSetup.TestField("Journal Batch Name");
        PayrollSetup.TestField("Jnl. Template Name Accrual");
        PayrollSetup.TestField("Jnl. Batch Name Accrual");

        PostedEmployeeChargingHeader.Get(DocNo);

        Clear(Window);

        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", PayrollSetup."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", PayrollSetup."Journal Batch Name");
        GenJnlLine.SetRange("Charging Doc. No", DocNo);
        if GenJnlLine.FindFirst() then begin
            Window.Open('Deleting general journals batch ' + PayrollSetup."Journal Batch Name" +
                        '\With charging number: ' + DocNo +
                        '\#1######');
            repeat
                Window.Update(1, GenJnlLine.Description);
                GenJnlLine.Delete(true);
            until GenJnlLine.Next() = 0;
            Window.Close();

        end else begin
            if not PostedEmployeeChargingHeader."Ignore Error On Cancelation" then
                Error('Cannot find journals related with document number %1 in batch %2. ' +
                      'Data is already processed by finance department. This document cannot be deleted.',
                      DocNo, PayrollSetup."Journal Batch Name");
        end;

        Clear(Window);

        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", PayrollSetup."Jnl. Template Name Accrual");
        GenJnlLine.SetRange("Journal Batch Name", PayrollSetup."Jnl. Batch Name Accrual");
        GenJnlLine.SetRange("Charging Doc. No", DocNo);
        if GenJnlLine.FindFirst() then begin

            Window3.Open('Deleting general journals batch ' + PayrollSetup."Jnl. Batch Name Accrual" +
                         '\With charging number: ' + DocNo +
                         '\#1######');
            repeat
                Window3.Update(1, GenJnlLine.Description);
                GenJnlLine.Delete(true);
            until GenJnlLine.Next() = 0;
            Window3.Close();

        end else begin
            if not PostedEmployeeChargingHeader."Ignore Error On Cancelation" then
                Error('Cannot find journals related with document number %1 in batch %2. ' +
                      'Data is already processed by finance department. This document cannot be deleted.',
                      DocNo, PayrollSetup."Jnl. Batch Name Accrual");
        end;

        Clear(Window3);

        Window2.Open('Deleting other data and finishing cancel process, please wait..');
        SeveranceAccrual.Reset();
        SeveranceAccrual.SetRange("Document No.", DocNo);
        if SeveranceAccrual.FindSet() then
            SeveranceAccrual.DeleteAll();

        THRAccrual.Reset();
        THRAccrual.SetRange("Document No.", DocNo);
        if THRAccrual.FindSet() then
            THRAccrual.DeleteAll();

        LeaveAccrual.Reset();
        LeaveAccrual.SetRange("Document No.", DocNo);
        if LeaveAccrual.FindSet() then
            LeaveAccrual.DeleteAll();

        SSWelfareAccrual.Reset();
        SSWelfareAccrual.SetRange("Document No.", DocNo);
        if SSWelfareAccrual.FindSet() then
            SSWelfareAccrual.DeleteAll();

        PayrollProcessedEntry.Reset();
        PayrollProcessedEntry.SetRange("Employee Charging Doc. No.", DocNo);
        if PayrollProcessedEntry.FindFirst() then begin
            PayrollProcessedEntry."Charging Processed" := false;
            PayrollProcessedEntry."Employee Charging Doc. No." := '';
            PayrollProcessedEntry.Validate("Posting Date Charging", 0D);
            PayrollProcessedEntry.Modify();
        end;

        PostedEmployeeChargingHeader.Get(DocNo);
        PostedEmpChargingLine.SetRange("Document No.", PostedEmployeeChargingHeader."No.");
        if PostedEmpChargingLine.FindSet() then
            repeat
                EmpChargingLine.TransferFields(PostedEmpChargingLine);
                EmpChargingLine.Insert();
            until PostedEmpChargingLine.Next() = 0;
        EmpChargingHeader.TransferFields(PostedEmployeeChargingHeader);
        EmpChargingHeader.Insert();
        PostedEmployeeChargingHeader.Delete(true);
        Window2.Close();

        Clear(Window2);

        Message('Document cancelled.');
    end;


    procedure ImportExcelIntoChargingLine(DocNo: Code[20])
    var
        ExcelBuffer: Record "Excel Buffer";
        EmployeeChargingLine: Record "Employee Charging Line";
        EmployeeChargingHeader: Record "Employee Charging Header";
        RowTerakhir: Integer;
        Columns: Integer;
        DialogCaption: Text;
        UploadResult: Boolean;
        SheetName: Text;
        FileName: Text;
        FileUploaded: Boolean;
        UploadedIntoStream: InStream;
        NVInStream: InStream;
        RowNo: Integer;
        LineNo: Integer;
        Name: Text;
        Employee: Record Employee;
        DimensionValue: Record "Dimension Value";
        Percentage: Decimal;
        PayrollLedgerEntry: Record "Payroll Ledger Entry";
    begin
        EmployeeChargingHeader.Get(DocNo);

        ExcelBuffer.DeleteAll();

        RowTerakhir := 0;
        Columns := 0;

        DialogCaption := 'Select file to upload';

        UploadResult := UploadIntoStream(DialogCaption, '', '', Name, NVInStream);

        If Name <> '' then
            Sheetname := ExcelBuffer.SelectSheetsNameStream(NVInStream)
        else
            exit;

        ExcelBuffer.Reset();
        ExcelBuffer.OpenBookStream(NVInStream, Sheetname);
        ExcelBuffer.ReadSheet();
        Commit();

        ExcelBuffer.Reset();
        ExcelBuffer.FindLast();
        RowTerakhir := ExcelBuffer."Row No.";

        //Mulai cek tiap row di excel
        for RowNo := 1 to RowTerakhir do begin
            if not Employee.Get(ValueAtIndex(RowNo, 1)) then
                Error('EMPLOYEE %1 referred by row %2 in the excel file does not exist in the database.', ValueAtIndex(RowNo, 1), RowNo);

            PayrollLedgerEntry.Reset();
            PayrollLedgerEntry.SetRange("Employee No.", ValueAtIndex(RowNo, 1));
            PayrollLedgerEntry.SetRange("Posting Date", EmployeeChargingHeader."Posting Date");
            if not PayrollLedgerEntry.FindFirst() then
                Error('Cannot find EMPLOYEE %1 (from row %3) in payroll processed on %2',
                ValueAtIndex(RowNo, 1),
                Format(EmployeeChargingHeader."Posting Date", 0, '<Day> <Month Text> <Year4>'),
                RowNo);

            DimensionValue.Reset();
            DimensionValue.SetRange("Global Dimension No.", 1);
            DimensionValue.SetRange(Blocked, false);
            DimensionValue.SetRange(Code, ValueAtIndex(RowNo, 3));
            if not DimensionValue.FindFirst() then
                Error('FUND CODE %1 referred by row %2 in the excel file does not exist in the database.', ValueAtIndex(RowNo, 3), RowNo);

            Evaluate(Percentage, ValueAtIndex(RowNo, 4));

            if Percentage > 100 then
                Error('The percentage on row %1 is more than 100', RowNo);

            Percentage := Percentage * 100;

            EmployeeChargingLine.Reset();
            EmployeeChargingLine.SetRange("Document No.", DocNo);
            if EmployeeChargingLine.FindLast() then
                LineNo := EmployeeChargingLine."Line No." + 1
            else
                LineNo := 1;


            EmployeeChargingLine.Init();
            EmployeeChargingLine."Document No." := DocNo;
            EmployeeChargingLine."Line No." := LineNo;
            EmployeeChargingLine."Posting Date" := EmployeeChargingHeader."Posting Date";
            EmployeeChargingLine.validate("Employee No.", ValueAtIndex(RowNo, 1));
            EmployeeChargingLine.Validate("Global Dimension 1 Code", ValueAtIndex(RowNo, 3));
            EmployeeChargingLine.Percentage := Percentage;
            EmployeeChargingLine.Insert();

        end;

        Message('Import completed.');
    end;


    local procedure ValueAtIndex(RowNo: Integer; ColNo: Integer): Text
    var
        Rec_ExcelBuffer: Record "Excel Buffer";
    begin
        Rec_ExcelBuffer.Reset();
        If Rec_ExcelBuffer.Get(RowNo, ColNo) then
            exit(Rec_ExcelBuffer."Cell Value as Text");
    end;


    //procedure untuk hitung jumlah hari karyawan masuk dalam bulan tertentu
    procedure CountAttendance(EmpNo: code[20]; PostingDate: Date; var Jumlah: Integer)
    var
        AttendanceHeader: Record "Employee Attendance Header";
        AttendanceLine: Record "Employee Absence Line";
        TanggalAwal: Date;
        TanggalAkhir: Date;
    begin
        TanggalAwal := CalcDate('CM-1M+1D', PostingDate);
        TanggalAkhir := CalcDate('CM', PostingDate);

        // AttendanceHeader.Reset();
        //AttendanceHeader.SetRange("Employee No.", EmpNo);
        //AttendanceHeader.SetRange("Effective Date", TanggalAwal, TanggalAkhir);
        //if AttendanceHeader.FindFirst() then begin
        AttendanceLine.Reset();
        AttendanceLine.SetRange("Employee No.", EmpNo);
        AttendanceLine.SetRange(Date, TanggalAwal, TanggalAkhir);
        if AttendanceLine.FindFirst() then
            Jumlah := AttendanceLine.Count
        else
            Jumlah := 0;
        //end else
        //    Jumlah := 0;
    end;

    //procedure untuk hitung jumlah hari karyawan bolos atau unpaid leave
    procedure CountBolos(EmpNo: code[20]; PostingDate: Date)
    begin

    end;


    //procedure untuk cek calendar kerja
    procedure CheckCalendar(PostingDate: Date; var JumlahHariKerja: Integer;
    var JumlahHariLibur: Integer)
    var
        LiburResmiKantor: Record "Base Calendar Change";
        TanggalAwal: Date;
        TanggalAkhir: Date;
    begin
        TanggalAwal := CalcDate('-CM', PostingDate);
        TanggalAkhir := CalcDate('CM', PostingDate);
        Clear(JumlahHariKerja);
        Clear(JumlahHariLibur);

        JumlahHariKerja := TanggalAkhir - TanggalAwal + 1;

        LiburResmiKantor.Reset();
        LiburResmiKantor.SetRange(Date, TanggalAwal, TanggalAkhir);
        //LiburResmiKantor.SetRange(Nonworking, true);
        if LiburResmiKantor.FindFirst() then
            JumlahHariLibur := LiburResmiKantor.Count;

        //Error('PostingDate=%3 HariKerja=%1 HariLibur=%2 tanggalAwal=%4 tanggalAkhir=%5',
        //JumlahHariKerja, JumlahHariLibur, PostingDate, TanggalAwal, TanggalAkhir);
    end;


    procedure CalculateJumlahHariKerja()
    begin

    end;

    procedure CalculateAdjustmentProrate(Karyawan: Record Employee; TanggalReff: Date)
    begin

    end;

    procedure WhichBasicSalary(Pegawai: Record Employee; var BasicSalaryDRE: Decimal)
    begin
        if (Pegawai."Newly Hired") or (Pegawai."Unpaid Leave Exist") then begin
            Pegawai.TestField("Adjustment Prorate");
            BasicSalaryDRE := Pegawai."Adjustment Prorate"
        end else begin
            Pegawai.TestField("MSI_HRIS Basic Salary");
            BasicSalaryDRE := Pegawai."MSI_HRIS Basic Salary";
        end;
    end;

    procedure calculateGajiBersih(__empNoGaji: Code[20]; __PostingDate: Date; var __Gaji: Decimal)
    var
        PayrollLedgerEntry: Record "Payroll Ledger Entry";
        EmployeeList: Page "Employee List HR";
        EmployeeGw: Record Employee;
        IuranPensiunTHTJHT: Decimal;
        PostedUnpaidLeave: Record "Posted Leave Request";
        UnpaidLeaveDeduction: Decimal;
        TotalIncome: Decimal;
        LessOverDeductTax: Decimal;
        TaxPerMonth: Decimal;
        NetSalary: Decimal;
        TakeHomePay: Decimal;
        OtherDeduction: Decimal;
    begin
        Clear(__Gaji);
        IuranPensiunTHTJHT := 0;
        UnpaidLeaveDeduction := 0;
        OtherDeduction := 0;
        TotalIncome := 0;
        LessOverDeductTax := 0;
        TaxPerMonth := 0;
        NetSalary := 0;
        TakeHomePay := 0;


        EmployeeGw.Reset();
        EmployeeGw.SetRange("No.", __empNoGaji);
        EmployeeGw.SetRange("Date Filter", __PostingDate);
        EmployeeGw.FindFirst();
        EmployeeGw.CalcFields("MSI_HRIS Total Deduction Taxed");
        EmployeeGw.CalcFields("MSI_HRIS Tax Per Year");
        EmployeeGw.CalcFields("MSI_HRIS BPJS Kesehatan Staff");

        PayrollLedgerEntry.Reset();
        PayrollLedgerEntry.SetRange("Employee No.", __empNoGaji);
        PayrollLedgerEntry.SetRange("Posting Date", __PostingDate);
        if PayrollLedgerEntry.FindFirst() then begin
            IuranPensiunTHTJHT := round(EmployeeGw."MSI_HRIS Total Deduction Taxed");

            PostedUnpaidLeave.Reset();
            PostedUnpaidLeave.SetRange("Employee No.", EmployeeGw."No.");
            PostedUnpaidLeave.SetRange("Payroll Ledger Entry No.",
            PayrollLedgerEntry."Entry No.");
            if PostedUnpaidLeave.FindFirst() then
                UnpaidLeaveDeduction := round(PostedUnpaidLeave."Salary Deduction", 1, '=');

            TotalIncome := PayrollLedgerEntry."Total Income";
            OtherDeduction := PayrollLedgerEntry."Other Deduction";

            if not EmployeeGw."MSI_HRIS Last Payroll" then
                if PayrollLedgerEntry."Periode Penghasilan" <> 0 then
                    TaxPerMonth := Round(EmployeeGw."MSI_HRIS Tax Per Year" /
                                            PayrollLedgerEntry."Periode Penghasilan", 1)
                else
                    TaxPerMonth := 0
            else
                TaxPerMonth := PayrollLedgerEntry."Less/Over Deduct Tax";

            NetSalary := round(TotalIncome + EmployeeGw."MSI_HRIS BPJS Kesehatan Staff" +
            IuranPensiunTHTJHT - TaxPerMonth, 1, '=');

            TakeHomePay := round(NetSalary - UnpaidLeaveDeduction - OtherDeduction, 1, '=');

            __Gaji := TakeHomePay;
        end;
    end;

    procedure calculateGajiGelondong(__PostingDate: Date; var GajiGelondongan: Decimal)
    var
        Gaji: Decimal;
        EmployeeGelondong: Record Employee;
    begin
        //ngitung gaji gelondongan
        GajiGelondongan := 0;
        EmployeeGelondong.Reset();
        EmployeeGelondong.SetRange(Status, EmployeeGelondong.Status::Active);
        EmployeeGelondong.FindFirst();
        repeat
            Gaji := 0;
            calculateGajiBersih(EmployeeGelondong."No.", __PostingDate, Gaji);
            GajiGelondongan := GajiGelondongan + Gaji;
        until EmployeeGelondong.Next() = 0;
    end;



    procedure PostCharging(ChargingHeader: Record "Employee Charging Header")
    var
        ChargingLineKosong: Record "Employee Charging Line";
        ChargingLineEmp: Record "Employee Charging Line";
        ChargingLineCopy: Record "Employee Charging Line";
        EmployeeProsesCharging: Record Employee;
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLineUpdateGelondong: Record "Gen. Journal Line";
        PayrollProcessedEntry: Record "Payroll Processed Entry";
        PayrollLedgerEntry: Record "Payroll Ledger Entry";
        PostedEmpChargingHeader: Record "Posted Employee Charg. Header";
        PostedEmpChargingLine: Record "Posted Employee Charging Line";

        SeveranceCair: Record "Severance Ledger Entry";
        THRCair: Record "THR Ledger Entry";
        //LeaveCair: Record "Sisa Cuti Accrual Ledger Entry";
        TanggalAwal: Date;
        TanggalAkhir: Date;
        DuitPisahCair: Decimal;
        DuitTHRCair: Decimal;
        DuitLeaveCair: Decimal;

        SisaPisah: Decimal;
        SisaPisahPorsi: Decimal;
        SisaTHR: Decimal;
        SisaTHRPorsi: Decimal;
        SisaLeave: Decimal;
        SisaLeavePorsi: Decimal;

        LineNo: Integer;
        __LineNoGelondong: Integer;
        AmountGelondongGenJnl: Decimal;
        GajiTotal: Decimal;
        GajiTHP: Decimal;
        TotalGajiTHP: Decimal;

        WindowPost1: Dialog;
        WindowPost2: Dialog;
        WindowPost3: Dialog;
        WindowPost4: Dialog;

        AdaSettinganKhusus: Boolean;
        HarusAdaCharging: Boolean;
        Tahun: Integer;
        Bulan: Integer;

        GrossSalary: Decimal;
        GrossSalaryPorsi: Decimal;

        AdjustmentProrate: Decimal;
        AdjustmentProratePorsi: Decimal;

        OvertimePorsi: Decimal;
        //OtherBenefits: Decimal;
        OtherBenefitsPorsi: Decimal;
        BPJSTKYCPPorsi: Decimal;
        BPJS_Kes_YCPPorsi: Decimal;
        AKDHKPorsi: Decimal;

        TaxPerMonth: Decimal;
        TotalTaxPerMonth: Decimal;
        TotalBPJS_TK_StaffPerMonth: Decimal;
        TotalBPJS_Kes_StaffPerMonth: Decimal;
        Total_AKDHK_PerMonth: Decimal;

        TotalIncome: Decimal;

        SeveranceAccrueAmount: Decimal;
        SeveranceAccrueAmountPorsi: Decimal;

        THRAccrueAmount: Decimal;
        THRAccrueAmountPorsi: Decimal;

        LeaveAccrueAmount: Decimal;
        LeaveAccrueAmountPorsi: Decimal;

        WelfareAccrueAmountPorsi: Decimal;

        SafeSecAccrueAmount: Decimal;
        SafeSecAccrueAmountPorsi: Decimal;

        THRAmount: Decimal;
        THRAmountPorsi: Decimal;
        THRTaxAmount: Decimal;
        THRTHPAmount: Decimal;
        TotalTHRTaxAmount: Decimal;
        TotalTHRTHPAmount: Decimal;

        PayrollLedgerEntryTHR: Record "Payroll Ledger Entry";
        EmployeeLastPayroll: Record Employee;
        Contract: Record "Position Ledger Entry";
        TaxPerYearLastPayroll: Decimal;

        UnpaidLeaveAmount: Decimal;
        TotalUnpaidLeaveAmount: Decimal;

        OtherDeductionAmount: Decimal;
        OtherDeductionAmountPorsi: Decimal;
        //TotalOtherDeductionAmount: Decimal;
        DetailedPayrollLedgerEntry: Record "Detailed Payroll Ledger Entry";
        Allowance: Record "Allowance Component";

        LessOverDeductTax: Decimal;

        LineNoGenJnl: Integer;
        Opsi: Enum "Journal Options";
        THRLedgerEntry: Record "THR Ledger Entry";
        PostedUnpaidLeave: Record "Posted Leave Request";

        THRStartingDate: Date;
        THREndingDate: Date;
        AccrualMgt: Codeunit "Accrual Management";
        EmployeeTHR: Record Employee;

        EmployeeSet: Record Employee;
        EmployeeKosong: Record Employee;
        Maxnye: Integer;
        JumlahYgAda: Integer;
        perpanjangan: Boolean;
    begin
        PayrollSetup.Get();
        PayrollSetup.TestField("Journal Template Name");
        PayrollSetup.TestField("Journal Batch Name");


        WindowPost1.Open('Posting first stage of general journals #1######');

        PayrollProcessedEntry.Get(ChargingHeader."Posting Date");

        TotalTaxPerMonth := 0;
        TotalBPJS_TK_StaffPerMonth := 0;
        TotalBPJS_Kes_StaffPerMonth := 0;
        Total_AKDHK_PerMonth := 0;
        TotalGajiTHP := 0;

        TotalTHRTaxAmount := 0;
        TotalTHRTHPAmount := 0;

        TotalUnpaidLeaveAmount := 0;
        //TotalOtherDeductionAmount := 0;

        THRStartingDate := CalcDate('-CM', ChargingHeader."Posting Date");
        THREndingDate := CalcDate('CM', ChargingHeader."Posting Date");

        //KELOMPOK JURNAL YANG PERTAMA
        EmployeeProsesCharging.Reset();
        //EmployeeProsesCharging.SetRange(Status, EmployeeProsesCharging.Status::Active);
        EmployeeProsesCharging.SetRange("Date Filter", ChargingHeader."Posting Date");
        EmployeeProsesCharging.SetRange(Status, EmployeeProsesCharging.Status::Active);
        EmployeeProsesCharging.FindFirst();
        //loop seluruh employee yg active, ...which is pasti gajian
        repeat
            WindowPost1.Update(1, EmployeeProsesCharging."No.");

            AdaSettinganKhusus := false;
            Clear(GrossSalary);
            Clear(AdjustmentProrate);

            //Clear(OtherBenefits);

            TaxPerMonth := 0;
            LessOverDeductTax := 0;

            PayrollLedgerEntry.Reset();
            PayrollLedgerEntry.SetRange("Employee No.", EmployeeProsesCharging."No.");
            PayrollLedgerEntry.SetRange("Payroll Processed Entry No.", PayrollProcessedEntry."Entry No.");
            if PayrollLedgerEntry.FindFirst() then begin

                GajiTHP := 0;
                TotalIncome := 0;

                THRTaxAmount := 0;
                THRTHPAmount := 0;
                THRAmount := 0;
                TaxPerYearLastPayroll := 0;

                UnpaidLeaveAmount := 0;

                OtherDeductionAmount := 0;

                PostedUnpaidLeave.Reset();
                PostedUnpaidLeave.SetRange("Employee No.", EmployeeProsesCharging."No.");
                PostedUnpaidLeave.SetRange("Payroll Ledger Entry No.",
                PayrollLedgerEntry."Entry No.");
                if PostedUnpaidLeave.FindFirst() then
                    UnpaidLeaveAmount := round(PostedUnpaidLeave."Salary Deduction", 1, '=');

                OtherDeductionAmount := PayrollLedgerEntry."Other Deduction";

                TotalUnpaidLeaveAmount := TotalUnpaidLeaveAmount + UnpaidLeaveAmount;
                //TotalOtherDeductionAmount := TotalOtherDeductionAmount + OtherDeductionAmount;

                THRLedgerEntry.Reset();
                THRLedgerEntry.SetRange("Employee No.", EmployeeProsesCharging."No.");
                THRLedgerEntry.SetRange("Posting Date", THRStartingDate, CalcDate('+1D', THREndingDate));
                THRLedgerEntry.SetRange("Disbursement Type", THRLedgerEntry."Disbursement Type"::Compensation);
                if THRLedgerEntry.FindFirst() then begin
                    THRAmount := THRLedgerEntry."THR Amount";

                    if PayrollLedgerEntryTHR.Get(THRLedgerEntry."Payroll Ledger Entry No.") then begin
                        EmployeeLastPayroll.Reset();
                        EmployeeLastPayroll.SetRange("No.", EmployeeProsesCharging."No.");
                        EmployeeLastPayroll.SetRange("Date Filter", PayrollLedgerEntryTHR."Posting Date");
                        EmployeeLastPayroll.FindFirst();
                        EmployeeLastPayroll.CalcFields("MSI_HRIS Tax Per Year");
                        TaxPerYearLastPayroll := EmployeeLastPayroll."MSI_HRIS Tax Per Year";

                        EmployeeTHR.Reset();
                        EmployeeTHR.SetRange("No.", THRLedgerEntry."Employee No.");
                        EmployeeTHR.SetRange("Date Filter", THRLedgerEntry."Posting Date");
                        EmployeeTHR.FindFirst();

                        EmployeeTHR.CalcFields("MSI_HRIS Tax Per Year THR");

                        //Message('No=%1 TaxPerYear=%2', EmployeeTHR."No.",
                        //EmployeeTHR."MSI_HRIS Tax Per Year THR");

                        if not EmployeeProsesCharging."MSI_HRIS Last Payroll" then begin
                            if EmployeeTHR."MSI_HRIS Tax Per Year THR" > 0 then
                                THRTaxAmount := EmployeeTHR."MSI_HRIS Tax Per Year THR" - TaxPerYearLastPayroll
                            else
                                THRTaxAmount := 0;
                        end else
                            THRTaxAmount := 0;

                        THRTHPAmount := round(THRAmount - THRTaxAmount, 1, '=');

                        TotalTHRTaxAmount := TotalTHRTaxAmount + THRTaxAmount;
                        TotalTHRTHPAmount := TotalTHRTHPAmount + THRTHPAmount;
                    end;
                end else begin
                    THRLedgerEntry.SetRange("Disbursement Type", THRLedgerEntry."Disbursement Type"::"With Non Muslim Disbursement");
                    THRLedgerEntry.SetRange("Posting Date", CalcDate('+20D', THRStartingDate), CalcDate('+20D', THREndingDate));
                    if THRLedgerEntry.FindFirst() then begin
                        THRAmount := THRLedgerEntry."THR Amount";

                        if PayrollLedgerEntryTHR.Get(THRLedgerEntry."Payroll Ledger Entry No.") then begin
                            EmployeeLastPayroll.Reset();
                            EmployeeLastPayroll.SetRange("No.", EmployeeProsesCharging."No.");
                            EmployeeLastPayroll.SetRange("Date Filter", PayrollLedgerEntryTHR."Posting Date");
                            EmployeeLastPayroll.FindFirst();
                            EmployeeLastPayroll.CalcFields("MSI_HRIS Tax Per Year");
                            TaxPerYearLastPayroll := EmployeeLastPayroll."MSI_HRIS Tax Per Year";

                            EmployeeTHR.Reset();
                            EmployeeTHR.SetRange("No.", THRLedgerEntry."Employee No.");
                            EmployeeTHR.SetRange("Date Filter", THRLedgerEntry."Posting Date");
                            EmployeeTHR.FindFirst();

                            EmployeeTHR.CalcFields("MSI_HRIS Tax Per Year THR");

                            //Message('No=%1 TaxPerYear=%2', EmployeeTHR."No.",
                            //EmployeeTHR."MSI_HRIS Tax Per Year THR");

                            if not EmployeeProsesCharging."MSI_HRIS Last Payroll" then begin
                                if EmployeeTHR."MSI_HRIS Tax Per Year THR" > 0 then
                                    THRTaxAmount := EmployeeTHR."MSI_HRIS Tax Per Year THR" - TaxPerYearLastPayroll
                                else
                                    THRTaxAmount := 0;
                            end else
                                THRTaxAmount := 0;

                            THRTHPAmount := round(THRAmount - THRTaxAmount, 1, '=');

                            TotalTHRTaxAmount := TotalTHRTaxAmount + THRTaxAmount;
                            TotalTHRTHPAmount := TotalTHRTHPAmount + THRTHPAmount;
                        end;
                    end else begin
                        THRLedgerEntry.SetRange("Disbursement Type", THRLedgerEntry."Disbursement Type"::"With Muslim Disbursement");
                        if THRLedgerEntry.FindFirst() then begin
                            THRAmount := THRLedgerEntry."THR Amount";

                            if PayrollLedgerEntryTHR.Get(THRLedgerEntry."Payroll Ledger Entry No.") then begin
                                EmployeeLastPayroll.Reset();
                                EmployeeLastPayroll.SetRange("No.", EmployeeProsesCharging."No.");
                                EmployeeLastPayroll.SetRange("Date Filter", PayrollLedgerEntryTHR."Posting Date");
                                EmployeeLastPayroll.FindFirst();
                                EmployeeLastPayroll.CalcFields("MSI_HRIS Tax Per Year");
                                TaxPerYearLastPayroll := EmployeeLastPayroll."MSI_HRIS Tax Per Year";

                                EmployeeTHR.Reset();
                                EmployeeTHR.SetRange("No.", THRLedgerEntry."Employee No.");
                                EmployeeTHR.SetRange("Date Filter", THRLedgerEntry."Posting Date");
                                EmployeeTHR.FindFirst();

                                EmployeeTHR.CalcFields("MSI_HRIS Tax Per Year THR");

                                //Message('No=%1 TaxPerYear=%2', EmployeeTHR."No.",
                                //EmployeeTHR."MSI_HRIS Tax Per Year THR");

                                if not EmployeeProsesCharging."MSI_HRIS Last Payroll" then begin
                                    if EmployeeTHR."MSI_HRIS Tax Per Year THR" > 0 then
                                        THRTaxAmount := EmployeeTHR."MSI_HRIS Tax Per Year THR" - TaxPerYearLastPayroll
                                    else
                                        THRTaxAmount := 0;
                                end else
                                    THRTaxAmount := 0;

                                THRTHPAmount := round(THRAmount - THRTaxAmount, 1, '=');

                                TotalTHRTaxAmount := TotalTHRTaxAmount + THRTaxAmount;
                                TotalTHRTHPAmount := TotalTHRTHPAmount + THRTHPAmount;
                            end;
                        end;
                    end;
                end;

                LessOverDeductTax := PayrollLedgerEntry."Less/Over Deduct Tax";
                GrossSalary := PayrollLedgerEntry."Basic Salary";
                AdjustmentProrate := PayrollLedgerEntry."Adjustment Prorate";

                EmployeeProsesCharging.CalcFields("MSI_HRIS Overtime");
                EmployeeProsesCharging.CalcFields("MSI_HRIS Total Allowance Fix");
                EmployeeProsesCharging.CalcFields("MSI_HRIS Total Allownc. NonFix");

                //OtherBenefits := EmployeeProsesCharging."MSI_HRIS Total Allowance Fix" + EmployeeProsesCharging."MSI_HRIS Total Allownc. NonFix";

                EmployeeProsesCharging.CalcFields("MSI_HRIS BPJS TK Paid by YCP");
                EmployeeProsesCharging.CalcFields("MSI_HRIS BPJS Kes. Paid by YCP");
                EmployeeProsesCharging.CalcFields("MSI_HRIS AKDHK Paid by YCP");

                EmployeeProsesCharging.CalcFields("MSI_HRIS BPJS TK YCP Staff");
                EmployeeProsesCharging.CalcFields("MSI_HRIS BPJS Kes. YCP Staff");

                EmployeeProsesCharging.CalcFields("MSI_HRIS Tax Per Year");

                TotalBPJS_TK_StaffPerMonth := TotalBPJS_TK_StaffPerMonth +
                EmployeeProsesCharging."MSI_HRIS BPJS TK YCP Staff";

                TotalBPJS_Kes_StaffPerMonth := TotalBPJS_Kes_StaffPerMonth +
                EmployeeProsesCharging."MSI_HRIS BPJS Kes. YCP Staff";

                if not EmployeeProsesCharging."MSI_HRIS Last Payroll" then
                    if PayrollLedgerEntry."Periode Penghasilan" <> 0 then
                        TaxPerMonth := Round(EmployeeProsesCharging."MSI_HRIS Tax Per Year" /
                                                PayrollLedgerEntry."Periode Penghasilan", 1)
                    else
                        TaxPerMonth := 0
                else
                    TaxPerMonth := LessOverDeductTax;

                TotalTaxPerMonth := TotalTaxPerMonth + TaxPerMonth;

                //kalkulasi THP
                calculateGajiBersih(EmployeeProsesCharging."No.", ChargingHeader."Posting Date",
                                    GajiTHP);

                TotalGajiTHP := TotalGajiTHP + GajiTHP;

                //cek dulu di charging, apa employee disetting khusus
                ChargingLineEmp.Reset();
                ChargingLineEmp.SetRange("Document No.", ChargingHeader."No.");
                ChargingLineEmp.SetRange("Employee No.", EmployeeProsesCharging."No.");
                if ChargingLineEmp.FindSet() then begin

                    AdaSettinganKhusus := true;

                    repeat

                        GrossSalaryPorsi := 0;
                        AdjustmentProratePorsi := 0;
                        OvertimePorsi := 0;

                        BPJSTKYCPPorsi := 0;
                        BPJS_Kes_YCPPorsi := 0;
                        AKDHKPorsi := 0;

                        THRAmountPorsi := 0;

                        OtherDeductionAmountPorsi := 0;

                        //kalkulasi other deduction
                        OtherDeductionAmountPorsi := (ChargingLineEmp.Percentage / 100) * OtherDeductionAmount;

                        //kalkulasi gross salary
                        GrossSalaryPorsi := (ChargingLineEmp.Percentage / 100) * GrossSalary;

                        //kalkulasi adjustment prorate
                        AdjustmentProratePorsi := (ChargingLineEmp.Percentage / 100) * AdjustmentProrate;

                        //kalkulasi overtime
                        OvertimePorsi := (ChargingLineEmp.Percentage / 100) * EmployeeProsesCharging."MSI_HRIS Overtime";

                        //kalkulasi other benefits

                        //Loop query di sini
                        //insert untuk other benefits
                        DetailedPayrollLedgerEntry.Reset();
                        DetailedPayrollLedgerEntry.SetRange("Employee No.", ChargingLineEmp."Employee No.");
                        DetailedPayrollLedgerEntry.SetRange(Type, DetailedPayrollLedgerEntry.Type::Allowance);
                        DetailedPayrollLedgerEntry.SetFilter("Allowance Type", '1|2');
                        DetailedPayrollLedgerEntry.SetRange("Posting Date", ChargingHeader."Posting Date");
                        if DetailedPayrollLedgerEntry.FindFirst() then
                            repeat
                                OtherBenefitsPorsi := 0;

                                OtherBenefitsPorsi := (ChargingLineEmp.Percentage / 100) * DetailedPayrollLedgerEntry.Amount;
                                Allowance.Get(DetailedPayrollLedgerEntry."Component Code");

                                if OtherBenefitsPorsi <> 0 then
                                    insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
                                    OtherBenefitsPorsi, ChargingLineEmp, false, LineNoGenJnl, EmployeeProsesCharging."No.",
                                    Opsi::"Other Benefits", Allowance.Name, false);

                            until DetailedPayrollLedgerEntry.Next() = 0;

                        //kalkulasi BPJS TK YCP
                        BPJSTKYCPPorsi := (ChargingLineEmp.Percentage / 100) * EmployeeProsesCharging."MSI_HRIS BPJS TK Paid by YCP";

                        //kalkulasi BPJS Kesehatan YCP
                        BPJS_Kes_YCPPorsi := (ChargingLineEmp.Percentage / 100) * EmployeeProsesCharging."MSI_HRIS BPJS Kes. Paid by YCP";

                        //kalkulasi AKDHK YCP
                        AKDHKPorsi := (ChargingLineEmp.Percentage / 100) * EmployeeProsesCharging."MSI_HRIS AKDHK Paid by YCP";

                        //kalkulasi THR Amount
                        THRAmountPorsi := (ChargingLineEmp.Percentage / 100) * THRAmount;


                        //insert untuk other deduction
                        if OtherDeductionAmountPorsi <> 0 then
                            insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
                            OtherDeductionAmountPorsi, ChargingLineEmp, true, LineNoGenJnl, EmployeeProsesCharging."No.",
                            Opsi::"Other Deduction", '', false);


                        //insert untuk gross salary
                        if GrossSalaryPorsi <> 0 then
                            insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
                            GrossSalaryPorsi, ChargingLineEmp, false, LineNoGenJnl, EmployeeProsesCharging."No.",
                            Opsi::"Gross Salary", '', false);

                        //insert untuk adjustment prorate
                        if AdjustmentProratePorsi <> 0 then
                            insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
                            AdjustmentProratePorsi, ChargingLineEmp, false, LineNoGenJnl, EmployeeProsesCharging."No.",
                            Opsi::"Adjustment Prorate", '', false);

                        //insert untuk overtime
                        if OvertimePorsi <> 0 then
                            insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
                            OvertimePorsi, ChargingLineEmp, false, LineNoGenJnl, EmployeeProsesCharging."No.",
                            Opsi::Overtime, '', false);


                        //insert untuk BPJS TK YCP
                        if BPJSTKYCPPorsi <> 0 then
                            insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
                            BPJSTKYCPPorsi, ChargingLineEmp, false, LineNoGenJnl, EmployeeProsesCharging."No.",
                            Opsi::"BPJS TK", '', false);

                        //insert untuk BPJS Kesehatan YCP
                        if BPJS_Kes_YCPPorsi <> 0 then
                            insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
                            BPJS_Kes_YCPPorsi, ChargingLineEmp, false, LineNoGenJnl, EmployeeProsesCharging."No.",
                            Opsi::"BPJS Health", '', false);

                        //insert untuk AKDHK YCP
                        if AKDHKPorsi <> 0 then
                            insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
                            AKDHKPorsi, ChargingLineEmp, false, LineNoGenJnl, EmployeeProsesCharging."No.",
                            Opsi::"AKDHK Debit", '', false);

                        //insert untuk THR Amount
                        if THRAmountPorsi <> 0 then
                            insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
                            THRAmountPorsi, ChargingLineEmp, false, LineNoGenJnl, EmployeeProsesCharging."No.",
                            Opsi::"THR Amount", '', false);

                        Total_AKDHK_PerMonth := Total_AKDHK_PerMonth + AKDHKPorsi;

                    until ChargingLineEmp.Next() = 0;
                end;

                //kalo di charging ngga ada settingan khusus, maka masuk ke sini...settingan umum
                if not AdaSettinganKhusus then begin
                    ChargingLineKosong.Reset();
                    ChargingLineKosong.SetRange("Document No.", ChargingHeader."No.");
                    ChargingLineKosong.SetRange("Employee No.", '');
                    if ChargingLineKosong.FindSet() then begin

                        repeat

                            GrossSalaryPorsi := 0;
                            AdjustmentProratePorsi := 0;
                            OvertimePorsi := 0;
                            OtherBenefitsPorsi := 0;
                            BPJSTKYCPPorsi := 0;
                            BPJS_Kes_YCPPorsi := 0;
                            AKDHKPorsi := 0;

                            THRAmountPorsi := 0;

                            OtherDeductionAmountPorsi := 0;

                            //kalkulasi other deduction
                            OtherDeductionAmountPorsi := (ChargingLineKosong.Percentage / 100) * OtherDeductionAmount;

                            //kalkulasi gross salary
                            GrossSalaryPorsi := (ChargingLineKosong.Percentage / 100) * GrossSalary;

                            //kalkulasi adjustment prorate
                            AdjustmentProratePorsi := (ChargingLineKosong.Percentage / 100) * AdjustmentProrate;

                            //kalkulasi overtime
                            OvertimePorsi := (ChargingLineKosong.Percentage / 100) * EmployeeProsesCharging."MSI_HRIS Overtime";

                            //Loop query di sini
                            //kalkulasi other benefits
                            //OtherBenefitsPorsi := (ChargingLineKosong.Percentage / 100) * OtherBenefits;
                            //insert untuk other benefits
                            if OtherBenefitsPorsi <> 0 then
                                insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
                                OtherBenefitsPorsi, ChargingLineKosong, false, LineNoGenJnl, EmployeeProsesCharging."No.",
                                Opsi::"Other Benefits", '', false);


                            //kalkulasi BPJS TK YCP
                            BPJSTKYCPPorsi := (ChargingLineKosong.Percentage / 100) * EmployeeProsesCharging."MSI_HRIS BPJS TK Paid by YCP";

                            //kalkulasi BPJS Kesehatan YCP
                            BPJS_Kes_YCPPorsi := (ChargingLineKosong.Percentage / 100) * EmployeeProsesCharging."MSI_HRIS BPJS Kes. Paid by YCP";

                            //kalkulasi AKDHK YCP
                            AKDHKPorsi := (ChargingLineKosong.Percentage / 100) * EmployeeProsesCharging."MSI_HRIS AKDHK Paid by YCP";

                            //kalkulasi THR Amount
                            THRAmountPorsi := (ChargingLineKosong.Percentage / 100) * THRAmount;


                            //insert untuk other deduction
                            if OtherDeductionAmountPorsi <> 0 then
                                insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
                                OtherDeductionAmountPorsi, ChargingLineKosong, true, LineNoGenJnl, EmployeeProsesCharging."No.",
                                Opsi::"Other Deduction", '', false);

                            //insert untuk gross salary
                            if GrossSalaryPorsi <> 0 then
                                insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
                                GrossSalaryPorsi, ChargingLineKosong, false, LineNoGenJnl, EmployeeProsesCharging."No.",
                                Opsi::"Gross Salary", '', false);

                            //insert untuk gross salary
                            if AdjustmentProratePorsi <> 0 then
                                insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
                                AdjustmentProratePorsi, ChargingLineKosong, false, LineNoGenJnl, EmployeeProsesCharging."No.",
                                Opsi::"Adjustment Prorate", '', false);

                            //insert untuk gross overtime
                            if OvertimePorsi <> 0 then
                                insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
                                OvertimePorsi, ChargingLineKosong, false, LineNoGenJnl, EmployeeProsesCharging."No.",
                                Opsi::Overtime, '', false);


                            //insert untuk BPJS TK YCP
                            if BPJSTKYCPPorsi <> 0 then
                                insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
                                BPJSTKYCPPorsi, ChargingLineKosong, false, LineNoGenJnl, EmployeeProsesCharging."No.",
                                Opsi::"BPJS TK", '', false);

                            //insert untuk BPJS Kesehatan YCP
                            if BPJS_Kes_YCPPorsi <> 0 then
                                insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
                                BPJS_Kes_YCPPorsi, ChargingLineKosong, false, LineNoGenJnl, EmployeeProsesCharging."No.",
                                Opsi::"BPJS Health", '', false);

                            //insert untuk AKDHK YCP
                            if AKDHKPorsi <> 0 then
                                insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
                                AKDHKPorsi, ChargingLineKosong, false, LineNoGenJnl, EmployeeProsesCharging."No.",
                                Opsi::"AKDHK Debit", '', false);

                            //insert untuk THR Amount
                            if THRAmountPorsi <> 0 then
                                insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
                                THRAmountPorsi, ChargingLineKosong, false, LineNoGenJnl, EmployeeProsesCharging."No.",
                                Opsi::"THR Amount", '', false);


                            Total_AKDHK_PerMonth := Total_AKDHK_PerMonth + AKDHKPorsi;

                        until ChargingLineKosong.Next() = 0;
                    end;
                end;
            end;
        until EmployeeProsesCharging.Next() = 0;

        WindowPost1.Close();


        WindowPost2.Open('Posting second stage of general journals...');

        //insert total unpaid leave di sini, di bagian kredit
        if TotalUnpaidLeaveAmount <> 0 then
            insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
            TotalUnpaidLeaveAmount, ChargingLineKosong, true, LineNoGenJnl, EmployeeProsesCharging."No.",
            Opsi::"Unpaid Leave", '', false);

        //insert total other deduction di sini, di bagian kredit
        //if TotalOtherDeductionAmount <> 0 then
        //insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
        //TotalOtherDeductionAmount, ChargingLineKosong, true, LineNoGenJnl, EmployeeProsesCharging."No.",
        //SOpsi::"Other Deduction");


        //insert untuk Total tax monthly
        if TotalTaxPerMonth <> 0 then
            insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
            TotalTaxPerMonth, ChargingLineKosong, true, LineNoGenJnl, EmployeeProsesCharging."No.",
            Opsi::Tax, '', false);

        //insert untuk Total BPJS TK paid by YCP Staff portion
        if TotalBPJS_TK_StaffPerMonth <> 0 then
            insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
            TotalBPJS_TK_StaffPerMonth, ChargingLineKosong, true, LineNoGenJnl, EmployeeProsesCharging."No.",
            Opsi::"BPJS TK Staff", '', false);

        //insert untuk Total BPJS Kesehatan paid by YCP Staff portion
        if TotalBPJS_Kes_StaffPerMonth <> 0 then
            insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
            TotalBPJS_Kes_StaffPerMonth, ChargingLineKosong, true, LineNoGenJnl, EmployeeProsesCharging."No.",
            Opsi::"BPJS Health Staff", '', false);

        //insert untuk Total AKDHK Paid by YCP
        if Total_AKDHK_PerMonth <> 0 then
            insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
            Total_AKDHK_PerMonth, ChargingLineKosong, true, LineNoGenJnl, EmployeeProsesCharging."No.",
            Opsi::"AKDHK Credit", '', false);

        //insert untuk Total THP
        if TotalGajiTHP <> 0 then
            insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
            TotalGajiTHP, ChargingLineKosong, true, LineNoGenJnl, EmployeeProsesCharging."No.",
            Opsi::THP, '', false);

        //insert untuk Total tax THR
        //Error('Oi=%1', TotalTHRTaxAmount);
        if TotalTHRTaxAmount <> 0 then
            insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
            TotalTHRTaxAmount, ChargingLineKosong, true, LineNoGenJnl, EmployeeProsesCharging."No.",
            Opsi::"THR Tax", '', false);

        //insert untuk total thp thr
        if TotalTHRTHPAmount <> 0 then
            insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
            TotalTHRTHPAmount, ChargingLineKosong, true, LineNoGenJnl, EmployeeProsesCharging."No.",
            Opsi::"THR THP", '', false);

        WindowPost2.Close();


        WindowPost3.Open('Posting third stage of general journals #1######');

        //KELOMPOK JURNAL YANG KEDUA
        //DI JURNAL DENGAN BATCH TERPISAH. SUDAH DIATUR PADA SAAT INSERT KE GEN JOURNAL
        PayrollSetup.TestField("Charg. Welfare Amount");

        EmployeeProsesCharging.Reset();
        //EmployeeProsesCharging.SetRange(Status, EmployeeProsesCharging.Status::Active);
        EmployeeProsesCharging.SetRange("Date Filter", ChargingHeader."Posting Date");
        EmployeeProsesCharging.FindFirst();
        //loop seluruh employee yg active, ...which is pasti gajian
        repeat
            WindowPost3.Update(1, EmployeeProsesCharging."No.");

            AdaSettinganKhusus := false;

            PayrollLedgerEntry.Reset();
            PayrollLedgerEntry.SetRange("Employee No.", EmployeeProsesCharging."No.");
            PayrollLedgerEntry.SetRange("Payroll Processed Entry No.", PayrollProcessedEntry."Entry No.");
            if PayrollLedgerEntry.FindFirst() then begin

                Clear(Maxnye);
                Clear(JumlahYgAda);

                AccrualMgt.AmbilMaxAccrual(EmployeeProsesCharging."No.", ChargingHeader."Posting Date Charging", Maxnye);
                AccrualMgt.JumlahAccrual(EmployeeProsesCharging, ChargingHeader."Posting Date Charging", JumlahYgAda);


                SeveranceAccrueAmount := 0;
                THRAccrueAmount := 0;
                LeaveAccrueAmount := 0;
                SafeSecAccrueAmount := 0;

                EmployeeProsesCharging.CalcFields("MSI_HRIS Total Allowance Fix");

                TotalIncome := PayrollLedgerEntry."Basic Salary" + EmployeeProsesCharging."MSI_HRIS Total Allowance Fix";

                SeveranceAccrueAmount := TotalIncome / 12;
                THRAccrueAmount := TotalIncome / 12;
                LeaveAccrueAmount := (TotalIncome / 21) * 1.25;

                SafeSecAccrueAmount := 0.02 * TotalIncome;

                //Di sini insert ke ledger masing-masing
                //Cek dulu, apakah contract sudah habis/resign. Jika demikian, maka tidak perlu pencadangan.
                Contract.Reset();
                Contract.SetRange("Employee No.", EmployeeProsesCharging."No.");
                Contract.FindLast();

                AccrualMgt.PencandanganSeverance(EmployeeProsesCharging, ChargingHeader."Posting Date",
                SeveranceAccrueAmount, PayrollLedgerEntry."Entry No.", ChargingHeader."No.");

                //------dipindah ke bawah
                if not AccrualMgt.Employeediperpanjang(EmployeeProsesCharging, ChargingHeader."Posting Date", perpanjangan) then
                    AccrualMgt.PencadanganLeave(EmployeeProsesCharging, ChargingHeader."Posting Date",
                    LeaveAccrueAmount, PayrollLedgerEntry."Entry No.", ChargingHeader."No.");

                AccrualMgt.PencandanganTHR(EmployeeProsesCharging, ChargingHeader."Posting Date",
                THRAccrueAmount, PayrollLedgerEntry."Entry No.", ChargingHeader."No.");

                AccrualMgt.PencandanganSafetySecurityWelfare(EmployeeProsesCharging, ChargingHeader."Posting Date",
                SafeSecAccrueAmount, PayrollLedgerEntry."Entry No.", true, ChargingHeader."No.");

                AccrualMgt.PencandanganSafetySecurityWelfare(EmployeeProsesCharging, ChargingHeader."Posting Date",
                PayrollSetup."Charg. Welfare Amount", PayrollLedgerEntry."Entry No.", false, ChargingHeader."No.");


                //ini untuk kelompok jurnal reverse THR, Severance, dan Leave
                Clear(DuitLeaveCair);
                Clear(DuitPisahCair);
                Clear(DuitTHRCair);
                Clear(SisaLeave);
                Clear(SisaPisah);
                Clear(SisaTHR);

                TanggalAwal := CalcDate('-CM', ChargingHeader."Posting Date");
                TanggalAkhir := CalcDate('CM', ChargingHeader."Posting Date");

                //reverse severance dan leave
                SeveranceCair.Reset();
                SeveranceCair.SetRange("Employee No.", EmployeeProsesCharging."No.");
                SeveranceCair.SetRange("Posting Date", TanggalAwal, TanggalAkhir);
                SeveranceCair.SetRange(Finished, true);
                if SeveranceCair.FindFirst() then begin
                    DuitLeaveCair := SeveranceCair."Unused Leave Amount";
                    DuitPisahCair := SeveranceCair."Severance Amount";
                end;

                //severance
                //if DuitPisahCair > 0 then
                AccrualMgt.AmbilHangusUntukReverse(EmployeeProsesCharging."No.", 0, DuitPisahCair,
                SisaPisah, ChargingHeader."No.");

                //leave
                //if DuitLeaveCair > 0 then
                AccrualMgt.AmbilHangusUntukReverse(EmployeeProsesCharging."No.", 2, DuitLeaveCair,
                SisaLeave, ChargingHeader."No.");

                //reverse thr
                THRCair.Reset();
                THRCair.SetRange("Employee No.", EmployeeProsesCharging."No.");
                THRCair.SetRange("Posting Date", TanggalAwal, TanggalAkhir);
                if THRCair.FindFirst() then
                    repeat
                        DuitTHRCair := DuitTHRCair + THRCair."THR Amount";
                    until THRCair.Next() = 0;

                //thr
                //if DuitTHRCair > 0 then
                AccrualMgt.AmbilHangusUntukReverse(EmployeeProsesCharging."No.", 1, DuitTHRCair,
                SisaTHR, ChargingHeader."No.");

                //----pindahan dr atas
                if AccrualMgt.Employeediperpanjang(EmployeeProsesCharging, ChargingHeader."Posting Date", perpanjangan) then
                    AccrualMgt.PencadanganLeavePerpanjang(EmployeeProsesCharging, ChargingHeader."Posting Date",
                                    LeaveAccrueAmount, PayrollLedgerEntry."Entry No.", ChargingHeader."No.");

                //cek dulu di charging, apa employee disetting khusus
                ChargingLineEmp.Reset();
                ChargingLineEmp.SetRange("Document No.", ChargingHeader."No.");
                ChargingLineEmp.SetRange("Employee No.", EmployeeProsesCharging."No.");
                if ChargingLineEmp.FindSet() then begin

                    AdaSettinganKhusus := true;

                    repeat

                        SeveranceAccrueAmountPorsi := 0;
                        LeaveAccrueAmountPorsi := 0;
                        THRAccrueAmountPorsi := 0;

                        SisaLeavePorsi := 0;
                        SisaPisahPorsi := 0;
                        SisaTHRPorsi := 0;

                        SisaPisahPorsi := (ChargingLineEmp.Percentage / 100) * SisaPisah;
                        SisaLeavePorsi := (ChargingLineEmp.Percentage / 100) * SisaLeave;
                        SisaTHRPorsi := (ChargingLineEmp.Percentage / 100) * SisaTHR;

                        //insert untuk debit dari reverse sisa uang pisah
                        if SisaPisahPorsi <> 0 then
                            insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
                            SisaPisahPorsi, ChargingLineEmp, false, LineNoGenJnl, EmployeeProsesCharging."No.",
                            Opsi::"Severance Accrue Charging", '', true);


                        //insert untuk debit dari reverse sisa leave
                        if SisaLeavePorsi <> 0 then
                            insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
                            SisaLeavePorsi, ChargingLineEmp, false, LineNoGenJnl, EmployeeProsesCharging."No.",
                            Opsi::"Leave Accrue Charging", '', true);

                        //insert untuk debit dari reverse sisa thr
                        if SisaTHRPorsi <> 0 then
                            insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
                            SisaTHRPorsi, ChargingLineEmp, false, LineNoGenJnl, EmployeeProsesCharging."No.",
                            Opsi::"THR Accrue Charging", '', true);


                        WelfareAccrueAmountPorsi := 0;
                        SafeSecAccrueAmountPorsi := 0;

                        //kalkulasi severance accrue porsian
                        SeveranceAccrueAmountPorsi := (ChargingLineEmp.Percentage / 100) * SeveranceAccrueAmount;

                        //kalkulasi leave accrue porsian
                        LeaveAccrueAmountPorsi := (ChargingLineEmp.Percentage / 100) * LeaveAccrueAmount;

                        //kalkulasi THR accrue porsian
                        THRAccrueAmountPorsi := (ChargingLineEmp.Percentage / 100) * THRAccrueAmount;

                        //kalkulasi welfare porsian
                        WelfareAccrueAmountPorsi := (ChargingLineEmp.Percentage / 100) * PayrollSetup."Charg. Welfare Amount";

                        //kalkulasi safe and securitu porsion
                        SafeSecAccrueAmountPorsi := (ChargingLineEmp.Percentage / 100) * SafeSecAccrueAmount;

                        //insert untuk Severance accrual yg porsian
                        if SeveranceAccrueAmountPorsi <> 0 then
                            insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
                            SeveranceAccrueAmountPorsi, ChargingLineEmp, false, LineNoGenJnl, EmployeeProsesCharging."No.",
                            Opsi::"Severance Accrue Charging", '', false);


                        //if EmployeeProsesCharging."No." = 'E0016' then
                        //Message('Maxnye=%1 JumlahYgAda=%2', Maxnye, JumlahYgAda);

                        //insert untuk leave accrual yg porsian                        
                        if (LeaveAccrueAmountPorsi <> 0) and ((JumlahYgAda < Maxnye) or perpanjangan) then begin

                            //if EmployeeProsesCharging."No." = 'E0001' then
                            //Message('nulis ke journal');

                            insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
                            LeaveAccrueAmountPorsi, ChargingLineEmp, false, LineNoGenJnl, EmployeeProsesCharging."No.",
                            Opsi::"Leave Accrue Charging", '', false);
                        end;


                        //insert untuk thr accrual yg porsian
                        if THRAccrueAmountPorsi <> 0 then
                            insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
                            THRAccrueAmountPorsi, ChargingLineEmp, false, LineNoGenJnl, EmployeeProsesCharging."No.",
                            Opsi::"THR Accrue Charging", '', false);

                        //insert untuk welfare accrual yg porsian
                        if WelfareAccrueAmountPorsi <> 0 then
                            insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
                            WelfareAccrueAmountPorsi, ChargingLineEmp, false, LineNoGenJnl, EmployeeProsesCharging."No.",
                            Opsi::"Welfare Accrue Charging", '', false);

                        //insert untuk safe security accrual yg porsian
                        if SafeSecAccrueAmountPorsi <> 0 then
                            insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
                            SafeSecAccrueAmountPorsi, ChargingLineEmp, false, LineNoGenJnl, EmployeeProsesCharging."No.",
                            Opsi::"Safety & Security Accrue Charging", '', false);


                    until ChargingLineEmp.Next() = 0;
                end;


                if not AdaSettinganKhusus then begin

                    ChargingLineKosong.Reset();
                    ChargingLineKosong.SetRange("Document No.", ChargingHeader."No.");
                    ChargingLineKosong.SetRange("Employee No.", '');
                    if ChargingLineKosong.FindSet() then begin
                        repeat

                            SeveranceAccrueAmountPorsi := 0;
                            LeaveAccrueAmountPorsi := 0;
                            THRAccrueAmountPorsi := 0;

                            SisaLeavePorsi := 0;
                            SisaPisahPorsi := 0;
                            SisaTHRPorsi := 0;

                            SisaPisahPorsi := (ChargingLineKosong.Percentage / 100) * SisaPisah;
                            SisaLeavePorsi := (ChargingLineKosong.Percentage / 100) * SisaLeave;
                            SisaTHRPorsi := (ChargingLineKosong.Percentage / 100) * SisaTHR;

                            //insert untuk debit dari reverse sisa uang pisah
                            if SisaPisahPorsi <> 0 then
                                insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
                                SisaPisahPorsi, ChargingLineKosong, false, LineNoGenJnl, EmployeeProsesCharging."No.",
                                Opsi::"Severance Accrue Charging", '', true);

                            //insert untuk debit dari reverse sisa leave
                            if SisaLeavePorsi <> 0 then
                                insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
                                SisaLeavePorsi, ChargingLineKosong, false, LineNoGenJnl, EmployeeProsesCharging."No.",
                                Opsi::"Leave Accrue Charging", '', true);

                            //insert untuk debit dari reverse sisa thr
                            if SisaTHRPorsi <> 0 then
                                insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
                                SisaTHRPorsi, ChargingLineKosong, false, LineNoGenJnl, EmployeeProsesCharging."No.",
                                Opsi::"THR Accrue Charging", '', true);

                            WelfareAccrueAmountPorsi := 0;
                            SafeSecAccrueAmountPorsi := 0;

                            //kalkulasi severance accrue porsian
                            SeveranceAccrueAmountPorsi := (ChargingLineKosong.Percentage / 100) * SeveranceAccrueAmount;

                            //kalkulasi leave accrue porsian
                            LeaveAccrueAmountPorsi := (ChargingLineKosong.Percentage / 100) * LeaveAccrueAmount;

                            //kalkulasi THR accrue porsian
                            THRAccrueAmountPorsi := (ChargingLineKosong.Percentage / 100) * THRAccrueAmount;

                            //kalkulasi welfare porsian
                            WelfareAccrueAmountPorsi := (ChargingLineKosong.Percentage / 100) * PayrollSetup."Charg. Welfare Amount";

                            //kalkulasi safe and securitu porsion
                            SafeSecAccrueAmountPorsi := (ChargingLineKosong.Percentage / 100) * SafeSecAccrueAmount;

                            //insert untuk Severance accrual yg porsian
                            if SeveranceAccrueAmountPorsi <> 0 then
                                insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
                                SeveranceAccrueAmountPorsi, ChargingLineKosong, false, LineNoGenJnl, EmployeeProsesCharging."No.",
                                Opsi::"Severance Accrue Charging", '', false);


                            //insert untuk leave accrual yg porsian
                            if (LeaveAccrueAmountPorsi <> 0) and (JumlahYgAda < Maxnye) then
                                insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
                                LeaveAccrueAmountPorsi, ChargingLineKosong, false, LineNoGenJnl, EmployeeProsesCharging."No.",
                                Opsi::"Leave Accrue Charging", '', false);

                            //insert untuk thr accrual yg porsian
                            if THRAccrueAmountPorsi <> 0 then
                                insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
                                THRAccrueAmountPorsi, ChargingLineKosong, false, LineNoGenJnl, EmployeeProsesCharging."No.",
                                Opsi::"THR Accrue Charging", '', false);

                            //insert untuk welfare accrual yg porsian
                            if WelfareAccrueAmountPorsi <> 0 then
                                insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
                                WelfareAccrueAmountPorsi, ChargingLineKosong, false, LineNoGenJnl, EmployeeProsesCharging."No.",
                                Opsi::"Welfare Accrue Charging", '', false);

                            //insert untuk safe security accrual yg porsian
                            if SafeSecAccrueAmountPorsi <> 0 then
                                insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
                                SafeSecAccrueAmountPorsi, ChargingLineKosong, false, LineNoGenJnl, EmployeeProsesCharging."No.",
                                Opsi::"Safety & Security Accrue Charging", '', false);

                        until ChargingLineKosong.Next() = 0;
                    end;

                end;


                //insert untuk credit dari reverse sisa uang pisah
                if SisaPisah <> 0 then
                    insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
                    SisaPisah, ChargingLineEmp, true, LineNoGenJnl, EmployeeProsesCharging."No.",
                    Opsi::"Severance Accrue", '', true);

                //insert untuk credit dari reverse sisa leave
                if SisaLeave <> 0 then
                    insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
                    SisaLeave, ChargingLineEmp, true, LineNoGenJnl, EmployeeProsesCharging."No.",
                    Opsi::"Leave Accrue", '', true);

                //insert untuk credit dari reverse sisa thr
                if SisaTHR <> 0 then
                    insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
                    SisaTHR, ChargingLineEmp, true, LineNoGenJnl, EmployeeProsesCharging."No.",
                    Opsi::"THR Accrue", '', true);


                //insert untuk severance accrual yang asli
                insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
                SeveranceAccrueAmount, ChargingLineEmp, true, LineNoGenJnl, EmployeeProsesCharging."No.",
                Opsi::"Severance Accrue", '', false);

                //insert untuk THR accrual yg asli
                insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
                THRAccrueAmount, ChargingLineEmp, true, LineNoGenJnl, EmployeeProsesCharging."No.",
                Opsi::"THR Accrue", '', false);


                //Clear(Maxnye);
                //Clear(JumlahYgAda);
                //AccrualMgt.AmbilMaxAccrual(EmployeeProsesCharging."No.", ChargingHeader."Posting Date", Maxnye);
                //AccrualMgt.JumlahAccrual(EmployeeProsesCharging, ChargingHeader."Posting Date Charging", JumlahYgAda);

                //insert untuk leave accrual yg asli
                if (JumlahYgAda < Maxnye) or perpanjangan then
                    insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
                    LeaveAccrueAmount, ChargingLineEmp, true, LineNoGenJnl, EmployeeProsesCharging."No.",
                    Opsi::"Leave Accrue", '', false);


                //insert untuk welfare accrual yg asli
                insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
                PayrollSetup."Charg. Welfare Amount", ChargingLineEmp, true, LineNoGenJnl, EmployeeProsesCharging."No.",
                Opsi::"Welfare Accrue", '', false);

                //insert untuk safe security accrual yg asli
                insertGenJnlLine(GenJnlLine, ChargingHeader."No.", ChargingHeader."Posting Date",
                SafeSecAccrueAmount, ChargingLineEmp, true, LineNoGenJnl, EmployeeProsesCharging."No.",
                Opsi::"Safety & Security Accrue", '', false);
            end;

        until EmployeeProsesCharging.Next() = 0;

        WindowPost3.Close();


        WindowPost4.Open('Finishing posting process...');

        //coding untuk tabel Payroll Processed Entry
        //Kasih beberapa flag
        PayrollProcessedEntry.Get(ChargingHeader."Posting Date");
        PayrollProcessedEntry."Charging Processed" := true;
        PayrollProcessedEntry."Employee Charging Doc. No." := ChargingHeader."No.";
        PayrollProcessedEntry.validate("Posting Date Charging", ChargingHeader."Posting Date Charging");

        Tahun := Date2DMY(ChargingHeader."Posting Date Charging", 3);
        //Bulan := Format(ChargingHeader."Posting Date Charging", 0, '<Month Text>');
        Bulan := Date2DMY(ChargingHeader."Posting Date Charging", 2);

        PayrollProcessedEntry."Year Charging" := Tahun;
        PayrollProcessedEntry."Month Charging" := Bulan;
        PayrollProcessedEntry.Modify();

        //coding untuk bikin posted document
        //lalu hapus dokumen employee charging sebelum post
        PostedEmpChargingHeader.Init();
        PostedEmpChargingHeader.TransferFields(ChargingHeader);
        PostedEmpChargingHeader.Insert();

        ChargingLineCopy.Reset();
        ChargingLineCopy.SetRange("Document No.", ChargingHeader."No.");
        ChargingLineCopy.FindSet();
        repeat
            PostedEmpChargingLine.Init();
            PostedEmpChargingLine.TransferFields(ChargingLineCopy);
            PostedEmpChargingLine.Insert();
        until ChargingLineCopy.Next() = 0;

        ChargingHeader.Delete(true);

        WindowPost4.Close();

        Message('Charging document %1 successfully posted\' +
                '%2 rows of general journal created.\' +
                'check them in batch %3 and %4',
                ChargingHeader."No.", GenJnlLine.Count,
                PayrollSetup."Journal Batch Name",
                PayrollSetup."Jnl. Batch Name Accrual");
    end;


    procedure insertGenJnlLine(var
                                   genJnlLineInsert: Record "Gen. Journal Line";
                                   DocNoDre: Code[20];
                                   xxPostingDate: Date;
                                   _duit: Decimal;
                                   WoiChargingLine: Record "Employee Charging Line";
                                   Lawan: Boolean;

    var
        LineNoBalik: Integer;
        EmployeeNo: Code[20];
        Pilihan: enum "Journal Options";
        Desc: Text;
        Reverse: Boolean)
    var
        nomorEntryGenJnl: Integer;
        NomorAkun: Code[20];
        PakeDimension: Boolean;
        Deskripsi: Text;
        Pegawai: Record Employee;
        duitNegatif: Decimal;

        JnlTemplateName: Code[10];
        JnlBatchName: Code[10];
        ApakahAccrue: Boolean;
        GenJnlBatch: Record "Gen. Journal Batch";
        NomorDokumen: Code[20];
        TanggalPosting: Date;
        DocumentNo: Code[20];
        //NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeriesMgt: Codeunit "No. Series";
        NoSeriesLama: Code[20];
        konst: Integer;
    begin
        konst := 1;
        PakeDimension := false;
        ApakahAccrue := false;
        TanggalPosting := 0D;
        Clear(DocumentNo);
        Clear(NomorDokumen);
        Clear(NoSeriesLama);

        PayrollSetup.Get();
        PayrollSetup.TestField("Journal Template Name");
        PayrollSetup.TestField("Journal Batch Name");

        JnlTemplateName := PayrollSetup."Journal Template Name";
        JnlBatchName := PayrollSetup."Journal Batch Name";

        if EmployeeNo <> '' then begin
            Pegawai.Get(EmployeeNo);
        end;


        //di bawah ini tadinya ada safety and security
        //tapi diminta pindahin ke batch GAJI. Jangan di batch accrue
        //Pilihan::"Safety & Security Accrue Charging", Pilihan::"Safety & Security Accrue"
        if Pilihan in [Pilihan::"Severance Accrue Charging", Pilihan::"Severance Accrue",
        Pilihan::"Leave Accrue Charging", Pilihan::"Leave Accrue", Pilihan::"THR Accrue Charging",
        Pilihan::"THR Accrue", Pilihan::"Welfare Accrue Charging", Pilihan::"Welfare Accrue"] then begin
            PayrollSetup.TestField("Jnl. Template Name Accrual");
            PayrollSetup.TestField("Jnl. Batch Name Accrual");
            JnlTemplateName := PayrollSetup."Jnl. Template Name Accrual";
            JnlBatchName := PayrollSetup."Jnl. Batch Name Accrual";
            ApakahAccrue := true;
        end;

        case Pilihan of
            Pilihan::"Gross Salary":
                begin
                    PayrollSetup.TestField("Charging Gross Salary Acc. No.");
                    NomorAkun := PayrollSetup."Charging Gross Salary Acc. No.";
                    PakeDimension := true;
                    Deskripsi := 'SAL YCP ' + format(xxPostingDate, 0, '<Month Text> <Year>');
                end;
            Pilihan::"Adjustment Prorate":
                begin
                    PayrollSetup.TestField("Charging Gross Salary Acc. No.");
                    NomorAkun := PayrollSetup."Charging Gross Salary Acc. No.";
                    PakeDimension := true;
                    Deskripsi := 'SAL ADJ YCP ' + format(xxPostingDate, 0, '<Month Text> <Year>');
                end;
            Pilihan::Overtime:
                begin
                    PayrollSetup.TestField("Overtime Account No.");
                    NomorAkun := PayrollSetup."Overtime Account No.";
                    PakeDimension := true;
                    Deskripsi := 'OT YCP ' + format(xxPostingDate, 0, '<Month Text> <Year>');
                end;
            Pilihan::"Other Benefits":
                begin
                    PayrollSetup.TestField("Charg. Other Benefits Acc. No.");
                    NomorAkun := PayrollSetup."Charg. Other Benefits Acc. No.";
                    PakeDimension := true;
                    Deskripsi := Desc + ' ' + format(xxPostingDate, 0, '<Month Text> <Year>');
                end;
            Pilihan::"BPJS TK":
                begin
                    PayrollSetup.TestField("Charg. BPJS TK Acc. No.");
                    NomorAkun := PayrollSetup."Charg. BPJS TK Acc. No.";
                    PakeDimension := true;
                    Deskripsi := 'BPJSTK YCP ' + format(xxPostingDate, 0, '<Month Text> <Year>');
                end;
            Pilihan::"BPJS Health":
                begin
                    PayrollSetup.TestField("Charg. BPJS Health Acc. No.");
                    NomorAkun := PayrollSetup."Charg. BPJS Health Acc. No.";
                    PakeDimension := true;
                    Deskripsi := 'BPJS HEALTH YCP ' + format(xxPostingDate, 0, '<Month Text> <Year>');
                end;
            Pilihan::"AKDHK Debit":
                begin
                    PayrollSetup.TestField("Charg. AKDHK Debit Acc. No.");
                    NomorAkun := PayrollSetup."Charg. AKDHK Debit Acc. No.";
                    PakeDimension := true;
                    Deskripsi := 'AKDHK YCP ' + format(xxPostingDate, 0, '<Month Text> <Year>');
                end;
            Pilihan::Tax:
                begin
                    PayrollSetup.TestField("Tax Account No.");
                    NomorAkun := PayrollSetup."Tax Account No.";
                    Deskripsi := 'TAX PYBL YCP ' + format(xxPostingDate, 0, '<Month Text> <Year>');
                end;
            Pilihan::"BPJS TK Staff":
                begin
                    PayrollSetup.TestField("Charg. BPJS TK Staff Acc. No.");
                    NomorAkun := PayrollSetup."Charg. BPJS TK Staff Acc. No.";
                    Deskripsi := 'BPJSTK PYBL YCP ' + format(xxPostingDate, 0, '<Month Text> <Year>');
                end;
            Pilihan::"BPJS Health Staff":
                begin
                    PayrollSetup.TestField("Charg. BPJS Health Staff Acc.");
                    NomorAkun := PayrollSetup."Charg. BPJS Health Staff Acc.";
                    Deskripsi := 'BPJS HEALTH ' + format(xxPostingDate, 0, '<Month Text> <Year>');
                end;
            Pilihan::"AKDHK Credit":
                begin
                    PayrollSetup.TestField("Charg. AKDHK Credit Acc. No.");
                    NomorAkun := PayrollSetup."Charg. AKDHK Credit Acc. No.";
                    Deskripsi := 'AKDHK ' + format(xxPostingDate, 0, '<Month Text> <Year>');
                end;
            Pilihan::THP:
                begin
                    PayrollSetup.TestField("Take Home Pay Account No.");
                    NomorAkun := PayrollSetup."Take Home Pay Account No.";
                    Deskripsi := 'SALARY YCP ' + format(xxPostingDate, 0, '<Month Text> <Year>');
                end;
            Pilihan::"Severance Accrue Charging":
                begin
                    if not Reverse then begin
                        PayrollSetup.TestField("Sevr. Accr. Debit Acc. No.");
                        NomorAkun := PayrollSetup."Sevr. Accr. Debit Acc. No.";

                        Deskripsi := 'Accr SPRT ' + format(xxPostingDate, 0, '<Month Text> <Year>') + ' ' + Pegawai.FullName()
                    end else begin
                        PayrollSetup.TestField("Sevr. Accr. debit Acc. No.");
                        NomorAkun := PayrollSetup."Sevr. Accr. debit Acc. No.";
                        konst := -1;
                        Deskripsi := 'Reverse SPRT ' + format(xxPostingDate, 0, '<Month Text> <Year>') + ' ' + Pegawai.FullName();
                    end;

                    PakeDimension := true;
                end;
            Pilihan::"THR Accrue Charging":
                //Rigon
                begin
                    if not Reverse then begin
                        PayrollSetup.TestField("THR Accr. Debit Acc. No.");
                        NomorAkun := PayrollSetup."THR Accr. Debit Acc. No.";

                        Deskripsi := 'Accr 13th Sal ' + format(xxPostingDate, 0, '<Month Text> <Year>') + ' ' + Pegawai.FullName()
                    end else begin
                        PayrollSetup.TestField("THR Accr. debit Acc. No.");
                        NomorAkun := PayrollSetup."THR Accr. debit Acc. No.";
                        konst := -1;
                        Deskripsi := 'Reverse 13th Sal ' + format(xxPostingDate, 0, '<Month Text> <Year>') + ' ' + Pegawai.FullName();
                    end;

                    PakeDimension := true;
                end;
            Pilihan::"Leave Accrue Charging":
                begin
                    if not Reverse then begin
                        PayrollSetup.TestField("Leave Accr. Debit Acc. No.");
                        NomorAkun := PayrollSetup."Leave Accr. Debit Acc. No.";

                        Deskripsi := 'Accr AL ' + format(xxPostingDate, 0, '<Month Text> <Year>') + ' ' + Pegawai.FullName()
                    end else begin
                        PayrollSetup.TestField("Leave Accr. debit Acc. No.");
                        NomorAkun := PayrollSetup."Leave Accr. debit Acc. No.";
                        konst := -1;
                        Deskripsi := 'Reverse AL ' + format(xxPostingDate, 0, '<Month Text> <Year>') + ' ' + Pegawai.FullName();
                    end;

                    PakeDimension := true;
                end;
            Pilihan::"Welfare Accrue Charging":
                begin
                    PayrollSetup.TestField("Charg. Welfare Debit Acc. No.");
                    NomorAkun := PayrollSetup."Charg. Welfare Debit Acc. No.";

                    Deskripsi := 'Accr Welfare ' + format(xxPostingDate, 0, '<Month Text> <Year>') + ' ' + Pegawai.FullName();
                    PakeDimension := true;
                end;
            Pilihan::"Safety & Security Accrue Charging":
                begin
                    PayrollSetup.TestField("Charg. SafeSec Debit Acc. No.");
                    NomorAkun := PayrollSetup."Charg. SafeSec Debit Acc. No.";

                    Deskripsi := 'S & S YCP ' + format(xxPostingDate, 0, '<Month Text> <Year>');
                    PakeDimension := true;
                end;
            Pilihan::"Severance Accrue":
                begin
                    if not Reverse then begin
                        PayrollSetup.TestField("Sevr. Accr. Credit Acc. No.");
                        NomorAkun := PayrollSetup."Sevr. Accr. Credit Acc. No.";

                        Deskripsi := 'Accr SPRT ' + format(xxPostingDate, 0, '<Month Text> <Year>') + ' ' + Pegawai.FullName()
                    end else begin
                        PayrollSetup.TestField("Sevr. Accr. credit Acc. No.");
                        NomorAkun := PayrollSetup."Sevr. Accr. credit Acc. No.";

                        Deskripsi := 'Reverse SPRT ' + format(xxPostingDate, 0, '<Month Text> <Year>') + ' ' + Pegawai.FullName();
                    end;

                    PakeDimension := false;
                end;
            Pilihan::"THR Accrue":
                begin
                    //Rigon

                    if not Reverse then begin
                        PayrollSetup.TestField("THR Accr. Credit Acc. No.");
                        NomorAkun := PayrollSetup."THR Accr. Credit Acc. No.";

                        Deskripsi := 'Accr 13th Sal ' + format(xxPostingDate, 0, '<Month Text> <Year>') + ' ' + Pegawai.FullName()
                    end else begin
                        PayrollSetup.TestField("THR Accr. credit Acc. No.");
                        NomorAkun := PayrollSetup."THR Accr. credit Acc. No.";

                        Deskripsi := 'Reverse 13th Sal ' + format(xxPostingDate, 0, '<Month Text> <Year>') + ' ' + Pegawai.FullName();
                    end;

                    PakeDimension := false;
                end;
            Pilihan::"Leave Accrue":
                begin
                    if not Reverse then begin
                        PayrollSetup.TestField("Leave Accr. Credit Acc. No.");
                        NomorAkun := PayrollSetup."Leave Accr. Credit Acc. No.";

                        Deskripsi := 'Accr AL ' + format(xxPostingDate, 0, '<Month Text> <Year>') + ' ' + Pegawai.FullName()
                    end else begin
                        PayrollSetup.TestField("Leave Accr. credit Acc. No.");
                        NomorAkun := PayrollSetup."Leave Accr. credit Acc. No.";

                        Deskripsi := 'Reverse AL ' + format(xxPostingDate, 0, '<Month Text> <Year>') + ' ' + Pegawai.FullName();
                    end;

                    PakeDimension := false;
                end;
            Pilihan::"Welfare Accrue":
                begin
                    PayrollSetup.TestField("Charg. Welfare Credit Acc. No.");
                    NomorAkun := PayrollSetup."Charg. Welfare Credit Acc. No.";

                    Deskripsi := 'Accr Welfare ' + format(xxPostingDate, 0, '<Month Text> <Year>') + ' ' + Pegawai.FullName();
                    PakeDimension := false;
                end;
            Pilihan::"Safety & Security Accrue":
                begin
                    PayrollSetup.TestField("Charg. SafeSec Credit Acc. No.");
                    NomorAkun := PayrollSetup."Charg. SafeSec Credit Acc. No.";

                    Deskripsi := 'S & S YCP ' + format(xxPostingDate, 0, '<Month Text> <Year>');
                    PakeDimension := false;
                end;

            Pilihan::"THR Amount":
                begin
                    PayrollSetup.TestField("THR Amount Acc. No.");
                    NomorAkun := PayrollSetup."THR Amount Acc. No.";

                    Deskripsi := '13th SAL YCP ' + format(xxPostingDate, 0, '<Month Text> <Year>');
                    PakeDimension := true;
                end;
            Pilihan::"THR Tax":
                begin
                    PayrollSetup.TestField("THR Tax Acc. No.");
                    NomorAkun := PayrollSetup."THR Tax Acc. No.";

                    Deskripsi := 'TAX PYBL 13th SAL ' + format(xxPostingDate, 0, '<Month Text> <Year>');
                    PakeDimension := false;
                end;
            Pilihan::"THR THP":
                begin
                    PayrollSetup.TestField("THR THP Acc. No.");
                    NomorAkun := PayrollSetup."THR THP Acc. No.";

                    Deskripsi := '13th SAL TOTAL ' + format(xxPostingDate, 0, '<Month Text> <Year>');
                    PakeDimension := false;
                end;
            Pilihan::"Unpaid Leave":
                begin
                    PayrollSetup.TestField("Unpaid Leave Acc. No.");
                    NomorAkun := PayrollSetup."Unpaid Leave Acc. No.";

                    Deskripsi := 'Total unpaid leave for ' + format(xxPostingDate);
                end;
            Pilihan::"Other Deduction":
                begin
                    PayrollSetup.TestField("Other Deduction Acc. No.");
                    NomorAkun := PayrollSetup."Other Deduction Acc. No.";
                    Deskripsi := 'DEDUCT YCP ' + format(xxPostingDate, 0, '<Month Text> <Year>');
                    PakeDimension := true;
                end;
        end;

        entryNoGenJnl(DocNoDre, nomorEntryGenJnl, ApakahAccrue, TanggalPosting, DocumentNo);
        LineNoBalik := nomorEntryGenJnl;

        if TanggalPosting <> xxPostingDate then begin
            if Pilihan in [Pilihan::"Severance Accrue Charging", Pilihan::"Severance Accrue",
            Pilihan::"Leave Accrue Charging", Pilihan::"Leave Accrue", Pilihan::"THR Accrue Charging",
            Pilihan::"THR Accrue", Pilihan::"Safety & Security Accrue Charging", Pilihan::"Safety & Security Accrue",
            Pilihan::"Welfare Accrue Charging", Pilihan::"Welfare Accrue"] then
                GenJnlBatch.Get(PayrollSetup."Jnl. Template Name Accrual", PayrollSetup."Jnl. Batch Name Accrual")
            else
                GenJnlBatch.Get(PayrollSetup."Journal Template Name", PayrollSetup."Journal Batch Name");

            GenJnlBatch.TestField("No. Series");
            NoSeriesLama := GenJnlBatch."No. Series";
            if NomorDokumen = '' then
                // NoSeriesMgt.InitSeries(GenJnlBatch."No. Series", NoSeriesLama,
                // TanggalPosting, NomorDokumen, GenJnlBatch."No. Series");
                NomorDokumen := NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series", TanggalPosting, false);
        end else
            NomorDokumen := DocumentNo;


        genJnlLineInsert.Init();
        genJnlLineInsert.Validate("Journal Template Name", JnlTemplateName);
        genJnlLineInsert.Validate("Journal Batch Name", JnlBatchName);
        genJnlLineInsert.Validate("Line No.", nomorEntryGenJnl);
        genJnlLineInsert.validate("Posting Date", xxPostingDate);
        genJnlLineInsert.validate("Document No.", NomorDokumen);
        genJnlLineInsert.Validate("Account Type", genJnlLineInsert."Account Type"::"G/L Account");
        genJnlLineInsert.Validate("Account No.", NomorAkun);


        if not Lawan then begin
            genJnlLineInsert.Validate(Amount, _duit * konst);
            if PakeDimension then begin
                genJnlLineInsert.Validate("Global Dimension 1 Code", WoiChargingLine."Global Dimension 1 Code");
                //genJnlLineInsert.Validate("Shortcut Dimension 7 Code", WoiChargingLine."Global Dimension 7 Code");
                genJnlLineInsert.Validate("Shortcut Dimension 6 Code", EmployeeNo);
                genJnlLineInsert.Validate("Shortcut Dimension 5 Code", Pegawai."Office Location Code");
            end else
                genJnlLineInsert.Validate("Global Dimension 1 Code", PayrollSetup."Global Dimension 1 Code");
        end else begin
            if PakeDimension then begin
                if Pilihan = Pilihan::"Other Deduction" then
                    genJnlLineInsert.Validate("Global Dimension 1 Code", WoiChargingLine."Global Dimension 1 Code");

                genJnlLineInsert.Validate("Shortcut Dimension 6 Code", EmployeeNo);
                genJnlLineInsert.Validate("Shortcut Dimension 5 Code", Pegawai."Office Location Code");
            end else
                genJnlLineInsert.Validate("Global Dimension 1 Code", PayrollSetup."Global Dimension 1 Code");


            if Pilihan = Pilihan::"THR Accrue" then
                _duit := -_duit;

            //Diubah sesuai permintaan Pak Erwin, untuk akomodir salah jurnal reverse
            //Untuk jurnal reverse THR April 2022
            if not Reverse then
                if _duit < 0 then
                    duitNegatif := _duit
                else
                    duitNegatif := -_duit;
            /*
    else
        if _duit < 0 then
            duitNegatif := -_duit
        else
            duitNegatif := _duit;
            */

            genJnlLineInsert.Validate(Amount, duitNegatif * konst);

        end;

        genJnlLineInsert."Charging Doc. No" := DocNoDre;
        genJnlLineInsert.Description := Deskripsi;
        genJnlLineInsert.Insert(true);
    end;

    procedure entryNoGenJnl(DocNoCharging: Code[20]; var NoEntry: Integer; Accrue: Boolean;
    var PostingDate: Date; var DocNo: Code[20])
    var
        GenJnlLineEntryNo: Record "Gen. Journal Line";
        JnlTemplateName: Code[10];
        JnlBatchName: Code[10];
    begin
        PayrollSetup.Get();

        if Accrue then begin
            PayrollSetup.TestField("Jnl. Template Name Accrual");
            PayrollSetup.TestField("Jnl. Batch Name Accrual");
            JnlTemplateName := PayrollSetup."Jnl. Template Name Accrual";
            JnlBatchName := PayrollSetup."Jnl. Batch Name Accrual";
        end else begin
            PayrollSetup.TestField("Journal Template Name");
            PayrollSetup.TestField("Journal Batch Name");
            JnlTemplateName := PayrollSetup."Journal Template Name";
            JnlBatchName := PayrollSetup."Journal Batch Name";
        end;

        GenJnlLineEntryNo.LockTable();
        GenJnlLineEntryNo.Reset();
        GenJnlLineEntryNo.SetRange("Journal Template Name", JnlTemplateName);
        GenJnlLineEntryNo.SetRange("Journal Batch Name", JnlBatchName);
        //GenJnlLineEntryNo.SetRange("Document No.", DocNoCharging);
        if GenJnlLineEntryNo.FindLast() then begin
            NoEntry := GenJnlLineEntryNo."Line No." + 1;
            PostingDate := GenJnlLineEntryNo."Posting Date";
            DocNo := GenJnlLineEntryNo."Document No.";
        end else
            NoEntry := 1;
    end;

    procedure ChargingCheckLine(ChargingHeader: Record "Employee Charging Header")
    var
        ChargingLine: Record "Employee Charging Line";
        ChargingLineKosong: Record "Employee Charging Line" temporary;
        TempChargingLine: Record "Employee Charging Line" temporary;
        EmployeeTemp: Record Employee temporary;
        Employee: Record Employee;
        JumlahActive: Integer;
        JumlahTemp: Integer;
        AdaYangKosong: Boolean;
        LineKosong: Boolean;
        WindowCek: Dialog;
        PayrollLedgerEntry: Record "Payroll Ledger Entry";
    begin
        Clear(TempChargingLine);
        Clear(EmployeeTemp);
        Clear(JumlahActive);
        Clear(JumlahTemp);
        Clear(AdaYangKosong);

        WindowCek.Open('Validating lines, please wait...');
        //Cek dulu di line ada isinya ato engga
        ChargingLine.Reset();
        ChargingLine.SetRange("Document No.", ChargingHeader."No.");
        ChargingLine.FindFirst();

        //Ngecek jika ada entry-an UMUM (ditandai dengan employee no kosong)
        ChargingLine.Reset();
        ChargingLine.SetRange("Document No.", ChargingHeader."No.");
        ChargingLine.SetRange("Employee No.", '');
        if ChargingLine.FindFirst() then
            AdaYangKosong := true;

        //Proses select distinct employee yg di-set di charging line
        ChargingLine.Reset();
        ChargingLine.SetRange("Document No.", ChargingHeader."No.");
        if ChargingLine.FindFirst() then
            repeat
                Clear(LineKosong);

                //sekalian paksa isi dimension 1 dan percentage
                //apapun kondisinya, 2 field ini HARUS ADA ISINYA
                ChargingLine.TestField("Global Dimension 1 Code");
                ChargingLine.TestField(Percentage);

                if ChargingLine."Employee No." = '' then LineKosong := true;

                if not LineKosong then begin
                    TempChargingLine.Reset();
                    TempChargingLine.SetRange("Document No.", ChargingHeader."No.");
                    TempChargingLine.SetRange("Employee No.", ChargingLine."Employee No.");
                    if not TempChargingLine.FindFirst() then begin
                        TempChargingLine.Init();
                        TempChargingLine.TransferFields(ChargingLine);
                        TempChargingLine.Insert();

                        Employee.Get(ChargingLine."Employee No.");
                        EmployeeTemp.Init();
                        EmployeeTemp.TransferFields(Employee);
                        EmployeeTemp.Insert(true);
                    end;
                end;
            until ChargingLine.Next() = 0;

        //Ambil jumlah employee active
        //Employee.Reset();
        //Employee.SetRange(Status, Employee.Status::Active);
        //Employee.FindSet();
        //JumlahActive := Employee.Count;

        //Ambil employee pada gajian di tanggal payroll sesuai posting date
        PayrollLedgerEntry.Reset();
        PayrollLedgerEntry.SetRange("Posting Date", ChargingHeader."Posting Date");
        PayrollLedgerEntry.FindFirst();
        JumlahActive := PayrollLedgerEntry.Count;

        //Ambil jumlah employee distinct (yg di-set di employee charging line)
        if EmployeeTemp.FindSet() then
            JumlahTemp := EmployeeTemp.Count;

        //Jika jumlah employee yg di-set charging, tidak sama dengan employee active, maka
        //Harus ada charging kosong (yg fungsinya adalah semua employee active)
        if (JumlahActive <> JumlahTemp) and (not AdaYangKosong) then
            Error('Employees set in charging line is smaller than in payroll %1\' +
                  'you need to set them all accordingly,\' +
                  'or set one line with blank EMPLOYEE NO. for general setting.',
                   Format(ChargingHeader."Posting Date", 0, '<Day> <Month Text> <Year4>'));

        Clear(ChargingLineKosong);
        FilterChargingLine(ChargingLine, ChargingHeader."No.", '');
        if ChargingLine.FindFirst() then begin
            //total percentage dari kelompok ini (employee kosong), harus 100%
            //ngga boleh lebih, ngga boleh kurang.
            Percentage100Percent(ChargingLine, true);

            if ChargingLine.Count > 1 then
                //Spesifik untuk employee kosong ini, cek apakah lebih dari satu?
                //Jika lebih dari satu, ngga boleh ada double...alias kosong tapi sama dimension
                repeat
                    ChargingLineKosongFilter(ChargingLineKosong, ChargingHeader."No.", '',
                    ChargingLine, true);
                    if not ChargingLineKosong.FindFirst() then
                        InsertChargingLineKosong(ChargingLineKosong, ChargingLine)
                    else
                        Error('There are double input for blank EMPLOYEE NO. with dimension code %1\' +
                              'Please change accordingly so each entry is unique.',
                              ChargingLine."Global Dimension 1 Code");
                until ChargingLine.Next() = 0;
        end;

        Clear(ChargingLine);
        Clear(ChargingLineKosong);
        //kalo Employee Temp ada isinya (berarti ada yg di-set employee-nya....spesifik punya charging sendiri)        
        if EmployeeTemp.FindFirst() then
            repeat
                FilterChargingLine(ChargingLine, ChargingHeader."No.", EmployeeTemp."No.");
                if ChargingLine.FindFirst() then begin
                    //total percentage dari kelompok ini (employee ada isinya sesuai loop employee temp), 
                    //harus 100% ngga boleh lebih, ngga boleh kurang.

                    Percentage100Percent(ChargingLine, false);

                    if ChargingLine.Count > 1 then
                        //Spesifik untuk employee temp ini, cek apakah lebih dari satu?
                        //Jika lebih dari satu, ngga boleh ada double...alias kosong tapi sama dimension
                        repeat
                            ChargingLineKosongFilter(ChargingLineKosong, ChargingHeader."No.", EmployeeTemp."No.",
                            ChargingLine, false);
                            if not ChargingLineKosong.FindFirst() then
                                InsertChargingLineKosong(ChargingLineKosong, ChargingLine)
                            else
                                Error('There are double input for employee %1 with dimension code %2\' +
                                      'Please change accordingly so each entry is unique.',
                                      EmployeeTemp."No.", ChargingLine."Global Dimension 1 Code");
                        until ChargingLine.Next() = 0;
                end;
            until EmployeeTemp.Next() = 0;

        WindowCek.Close();
    end;

    procedure InsertChargingLineKosong(var __LineKampretKosong: Record "Employee Charging Line" temporary;
    __chargingLineBeneran: Record "Employee Charging Line")
    begin
        __LineKampretKosong.Init();
        __LineKampretKosong.TransferFields(__chargingLineBeneran);
        __LineKampretKosong.Insert();
    end;

    procedure ChargingLineKosongFilter(var LineKampretKosong: Record "Employee Charging Line" temporary;
    _docNoHeader: Code[20]; _empNoTemp: Code[20]; chargingLineBeneran: Record "Employee Charging Line";
    _kosong: Boolean)
    begin
        LineKampretKosong.Reset();
        LineKampretKosong.SetRange("Document No.", _docNoHeader);
        LineKampretKosong.SetRange("Global Dimension 1 Code",
                                     chargingLineBeneran."Global Dimension 1 Code");
        if _kosong then
            LineKampretKosong.SetFilter("Employee No.", '')
        else
            LineKampretKosong.SetRange("Employee No.", _empNoTemp);
    end;

    procedure FilterChargingLine(var
                                     ChargingLineNyet: Record "Employee Charging Line";
                                     DocNo: Code[20];
                                     EmpNo: Code[20])
    begin
        ChargingLineNyet.Reset();
        ChargingLineNyet.SetRange("Document No.", DocNo);
        ChargingLineNyet.SetCurrentKey("Document No.", "Employee No.");
        ChargingLineNyet.SetRange("Employee No.", EmpNo);
    end;


    procedure Percentage100Percent(var __ChargingLine: Record "Employee Charging Line"; ___empty: Boolean)
    var
        strEmp: Text;
        _EmployeeGituLoh: Record Employee;
    begin
        if ___empty then
            strEmp := 'BLANK EMPLOYEE'
        else begin
            _EmployeeGituLoh.Get(__ChargingLine."Employee No.");
            strEmp := __ChargingLine."Employee No." + '-' + _EmployeeGituLoh.FullName();
        end;

        __ChargingLine.SetCurrentKey("Document No.", "Employee No.");
        __ChargingLine.CalcSums(Percentage);
        if __ChargingLine.Percentage <> 100 then
            Error('The percentage accumulation for %2 is %1% \' +
                  'you have to change so it will become 100%.', __ChargingLine.Percentage, strEmp);
    end;

    procedure CreatePayrollProcessedEntry(PostingDate: Date; var EntryNo: Integer; AkhirTahun: Boolean)
    var
        PayrollProcessedEntry: Record "Payroll Processed Entry";
        EntryCekIsi: Record "Payroll Processed Entry";
        TahunGajian: Integer;
        BulanGajian: Integer;
    begin
        EntryCekIsi.LockTable();
        EntryCekIsi.Reset();
        if EntryCekIsi.FindLast() then
            EntryNo := EntryCekIsi."Entry No." + 1
        else
            EntryNo := 1;

        //Cek gajian di bulan yg sama, apakah ada.
        TahunGajian := Date2DMY(PostingDate, 3);
        BulanGajian := Date2DMY(PostingDate, 2);

        //PayrollProcessedEntry.Reset();
        //PayrollProcessedEntry.SetRange(Year, TahunGajian);
        //PayrollProcessedEntry.SetRange(Month, BulanGajian);
        //if PayrollProcessedEntry.FindFirst() then
        //Error('Salary for period %1 already exist. \Posted at %2',
        //PayrollProcessedEntry.MonthString + '-' +
        //format(PayrollProcessedEntry.Year),
        //PayrollProcessedEntry."Posting Date Salary");

        PayrollProcessedEntry.Init();
        PayrollProcessedEntry."Entry No." := EntryNo;
        PayrollProcessedEntry.Validate("Posting Date Salary", PostingDate);

        if AkhirTahun then begin
            PayrollProcessedEntry."Year End Process" :=
                PayrollProcessedEntry."Year End Process"::"Awaiting Process";
            PayrollProcessedEntry."Posting Date Year End" := CalcDate('<CM>', PostingDate);
        end;

        PayrollProcessedEntry.Insert(true);
    end;

    procedure CalculateDates(PostingDate: Date; var StartingDate: Date; var EndingDate: Date)
    begin
        if PostingDate = 0D then
            PostingDate := Today;

        FirstDay := CalcDate('-CM', PostingDate);
        StartingDate := FirstDay + 19;
        EndingDate := CalcDate('CM', PostingDate);
    end;

    var
        PayrollSetup: Record "Payroll General Setup";
        FirstDay: Date;
        PostingDateWords: Text;
        DateRange: Text;
}
