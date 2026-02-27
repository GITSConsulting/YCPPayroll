page 60053 "Payroll Processed Entries"
{
    PageType = List;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Payroll Processed Entry";
    DeleteAllowed = false;
    ModifyAllowed = false;
    InsertAllowed = false;
    Caption = 'Monthly Payroll Summaries';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date Salary"; Rec."Posting Date Salary")
                {
                    ApplicationArea = all;
                }
                field(Year; Rec.Year)
                {
                    ApplicationArea = all;
                }
                field(MonthString; Rec.MonthString)
                {
                    ApplicationArea = all;
                }
                field("Charging Processed"; Rec."Charging Processed")
                {
                    ApplicationArea = all;
                }
                field("GP Document No."; Rec."GP Document No.")
                {
                    ApplicationArea = all;

                    trigger
                    OnDrillDown()
                    begin
                        ShowGPDocument(Rec."GP Document No.");
                    end;
                }
                field("GP For Tax"; Rec."GP For Tax")
                {

                    ApplicationArea = all;

                    trigger OnDrillDown()
                    begin
                        ShowGPDocument(Rec."GP For Tax");
                    end;
                }
                field("GP For BPJS TK"; Rec."GP For BPJS TK")
                {
                    ApplicationArea = all;
                    trigger OnDrillDown()
                    begin
                        ShowGPDocument(Rec."GP For BPJS TK");
                    end;
                }
                field("Employee Charging Doc. No."; Rec."Employee Charging Doc. No.")
                {
                    ApplicationArea = all;
                }
                field("Posting Date Charging"; Rec."Posting Date Charging")
                {
                    ApplicationArea = all;
                }
                field("Year Charging"; Rec."Year Charging")
                {
                    ApplicationArea = all;
                }
                field(MonthChargingString; Rec.MonthChargingString)
                {
                    ApplicationArea = all;
                }
                field("Year End Process"; Rec."Year End Process")
                {
                    ApplicationArea = all;
                }
                field("Paid Taxes Retrieved"; Rec."Paid Taxes Retrieved")
                {
                    ApplicationArea = all;
                }
                field("Tax Per Year Calculated"; Rec."Tax Per Year Calculated")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Process Day 5 of Next Month")
            {
                Image = Process;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;
                ApplicationArea = all;
                Visible = false;

                trigger
                OnAction()
                var
                    NextMonth: Date;
                    StartingNextMonth: Date;
                    TanggalLimaNext: Date;
                    StrConfirm: Text;
                    AdvanceHeader: Record "Advance Header";
                    AdvanceHeader2: Record "Advance Header";
                    GenJnlLine: Record "Gen. Journal Line";
                    KuliBangunan: Record Employee;
                    Window: Dialog;
                    _GenJnlBatch: Record "Gen. Journal Batch";
                    AdvancePostDRE: Codeunit "Advance-Post";
                    PayrollSetup: Record "Payroll General Setup";
                    TotalTax: Decimal;
                    TotalTaxTHR: Decimal;
                    Pajak: Decimal;
                    PajakTHR: Decimal;
                    TotalBPJSTK: Decimal;
                    GPNoSatu: Code[20];
                    GPNoDua: Code[20];
                begin
                    NextMonth := CalcDate('1M', Rec."Posting Date Salary");
                    StartingNextMonth := CalcDate('-CM', NextMonth);
                    TanggalLimaNext := StartingNextMonth + 4;

                    StrConfirm := 'This process will create general payment for BPJS TK and PPh 21 on ' +
                                    Format(TanggalLimaNext, 0, '<Day> <Month Text> <Year4>') + '.\ \Proceed?';

                    if not Confirm(StrConfirm) then exit;

                    Window.Open('Creating general payment, please wait..');

                    PayrollSetup.Get();
                    PayrollSetup.TestField("Charg. BPJS TK Staff Acc. No.");
                    PayrollSetup.TestField("Tax Account No.");

                    KuliBangunan.Reset();
                    KuliBangunan.SetRange("Date Filter", Rec."Posting Date Salary");
                    KuliBangunan.FindFirst();
                    repeat
                        Pajak := 0;
                        KuliBangunan.CalcFields("MSI_HRIS BPJS TK YCP Staff");
                        CalculateTaxPerMonth(Rec."Posting Date Salary", KuliBangunan."No.", Pajak);
                        TotalTax := TotalTax + Pajak;
                        TotalBPJSTK := TotalBPJSTK + KuliBangunan."MSI_HRIS BPJS TK YCP Staff";
                    until KuliBangunan.Next() = 0;


                    TotalBPJSTK := -1 * TotalBPJSTK;

                    KuliBangunan.Reset();
                    KuliBangunan.SetRange("User ID", UserId);
                    KuliBangunan.FindFirst();

                    //Create General Payment untuk BPJS TK
                    AdvanceHeader.Init();
                    AdvanceHeader.Validate("Document Type", AdvanceHeader."Document Type"::"General Payment");
                    AdvanceHeader.Validate("No.", '');
                    AdvanceHeader."Employee No." := KuliBangunan."No.";
                    AdvanceHeader.validate("Shortcut Dimension 1 Code", KuliBangunan."MSI_HRIS Shortcut Dim Code");
                    AdvanceHeader.Insert(true);
                    GPNoSatu := AdvanceHeader."No.";

                    AdvanceHeader2.get(AdvanceHeader2."Document Type"::"General Payment",
                    GPNoSatu);
                    if not _GenJnlBatch.GET(AdvancePostDRE.GetTemplateInitial,
                        AdvancePostDRE.GetBatchInitial(AdvanceHeader)) THEN BEGIN
                        _GenJnlBatch.Init();
                        _GenJnlBatch."Journal Template Name" := AdvancePostDRE.GetTemplateInitial;
                        _GenJnlBatch.Name := AdvancePostDRE.GetBatchInitial(AdvanceHeader);
                        _GenJnlBatch.Insert();
                    end;

                    AdvanceHeader2."Journal Template Name" := AdvancePostDRE.GetTemplateInitial;
                    AdvanceHeader2."Journal Batch Name" := _GenJnlBatch.Name;
                    AdvanceHeader2."Journal Description" := 'GP for BPJS TK';
                    AdvanceHeader2.Validate("Posting Date", TanggalLimaNext);
                    AdvanceHeader2.Modify();

                    GenJnlLine.Init();
                    GenJnlLine.Validate("Journal Template Name", AdvanceHeader2."Journal Template Name");
                    GenJnlLine.validate("Journal Batch Name", AdvanceHeader2."Journal Batch Name");
                    GenJnlLine.Validate("Line No.", 10000);
                    GenJnlLine.Validate("Document No.", GPNoSatu);
                    GenJnlLine.Validate("Posting Date", TanggalLimaNext);
                    GenJnlLine.Validate(Amount, TotalBPJSTK);
                    GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
                    GenJnlLine.Validate("Account No. 2", PayrollSetup."Charg. BPJS TK Staff Acc. No.");
                    GenJnlLine.Insert(true);


                    Clear(AdvanceHeader);
                    Clear(AdvanceHeader2);
                    Clear(AdvancePostDRE);
                    Clear(GenJnlLine);


                    //Create General Payment untuk Pajak bulanan dan THR
                    AdvanceHeader.Init();
                    AdvanceHeader.Validate("Document Type", AdvanceHeader."Document Type"::"General Payment");
                    AdvanceHeader.Validate("No.", '');
                    AdvanceHeader."Employee No." := KuliBangunan."No.";
                    AdvanceHeader.validate("Shortcut Dimension 1 Code", KuliBangunan."MSI_HRIS Shortcut Dim Code");
                    AdvanceHeader.Insert(true);
                    GPNoDua := AdvanceHeader."No.";

                    AdvanceHeader2.get(AdvanceHeader2."Document Type"::"General Payment",
                    GPNoDua);
                    if not _GenJnlBatch.GET(AdvancePostDRE.GetTemplateInitial,
                        AdvancePostDRE.GetBatchInitial(AdvanceHeader)) THEN BEGIN
                        _GenJnlBatch.Init();
                        _GenJnlBatch."Journal Template Name" := AdvancePostDRE.GetTemplateInitial;
                        _GenJnlBatch.Name := AdvancePostDRE.GetBatchInitial(AdvanceHeader);
                        _GenJnlBatch.Insert();
                    end;

                    AdvanceHeader2."Journal Template Name" := AdvancePostDRE.GetTemplateInitial;
                    AdvanceHeader2."Journal Batch Name" := _GenJnlBatch.Name;
                    AdvanceHeader2."Journal Description" := 'GP for Payroll Tax and THR';
                    AdvanceHeader2.Validate("Posting Date", TanggalLimaNext);
                    AdvanceHeader2.Modify();

                    GenJnlLine.Init();
                    GenJnlLine.Validate("Journal Template Name", AdvanceHeader2."Journal Template Name");
                    GenJnlLine.validate("Journal Batch Name", AdvanceHeader2."Journal Batch Name");
                    GenJnlLine.Validate("Line No.", 10000);
                    GenJnlLine.Validate("Document No.", GPNoDua);
                    GenJnlLine.Validate("Posting Date", TanggalLimaNext);
                    GenJnlLine.Validate(Amount, TotalTax);
                    GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
                    GenJnlLine.Validate("Account No. 2", PayrollSetup."Tax Account No.");
                    GenJnlLine.Validate(Description, 'Total payroll tax for ' + Format(Rec."Posting Date Salary"));
                    GenJnlLine.Insert(true);

                    GenJnlLine.Init();
                    GenJnlLine.Validate("Journal Template Name", AdvanceHeader2."Journal Template Name");
                    GenJnlLine.validate("Journal Batch Name", AdvanceHeader2."Journal Batch Name");
                    GenJnlLine.Validate("Line No.", 20000);
                    GenJnlLine.Validate("Document No.", GPNoDua);
                    GenJnlLine.Validate("Posting Date", TanggalLimaNext);
                    GenJnlLine.Validate(Amount, 0);
                    GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
                    GenJnlLine.Validate("Account No. 2", PayrollSetup."Tax Account No.");
                    GenJnlLine.Validate(Description, 'Total THR tax for ' + Format(Rec.Month) + ' ' + Format(Rec.Year));
                    GenJnlLine.Insert(true);


                    Rec.Modify();

                    Window.Close();
                    Message('General payment %1 for BPJS TK and %2 for taxes are created.', GPNoSatu, GPNoDua);
                end;
            }
        }
    }

    procedure ShowGPDocument(DocNo: Code[20])
    var
        GeneralPayment: page "General Payment";
        AdvanceHeader: Record "Advance Header";
    begin
        Clear(GeneralPayment);
        AdvanceHeader.Reset();
        AdvanceHeader.SetRange("Document Type",
        AdvanceHeader."Document Type"::"General Payment");
        AdvanceHeader.SetRange("No.", DocNo);
        AdvanceHeader.SetRange("Voucher Type", AdvanceHeader."Voucher Type"::" ");
        if AdvanceHeader.FindFirst() then begin
            GeneralPayment.SetRecord(AdvanceHeader);
            GeneralPayment.Run();
        end else
            Error('General payment does not exist, or already processed by finance department.');

    end;


    procedure CalculateTaxTHRPerMonth(TanggalPayroll: Date; KodeKuli: Code[20];
    var TaxTHR: Decimal)
    var
        THRLedgerEntry: Record "THR Ledger Entry";
        Pegawai: Record Employee;
        EmployeeLastPayroll: Record Employee;
    begin



    end;

    procedure CalculateTaxPerMonth(TanggalPayroll: Date; KodeKuli: Code[20];
    var TaxPerMonth: Decimal)
    var
        PayrollLedgerEntry: Record "Payroll Ledger Entry";
        Pegawai: Record Employee;

    begin
        Pegawai.Reset();
        Pegawai.SetRange("No.", KodeKuli);
        Pegawai.SetRange("Date Filter", TanggalPayroll);
        if Pegawai.FindFirst() then
            Pegawai.CalcFields("MSI_HRIS Tax Per Year");

        PayrollLedgerEntry.Reset();
        PayrollLedgerEntry.SetRange("Employee No.", KodeKuli);
        PayrollLedgerEntry.SetRange("Posting Date", TanggalPayroll);
        if PayrollLedgerEntry.FindFirst() then begin
            if PayrollLedgerEntry."Periode Penghasilan" <> 0 then
                TaxPerMonth := Round(Pegawai."MSI_HRIS Tax Per Year" /
                                        PayrollLedgerEntry."Periode Penghasilan", 1)
            else
                TaxPerMonth := 0
        end
    end;
}