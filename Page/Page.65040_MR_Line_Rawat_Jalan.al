page 65040 "MR Line Rawat Jalan"
{
    Caption = 'Medical Rawat Jalan';
    PageType = ListPart;
    SourceTable = "Medical Reimbursement Line";
    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    RefreshOnActivate = true;
    // MultipleNewLines = true;
    InsertAllowed = false;
    layout
    {
        area(content)
        {
            repeater(Line)
            {
                ShowCaption = false;
                field("Medical Type"; rec."Medical Type"::"Rawat Jalan")
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
                field("Medical Value"; rec."Medical Value")
                {
                    Editable = false;
                    ApplicationArea = All;
                    TableRelation = "Medical Values".Code where("Medical Type" = const("Rawat Jalan"));
                    trigger OnValidate()
                    var
                        recMedicalSlot: Record "Medical Values";
                    begin
                        // get deskripsi medical values
                        recMedicalSlot.SetRange(Code, Rec."Medical Value");
                        if recMedicalSlot.FindFirst() then
                            rec.Description := recMedicalSlot.Description;

                        CurrPage.Update();
                    end;
                }
                field(Date; rec.Date)
                {
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
                    end;
                }
                field("Status Poin"; rec."Status Poin")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Poin"; rec.Poin)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Basic Plafon"; frz_BasicPlafon)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Visible = false;
                }
                field(Plafon; frz_Plafon)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Visible = false;
                }
                field("Claim Amount"; rec."Claim Amount")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        rec.TestField(Date);
                        cekClaimAmount();

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
                }
            }
            group(General)
            {
                ShowCaption = false;
                field(frz_CurrentBalance_prosess; frz_CurrentBalance_prosess)
                {
                    Caption = 'Plafon in Process';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(frz_CurrentBalance_ledger; frz_CurrentBalance_ledger)
                {
                    Caption = 'Plafon Balance';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(frz_CurrentBalance; frz_CurrentBalance)
                {
                    Caption = 'Total Plafon Balance';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Basic Plafon 1"; frz_BasicPlafon)
                {
                    Caption = 'Basic Plafon';
                    Visible = false;
                    ApplicationArea = all;
                    Editable = false;
                }
            }
        }
    }
    var
        frz_Plafon: Decimal;
        frz_BasicPlafon: Decimal;
        frz_CurrentBalance: decimal;
        frz_CurrentBalance_prosess: decimal;
        frz_CurrentBalance_ledger: decimal;
        frz_LedgerMedical: Record "Medical Reim Ledger Entries";

    trigger OnAfterGetRecord()
    var
        frz_MedicalValues: Record "Medical Values";
        frz_MedicalLines: Record "Medical Reimbursement Line";
        frz_TotalPaidCurrent: Decimal;

        frz_MedicalLines_proses: Record "Medical Reimbursement Line";
        frz_MedicalHeader_proses: Record "Medical Reimbursement Header";
    begin
        // get plafon dan basic plafonnya
        frz_MedicalValues.Reset();
        frz_MedicalValues.SetRange("Medical Type", Rec."Medical Type");
        frz_MedicalValues.SetRange(Code, rec."Medical Value");
        if frz_MedicalValues.FindFirst() then begin
            frz_BasicPlafon := frz_MedicalValues.Plafon;

            frz_MedicalLines.Reset();
            frz_MedicalLines.SetRange("Document No.", rec."Document No.");
            frz_MedicalLines.SetRange("Medical Type", Rec."Medical Type"::"Rawat Jalan");
            if frz_MedicalLines.FindFirst() then
                repeat
                    frz_TotalPaidCurrent += frz_MedicalLines."Paid Amount";
                until frz_MedicalLines.Next() = 0;
        end;
        // proses balance document
        frz_CurrentBalance_prosess := 0;
        frz_MedicalHeader_proses.Reset();
        frz_MedicalHeader_proses.SetFilter(Status, '<> %1', frz_MedicalHeader_proses.Status::Open);
        frz_MedicalHeader_proses.SetFilter("No.", '<> %1', rec."Document No.");
        frz_MedicalHeader_proses.SetFilter("Employee No.", rec."Employee No.");
        frz_MedicalHeader_proses.SetRange("Medical Type 2", true);
        if frz_MedicalHeader_proses.FindFirst() then
            repeat
                frz_MedicalLines_proses.Reset();
                frz_MedicalLines_proses.SetRange("Document No.", frz_MedicalHeader_proses."No.");
                frz_MedicalLines_proses.SetRange("Medical Type", frz_MedicalLines_proses."Medical Type"::"Rawat Jalan");
                if frz_MedicalLines_proses.FindFirst() then
                    repeat
                        frz_CurrentBalance_prosess += frz_MedicalLines_proses."Paid Amount";
                    until frz_MedicalLines_proses.Next() = 0;
            until frz_MedicalHeader_proses.Next() = 0;
        // proses balance document tutup
        frz_CurrentBalance_ledger := 0;
        frz_LedgerMedical.Reset();
        frz_LedgerMedical.SetRange("Employee No.", rec."Employee No.");
        frz_LedgerMedical.SetRange("Medical Type", frz_LedgerMedical."Medical Type"::"Rawat Jalan");
        frz_LedgerMedical.CalcSums(Amount);
        frz_CurrentBalance_ledger := frz_LedgerMedical.Amount;
        frz_CurrentBalance := frz_LedgerMedical.Amount - frz_TotalPaidCurrent - frz_CurrentBalance_prosess;
    end;

    procedure cekClaimAmount()
    var
        frz_MedicalLines: Record "Medical Reimbursement Line";
        frz_TotalPaidCurrent: Decimal;
        frz_MedicalValues: Record "Medical Values";
        frz_Persentasenya: Decimal;
    begin
        frz_Persentasenya := 100;

        frz_MedicalValues.Reset();
        frz_MedicalValues.SetRange(Code, rec."Medical Value");
        frz_MedicalValues.SetRange("Medical Type", frz_MedicalValues."Medical Type"::"Rawat Jalan");
        if frz_MedicalValues.FindFirst() then begin
            frz_Persentasenya := frz_MedicalValues.Percentage;
        end else
            frz_Persentasenya := 100;

        if frz_CurrentBalance > 0 then begin

            if rec."Claim Amount" >= (frz_CurrentBalance + rec."Paid Amount") then begin
                if frz_Persentasenya = 0 then begin
                    // rec."Claim Amount" := (frz_CurrentBalance + rec."Paid Amount") * 1;
                    rec."Paid Amount" := (frz_CurrentBalance + rec."Paid Amount") * 1;
                end
                else begin
                    // rec."Claim Amount" := (frz_CurrentBalance + rec."Paid Amount") * (frz_Persentasenya / 100);
                    rec."Paid Amount" := (frz_CurrentBalance + rec."Paid Amount") * (frz_Persentasenya / 100);
                end;
            end else
                if frz_Persentasenya = 0 then
                    Rec."Paid Amount" := rec."Claim Amount" * 1 else
                    rec."Paid Amount" := rec."Claim Amount" * (frz_Persentasenya / 100);

        end else begin
            if (rec."Claim Amount" = 0) or (rec."Claim Amount" < rec."Paid Amount") then begin
                if frz_Persentasenya = 0 then
                    Rec."Paid Amount" := rec."Claim Amount" * 1
                else
                    rec."Paid Amount" := rec."Claim Amount" * (frz_Persentasenya / 100);
            end;

        end;

        frz_MedicalLines.Reset();
        frz_MedicalLines.SetRange("Document No.", rec."Document No.");
        frz_MedicalLines.SetRange("Medical Type", Rec."Medical Type"::"Rawat Jalan");
        if frz_MedicalLines.FindFirst() then
            repeat
                frz_TotalPaidCurrent += frz_MedicalLines."Paid Amount";
            until frz_MedicalLines.Next() = 0;
    end;
}
