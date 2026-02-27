page 60144 "Employee List PPh Akhir Tahun"
{
    Caption = 'Year End PPh Calculation';
    PageType = Worksheet;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Employee;
    SourceTableView = where("First Name" = filter('<>MSI'), Status = const(Active));
    CardPageId = "Employee Card HR";
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

                field(StrDisplaying; StrDisplaying)
                {
                    ShowCaption = false;
                    Editable = false;
                    ApplicationArea = all;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
            }
            repeater(GroupName)
            {
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
                field(PeriodePenghasilan; PeriodePenghasilan)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Periode Penghasilan';
                }
                field("MSI_HRIS Yearly Gross Income"; Rec."MSI_HRIS Yearly Gross Income")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("MSI_HRIS Yearly THR Amount"; Rec."MSI_HRIS Yearly THR Amount")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(BiayaJabatan; BiayaJabatan)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Biaya Jabatan';
                }
                field("MSI_HRIS Total Deduction Taxed"; Rec."MSI_HRIS Total Deduction Taxed")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Iuran Pensiun atau Iuran THT/JHT';
                    DecimalPlaces = 0 : 0;
                }
                field(PenghasilanNettoSetahun; PenghasilanNettoSetahun)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Penghasilan Netto Setahun';
                    DecimalPlaces = 0 : 0;
                }
                field("MSI_HRIS PTKP Baru"; Rec."MSI_HRIS PTKP Baru")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(PKP; PKP)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("MSI_HRIS Tax Per Year Tahunan"; Rec."MSI_HRIS Tax Per Year Tahunan")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("MSI_HRIS Tax Paid"; Rec."MSI_HRIS Tax Paid")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(PPh21Terutang; PPh21Terutang)
                {
                    Caption = 'PPh 21 Terutang';
                    ApplicationArea = all;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Retrieve All Taxes Paid")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = GetBinContent;
                ApplicationArea = all;

                trigger OnAction();
                var
                    StrConfirm: Text;
                    Window: Dialog;
                    Employee: Record Employee;
                    PayrollLedgerEntry: Record "Payroll Ledger Entry";
                    TaxPaidEntry: Record "Tax Paid Entry";
                    EntryNo: Integer;
                    THRTaxPaid: Decimal;
                    EmployeeLastPayroll: Record Employee;
                    TaxPerYearLastPayroll: Decimal;
                    TaxPerYearTHR: Decimal;
                    TaxPaidEntryCheck: Record "Tax Paid Entry";
                    THREmployeeJoined: Query "THR Ledger and Employee Joined";
                begin
                    if not AdaAwaiting then
                        Error('You need to process payroll for December this year first.');

                    if PayrollProcessedEntry."Paid Taxes Retrieved" then
                        Error('You already retrieve all the paid taxes.');

                    StrConfirm := 'You are about to retrieve all the paid taxes from ' + Format(StartingDate, 0, '<Day> <Month Text> <Year4>') +
                                  ' to ' + Format(EndingDate, 0, '<Day> <Month Text> <Year4>') + ', for all employees.\' +
                                  'Are you sure to proceed?';

                    if not Confirm(StrConfirm) then exit;

                    //Ini untuk payroll bulanan
                    PayrollProcessedEntry.Reset();
                    PayrollProcessedEntry.SetRange("Posting Date Salary", StartingDate, EndingDateNovember);
                    if PayrollProcessedEntry.FindFirst() then begin

                        KotakProgress.Open('Retrieving payroll taxes in #1######');

                        repeat
                            KotakProgress.Update(1, Format(PayrollProcessedEntry."Posting Date Salary",
                            0, '<Day> <Month Text> <Year4>'));

                            Employee.Reset();
                            Employee.SetFilter("First Name", '<>MSI');
                            Employee.SetRange(Status, Employee.Status::Active);
                            Employee.SetRange("Date Filter", PayrollProcessedEntry."Posting Date Salary");
                            Employee.FindFirst();
                            repeat
                                Employee.CalcFields("MSI_HRIS Tax Per Year");
                                TaxPaidPerMonth := 0;

                                PayrollLedgerEntry.Reset();
                                PayrollLedgerEntry.SetRange("Payroll Processed Entry No.",
                                PayrollProcessedEntry."Entry No.");
                                PayrollLedgerEntry.SetRange("Employee No.", Employee."No.");
                                if PayrollLedgerEntry.FindFirst() then begin
                                    if PayrollLedgerEntry."Last Payroll" then
                                        TaxPaidPerMonth := PayrollLedgerEntry."Less/Over Deduct Tax"
                                    else
                                        if PayrollLedgerEntry."Periode Penghasilan" <> 0 then
                                            TaxPaidPerMonth := Round(Employee."MSI_HRIS Tax Per Year" /
                                            PayrollLedgerEntry."Periode Penghasilan", 1)
                                end else
                                    TaxPaidPerMonth := 0;

                                if TaxPaidPerMonth <> 0 then begin
                                    TaxPaidEntry.Reset();
                                    if TaxPaidEntry.FindLast() then
                                        EntryNo := TaxPaidEntry."Entry No." + 1
                                    else
                                        EntryNo := 1;

                                    TaxPaidEntry.Init();
                                    TaxPaidEntry."Entry No." := EntryNo;
                                    TaxPaidEntry."Employee No." := Employee."No.";
                                    TaxPaidEntry."Payroll Ledger Entry No." := PayrollLedgerEntry."Entry No.";
                                    TaxPaidEntry."Posting Date" := PayrollLedgerEntry."Posting Date";
                                    TaxPaidEntry."Tax Paid" := TaxPaidPerMonth;
                                    TaxPaidEntry."Retrieve Date" := EndingDate;
                                    TaxPaidEntry.Type := TaxPaidEntry.Type::Payroll;
                                    TaxPaidEntry.Insert();
                                end;

                            until Employee.Next() = 0;
                        until PayrollProcessedEntry.Next() = 0;
                    end;

                    KotakProgress.Close();

                    //ini untuk THR
                    //THRLedgerEntry.Reset();
                    //THRLedgerEntry.SetRange("Posting Date", StartingDate, EndingDate);
                    //if THRLedgerEntry.FindSet() then begin

                    KotakProgress2.Open('Retrieving THR taxes in #1######');

                    THREmployeeJoined.SetRange(THREmployeeJoined.Posting_Date, StartingDate, EndingDate);
                    THREmployeeJoined.Open();
                    while THREmployeeJoined.Read() do begin

                        TaxPerYearLastPayroll := 0;
                        THRTaxPaid := 0;
                        TaxPerYearTHR := 0;

                        KotakProgress2.Update(1, THREmployeeJoined.No_ + '-' +
                        Format(THREmployeeJoined.Posting_Date, 0, '<Day> <Month Text> <Year4>'));

                        Employee.Reset();
                        Employee.SetRange("No.", THREmployeeJoined.No_);
                        Employee.SetRange("Date Filter", THREmployeeJoined.Posting_Date);
                        Employee.FindFirst();
                        Employee.CalcFields("MSI_HRIS Tax Per Year THR");
                        TaxPerYearTHR := Employee."MSI_HRIS Tax Per Year THR";

                        PayrollLedgerEntry.Get(THREmployeeJoined.Payroll_Ledger_Entry_No_);

                        EmployeeLastPayroll.Reset();
                        EmployeeLastPayroll.SetRange("No.", THREmployeeJoined.No_);
                        EmployeeLastPayroll.SetRange("Date Filter", PayrollLedgerEntry."Posting Date");
                        EmployeeLastPayroll.FindFirst();
                        EmployeeLastPayroll.CalcFields("MSI_HRIS Tax Per Year");
                        TaxPerYearLastPayroll := EmployeeLastPayroll."MSI_HRIS Tax Per Year";


                        //if Employee."No." = 'E0004' then
                        //Message('Tgl = %1 Tipe=%2', THRLedgerEntry."Posting Date", THRLedgerEntry."Disbursement Type");

                        if TaxPerYearTHR > 0 then begin

                            THRTaxPaid := TaxPerYearTHR - TaxPerYearLastPayroll;

                            if THRTaxPaid <> 0 then begin
                                TaxPaidEntry.Reset();
                                if TaxPaidEntry.FindLast() then
                                    EntryNo := TaxPaidEntry."Entry No." + 1
                                else
                                    EntryNo := 1;

                                //TaxPaidEntryCheck.Reset();
                                //TaxPaidEntryCheck.SetRange("Employee No.", Employee."No.");
                                //TaxPaidEntryCheck.SetRange("Posting Date", THRLedgerEntry."Posting Date");
                                //if not TaxPaidEntryCheck.FindFirst() then begin
                                if not PayrollLedgerEntry."Last Payroll" then begin
                                    TaxPaidEntry.Init();
                                    TaxPaidEntry."Entry No." := EntryNo;
                                    TaxPaidEntry."Employee No." := THREmployeeJoined.No_;
                                    TaxPaidEntry."THR Ledger Entry No." := THREmployeeJoined.Entry_No_;
                                    TaxPaidEntry."Posting Date" := THREmployeeJoined.Posting_Date;
                                    TaxPaidEntry."Tax Paid" := THRTaxPaid;
                                    TaxPaidEntry."Retrieve Date" := EndingDate;
                                    TaxPaidEntry.Type := TaxPaidEntry.Type::THR;
                                    TaxPaidEntry."Disbursement Type" := THREmployeeJoined.Disbursement_Type;
                                    TaxPaidEntry.Insert();
                                end;
                                //end;
                            end;
                        end;


                    end;
                    //until THRLedgerEntry.Next() = 0;

                    THREmployeeJoined.Close();


                    PayrollProcessedEntry.Reset();
                    PayrollProcessedEntry.SetRange("Year End Process",
                    PayrollProcessedEntry."Year End Process"::"Awaiting Process");
                    if PayrollProcessedEntry.FindFirst() then begin
                        PayrollProcessedEntry."Paid Taxes Retrieved" := true;
                        PayrollProcessedEntry.Modify();
                    end;

                    KotakProgress2.Close();

                    CurrPage.Update();

                    Message('All tax paid successfully retrieved.');
                end;
            }
            action("Calculate Tax Per Year")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Calculate;
                ApplicationArea = all;

                trigger OnAction()
                var
                    PegawaiGituCui: Record Employee;
                    Window: Dialog;

                    TotalGrossIncome2: Decimal;
                    BiayaJabatan2: Decimal;
                    JumlahPengurangan2: Decimal;
                    PenghasilanNettoSetahun2: Decimal;
                    PKP2: Decimal;
                    TaxPerYear2: Decimal;
                    PPh21Terutang2: Decimal;
                    TarifPPh21EntryTahunan: Record "Tarif PPh21 Entry Tahunan";
                    EmployeeListHR: page "Employee List HR";
                    PeriodePenghasilanResign2: Integer;
                    BeneranResign2: Boolean;
                    PeriodePenghasilan2: Integer;
                begin
                    if not AdaAwaiting then
                        Error('You need to process payroll for December this year first.');

                    if not PayrollProcessedEntry."Paid Taxes Retrieved" then
                        Error('Please retrieve all the paid taxes');

                    if PayrollProcessedEntry."Tax Per Year Calculated" then
                        Error('You already calculate tax per year.');

                    if not Confirm('Proceed with calculating tax per year?') then exit;

                    Window.Open('Calculating tax per year...please wait.');

                    PegawaiGituCui.Reset();
                    PegawaiGituCui.SetFilter("First Name", '<>MSI');
                    PegawaiGituCui.SetRange("Date Filter", StartingDate, EndingDate);
                    if PegawaiGituCui.FindSet() then
                        repeat
                            TotalGrossIncome2 := 0;
                            BiayaJabatan2 := 0;
                            JumlahPengurangan2 := 0;
                            PenghasilanNettoSetahun2 := 0;
                            PKP2 := 0;
                            TaxPerYear2 := 0;
                            PPh21Terutang2 := 0;

                            PegawaiGituCui.CalcFields("MSI_HRIS Yearly Gross Income");
                            PegawaiGituCui.CalcFields("MSI_HRIS Yearly THR Amount");

                            TotalGrossIncome2 := PegawaiGituCui."MSI_HRIS Yearly Gross Income" + PegawaiGituCui."MSI_HRIS Yearly THR Amount";

                            ContractDetail.GetPeriodePenghasilan(PegawaiGituCui, EndingDate, PeriodePenghasilan2);
                            isResigned(PegawaiGituCui, PeriodePenghasilanResign2, BeneranResign2);
                            if BeneranResign2 then
                                PeriodePenghasilan2 := PeriodePenghasilanResign2;

                            BijabTahunan(BiayaJabatan2, TotalGrossIncome2, PeriodePenghasilan2);

                            //PayrollPost.GetBiayaJabatan(BiayaJabatan2, TotalGrossIncome2, false);

                            PegawaiGituCui.CalcFields("MSI_HRIS Total Deduction Taxed");


                            JumlahPengurangan2 := BiayaJabatan2 - PegawaiGituCui."MSI_HRIS Total Deduction Taxed";

                            PenghasilanNettoSetahun2 := (TotalGrossIncome2 - BiayaJabatan2) + PegawaiGituCui."MSI_HRIS Total Deduction Taxed";

                            PegawaiGituCui.CalcFields("MSI_HRIS PTKP Baru");

                            if (PenghasilanNettoSetahun2 - PegawaiGituCui."MSI_HRIS PTKP Baru" > 0) then
                                PKP2 := Round(PenghasilanNettoSetahun2 - PegawaiGituCui."MSI_HRIS PTKP Baru", 1000, '<')
                            else
                                PKP2 := 0;

                            TarifPPh21EntryTahunan.Reset();
                            TarifPPh21EntryTahunan.SetRange("Employee No.", PegawaiGituCui."No.");
                            TarifPPh21EntryTahunan.SetRange("Posting Date Payroll", EndingDate);
                            if not TarifPPh21EntryTahunan.FindFirst() then
                                EmployeeListHR.HitungTaxLagiTahunan(PegawaiGituCui."No.", PKP2, EndingDate);

                        until PegawaiGituCui.Next() = 0;

                    PayrollProcessedEntry.Reset();
                    PayrollProcessedEntry.SetRange("Year End Process",
                    PayrollProcessedEntry."Year End Process"::"Awaiting Process");
                    if PayrollProcessedEntry.FindFirst() then begin
                        PayrollProcessedEntry."Tax Per Year Calculated" := true;
                        PayrollProcessedEntry.Modify();
                    end;

                    Window.Close();
                    CurrPage.Update();
                    Message('Tax per year calculated successfully.');
                end;
            }
            action("Apply Results to December Payroll")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Apply;
                ApplicationArea = all;

                trigger OnAction()
                var
                    Window: Dialog;
                    Pegawai: Record Employee;
                    Terutang: Decimal;
                    EntryNo: Integer;
                begin
                    if not AdaAwaiting then
                        Error('You need to process payroll for December this year first.');

                    if not PayrollProcessedEntry."Paid Taxes Retrieved" then
                        Error('Please retrieve all the paid taxes.');

                    if not PayrollProcessedEntry."Tax Per Year Calculated" then
                        Error('Please calculate the tax per year.');

                    if PayrollProcessedEntry."Year End Process" =
                        PayrollProcessedEntry."Year End Process"::Processed then
                        Error('Year end is already processed.');

                    Window.Open('Applying results to December payroll...please wait.');

                    TarifPPh21EntryTahunan.Reset();
                    TarifPPh21EntryTahunan.SetRange("Posting Date Payroll", EndingDate);
                    TarifPPh21EntryTahunan.FindSet();
                    TarifPPh21EntryTahunan.ModifyAll("Posting Date December Payroll",
                    PayrollProcessedEntry."Posting Date Salary");

                    Pegawai.Reset();
                    Pegawai.SetFilter("First Name", '<>MSI');
                    Pegawai.SetRange(Status, Pegawai.Status::Active);
                    Pegawai.SetRange("Date Filter", StartingDate, EndingDate);
                    Pegawai.FindFirst();
                    repeat
                        Terutang := 0;
                        Pegawai.CalcFields("MSI_HRIS Tax Paid");
                        Pegawai.CalcFields("MSI_HRIS Tax Per Year Tahunan");

                        Terutang := Pegawai."MSI_HRIS Tax Per Year Tahunan" - Pegawai."MSI_HRIS Tax Paid";

                        YearEndLedgerEntry.LockTable();
                        YearEndLedgerEntry.Reset();
                        if YearEndLedgerEntry.FindLast() then
                            EntryNo := YearEndLedgerEntry."Entry No." + 1
                        else
                            EntryNo := 1;

                        YearEndLedgerEntry.Init();
                        YearEndLedgerEntry."Entry No." := EntryNo;
                        YearEndLedgerEntry."Employee No." := Pegawai."No.";
                        YearEndLedgerEntry."Year End Starting" := StartingDate;
                        YearEndLedgerEntry."Year End Ending" := EndingDate;
                        YearEndLedgerEntry."Posting Date Year End" := EndingDate;
                        YearEndLedgerEntry."Posting Date December Payroll" :=
                        PayrollProcessedEntry."Posting Date Salary";
                        YearEndLedgerEntry."PPh 21 Terutang" := Terutang;
                        YearEndLedgerEntry.Insert();
                    until Pegawai.Next() = 0;

                    PayrollProcessedEntry."Year End Process" := PayrollProcessedEntry."Year End Process"::Processed;
                    PayrollProcessedEntry.Modify();

                    Window.Close();
                    Message('Year end results successfully applied to December payroll.');

                    CurrPage.Close();
                    PageAkhirTahun.Run();
                end;
            }
            action("Undo Apply and Clear Transaction")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = DeleteRow;
                ApplicationArea = all;

                trigger OnAction()
                var
                    StrConfirm: Text;
                    Window: Dialog;

                    TaxPaidEntry: Record "Tax Paid Entry";
                    PayrollProcessedEntryTerakhir: Record "Payroll Processed Entry";
                begin
                    PayrollProcessedEntryTerakhir.Reset();
                    PayrollProcessedEntryTerakhir.SetFilter("Year End Process", '<>%1',
                    PayrollProcessedEntryTerakhir."Year End Process"::" ");
                    if PayrollProcessedEntryTerakhir.FindLast() then
                        if PayrollProcessedEntryTerakhir."Entry No." <> PayrollProcessedEntry."Entry No." then
                            Error('You can only undo the latest data. Cannot be done backdated.');

                    StrConfirm := 'This will unapply the December transaction and delete all data of calculated Year-End Tax and retrieved Tax Paid,\' +
                                  'from ' + Format(StartingDate, 0, '<Day> <Month Text> <Year4>') + ' to ' +
                                  Format(EndingDate, 0, '<Day> <Month Text> <Year4>') + '.\' +
                                  'Are you sure to continue?';
                    if not Confirm(StrConfirm) then exit;

                    Window.Open('Unapplying and deleting data, please wait..');

                    TarifPPh21EntryTahunan.Reset();
                    TarifPPh21EntryTahunan.SetRange("Posting Date Payroll", EndingDate);
                    if TarifPPh21EntryTahunan.FindSet() then
                        TarifPPh21EntryTahunan.DeleteAll();

                    TaxPaidEntry.Reset();
                    TaxPaidEntry.SetRange("Retrieve Date", EndingDate);
                    if TaxPaidEntry.FindSet() then
                        TaxPaidEntry.DeleteAll();

                    YearEndLedgerEntry.Reset();
                    YearEndLedgerEntry.SetRange("Posting Date Year End", EndingDate);
                    if YearEndLedgerEntry.FindSet() then
                        YearEndLedgerEntry.DeleteAll();

                    PayrollProcessedEntry.Reset();
                    //PayrollProcessedEntry.SetRange();

                    PayrollProcessedEntry."Paid Taxes Retrieved" := false;
                    PayrollProcessedEntry."Tax Per Year Calculated" := false;
                    PayrollProcessedEntry."Year End Process" := PayrollProcessedEntry."Year End Process"::"Awaiting Process";
                    PayrollProcessedEntry.Modify();

                    Window.Close();
                    Message('Data cleared.');

                    CurrPage.Close();
                    PageAkhirTahun.Run();
                end;
            }
        }
    }

    trigger
    OnAfterGetRecord()
    var
        PeriodePenghasilanResign: Integer;
        BeneranResign: Boolean;
    begin
        Clear(TotalGrossIncome);
        Clear(BiayaJabatan);
        Clear(JumlahPengurangan);
        Clear(PenghasilanNettoSetahun);
        Clear(PKP);
        //Clear(TaxPerYear);
        Clear(PPh21Terutang);
        Clear(PeriodePenghasilan);

        StrTanggalFilter := Rec.GetFilter("Date Filter");
        Evaluate(TanggalFilter, StrTanggalFilter);

        PayrollProcessedEntry.Reset();
        PayrollProcessedEntry.SetFilter("Year End Process", '<>%1',
        PayrollProcessedEntry."Year End Process"::" ");
        PayrollProcessedEntry.SetRange("Posting Date Year End", TanggalFilter);
        if PayrollProcessedEntry.FindFirst() then begin
            if PayrollProcessedEntry."Year End Process" =
                PayrollProcessedEntry."Year End Process"::"Awaiting Process" then
                StrDisplaying := 'Year end tax ' + Format(TanggalFilter) + ' is awaiting to be processed.'
            else
                StrDisplaying := 'Year end tax ' + Format(TanggalFilter) + ' already processed.';

            StrStartingDate := '0101' + Format(PayrollProcessedEntry.Year);
            Evaluate(StartingDate, StrStartingDate);
            EndingDate := CalcDate('<CY>', StartingDate);
            EndingDateNovember := CalcDate('<-1M>', EndingDate);
            EndingDateNovember := CalcDate('<CM>', EndingDateNovember);

        end;

        if EndingDate <> 0D then begin

            ContractDetail.GetPeriodePenghasilan(Rec, EndingDate, PeriodePenghasilan);
            isResigned(Rec, PeriodePenghasilanResign, BeneranResign);
            if BeneranResign then
                PeriodePenghasilan := PeriodePenghasilanResign;

            Rec.SetRange("Date Filter", StartingDate, EndingDate);
            //if Rec.FindFirst() then begin
            Rec.CalcFields("MSI_HRIS Yearly Gross Income");
            Rec.CalcFields("MSI_HRIS Yearly THR Amount");
            Rec.CalcFields("MSI_HRIS PTKP Baru");

            TotalGrossIncome := Rec."MSI_HRIS Yearly Gross Income" + Rec."MSI_HRIS Yearly THR Amount";

            //PayrollPost.GetBiayaJabatan(BiayaJabatan, TotalGrossIncome, false);
            BijabTahunan(BiayaJabatan, TotalGrossIncome, PeriodePenghasilan);

            Rec.CalcFields("MSI_HRIS Total Deduction Taxed");

            //dikurangi karena total deduction tax udah negatif
            JumlahPengurangan := BiayaJabatan - Rec."MSI_HRIS Total Deduction Taxed";

            //dijumlahkan karena jumlah pengurangan udah negatif
            PenghasilanNettoSetahun := (TotalGrossIncome - BiayaJabatan) + Rec."MSI_HRIS Total Deduction Taxed";


            if (PenghasilanNettoSetahun - Rec."MSI_HRIS PTKP Baru" > 0) then
                PKP := Round(PenghasilanNettoSetahun - Rec."MSI_HRIS PTKP Baru", 1000, '<')
            else
                PKP := 0;


            Rec.CalcFields("MSI_HRIS Tax Paid");

            PPh21Terutang := Rec."MSI_HRIS Tax Per Year Tahunan" - Rec."MSI_HRIS Tax Paid";

        end;
    end;

    trigger
    OnOpenPage()
    begin
        AmbilDataLast(TanggalFilter, AdaAwaiting, AdaLast, PayrollProcessedEntry);

        //Message('adalast=%1 adawaiting=%2', AdaLast, AdaAwaiting);

        if AdaLast then begin
            StrDisplaying := 'Year end tax ' + Format(TanggalFilter) + ' is already processed.';
            if AdaAwaiting then begin
                StrDisplaying := 'Year end tax ' + Format(TanggalFilter) + ' is awaiting to be processed.';
                StrStartingDate := '0101' + Format(PayrollProcessedEntry.Year);
                Evaluate(StartingDate, StrStartingDate);
                EndingDate := CalcDate('<CY>', StartingDate);
                EndingDateNovember := CalcDate('<-1M>', EndingDate);
                EndingDateNovember := CalcDate('<CM>', EndingDateNovember);
            end;
        end else
            StrDisplaying := '';

    end;

    local procedure AmbilDataLast(var TanggalFilterLast: Date; var isAwaiting: Boolean; var isAdaLast: Boolean;
    var PayrollProcessedEntryLast: Record "Payroll Processed Entry")
    begin
        PayrollProcessedEntryLast.Reset();
        PayrollProcessedEntryLast.SetFilter("Year End Process", '<>%1',
        PayrollProcessedEntryLast."Year End Process"::" ");
        if PayrollProcessedEntryLast.FindLast() then begin
            isAdaLast := true;
            TanggalFilterLast := PayrollProcessedEntryLast."Posting Date Year End";
            if PayrollProcessedEntryLast."Year End Process" =
            PayrollProcessedEntryLast."Year End Process"::"Awaiting Process" then
                isAwaiting := true
            else
                isAwaiting := false;
        end else
            TanggalFilterLast := 0D;
    end;

    var
        PageAkhirTahun: Page "Employee List PPh Akhir Tahun";
        StrDisplaying: Text;
        AdaLast: Boolean;
        TanggalFilter: Date;
        StrTanggalFilter: Text;

        TarifPPh21EntryTahunan: Record "Tarif PPh21 Entry Tahunan";
        YearEndLedgerEntry: Record "Year End Ledger Entry";
        LineCount: Integer;
        KotakProgress: Dialog;
        KotakProgress2: Dialog;
        ContractDetail: Record "Contract Detail";
        Contract: Record "Position Ledger Entry";

        TaxPaidPerMonth: Decimal;
        TaxPerYear: Decimal;
        PKP: Decimal;
        PenghasilanNettoSetahun: Decimal;
        JumlahPengurangan: Decimal;
        BiayaJabatan: Decimal;
        PayrollPost: Codeunit "Payroll Post";
        PeriodePenghasilan: Integer;
        PayrollProcessedEntry: Record "Payroll Processed Entry";
        StartingDate: Date;
        EndingDate: Date;
        EndingDateNovember: Date;
        StringAwaiting: Text;
        AdaAwaiting: Boolean;
        StrStartingDate: Text;
        TotalGrossIncome: Decimal;
        PPh21Terutang: Decimal;

    local procedure isResigned(Kuli: Record Employee; var _PeriodePeng: Integer;
    var IyaDiaResign: Boolean)
    var
        AddModifyContract: Page "Add-Modify Contract";
    begin
        Contract.Reset();
        Contract.SetRange("Employee No.", Kuli."No.");
        if Contract.FindLast() then
            if Contract."Resign Date" <> 0D then begin
                AddModifyContract.CountMonth(StartingDate, Contract."Resign Date", _PeriodePeng);
                IyaDiaResign := true;
            end else
                IyaDiaResign := false;
    end;

    local procedure BijabTahunan(var _BijabKoreksi: Decimal; _TotalGrossIncome: Decimal;
    PeriodePengki: Integer)
    var
        BiayaJabatanSetup: Record "Payroll General Setup";
        MaxTimesPeriod: Decimal;
        LimaPersenTotalGross: Decimal;
    begin
        BiayaJabatanSetup.Get();
        BiayaJabatanSetup.TestField("Monthly Max Income");
        Clear(MaxTimesPeriod);
        Clear(LimaPersenTotalGross);

        MaxTimesPeriod := PeriodePengki * BiayaJabatanSetup."Monthly Max Income";
        LimaPersenTotalGross := 0.05 * _TotalGrossIncome;

        if LimaPersenTotalGross >= MaxTimesPeriod then
            _BijabKoreksi := MaxTimesPeriod
        else
            _BijabKoreksi := LimaPersenTotalGross;
    end;
}