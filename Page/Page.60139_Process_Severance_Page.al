page 60139 "Process Severance Page"
{
    PageType = Card;
    //ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Process Severance Table";
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(GENERAL)
            {
                field(PostingDate; Rec.PostingDate)
                {
                    Caption = 'Document Date';
                    ApplicationArea = All;

                    trigger
                    OnValidate()
                    begin
                        if Rec."Ada Leave" then
                            if Rec.PostingDate <> xRec.PostingDate then
                                Error('You cannot change document date because its linked to the unused leave.');
                    end;
                }
            }
            group("EMPLOYEES RECAP")
            {
                group(atas)
                {
                    ShowCaption = false;
                    field(AllActive; AllActive)
                    {
                        ApplicationArea = all;
                        Editable = false;
                        Caption = 'All Active Employee';
                    }
                }
                group(bawah)
                {
                    ShowCaption = false;
                    field(ToBeProcessedSeverance; ToBeProcessedSeverance)
                    {
                        ApplicationArea = all;
                        Editable = false;
                        Caption = 'Severance to be Processed';
                    }
                }
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
                    Window: Dialog;
                    Contract: Record "Position Ledger Entry";
                    EmpSeveranceList: Page "Employee Severance List";
                    BulanPosting: Integer;
                    TahunPosting: Integer;
                    AccrualMgt: Codeunit "Accrual Management";
                    PayrollLedgerEntry: Record "Payroll Ledger Entry";
                    TotalAmount: Decimal;
                    BasicSalary: Decimal;
                    SummaryOfSeverance: Record "Summary Of Severance";
                    EntryNoSummary: Integer;
                    SudahAdaSummary: Boolean;
                    LeaveMgt: Codeunit "Leave Management";
                    DokumenNoGP: Code[20];
                    GPNoForTax: Code[20];
                    EmployeeTax: Record Employee;
                    StrGPDocNo: Text;
                    SeveranceLedgerAdaLink: Record "Severance Ledger Entry";
                    NomorEntryWoi: Integer;
                begin
                    if Rec.PostingDate = 0D then
                        Error('Please fill the posting date.');

                    if not Confirm('This will process severeance\Are you sure to continue?') then exit;

                    Clear(StrGPDocNo);

                    Window.Open('Posting....please wait..');

                    SummaryOfSeverance.Reset();
                    SummaryOfSeverance.SetRange("Document Date", Rec.PostingDate);
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
                        SummaryOfSeverance."Document Date" := Rec.PostingDate;
                        SummaryOfSeverance.Insert();
                    end;

                    EmployeeSeverance.FindFirst();
                    repeat
                        _ContractStart := 0D;
                        _ContractEnd := 0D;
                        _EndingDateCalc := 0D;
                        _ResignDate := 0D;
                        Clear(SeveranceReason);
                        TotalHariLoSSev := 0;
                        SeveranceLoS := 0;
                        CalcLoS := 0;
                        TotalIncome := 0;
                        SeveranceAmount := 0;
                        _HiringEntryNo := 0;
                        BulanPosting := 0;
                        TahunPosting := 0;
                        TotalAmount := 0;
                        BasicSalary := 0;
                        NomorEntryWoi := 0;

                        EmployeeSeverance.CalcFields("MSI_HRIS Total Severance Accr.");

                        PayrollLedgerEntry.Reset();
                        PayrollLedgerEntry.SetRange("Employee No.", EmployeeSeverance."No.");
                        PayrollLedgerEntry.FindLast();

                        EmployeeSeverance.SetRange("Date Filter", PayrollLedgerEntry."Posting Date");
                        EmployeeSeverance.CalcFields("MSI_HRIS Total Allowance Fix");

                        if EmployeeSeverance."MSI_HRIS Sevr. Apply to Old" then begin
                            EmployeeSeverance.TestField("MSI_HRIS Old Basic Salary");
                            BasicSalary := EmployeeSeverance."MSI_HRIS Old Basic Salary";
                        end else
                            BasicSalary := EmployeeSeverance."MSI_HRIS Basic Salary";

                        TotalIncome := BasicSalary + EmployeeSeverance."MSI_HRIS Total Allowance Fix";

                        EmployeeSeveranceList.FindStartAndEnd(EmployeeSeverance."No.", _ContractStart,
                        _ContractEnd, _EndingDateCalc, _ResignDate, _HiringEntryNo);

                        BulanPosting := Date2DMY(Rec.PostingDate, 2);
                        TahunPosting := Date2DMY(Rec.PostingDate, 3);

                        SeveranceLedgerEntryCheckDupl.Reset();
                        SeveranceLedgerEntryCheckDupl.SetRange("Employee No.", EmployeeSeverance."No.");
                        SeveranceLedgerEntryCheckDupl.SetRange("Bulan Posting", BulanPosting);
                        SeveranceLedgerEntryCheckDupl.SetRange("Tahun Posting", TahunPosting);
                        if SeveranceLedgerEntryCheckDupl.FindFirst() then
                            Error('Severance for %1-%2 for period %3 is already processed',
                                EmployeeSeverance."No.", EmployeeSeverance.FullName(),
                                Format(BulanPosting) + ' - ' + Format(TahunPosting));

                        if _ResignDate <> 0D then
                            SeveranceReason := 'Resigned/Terminated'
                        else
                            SeveranceReason := 'Contract Expired';

                        TotalHariLoSSev := InputTHRDateCalc.ExcelDays360(_ContractStart, _EndingDateCalc);
                        SeveranceLoS := (TotalHariLoSSev / 360 * 12) / 12;

                        if SeveranceLoS > 1 then
                            CalcLoS := 1
                        else
                            CalcLoS := SeveranceLoS;

                        SeveranceAmount := TotalIncome * CalcLoS;
                        TotalAmount := SeveranceAmount;

                        SeveranceLedgerAdaLink.Reset();
                        SeveranceLedgerAdaLink.SetRange("Employee No.", EmployeeSeverance."No.");
                        SeveranceLedgerAdaLink.SetRange("Unused Leave Doc. No.", Rec.UnusedLeaveDocNo);
                        if not SeveranceLedgerAdaLink.FindFirst() then begin

                            //bikin GP baru, karena ini ga ada leave-nya
                            LeaveMgt.CreateGPUnusedLeaveSeverance(EmployeeSeverance."No.", SeveranceAmount,
                            Rec.PostingDate, DokumenNoGP, false, true);

                            StrGPDocNo := StrGPDocNo + '-' + DokumenNoGP;

                            Clear(EntryNo);

                            SeveranceLedgerEntry.LockTable();
                            SeveranceLedgerEntry.Reset();
                            if SeveranceLedgerEntry.FindLast() then
                                EntryNo := SeveranceLedgerEntry."Entry No." + 1
                            else
                                EntryNo := 1;

                            NomorEntryWoi := EntryNo;

                            //insert ke table ledger asli
                            SeveranceLedgerEntry.Init();
                            SeveranceLedgerEntry."Entry No." := EntryNo;
                            SeveranceLedgerEntry."Employee No." := EmployeeSeverance."No.";
                            SeveranceLedgerEntry."Posting Date" := Rec.PostingDate;
                            SeveranceLedgerEntry."Severance Amount" := SeveranceAmount;
                            SeveranceLedgerEntry."Severance LoS" := SeveranceLoS;
                            SeveranceLedgerEntry."Calc. LoS" := CalcLoS;
                            SeveranceLedgerEntry."Severance Reason" := SeveranceReason;
                            SeveranceLedgerEntry."Total Hari LoS Severance" := TotalHariLoSSev;
                            SeveranceLedgerEntry."Contract Entry No." := _HiringEntryNo;
                            SeveranceLedgerEntry."Bulan Posting" := BulanPosting;
                            SeveranceLedgerEntry."Tahun Posting" := TahunPosting;
                            SeveranceLedgerEntry."Sum of Sev. Ledger Entry No." := EntryNoSummary;
                            SeveranceLedgerEntry."GP No." := DokumenNoGP;
                            SeveranceLedgerEntry."Document Date" := Rec.PostingDate;
                            SeveranceLedgerEntry.Finished := true;

                            SeveranceLedgerEntry."Basic Salary Used" := BasicSalary;
                            SeveranceLedgerEntry."Fix Allowance Used" := EmployeeSeverance."MSI_HRIS Total Allowance Fix";
                            SeveranceLedgerEntry."Actual Payment Date" := EmployeeSeverance."MSI_HRIS Actual Payment Date";
                            SeveranceLedgerEntry."Contract Start Date" := _ContractStart;
                            SeveranceLedgerEntry."Contract End Date" := _ContractEnd;
                            SeveranceLedgerEntry.Insert();

                            GPNoForTax := DokumenNoGP;
                        end else begin
                            SeveranceLedgerEntry.Reset();
                            SeveranceLedgerEntry.SetRange("Employee No.", EmployeeSeverance."No.");
                            SeveranceLedgerEntry.SetRange("Unused Leave Doc. No.", Rec.UnusedLeaveDocNo);
                            SeveranceLedgerEntry.FindFirst();

                            NomorEntryWoi := SeveranceLedgerEntry."Entry No.";

                            SeveranceLedgerEntry."Posting Date" := Rec.PostingDate;
                            SeveranceLedgerEntry."Severance Amount" := SeveranceAmount;
                            SeveranceLedgerEntry."Severance LoS" := SeveranceLoS;
                            SeveranceLedgerEntry."Calc. LoS" := CalcLoS;
                            SeveranceLedgerEntry."Severance Reason" := SeveranceReason;
                            SeveranceLedgerEntry."Total Hari LoS Severance" := TotalHariLoSSev;
                            SeveranceLedgerEntry."Contract Entry No." := _HiringEntryNo;
                            SeveranceLedgerEntry."Bulan Posting" := BulanPosting;
                            SeveranceLedgerEntry."Tahun Posting" := TahunPosting;
                            SeveranceLedgerEntry.Finished := true;
                            SeveranceLedgerEntry."Basic Salary Used" := BasicSalary;
                            SeveranceLedgerEntry."Fix Allowance Used" := EmployeeSeverance."MSI_HRIS Total Allowance Fix";
                            SeveranceLedgerEntry."Actual Payment Date" := EmployeeSeverance."MSI_HRIS Actual Payment Date";
                            SeveranceLedgerEntry."Contract Start Date" := _ContractStart;
                            SeveranceLedgerEntry."Contract End Date" := _ContractEnd;
                            SeveranceLedgerEntry.Modify();

                            StrGPDocNo := StrGPDocNo + '-' + SeveranceLedgerEntry."GP No.";

                            GPNoForTax := SeveranceLedgerEntry."GP No.";

                            //tambahin line severance di bawah unused leave
                            LeaveMgt.UpdateGPWithExtraLine(SeveranceLedgerEntry."GP No.", SeveranceAmount,
                            true, EmployeeSeverance);

                            TotalAmount := TotalAmount + SeveranceLedgerEntry."Unused Leave Amount";
                        end;

                        Contract.Reset();
                        Contract.SetRange("Employee No.", EmployeeSeverance."No.");
                        Contract.FindLast();

                        TarifPPhSeveranceEntry.Reset();
                        TarifPPhSeveranceEntry.SetRange("Employee No.", EmployeeSeverance."No.");
                        TarifPPhSeveranceEntry.SetRange("Posting Date", Contract."Contract End Date");
                        if not TarifPPhSeveranceEntry.FindFirst() then
                            HitungTaxSeverance(EmployeeSeverance."No.", TotalAmount,
                            Contract."Contract End Date", NomorEntryWoi);

                        EmployeeTax.Reset();
                        EmployeeTax.SetRange("No.", EmployeeSeverance."No.");
                        EmployeeTax.SetRange("Date Filter", Contract."Contract End Date");
                        EmployeeTax.FindFirst();
                        EmployeeTax.CalcFields("MSI_HRIS Tax Severance Leave");

                        //tambahin line tax
                        if EmployeeTax."MSI_HRIS Tax Severance Leave" <> 0 then
                            LeaveMgt.UpdateGPWithExtraLine(GPNoForTax, EmployeeTax."MSI_HRIS Tax Severance Leave",
                            false, EmployeeSeverance);

                        //nulis negative entry ke severence accrual
                        AccrualMgt.PencairanSeveranceAccrual(EmployeeSeverance, Rec.PostingDate,
                    SeveranceAmount, EntryNo);

                    until EmployeeSeverance.Next() = 0;

                    Window.Close();

                    NgePost := true;

                    Message('Severance period: %1\With %2 employee is completed.' +
                             '\GP %3 was updated/created.',
                             FORMAT(Rec.PostingDate, 0, '<Day> <Month Text> <Year>'),
                             ToBeProcessedSeverance, StrGPDocNo);

                    Rec.Delete();

                    CurrPage.Close();

                    EmpSeveranceList.Run();
                end;
            }
        }
    }

    var
        TarifPPhSeveranceEntry: Record "Tarif PPh21 Sevr. Leave Entry";
        AccrualSeverance: Record "Severance Accrual Ledger Entry";
        SeveranceLedgerEntryCheckDupl: Record "Severance Ledger Entry";
        EmployeeSeveranceList: Page "Employee Severance List";
        AllActive: Integer;
        ToBeProcessedSeverance: Integer;
        EmployeeSeverance: Record Employee;
        Judul: Text;
        _ResignDate: Date;
        _ContractStart: Date;
        _ContractEnd: Date;
        _EndingDateCalc: Date;
        _HiringEntryNo: Integer;
        SeveranceReason: Text;
        TotalHariLoSSev: Integer;
        SeveranceLoS: Decimal;
        CalcLoS: Decimal;
        InputTHRDateCalc: page "Input THR Date for Calculation";
        SeveranceLedgerEntry: Record "Severance Ledger Entry";
        EntryNo: Integer;
        TotalIncome: Decimal;
        SeveranceAmount: Decimal;
        NgePost: Boolean;
        AdakahLeave: Boolean;
        DocumentNoLeave: Code[20];
        AdakahLeave2: Boolean;
        DocumentNoLeave2: Code[20];
        DocumentDate: Date;

    trigger
    OnQueryClosePage(CloseAction: Action): Boolean
    var
        EmployeeSevList: page "Employee Severance List";
    begin
        if not NgePost then
            if not confirm('Exit without post?') then error('');

        EmployeeSevList.Run();
    end;


    trigger
    OnOpenPage()
    var
        PostedCutiDibayarHeader: Record "Posted Cuti Dibayar Header";
    begin

        if Rec."Ada Leave" then begin
            PostedCutiDibayarHeader.Get(Rec.UnusedLeaveDocNo);
            DocumentDate := PostedCutiDibayarHeader."Document Date";
        end else
            DocumentDate := Today;

        EmployeeSeverance.Reset();
        EmployeeSeverance.SetRange(Status, EmployeeSeverance.Status::Active);
        EmployeeSeverance.SetFilter("First Name", '<>MSI');
        EmployeeSeverance.FindSet();
        AllActive := EmployeeSeverance.Count;

        Judul := 'This will process Severance, ';

        EmployeeSeverance.SetRange("MSI_HRIS Severance", true);
        EmployeeSeverance.FindSet();

        ToBeProcessedSeverance := EmployeeSeverance.Count;
    end;


    procedure GetTarifNPWPSeverance(EmployeeNPWP: Record Employee;
                                  TariffPPh21Severance: Record "Tariff Uang Pisah Setup"): Decimal;
    begin
        if EmployeeNPWP."MSI_HRIS NPWP No." <> '' then begin
            //TariffPPh21Severance.TestField("% Tariff");
            exit(TariffPPh21Severance."% Tariff")
        end else begin
            //TariffPPh21Severance.TestField("% Tariff Non NPWP");
            exit(TariffPPh21Severance."% Tariff Non NPWP");
        end;
    end;


    procedure HitungTaxSeverance(KodeEmp: Code[20]; NetPKP: Decimal; PostingDateGajian: Date;
    NomorEntrySeverance: Integer);
    var
        TarifPPh21Severance: Record "Tariff Uang Pisah Setup";
        Selesai: Boolean;
        _TarifYangDipake: Decimal;
        TempTax: Decimal;
        Monyet: Record Employee;
    begin
        Monyet.Get(KodeEmp);

        TarifPPh21Severance.Reset();
        TarifPPh21Severance.FindFirst();
        repeat
            _TarifYangDipake := GetTarifNPWPSeverance(Monyet, TarifPPh21Severance);

            if (TarifPPh21Severance."Upper Limit" <> 0) and
                (TarifPPh21Severance."Nilai Pengali Tarif" < NetPKP) then begin
                InsertTarifPPh21SeveranceEntry(Monyet, TarifPPh21Severance."Nilai Pengali Tarif",
                _TarifYangDipake, PostingDateGajian, NomorEntrySeverance);
                NetPKP := NetPKP - TarifPPh21Severance."Nilai Pengali Tarif";
            end else begin
                InsertTarifPPh21SeveranceEntry(Monyet, NetPKP, _TarifYangDipake,
                PostingDateGajian, NomorEntrySeverance);
                Selesai := true;
            end;

        until (Selesai) or (TarifPPh21Severance.Next() = 0);
    end;


    procedure InsertTarifPPh21SeveranceEntry(Karyawan: Record Employee; Duitnya: Decimal; Persen: Decimal;
    TanggalPosting: Date; SeveranceEntryNo: Integer)
    var
        TarifPPh21SeveranceEntry: Record "Tarif PPh21 Sevr. Leave Entry";
        TarifPPh21SeveranceEntry2: Record "Tarif PPh21 Sevr. Leave Entry";
        EntryNo: Integer;
    begin
        TarifPPh21SeveranceEntry2.LockTable();
        TarifPPh21SeveranceEntry2.Reset();
        if TarifPPh21SeveranceEntry2.FindLast() then
            EntryNo := TarifPPh21SeveranceEntry2."Entry No." + 1
        else
            EntryNo := 1;

        TarifPPh21SeveranceEntry.Init();
        TarifPPh21SeveranceEntry."Entry No." := EntryNo;
        TarifPPh21SeveranceEntry."Employee No." := Karyawan."No.";
        TarifPPh21SeveranceEntry.Amount := Duitnya;
        TarifPPh21SeveranceEntry."Used Percentage" := Persen;
        TarifPPh21SeveranceEntry.Tax := Duitnya * (Persen / 100);
        TarifPPh21SeveranceEntry."Posting Date" := TanggalPosting;
        TarifPPh21SeveranceEntry."Severance Ledger Entry No." := SeveranceEntryNo;
        TarifPPh21SeveranceEntry.Insert();
    end;

    procedure setAdakahLeave(AdaLeaveKirim: Boolean; DocNo: Code[20]; DocDate: Date)
    begin
        AdakahLeave2 := AdaLeaveKirim;
        DocumentNoLeave2 := DocNo;

        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.PostingDate := DocDate;
            Rec."Ada Leave" := AdaLeaveKirim;
            Rec.UnusedLeaveDocNo := DocNo;
            Rec.Insert();
        end else begin
            Rec.PostingDate := DocDate;
            Rec."Ada Leave" := AdaLeaveKirim;
            Rec.UnusedLeaveDocNo := DocNo;
            Rec.Modify();
        end;
    end;
}