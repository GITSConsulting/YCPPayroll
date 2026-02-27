page 65005 "MR Line Kacamata"
{
    Caption = 'Medical Kacamata';
    PageType = ListPart;
    SourceTable = "Medical Reimbursement Line";
    SourceTableView = where("Medical Type" = const(Kacamata));
    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    // MultipleNewLines = true;
    RefreshOnActivate = true;
    InsertAllowed = false;
    layout
    {
        area(content)
        {
            repeater(Line)
            {
                ShowCaption = false;
                field("Medical Type"; rec."Medical Type"::Kacamata)
                {
                    Editable = false;
                    Caption = 'Medical Claim Type';
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        recHeader: Record "Medical Reimbursement Header";
                    begin
                        CurrPage.Update();
                    end;
                }
                field(Date; rec.Date)
                {
                    // Editable = false;
                    Caption = 'Date Reimburesement';
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        frz_MEdicalHeader: Record "Medical Reimbursement Header";
                    begin
                        frz_MEdicalHeader.Reset();
                        frz_MEdicalHeader.SetRange("No.", rec."Document No.");
                        if frz_MEdicalHeader.FindFirst() then begin
                            if Rec.Date > frz_MEdicalHeader."Posting Date" then
                                Error('The date must be less than equal to Posting Date header');
                        end;
                        CurrPage.Update();
                    end;
                }
                field("Medical Value"; rec."Medical Value")
                {
                    Editable = false;
                    ApplicationArea = All;
                    TableRelation = "Medical Values".Code where("Medical Type" = const(Kacamata));
                    trigger OnValidate()
                    var
                        recMedicalSlot: Record "Medical Values";
                    begin
                        recMedicalSlot.SetRange(Code, Rec."Medical Value");
                        if recMedicalSlot.FindFirst() then
                            rec.Description := recMedicalSlot.Description;
                        CurrPage.Update();
                    end;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Reimbursement per-Year"; frz_PerYear)
                {
                    Caption = 'Reimbursement Year';
                    Visible = false;
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Balance Reimbursement per-Year"; frz_BalancePerYear)
                {
                    Caption = 'Balance Reimbursement Year';
                    Editable = false;
                    ApplicationArea = all;
                }
                field(Plafon; frz_Plafon)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Visible = false;
                }
                field(MedicalLedger; MedicalLedger)
                {
                    Caption = 'Plafon Balance';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(frz_CurrentBalance_prosess; frz_CurrentBalance_prosess)
                {
                    Caption = 'Plafon in Process';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(frz_BalanceAmount_kacamata; frz_BalanceAmount_kacamata)
                {
                    Caption = 'Total Plafon Balance';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Claim Amount"; rec."Claim Amount")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        rec.TestField(rec.Date);
                        if frz_BalancePerYear > 0 then begin

                            if frz_BalanceAmount_kacamata > 0 then begin

                                if rec."Claim Amount" >= frz_BalanceAmount_kacamata then
                                    rec."Paid Amount" := frz_BalanceAmount_kacamata else
                                    Rec."Paid Amount" := rec."Claim Amount";

                            end else begin
                                if (rec."Claim Amount" = 0) and (rec."Claim Amount" < rec."Paid Amount") then begin
                                    Rec."Paid Amount" := rec."Claim Amount";
                                end;
                            end;
                        end else
                            Error('Your balance slot = 0');
                        frz_BalanceAmount_kacamata := frz_BalanceAmount_kacamata - rec."Paid Amount";
                        CurrPage.Update();
                    end;
                }
                field("Paid Amount"; rec."Paid Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {
                    Caption = 'Fund Code';
                    ApplicationArea = All;
                    TableRelation = "Dimension Value".Code where("Dimension Code" = filter('FUND CODE'));
                    trigger OnValidate()
                    begin
                        // medicalTypeNotBlank();
                    end;
                }
            }
        }
    }
    var

        frz_Plafon: Decimal;
        frz_PerYear: Integer;
        frz_BalancePerYear: Integer;
        frz_BalanceAmount_kacamata: Decimal;
        frz_LedgerMedical: Record "Medical Reim Ledger Entries";
        frz_LedgerMedical_2: Record "Medical Reim Ledger Entries";
        frz_LedgerMedical_3: Record "Medical Reim Ledger Entries";
        frz_CurrentBalance_prosess: Decimal;
        MedicalLedger: Decimal;

    trigger OnAfterGetRecord()
    var
        frz_MedicalValues: Record "Medical Values";

        frz_MedicalHeader: Record "Medical Reimbursement Header";
        frz_PostedMedicalHeader: Record "Posted MR Header";
        frz_PostedMedicalLine: Record "Posted MR Line";

        frz_PostedMedicalLineMaster: Record "Posted MR Line";

        frz_QtyTotalPosted: Integer;
        frz_TotalCount: Integer;
        frz_loncatTahun: Text;
        frz_MedicalLines_proses: Record "Medical Reimbursement Line";
        frz_MedicalHeader_proses: Record "Medical Reimbursement Header";
    begin
        frz_Plafon := 0;
        frz_BalancePerYear := 1;
        frz_BalanceAmount_kacamata := 0;
        frz_TotalCount := 0;
        frz_MedicalValues.Reset();
        frz_MedicalValues.SetRange("Medical Type", Rec."Medical Type");
        frz_MedicalValues.SetRange(Code, rec."Medical Value");
        if frz_MedicalValues.FindFirst() then begin

            frz_Plafon := frz_MedicalValues.Plafon;

            frz_LedgerMedical.Reset();
            frz_LedgerMedical.SetRange("Employee No.", rec."Employee No.");
            frz_LedgerMedical.SetRange("Medical Type", frz_LedgerMedical."Medical Type"::Kacamata);
            frz_LedgerMedical.SetRange("Medical Value", frz_MedicalValues.Code);
            frz_LedgerMedical.CalcSums(Amount);
            MedicalLedger := frz_LedgerMedical.Amount;

            frz_LedgerMedical_3.Reset();
            frz_LedgerMedical_3.SetRange("Employee No.", rec."Employee No.");
            frz_LedgerMedical_3.SetRange("Document No.", 'OPBAL');
            frz_LedgerMedical_3.SetRange("Medical Type", frz_LedgerMedical_3."Medical Type"::Kacamata);
            frz_LedgerMedical_3.SetRange("Medical Value", frz_MedicalValues.Code);
            if frz_LedgerMedical_3.FindLast() then
                frz_PerYear := frz_LedgerMedical_3."Quantity 2";

            frz_LedgerMedical_2.Reset();
            frz_LedgerMedical_2.SetRange("Employee No.", rec."Employee No.");
            frz_LedgerMedical_2.SetRange("Medical Type", frz_LedgerMedical_2."Medical Type"::Kacamata);
            frz_LedgerMedical_2.SetRange("Medical Value", frz_MedicalValues.Code);
            frz_LedgerMedical_2.SetFilter("expired date optical", '<> %1', 0D);
            if frz_LedgerMedical_2.FindLast() then begin
                if frz_LedgerMedical_2."Entry Type" = frz_LedgerMedical_2."Entry Type"::Negative then
                    if Today <= frz_LedgerMedical_2."expired date optical" then
                        frz_BalancePerYear := 0;
            end;
            // proses balance document
            frz_CurrentBalance_prosess := 0;
            frz_MedicalHeader_proses.Reset();
            frz_MedicalHeader_proses.SetFilter(Status, '<> %1', frz_MedicalHeader_proses.Status::Open);
            frz_MedicalHeader_proses.SetFilter("No.", '<> %1', rec."Document No.");
            frz_MedicalHeader_proses.SetFilter("Employee No.", rec."Employee No.");
            frz_MedicalHeader_proses.SetRange("Medical Type 1", true);
            if frz_MedicalHeader_proses.FindFirst() then
                repeat
                    frz_MedicalLines_proses.Reset();
                    frz_MedicalLines_proses.SetRange("Document No.", frz_MedicalHeader_proses."No.");
                    frz_MedicalLines_proses.SetRange("Medical Type", frz_MedicalLines_proses."Medical Type"::Kacamata);
                    frz_MedicalLines_proses.SetRange("Medical Value", frz_MedicalValues.Code);
                    if frz_MedicalLines_proses.FindFirst() then
                        repeat
                            frz_CurrentBalance_prosess += frz_MedicalLines_proses."Paid Amount";
                            frz_BalancePerYear := 0;
                        until frz_MedicalLines_proses.Next() = 0;
                until frz_MedicalHeader_proses.Next() = 0;
            // proses balance document tutup

            frz_BalanceAmount_kacamata := MedicalLedger - frz_CurrentBalance_prosess;
        end;
    end;
}
