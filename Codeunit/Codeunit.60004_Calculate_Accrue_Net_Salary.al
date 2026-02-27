codeunit 60004 "Calculate Accrue Net Salary"
{
    var
        AllowanceComp: record "Allowance Component";
        DeductionComp: Record "Deduction Component";
        EntryNo: Integer;
        Window: Dialog;
        TempDetailedPayrollLedgerEntry: Record "Det. Payrol Ledg. Entry Accrue" temporary;
        PayrollGeneralSetup: Record "Payroll General Setup";


    local procedure SetDetailedPayroll(var _DetailedPayrollLedgerForJnl: Record "Det. Payrol Ledg. Entry Accrue";
    _PostingDateJnl: Date; DimensionValueCode: Code[20])
    begin
        _DetailedPayrollLedgerForJnl.Reset();
        _DetailedPayrollLedgerForJnl.SetCurrentKey("Employee No.", "Posting Date", "Type",
                                                    "dimension code", "Paid by Employee",
                                                    "Component Code");
        _DetailedPayrollLedgerForJnl.SetRange("Posting Date", _PostingDateJnl);
        _DetailedPayrollLedgerForJnl.SetRange("Dimension Value", DimensionValueCode);
    end;


    procedure LoopThroughEmployee(EmployeeLoopThru: Record Employee; var
                                                                         Post: Boolean;
                                                                         PostingDateLoopThru: Date;
                                                                         THRProcess: Boolean;
                                                                         WithTHRAdded: Boolean);
    var
        TahunPostingDate: Integer;
        BulanPostingDate: Integer;
        TahunGajianTerakhir: Integer;
        BulanGajianTerakhir: Integer;
        TanggalTHRTerakhir: Date;
        PayrollLedgerEntry: Record "Payroll Ledger Entry Accrue";
        THRLedgerEntry: Record "THR Ledger Entry";
        StrDate: Text[30];
        StrGender: text[5];
        THRAmount: Decimal;
    begin
        EmployeeLoopThru.TestField("MSI_HRIS Basic Salary");

        PayrollGeneralSetup.Get();
        clear(THRAmount);

        //accrue ngga kesini
        if THRProcess then
            if PayrollGeneralSetup."THR Source" = PayrollGeneralSetup."THR Source"::"Manually assigned" then begin
                EmployeeLoopThru.TestField("MSI_HRIS THR Amount");
                THRAmount := EmployeeLoopThru."MSI_HRIS THR Amount";
            end else
                THRAmount := EmployeeLoopThru."MSI_HRIS Basic Salary";

        TahunPostingDate := Date2DMY(PostingDateLoopThru, 3);
        BulanPostingDate := Date2DMY(PostingDateLoopThru, 2);

        if not THRProcess then begin
            PayrollLedgerEntry.Reset();
            PayrollLedgerEntry.SetCurrentKey("Employee No.", "Posting Date");
            PayrollLedgerEntry.SetRange("Employee No.", EmployeeLoopThru."No.");
            if PayrollLedgerEntry.FindLast() then begin
                TahunGajianTerakhir := Date2DMY(PayrollLedgerEntry."Posting Date", 3);
                BulanGajianTerakhir := Date2DMY(PayrollLedgerEntry."Posting Date", 2);

                StrDate := Format(PostingDateLoopThru, 0, '<Month Text> <Year4>');

                if (TahunGajianTerakhir = TahunPostingDate) and
                    (BulanGajianTerakhir = BulanPostingDate) then
                    Error('Salary period %1 is already processed for employee: %2',
                          StrDate, EmployeeLoopThru.FullName());
            end;
        end else begin
            //accrue ngga masuk ke ELSE ini
            THRLedgerEntry.Reset();
            THRLedgerEntry.SetCurrentKey("PPh 21 THR Type", "Employee No.", "Posting Date");
            THRLedgerEntry.SetRange("PPh 21 THR Type", THRLedgerEntry."PPh 21 THR Type"::"Without THR Amount");
            THRLedgerEntry.SetRange("Employee No.", EmployeeLoopThru."No.");
            if THRLedgerEntry.FindLast() then
                TanggalTHRTerakhir := THRLedgerEntry."Posting Date";

            if EmployeeLoopThru.Gender = EmployeeLoopThru.Gender::Male then
                StrGender := 'his'
            else
                StrGender := 'her';

            if TanggalTHRTerakhir <> 0D then
                if PostingDateLoopThru - TanggalTHRTerakhir < 180 then
                    Error('%1 is already received %2 THR in the last 6 month.',
                         EmployeeLoopThru.FullName(), StrGender);
        end;

        LoopSalarySetup(EmployeeLoopThru, PostingDateLoopThru, THRProcess, WithTHRAdded, THRAmount);
        Post := true;
    end;

    local procedure LoopSalarySetup(EmployeeLoopSalary: Record Employee; _PostingDate: Date;
                    iniTHR: Boolean; denganAngkaTHR: Boolean; UangTHRGitu: Decimal);
    var
        DetailedPayrollBrutto: Record "Det. Payrol Ledg. Entry Accrue";
        DetailedPayrollBruttoTax: Record "Det. Payrol Ledg. Entry Accrue";
        DetailedPayrollPengurangPajak: Record "Det. Payrol Ledg. Entry Accrue";
        EmployeeSalaryComponent: Record "Employee Salary Component";
        PayrollLedgerEntryUpdate: Record "Payroll Ledger Entry Accrue";

        PayrollLedgEntryNo: Integer;
        BulanKerjaGitu: Integer;
        Valuenya: Decimal;
        Uangnya: Decimal;
        _Salarynya: Decimal;
        DuitBrutto: Decimal;
        DuitBruttoTax: Decimal;
        UangPengurangPajak: Decimal;
        UangPPh21: Decimal;
        _DuitBersihSebulan: Decimal;
        _DuitBersihSetahun: Decimal;
        _DuitPTKPGitu: Decimal;
        _DuitJabatan: Decimal;
        OvertimeJnlLine: Record "Overtime Journal Line";
        OvertimeLedgerEntry: Record "Overtime Ledger Entry Accrue";
        DibayarKaryawan: Boolean;
        DetailType: Enum "Det. Payroll Ledg. Entry Type";
        OvertimeEntryNo: Integer;
        OvertimeLedgerEntry2: Record "Overtime Ledger Entry Accrue";
    begin
        Clear(PayrollLedgEntryNo);

        EmployeeLoopSalary.TestField("MSI_HRIS Basic Salary");
        if not iniTHR then
            InsertPayrollLedgerEntry(EmployeeLoopSalary."No.", _PostingDate, PayrollLedgEntryNo);

        //Kosongkan table temporary detailed payroll ledger untuk setiap employee
        if iniTHR then
            TempDetailedPayrollLedgerEntry.DeleteAll();

        EmployeeSalaryComponent.reset;
        EmployeeSalaryComponent.SetRange("Employee No.", EmployeeLoopSalary."No.");
        if EmployeeSalaryComponent.FindFirst() then
            repeat
                //allowance
                Clear(Valuenya);
                Clear(Uangnya);
                clear(_Salarynya);
                clear(DibayarKaryawan);

                if EmployeeSalaryComponent."Allowance Component Code" <> '' then begin
                    AllowanceComp.Get(EmployeeSalaryComponent."Allowance Component Code");

                    if AllowanceComp."Value Type" = AllowanceComp."Value Type"::Percentage then
                        Valuenya := AllowanceComp.Value;

                    //Basic salary dikali persentase dari value
                    Uangnya := EmployeeLoopSalary."MSI_HRIS Basic Salary" * (Valuenya / 100);

                    //cek kalo age restricted, kalo iya dan ngga memenuhi umur, timpa uangnya dengan nol
                    if AllowanceComp."Age Restricted" then
                        if not AgeEligible(EmployeeLoopSalary, _PostingDate, AllowanceComp.kode,
                            true) then
                            Uangnya := 0;

                    //cek kalo salary restricted, kalo masuk restricted, timpa uangnya dengan versi restricted
                    if AllowanceComp."Salary Restricted" then begin
                        SalaryRestriction(EmployeeLoopSalary, _Salarynya, true, AllowanceComp.Kode);
                        Uangnya := _Salarynya * (Valuenya / 100);
                    end;

                    //tapi kalo ngga persentase, timpa uangnya dengan value langsung
                    if AllowanceComp."Value Type" = AllowanceComp."Value Type"::Amount then
                        Uangnya := AllowanceComp."Value";

                    if not iniTHR then
                        InsertDetailedPayrollLedgerEntry(EmployeeLoopSalary."No.", _PostingDate,
                        PayrollLedgEntryNo, true, AllowanceComp.Kode, Uangnya, DetailType::Allowance,
                        false, false)
                    else
                        InsertDetailedPayrollLedgerEntry(EmployeeLoopSalary."No.", _PostingDate,
                        PayrollLedgEntryNo, true, AllowanceComp.Kode, Uangnya, DetailType::Allowance,
                        true, false)
                end;

                //deduction
                Clear(Valuenya);
                Clear(Uangnya);
                clear(_Salarynya);
                clear(DibayarKaryawan);

                if EmployeeSalaryComponent."Deduction Component Code" <> '' then begin
                    DeductionComp.Get(EmployeeSalaryComponent."Deduction Component Code");

                    if DeductionComp."Value Type" = DeductionComp."Value Type"::Percentage then
                        Valuenya := DeductionComp.Value;

                    //Basic salary dikali persentase dari value
                    Uangnya := EmployeeLoopSalary."MSI_HRIS Basic Salary" * (Valuenya / 100);

                    //cek kalo age restricted, kalo iya dan ngga memenuhi umur, timpa uangnya dengan nol
                    if DeductionComp."Age Restricted" then
                        if not AgeEligible(EmployeeLoopSalary, _PostingDate, DeductionComp.kode,
                            false) then
                            Uangnya := 0;

                    //cek kalo salary restricted, kalo masuk restricted, timpa uangnya dengan versi restricted
                    if DeductionComp."Salary Restricted" then begin
                        SalaryRestriction(EmployeeLoopSalary, _Salarynya, false, DeductionComp.Kode);
                        Uangnya := _Salarynya * (Valuenya / 100);
                    end;

                    //tapi kalo ngga persentase, timpa uangnya dengan value langsung
                    if DeductionComp."Value Type" = DeductionComp."Value Type"::Amount then
                        Uangnya := DeductionComp."Value";

                    //Cek jika deduction ini adalah potongan yg dibayar oleh karyawan
                    AllowanceComp.Reset();
                    AllowanceComp.SetRange("Deduction Code", DeductionComp.Kode);
                    if not AllowanceComp.FindFirst() then DibayarKaryawan := true;

                    if not iniTHR then
                        InsertDetailedPayrollLedgerEntry(EmployeeLoopSalary."No.", _PostingDate,
                        PayrollLedgEntryNo, false, DeductionComp.Kode, Uangnya, DetailType::Deduction,
                        false, DibayarKaryawan)
                    else
                        InsertDetailedPayrollLedgerEntry(EmployeeLoopSalary."No.", _PostingDate,
                        PayrollLedgEntryNo, false, DeductionComp.Kode, Uangnya, DetailType::Deduction,
                        true, false)
                end;
            until EmployeeSalaryComponent.Next() = 0;

        if not iniTHR then begin
            //Hitung gaji brutto
            Clear(DuitBrutto);
            DetailedPayrollBrutto.Reset();
            DetailedPayrollBrutto.SetCurrentKey("Type", "Employee No.", "Posting Date",
                                                "Deduction Mandatory for Tax");
            DetailedPayrollBrutto.SetRange("Type", DetailedPayrollBrutto."Type"::Allowance);
            DetailedPayrollBrutto.SetRange("Employee No.", EmployeeLoopSalary."No.");
            DetailedPayrollBrutto.SetRange("Posting Date", _PostingDate);
            if DetailedPayrollBrutto.FindSet() then
                DetailedPayrollBrutto.CalcSums(Amount);

            DuitBrutto := EmployeeLoopSalary."MSI_HRIS Basic Salary" + DetailedPayrollBrutto.Amount;

            //Hitung pengurang pajak
            Clear(UangPengurangPajak);
            DetailedPayrollPengurangPajak.Reset();
            DetailedPayrollPengurangPajak.SetCurrentKey("Type", "Employee No.", "Posting Date",
                                                        "Deduction Mandatory for Tax");
            DetailedPayrollPengurangPajak.SetRange("Type", DetailedPayrollPengurangPajak."type"::Deduction);
            DetailedPayrollPengurangPajak.SetRange("Employee No.", EmployeeLoopSalary."No.");
            DetailedPayrollPengurangPajak.SetRange("Posting Date", _PostingDate);
            DetailedPayrollPengurangPajak.SetRange("Deduction Mandatory for Tax", true);
            if DetailedPayrollPengurangPajak.FindSet() then begin
                DetailedPayrollPengurangPajak.CalcSums(Amount);
                UangPengurangPajak := DetailedPayrollPengurangPajak.Amount;
            end;

            //Hitung gaji brutto yang mandatory tax
            Clear(DuitBruttoTax);
            DetailedPayrollBruttoTax.Reset();
            DetailedPayrollBruttoTax.SetCurrentKey("Type", "Employee No.", "Posting Date",
                                                    "Allowance Mandatory for Tax");
            DetailedPayrollBruttoTax.SetRange("Type", DetailedPayrollBruttoTax."Type"::Allowance);
            DetailedPayrollBruttoTax.SetRange("Employee No.", EmployeeLoopSalary."No.");
            DetailedPayrollBruttoTax.SetRange("Posting Date", _PostingDate);
            DetailedPayrollBruttoTax.SetRange("Allowance Mandatory for Tax", true);
            if DetailedPayrollBruttoTax.FindSet() then begin
                DetailedPayrollBruttoTax.CalcSums(Amount);
                DuitBruttoTax := DetailedPayrollBruttoTax.Amount;
            end;

            //hitung overtime
            EmployeeLoopSalary.CalcFields("MSI_HRIS Overtime Entered");
            //Pindahkan isi table overtime journal line ke overtime ledger entry
            OvertimeJnlLine.Reset();
            OvertimeJnlLine.SetRange("Employee No.", EmployeeLoopSalary."No.");
            OvertimeJnlLine.SetRange("Posting Date", _PostingDate);
            if OvertimeJnlLine.FindSet() then begin
                PayrollGeneralSetup.TestField("Overtime Account No.");
                repeat
                    //dreegitu
                    clear(OvertimeEntryNo);
                    //Clear(OvertimeLedgerEntry2);

                    OvertimeLedgerEntry2.LockTable();
                    OvertimeLedgerEntry2.Reset();
                    if OvertimeLedgerEntry2.FindLast() then
                        OvertimeEntryNo := OvertimeLedgerEntry2."Entry No." + 1
                    else
                        OvertimeEntryNo := 1;

                    OvertimeLedgerEntry.Init();
                    OvertimeLedgerEntry."Entry No." := OvertimeEntryNo;
                    OvertimeLedgerEntry.TransferFields(OvertimeJnlLine);
                    OvertimeLedgerEntry.Insert();
                until OvertimeJnlLine.Next() = 0;
            end;

            //jumlahkan semua, dapet brutto tax
            DuitBruttoTax := EmployeeLoopSalary."MSI_HRIS Basic Salary" + EmployeeLoopSalary."MSI_HRIS Overtime Entered" +
                                DetailedPayrollBruttoTax.Amount;
        end else begin
            //Hitung gaji brutto yang mandatory tax, UNTUK THR
            Clear(DuitBruttoTax);
            TempDetailedPayrollLedgerEntry.Reset();
            TempDetailedPayrollLedgerEntry.SetCurrentKey("Type", "Employee No.", "Posting Date",
                                                        "Allowance Mandatory for Tax");
            /* Harusnya ngga perlu di-filter, karena isi table hanya punya employee yang digunakan saat ini
            TempDetailedPayrollLedgerEntry.SetRange("Type", TempDetailedPayrollLedgerEntry."Type"::Allowance);
            TempDetailedPayrollLedgerEntry.SetRange("Employee No.", EmployeeLoopSalary."No.");
            TempDetailedPayrollLedgerEntry.SetRange("Posting Date", _PostingDate);
            TempDetailedPayrollLedgerEntry.SetRange("Allowance Mandatory for Tax", true);
            */
            if TempDetailedPayrollLedgerEntry.FindSet() then begin
                TempDetailedPayrollLedgerEntry.CalcSums(Amount);
                DuitBruttoTax := TempDetailedPayrollLedgerEntry.Amount;
            end;

            DuitBruttoTax := EmployeeLoopSalary."MSI_HRIS Basic Salary" + TempDetailedPayrollLedgerEntry.Amount;
        end;

        if (iniTHR and denganAngkaTHR) then
            DuitBruttoTax := DuitBruttoTax + UangTHRGitu;

        Clear(UangPPh21);
        Clear(BulanKerjaGitu);
        Clear(_DuitBersihSebulan);
        Clear(_DuitBersihSetahun);
        Clear(_DuitPTKPGitu);
        Clear(_DuitJabatan);

        //Proses hitung PPh21
        HitungPPh21(EmployeeLoopSalary, _PostingDate, BulanKerjaGitu, UangPengurangPajak,
                    DuitBruttoTax, _DuitBersihSebulan, _DuitBersihSetahun, _DuitPTKPGitu,
                    _DuitJabatan, PayrollLedgEntryNo, iniTHR, UangTHRGitu, denganAngkaTHR);

        if not iniTHR then begin
            //Mengisi data2 tambahan pada tabel payroll ledger entry
            PayrollLedgerEntryUpdate.Get(PayrollLedgEntryNo);
            PayrollLedgerEntryUpdate.CalcFields("PPh 21");
            PayrollLedgerEntryUpdate."Biaya Jabatan" := _DuitJabatan;
            PayrollLedgerEntryUpdate."Brutto Income" := DuitBrutto;
            PayrollLedgerEntryUpdate."Brutto Income Taxable" := DuitBruttoTax;
            PayrollLedgerEntryUpdate."Monthly Nett Income" := _DuitBersihSebulan;
            PayrollLedgerEntryUpdate.PTKP := _DuitPTKPGitu;
            PayrollLedgerEntryUpdate."Tax Deduction Amount" := UangPengurangPajak;
            PayrollLedgerEntryUpdate."Total Working Month" := BulanKerjaGitu;
            PayrollLedgerEntryUpdate."Yearly Nett Income" := _DuitBersihSetahun;
            PayrollLedgerEntryUpdate."Basic Salary" := EmployeeLoopSalary."MSI_HRIS Basic Salary";
            PayrollLedgerEntryUpdate.Modify();

            //insert entry-an PPh21
            InsertDetailedPayrollLedgerEntry(EmployeeLoopSalary."No.", _PostingDate,
                                            PayrollLedgEntryNo, false, DeductionComp.Kode,
                                            PayrollLedgerEntryUpdate."PPh 21", DetailType::"PPh 21",
                                            false, false);
        end;
    end;

    local procedure GetTarifNPWP(EmployeeNPWP: Record Employee;
                                 TariffPPh21: Record "Tariff PPh 21 Setup"): Decimal;
    begin
        if EmployeeNPWP."MSI_HRIS NPWP No." <> '' then begin
            TariffPPh21.TestField("% Tariff");
            exit(TariffPPh21."% Tariff")
        end else begin
            TariffPPh21.TestField("% Tariff Non NPWP");
            exit(TariffPPh21."% Tariff Non NPWP");
        end;
    end;

    local procedure InsertPKPLedgerEntry(PayrollLedgEntryNoHitungPPh21: Integer;
                    _UsedPercentage: Decimal; PPhCalculated: Decimal; _UsedAmount: Decimal;
                    _YearlyPKP: Decimal; _OwedPPh21: Decimal; PostingDatePKPLedgEntry: Date;
                    EmployeeNoPKPLedgEntry: Code[20]);
    var
        TarifPKPLedgerEntry: Record "Tarif PKP Ledger Entry Accrue";
        TarifEntryNo: Integer;
        TarifPKPLedgerEntry2: Record "Tarif PKP Ledger Entry Accrue";
    begin
        TarifPKPLedgerEntry2.LockTable();
        TarifPKPLedgerEntry2.RESET;
        IF TarifPKPLedgerEntry2.FINDLAST THEN
            TarifEntryNo := TarifPKPLedgerEntry2."Entry No." + 1
        ELSE
            TarifEntryNo := 1;

        TarifPKPLedgerEntry.INIT;
        TarifPKPLedgerEntry."Entry No." := TarifEntryNo;
        TarifPKPLedgerEntry."Payroll Ledger Entry No." := PayrollLedgEntryNoHitungPPh21;
        TarifPKPLedgerEntry."Used Percentage" := _UsedPercentage;
        TarifPKPLedgerEntry.PPh21 := PPhCalculated;
        TarifPKPLedgerEntry."Amount Used" := _UsedAmount;
        TarifPKPLedgerEntry."Yearly PKP" := _YearlyPKP;
        TarifPKPLedgerEntry."Owed PPh 21" := _OwedPPh21;
        TarifPKPLedgerEntry."Posting Date" := PostingDatePKPLedgEntry;
        TarifPKPLedgerEntry."Employee No." := EmployeeNoPKPLedgEntry;
        TarifPKPLedgerEntry.Insert();
    end;

    local procedure InsertTHRLedgerEntry(EmployeeNoTHR: code[20]; PostingDateTHR: date; _PPh21THRGitu: Decimal;
                                        THRnya: Decimal; YangPakeTHR: Boolean; Kotor: Decimal;
                                        TarifTHR: Decimal; PKPSetahunTHR: Decimal);
    var
        THRLedgerEntry: Record "THR Ledger Entry";
        THRLedgerEntry2: Record "THR Ledger Entry";
        EntryNo: Integer;
        EmployeeTHR: Record Employee;
        DimensionCodeTHR: Code[20];
    begin
        EmployeeTHR.Get(EmployeeNoTHR);
        EmployeeTHR.CalcFields("MSI_HRIS Shortcut Dim No.");
        EmployeeTHR.TestField("MSI_HRIS Shortcut Dim Code");
        EmployeeTHR.GeneralLedgerDimensionSetup(DimensionCodeTHR,
                    EmployeeTHR."MSI_HRIS Shortcut Dim No.");

        THRLedgerEntry2.LockTable();
        THRLedgerEntry2.Reset();
        if THRLedgerEntry2.FindLast() then
            EntryNo := THRLedgerEntry2."Entry No." + 1
        else
            EntryNo := 1;

        THRLedgerEntry.Init();
        THRLedgerEntry."Entry No." := EntryNo;
        THRLedgerEntry."Dimension Code" := DimensionCodeTHR;
        THRLedgerEntry."Dimension No." := EmployeeTHR."MSI_HRIS Shortcut Dim No.";
        THRLedgerEntry."Dimension Value" := EmployeeTHR."MSI_HRIS Shortcut Dim Code";
        THRLedgerEntry."Employee No." := EmployeeNoTHR;
        THRLedgerEntry."Posting Date" := PostingDateTHR;
        if YangPakeTHR then begin
            THRLedgerEntry."PPh 21 THR Type" := THRLedgerEntry."PPh 21 THR Type"::"With THR Amount";
            THRLedgerEntry."Brutto Plus THR" := kotor;
            THRLedgerEntry."PPh 21 THR" := _PPh21THRGitu;
            THRLedgerEntry."THR Amount" := THRnya;

        end else begin
            THRLedgerEntry."PPh 21 THR Type" := THRLedgerEntry."PPh 21 THR Type"::"Without THR Amount";
            THRLedgerEntry."Brutto Minus THR" := Kotor;
            THRLedgerEntry."PPh 21 THR" := -1 * _PPh21THRGitu;
            THRLedgerEntry."THR Amount" := 0;

        end;
        THRLedgerEntry."% Tarif Used" := TarifTHR;
        THRLedgerEntry."PKP Setahun" := PKPSetahunTHR;

        THRLedgerEntry.Insert();
    end;

    local procedure HitungDuitPPh21(_JumlahBulan: Integer; AmountUsed: Decimal;
                                    var TarifYangDipake: Decimal; var PPh21Terutang: Decimal;
                                    var _DuitPPh21: Decimal; CalculateTHR: Boolean);
    begin
        PPh21Terutang := (TarifYangDipake / 100) * AmountUsed;
        //if not CalculateTHR then
        _DuitPPh21 := PPh21Terutang / _JumlahBulan;
        //else
        //  _DuitPPh21 := PPh21Terutang;
        IF _DuitPPh21 < 0 THEN _DuitPPh21 := 0;
    end;

    local procedure HitungPPh21(EmployeePPh21: Record Employee; PostingDatePPh21: Date;
                                VAR JumlahBulan: Integer; VAR PengurangPajak: Decimal;
                                VAR PenghasilanKotor: Decimal; VAR DuitBersihSebulan: Decimal;
                                VAR DuitBersihSetahun: Decimal; VAR DuitPTKPGituLoh: Decimal;
                                VAR DuitJabatan: Decimal; _PayrollLedgerEntryNo: integer;
                                HitungTHR: Boolean; _UangTHR: Decimal; _denganAngkaTHR: Boolean);
    var
        TarifPPh21Setup: Record "Tariff PPh 21 Setup";
        Selesai: Boolean;
        PKPSetahun: Decimal;
        _TarifYangDipake: Decimal;
        _PPh21Terutang: Decimal;
        PKPSetahunAsli: Decimal;
        _DuitPPh21: Decimal;
        _DuitPPh21THR: Decimal;
    begin
        CLEAR(DuitBersihSebulan);
        CLEAR(DuitBersihSetahun);
        CLEAR(DuitPTKPGituLoh);
        CLEAR(PKPSetahun);
        Clear(_TarifYangDipake);
        clear(_PPh21Terutang);
        Clear(_DuitPPh21);
        Clear(_DuitPPh21THR);

        Selesai := FALSE;

        HitungBulanKerja(EmployeePPh21, JumlahBulan, PostingDatePPh21);

        GetBiayaJabatan(DuitJabatan, PenghasilanKotor, TRUE);

        PengurangPajak := PengurangPajak - DuitJabatan;

        DuitBersihSebulan := PenghasilanKotor + PengurangPajak;
        DuitBersihSetahun := DuitBersihSebulan * JumlahBulan;

        DuitBersihSetahun := Round(DuitBersihSetahun, 1000, '=');

        GetPTKP(EmployeePPh21, DuitPTKPGituLoh, PostingDatePPh21);

        PKPSetahun := DuitBersihSetahun - DuitPTKPGituLoh;
        PKPSetahunAsli := PKPSetahun;

        TarifPPh21Setup.RESET;
        TarifPPh21Setup.FINDFIRST;
        REPEAT
            _TarifYangDipake := GetTarifNPWP(EmployeePPh21, TarifPPh21Setup);
            Clear(_DuitPPh21);

            if (TarifPPh21Setup."Upper Limit" <> 0)
               and (TarifPPh21Setup."Upper Limit" < PKPSetahun) then begin

                //proses hitung pph21 gaji biasa
                if not HitungTHR then begin
                    HitungDuitPPh21(JumlahBulan, TarifPPh21Setup."Upper Limit", _TarifYangDipake,
                                    _PPh21Terutang, _DuitPPh21, false);
                    InsertPKPLedgerEntry(_PayrollLedgerEntryNo, _TarifYangDipake, _DuitPPh21,
                                        TarifPPh21Setup."Upper Limit", PKPSetahunAsli, _PPh21Terutang,
                                        PostingDatePPh21, EmployeePPh21."No.");
                end else begin
                    //proses hitung pph21 THR
                    HitungDuitPPh21(JumlahBulan, TarifPPh21Setup."Upper Limit", _TarifYangDipake,
                                    _PPh21Terutang, _DuitPPh21, true);

                    //misahin dan insert ke table, mana PPh21 dengan nominal THR, mana yang tanpa.
                    if HitungTHR then
                        if not _denganAngkaTHR then begin
                            _DuitPPh21THR := _DuitPPh21THR * -1;
                            //insert ke THR Ledger Entry yang minus THR
                            InsertTHRLedgerEntry(EmployeePPh21."No.", PostingDatePPh21, _DuitPPh21, _UangTHR, false,
                            PenghasilanKotor, _TarifYangDipake, PKPSetahun);
                        end else
                            InsertTHRLedgerEntry(EmployeePPh21."No.", PostingDatePPh21, _DuitPPh21, _UangTHR, true,
                            PenghasilanKotor, _TarifYangDipake, PKPSetahun);

                end;
                PKPSetahun := PKPSetahun - TarifPPh21Setup."Upper Limit";

            end
            else begin
                //proses hitung pph21 gaji biasa
                if not HitungTHR then begin
                    HitungDuitPPh21(JumlahBulan, PKPSetahun, _TarifYangDipake, _PPh21Terutang,
                                    _DuitPPh21, false);
                    InsertPKPLedgerEntry(_PayrollLedgerEntryNo, _TarifYangDipake, _DuitPPh21,
                                        PKPSetahun, PKPSetahunAsli, _PPh21Terutang, PostingDatePPh21,
                                        EmployeePPh21."No.");
                end else begin
                    //proses hitung pph21 THR
                    HitungDuitPPh21(JumlahBulan, PKPSetahun, _TarifYangDipake, _PPh21Terutang,
                                    _DuitPPh21, true);

                    //misahin dan insert ke table, mana PPh21 dengan nominal THR, mana yang tanpa.
                    if HitungTHR then
                        if not _denganAngkaTHR then begin
                            _DuitPPh21THR := _DuitPPh21THR * -1;
                            //insert ke THR Ledger Entry yang minus THR
                            InsertTHRLedgerEntry(EmployeePPh21."No.", PostingDatePPh21, _DuitPPh21, _UangTHR, false,
                            PenghasilanKotor, _TarifYangDipake, PKPSetahun);
                        end else
                            InsertTHRLedgerEntry(EmployeePPh21."No.", PostingDatePPh21, _DuitPPh21, _UangTHR, true,
                            PenghasilanKotor, _TarifYangDipake, PKPSetahun);
                end;
                Selesai := true;
            end;
        UNTIL (Selesai) OR (TarifPPh21Setup.NEXT = 0);

    end;

    local procedure InsertDetailedPayrollLedgerEntry(EmployeeNoDetailed: Code[20];
                    PostingDateDetailed: Date; _PayrollLedgEntryNo: Integer;
                    Allowance: Boolean; ComponentCode: Code[20]; Uangnya: Decimal;
                    Tipe: Enum "Det. Payroll Ledg. Entry Type";
                    THRDetailedPayroll: Boolean; PaidByEmployee: Boolean);
    var
        DetailedPayrollLedgerEntry: Record "Det. Payrol Ledg. Entry Accrue";
        DetailedPayrollLedgerEntry2: Record "Det. Payrol Ledg. Entry Accrue";
        AllowanceComp: record "Allowance Component";
        DeductionComp: Record "Deduction Component";
        EmployeeDetailedPayroll: Record Employee;
        _StatusDetailed: enum "Marital Status";
        _JumlahDependentsDetailed: Integer;
        EntryNoTemp: Integer;
        DimensionCodeDetailedPayroll: Code[20];
    begin
        EmployeeDetailedPayroll.GET(EmployeeNoDetailed);
        EmployeeDetailedPayroll.CalcFields("MSI_HRIS Shortcut Dim No.");
        EmployeeDetailedPayroll.GeneralLedgerDimensionSetup(DimensionCodeDetailedPayroll,
        EmployeeDetailedPayroll."MSI_HRIS Shortcut Dim No.");

        if not THRDetailedPayroll then begin
            //Blok insert ke tabel fisik, karena ini adalah proses payroll biasa
            DetailedPayrollLedgerEntry2.LockTable();
            DetailedPayrollLedgerEntry2.Reset();
            IF DetailedPayrollLedgerEntry2.FindLast() THEN
                EntryNo := DetailedPayrollLedgerEntry2."Entry No." + 1
            ELSE
                EntryNo := 1;

            DetailedPayrollLedgerEntry.INIT;
            DetailedPayrollLedgerEntry."Entry No." := EntryNo;
            DetailedPayrollLedgerEntry."Payroll Ledger Entry No." := _PayrollLedgEntryNo;
            DetailedPayrollLedgerEntry."Posting Date" := PostingDateDetailed;
            DetailedPayrollLedgerEntry."Employee No." := EmployeeNoDetailed;
            DetailedPayrollLedgerEntry."Dimension Code" := DimensionCodeDetailedPayroll;
            DetailedPayrollLedgerEntry."Dimension No." :=
                                    EmployeeDetailedPayroll."MSI_HRIS Shortcut Dim No.";
            DetailedPayrollLedgerEntry."Dimension Value" :=
                                        EmployeeDetailedPayroll."MSI_HRIS Shortcut Dim Code";

            StatusDanDependentPajak(PostingDateDetailed, EmployeeDetailedPayroll, _StatusDetailed, _JumlahDependentsDetailed);

            DetailedPayrollLedgerEntry."Marital Status for Tax" := _StatusDetailed;
            DetailedPayrollLedgerEntry."Dependent Kids for Tax" := _JumlahDependentsDetailed;

            if PaidByEmployee then
                DetailedPayrollLedgerEntry."Paid by Employee" := PaidByEmployee;

            CASE Tipe OF
                Tipe::Allowance:
                    BEGIN
                        DetailedPayrollLedgerEntry.Type := DetailedPayrollLedgerEntry.Type::Allowance;
                        AllowanceComp.GET(ComponentCode);
                        DetailedPayrollLedgerEntry.Description := AllowanceComp.Name;
                        DetailedPayrollLedgerEntry."Component Code" := AllowanceComp.Kode;
                        DetailedPayrollLedgerEntry.Amount := Uangnya;
                        if AllowanceComp."Mandatory for Tax" then
                            DetailedPayrollLedgerEntry."Allowance Mandatory for Tax" := true;
                    END;

                Tipe::Deduction:
                    BEGIN
                        DetailedPayrollLedgerEntry.Type := DetailedPayrollLedgerEntry.Type::Deduction;
                        DeductionComp.GET(ComponentCode);
                        DetailedPayrollLedgerEntry.Description := DeductionComp.Name;
                        DetailedPayrollLedgerEntry."Component Code" := DeductionComp.Kode;
                        DetailedPayrollLedgerEntry.Amount := -Uangnya;
                        IF DeductionComp."Mandatory For Tax" THEN
                            DetailedPayrollLedgerEntry."Deduction Mandatory for Tax" := TRUE;
                    END;

                Tipe::"Biaya Jabatan":
                    BEGIN
                        DetailedPayrollLedgerEntry.Description := 'Biaya Jabatan';
                        DetailedPayrollLedgerEntry.Type := DetailedPayrollLedgerEntry.Type::"Biaya Jabatan";
                        DetailedPayrollLedgerEntry.Amount := -Uangnya;
                    END;

                Tipe::"PPh 21":
                    BEGIN
                        DetailedPayrollLedgerEntry.Description := 'Pajak PPh21';
                        DetailedPayrollLedgerEntry.Type := DetailedPayrollLedgerEntry.Type::"PPh 21";
                        DetailedPayrollLedgerEntry.Amount := -Uangnya;
                    END;
            END;
            DetailedPayrollLedgerEntry.Insert();
        end else begin
            //Blok insert ke table temp, karena ini adalah proses THR
            TempDetailedPayrollLedgerEntry.Reset();
            if TempDetailedPayrollLedgerEntry.FindLast() then
                EntryNoTemp := TempDetailedPayrollLedgerEntry."Entry No." + 1
            else
                EntryNoTemp := 1;

            TempDetailedPayrollLedgerEntry.Init();
            TempDetailedPayrollLedgerEntry."Entry No." := EntryNoTemp;
            TempDetailedPayrollLedgerEntry."Posting Date" := PostingDateDetailed;
            TempDetailedPayrollLedgerEntry."Employee No." := EmployeeNoDetailed;

            StatusDanDependentPajak(PostingDateDetailed, EmployeeDetailedPayroll, _StatusDetailed, _JumlahDependentsDetailed);

            TempDetailedPayrollLedgerEntry."Marital Status for Tax" := _StatusDetailed;
            TempDetailedPayrollLedgerEntry."Dependent Kids for Tax" := _JumlahDependentsDetailed;

            CASE Tipe OF
                Tipe::Allowance:
                    BEGIN
                        TempDetailedPayrollLedgerEntry.Type := TempDetailedPayrollLedgerEntry.Type::Allowance;
                        AllowanceComp.GET(ComponentCode);
                        TempDetailedPayrollLedgerEntry.Description := AllowanceComp.Name;
                        TempDetailedPayrollLedgerEntry."Component Code" := AllowanceComp.Kode;
                        TempDetailedPayrollLedgerEntry.Amount := Uangnya;
                        if AllowanceComp."Mandatory for Tax" then
                            TempDetailedPayrollLedgerEntry."Allowance Mandatory for Tax" := true;
                    END;

                Tipe::Deduction:
                    BEGIN
                        TempDetailedPayrollLedgerEntry.Type := TempDetailedPayrollLedgerEntry.Type::Deduction;
                        DeductionComp.GET(ComponentCode);
                        TempDetailedPayrollLedgerEntry.Description := DeductionComp.Name;
                        TempDetailedPayrollLedgerEntry."Component Code" := DeductionComp.Kode;
                        TempDetailedPayrollLedgerEntry.Amount := -Uangnya;
                        IF DeductionComp."Mandatory For Tax" THEN
                            TempDetailedPayrollLedgerEntry."Deduction Mandatory for Tax" := TRUE;
                    END;

                Tipe::"Biaya Jabatan":
                    BEGIN
                        TempDetailedPayrollLedgerEntry.Description := 'Biaya Jabatan';
                        TempDetailedPayrollLedgerEntry.Type := TempDetailedPayrollLedgerEntry.Type::"Biaya Jabatan";
                        TempDetailedPayrollLedgerEntry.Amount := -Uangnya;
                    END;

                Tipe::"PPh 21":
                    BEGIN
                        TempDetailedPayrollLedgerEntry.Description := 'Pajak PPh21';
                        TempDetailedPayrollLedgerEntry.Type := TempDetailedPayrollLedgerEntry.Type::"PPh 21";
                        TempDetailedPayrollLedgerEntry.Amount := -Uangnya;
                    END;
            END;
            TempDetailedPayrollLedgerEntry.Insert();
        end;
    end;

    local procedure SalaryRestriction(EmployeeSalaryRestricted: Record Employee; VAR WhatSalary: Decimal; Allowance: Boolean; ComponentCode: Code[20])
    var
        SalaryToUse: Decimal;
    begin
        CLEAR(SalaryToUse);
        CLEAR(WhatSalary);

        SalaryToUse := EmployeeSalaryRestricted."MSI_HRIS Basic Salary";
        WhatSalary := SalaryToUse;

        IF Allowance THEN BEGIN
            AllowanceComp.GET(ComponentCode);

            IF AllowanceComp."Salary Lower Limit" <> 0 THEN
                IF SalaryToUse <= AllowanceComp."Salary Lower Limit" THEN
                    WhatSalary := AllowanceComp."Salary Lower Limit";

            IF AllowanceComp."Salary Upper Limit" <> 0 THEN
                IF SalaryToUse > AllowanceComp."Salary Upper Limit" THEN
                    WhatSalary := AllowanceComp."Salary Upper Limit";

        END ELSE BEGIN
            DeductionComp.GET(ComponentCode);

            IF DeductionComp."Salary Lower Limit" <> 0 THEN
                IF SalaryToUse <= DeductionComp."Salary Lower Limit" THEN
                    WhatSalary := DeductionComp."Salary Lower Limit";

            IF DeductionComp."Salary Upper Limit" <> 0 THEN
                IF SalaryToUse > DeductionComp."Salary Upper Limit" THEN
                    WhatSalary := DeductionComp."Salary Upper Limit";

        END;
    end;


    local procedure AgeEligible(EmployeeAge: Record Employee; PostingDate: Date; ComponentCode: Code[20]; Allowance: Boolean): Boolean
    var
        Umur: integer;
    begin
        EmployeeAge.TESTFIELD("Birth Date");

        Umur := PostingDate - EmployeeAge."Birth Date";

        IF Allowance THEN BEGIN
            AllowanceComp.GET(ComponentCode);
            IF (Umur >= AllowanceComp."Age Lower Limit") AND (Umur <= AllowanceComp."Age Upper Limit") THEN
                EXIT(TRUE);
        END ELSE BEGIN
            DeductionComp.GET(ComponentCode);
            IF (Umur >= AllowanceComp."Age Lower Limit") AND (Umur <= AllowanceComp."Age Upper Limit") THEN
                EXIT(TRUE);
        END;
    end;

    local procedure GetPTKP(EmployeePTKP: Record Employee; VAR AngkaPTKP: Decimal; PostingDatePTKP: Date)
    var
        PTKPSetup: record "Payroll General Setup";
        _StatusPTKP: enum "Marital Status";
        _JumlahDependentsPTKP: Integer;
    begin
        PTKPSetup.GET;
        PTKPSetup.TESTFIELD("PTKP Single");
        PTKPSetup.TESTFIELD("PTKP Married");
        PTKPSetup.TESTFIELD("PTKP Dependent");
        EmployeePTKP.TestField(Gender);

        CLEAR(AngkaPTKP);
        CLEAR(_JumlahDependentsPTKP);
        CLEAR(_StatusPTKP);

        AngkaPTKP := PTKPSetup."PTKP Single";

        StatusDanDependentPajak(PostingDatePTKP, EmployeePTKP, _StatusPTKP, _JumlahDependentsPTKP);

        IF _StatusPTKP = _StatusPTKP::Married THEN
            AngkaPTKP := AngkaPTKP + PTKPSetup."PTKP Married";

        IF _JumlahDependentsPTKP > 3 THEN _JumlahDependentsPTKP := 3;

        AngkaPTKP := AngkaPTKP + (_JumlahDependentsPTKP * PTKPSetup."PTKP Dependent");

    end;

    local procedure HitungBulanKerja(EmployeeHitungBulan: Record Employee; VAR BulanKerja: Integer; PostingDateHitungBulan: Date)
    var
        PositionLedgerEntry: Record "Position Ledger Entry";
        BulanBergabung: Integer;
        BulanPostingDate: Integer;
        TahunBergabung: Integer;
        TahunPostingDate: integer;
        MultipleRecord: Boolean;
    begin
        MultipleRecord := FALSE;
        PositionLedgerEntry.RESET;
        PositionLedgerEntry.SETRANGE("Employee No.", EmployeeHitungBulan."No.");
        /* BLOK INI UNTUK PENGEMBANGAN
        IF PositionLedgerEntry.FINDLAST THEN BEGIN
            IF PositionLedgerEntry.COUNT > 1 THEN BEGIN
                MultipleRecord := TRUE;
                //pindahkan kursor ke record pertama
                PositionLedgerEntry.FINDFIRST;
                TahunBergabung := DATE2DMY(PositionLedgerEntry."Effective Date", 3);
                TahunPostingDate := DATE2DMY(PostingDateHitungBulan, 3);

                IF TahunBergabung < TahunPostingDate THEN
                    BulanKerja := 12;
            END;

            IF (MultipleRecord) OR (PositionLedgerEntry.COUNT = 1) THEN BEGIN
                BulanBergabung := DATE2DMY(PositionLedgerEntry."Effective Date", 2);
                BulanPostingDate := DATE2DMY(PostingDateHitungBulan, 2);
                IF BulanBergabung = 1 THEN
                    BulanKerja := 12
                ELSE
                    BulanKerja := (12 - BulanBergabung) + 1;
            END;
        END*/

        //sementara pake blok ini untuk position ledger entry yg lebih sederhana.
        if PositionLedgerEntry.FindFirst() then begin
            PositionLedgerEntry.FINDFIRST;
            TahunBergabung := DATE2DMY(PositionLedgerEntry."Contract Start Date", 3);
            TahunPostingDate := DATE2DMY(PostingDateHitungBulan, 3);

            if TahunBergabung < TahunPostingDate then
                BulanKerja := 12
            else begin
                BulanBergabung := DATE2DMY(PositionLedgerEntry."Contract Start Date", 2);
                BulanPostingDate := DATE2DMY(PostingDateHitungBulan, 2);
                IF BulanBergabung = 1 THEN
                    BulanKerja := 12
                ELSE
                    BulanKerja := (12 - BulanBergabung) + 1;
            end;
        end
        else
            error('Employee has not been set hired.');
    end;

    local procedure GetBiayaJabatan(VAR BiayaJabatan: Decimal; BruttoIncome: Decimal; Monthly: Boolean)
    var
        BiayaJabatanSetup: Record "Payroll General Setup";
    begin
        BiayaJabatanSetup.GET;
        BiayaJabatanSetup.TestField("Monthly Max Income");
        BiayaJabatanSetup.TestField("Yearly Max Income");

        BiayaJabatan := (BiayaJabatanSetup."Yearly Brutto Inc. Percentage" / 100) * BruttoIncome;

        IF Monthly THEN
            IF BiayaJabatan > BiayaJabatanSetup."Monthly Max Income" THEN
                BiayaJabatan := BiayaJabatanSetup."Monthly Max Income"
            ELSE
                IF BiayaJabatan > BiayaJabatanSetup."Yearly Max Income" THEN
                    BiayaJabatan := BiayaJabatanSetup."Yearly Max Income";
    end;

    local procedure InsertPayrollLedgerEntry(EmployeeNoPayroll: Code[20]; PostingDatePayroll: Date; VAR _PayrollLedgEntryNo: Integer)
    var
        PayrollLedgerEntry: Record "Payroll Ledger Entry Accrue";
        PayrollLedgerEntry2: Record "Payroll Ledger Entry Accrue";
        EmployeePayrollLedgerEntry: Record Employee;
        DimensionCodeIPLE: Code[20];
    begin
        EmployeePayrollLedgerEntry.Get(EmployeeNoPayroll);
        EmployeePayrollLedgerEntry.TestField("MSI_HRIS Shortcut Dim Code");
        EmployeePayrollLedgerEntry.CalcFields("MSI_HRIS Shortcut Dim No.");

        EmployeePayrollLedgerEntry.GeneralLedgerDimensionSetup(DimensionCodeIPLE,
        EmployeePayrollLedgerEntry."MSI_HRIS Shortcut Dim No.");

        PayrollLedgerEntry2.LockTable();
        PayrollLedgerEntry2.RESET;
        IF PayrollLedgerEntry2.FINDLAST THEN
            _PayrollLedgEntryNo := PayrollLedgerEntry2."Entry No." + 1
        ELSE
            _PayrollLedgEntryNo := 1;

        PayrollLedgerEntry.INIT;
        PayrollLedgerEntry."Entry No." := _PayrollLedgEntryNo;
        PayrollLedgerEntry."Employee No." := EmployeeNoPayroll;
        PayrollLedgerEntry."Posting Date" := PostingDatePayroll;
        PayrollLedgerEntry."Dimension No." := EmployeePayrollLedgerEntry."MSI_HRIS Shortcut Dim No.";
        PayrollLedgerEntry."Dimension Code" := DimensionCodeIPLE;
        PayrollLedgerEntry."Dimension Value" := EmployeePayrollLedgerEntry."MSI_HRIS Shortcut Dim Code";
        PayrollLedgerEntry.INSERT;
    end;

    local procedure GetFamilyDependents(EmployeeDependents: Record Employee; VAR JumlahDependents: Integer; PostingDateFamily: Date)
    var
        EmployeeFamilyEntry: Record "Employee Family Entry";
        TahunPostingDateFamily: Integer;
        TahunLahir: Integer;
    begin
        TahunPostingDateFamily := DATE2DMY(PostingDateFamily, 3);
        JumlahDependents := 0;

        EmployeeFamilyEntry.RESET;
        EmployeeFamilyEntry.SETRANGE("Employee No.", EmployeeDependents."No.");
        EmployeeFamilyEntry.SETFILTER(Relationship, '1|2|3|4|5|6|7|8|9|10');
        EmployeeFamilyEntry.SETRANGE(Dependent, TRUE);
        if EmployeeFamilyEntry.FINDSET then
            repeat
                Clear(TahunLahir);
                TahunLahir := Date2DMY(EmployeeFamilyEntry."Date of Birth", 3);
                if TahunLahir < TahunPostingDateFamily then
                    JumlahDependents := JumlahDependents + 1;
            until EmployeeFamilyEntry.Next() = 0;
    end;

    local procedure StatusDanDependentPajak(PostingDatePajak: Date; EmployeePajak: Record Employee; VAR _StatusMenurutPajak: enum "Marital Status"; VAR _JumlahDependentsMenurutPajak: Integer): Boolean
    var
        DetailedPayrollPTKP: record "Det. Payrol Ledg. Entry Accrue";
        TahunPostingDate: Integer;
        TahunEntryTerakhirLedger: Integer;
        TahunMenikah: Integer;
    begin
        TahunPostingDate := DATE2DMY(PostingDatePajak, 3);

        //Begitu mulai, langsung status dikasi single
        _StatusMenurutPajak := _StatusMenurutPajak::Single;

        //Lalu cek status married dan married date, 
        if EmployeePajak."MSI_HRIS Marital Status" = EmployeePajak."MSI_HRIS Marital Status"::Married then begin

            if EmployeePajak."MSI_HRIS Marital Date" <> 0D then
                TahunMenikah := Date2DMY(EmployeePajak."MSI_HRIS Marital Date", 3);

            //if TahunMenikah < TahunPostingDate then
            _StatusMenurutPajak := _StatusMenurutPajak::Married;
        end;

        GetFamilyDependents(EmployeePajak, _JumlahDependentsMenurutPajak, PostingDatePajak);

        //Tapi kemudian akan dicek, jika detailed payroll terisi, dan tahunpostingdate = tahunentryterakhir ledger, maka
        //Ganti value di bawah ini dengan yg di dalam detailed payroll ledger.

        DetailedPayrollPTKP.RESET;
        DetailedPayrollPTKP.SETRANGE("Employee No.", EmployeePajak."No.");
        DetailedPayrollPTKP.SETCURRENTKEY("Posting Date");
        IF DetailedPayrollPTKP.FINDLAST THEN BEGIN

            TahunEntryTerakhirLedger := DATE2DMY(DetailedPayrollPTKP."Posting Date", 3);

            //Kalo tahun postingdate sama dengan tahun di detail payroll ledger, ambil status dan dependent di ledger tersebut
            //Sisanya ambil nilai default yang sudah di-inisiasi di atas, yaitu di employee card.
            IF TahunPostingDate = TahunEntryTerakhirLedger THEN BEGIN
                _StatusMenurutPajak := DetailedPayrollPTKP."Marital Status for Tax";
                _JumlahDependentsMenurutPajak := DetailedPayrollPTKP."Dependent Kids for Tax";
            END;

        END;
    end;
}