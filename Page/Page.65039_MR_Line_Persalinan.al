page 65039 "MR Line Persalinan"
{
    Caption = 'Medical Persalinan';
    PageType = ListPart;
    SourceTable = "Medical Reimbursement Line";
    SourceTableView = where("Medical Type" = const(Persalinan));
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
                field("Medical Type"; rec."Medical Type"::Persalinan)
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
                field("Medical Value"; rec."Medical Value")
                {
                    Editable = false;
                    ApplicationArea = All;
                    TableRelation = "Medical Values".Code where("Medical Type" = const(Persalinan));
                    trigger OnValidate()
                    var
                        recMedicalSlot: Record "Medical Values";
                    begin
                        // recMedicalSlot.SetRange("Employee No.", rec."Employee No.");
                        // recMedicalSlot.SetRange("Medical Code", Rec."Medical Value");
                        // if recMedicalSlot.FindFirst() then
                        //     rec.Description := recMedicalSlot.Description;
                        recMedicalSlot.SetRange(Code, Rec."Medical Value");
                        if recMedicalSlot.FindFirst() then
                            rec.Description := recMedicalSlot.Description;
                        CurrPage.Update();
                    end;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
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
                    trigger OnValidate()
                    begin
                        // medicalTypeNotBlank();
                    end;
                }
                field(frz_CurrentBalance_ledger; frz_CurrentBalance_ledger)
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
                field(frz_CurrentBalance; frz_CurrentBalance)
                {
                    Caption = 'Total Plafon Balance';
                    ApplicationArea = all;
                    Editable = false;
                }
            }
        }
    }
    var
        Type1: Code[20];
        getOption: array[4] of Boolean;
        getnama: array[4] of Text;
        Type2: Text;
        Type3: Text;
        Type4: Text;
        frz_Plafon: Decimal;
        frz_CurrentBalance: Decimal;
        frz_GantiTahunTemporary: Integer;
        frz_GantiTahun: Text;
        frz_GantiTahunEnd: Text;
        frz_LedgerMedical: Record "Medical Reim Ledger Entries";
        frz_CurrentBalance_prosess: Decimal;
        frz_CurrentBalance_ledger: Decimal;

    trigger OnAfterGetRecord()
    var
        frz_MedicalValues: Record "Medical Values";
        frz_MedicalLines_proses: Record "Medical Reimbursement Line";
        frz_MedicalHeader_proses: Record "Medical Reimbursement Header";
    begin
        // get plafon dan basic plafonnya
        frz_CurrentBalance := 0;
        frz_CurrentBalance_ledger := 0;
        frz_MedicalValues.Reset();
        frz_MedicalValues.SetRange("Medical Type", Rec."Medical Type");
        frz_MedicalValues.SetRange(Code, rec."Medical Value");
        if frz_MedicalValues.FindFirst() then begin
            frz_LedgerMedical.Reset();
            frz_LedgerMedical.SetRange("Employee No.", rec."Employee No.");
            frz_LedgerMedical.SetRange("Medical Type", frz_LedgerMedical."Medical Type"::Persalinan);
            frz_LedgerMedical.SetRange("Medical Value", frz_MedicalValues.Code);
            frz_LedgerMedical.CalcSums(Amount);
            frz_CurrentBalance_ledger := frz_LedgerMedical.Amount;
            // proses balance document
            frz_CurrentBalance_prosess := 0;
            frz_MedicalHeader_proses.Reset();
            frz_MedicalHeader_proses.SetFilter(Status, '<> %1', frz_MedicalHeader_proses.Status::Open);
            frz_MedicalHeader_proses.SetFilter("No.", '<> %1', rec."Document No.");
            frz_MedicalHeader_proses.SetFilter("Employee No.", rec."Employee No.");
            frz_MedicalHeader_proses.SetRange("Medical Type 4", true);
            if frz_MedicalHeader_proses.FindFirst() then
                repeat
                    frz_MedicalLines_proses.Reset();
                    frz_MedicalLines_proses.SetRange("Document No.", frz_MedicalHeader_proses."No.");
                    frz_MedicalLines_proses.SetRange("Medical Type", frz_MedicalLines_proses."Medical Type"::Persalinan);
                    frz_MedicalLines_proses.SetRange("Medical Value", frz_MedicalValues.Code);
                    if frz_MedicalLines_proses.FindFirst() then
                        repeat
                            frz_CurrentBalance_prosess += frz_MedicalLines_proses."Paid Amount";
                        until frz_MedicalLines_proses.Next() = 0;
                until frz_MedicalHeader_proses.Next() = 0;
            // proses balance document tutup

        end;

        frz_CurrentBalance := frz_LedgerMedical.Amount - Rec."Paid Amount" - frz_CurrentBalance_prosess;
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
        frz_MedicalValues.SetRange("Medical Type", frz_MedicalValues."Medical Type"::Persalinan);
        if frz_MedicalValues.FindFirst() then begin

            if frz_CurrentBalance > 0 then begin

                if rec."Claim Amount" >= (frz_CurrentBalance + rec."Paid Amount") then begin
                    rec."Claim Amount" := rec."Claim Amount";
                    rec."Paid Amount" := (frz_CurrentBalance + rec."Paid Amount");
                end else
                    Rec."Paid Amount" := rec."Claim Amount";
            end else begin
                if (rec."Claim Amount" = 0) or (rec."Claim Amount" < rec."Paid Amount") then begin
                    Rec."Paid Amount" := rec."Claim Amount" * 1;
                end;
            end;
        end;
    end;

}
