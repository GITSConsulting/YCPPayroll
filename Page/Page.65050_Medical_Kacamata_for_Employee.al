page 65050 "Medical Kacamata Balance"
{
    Caption = 'Balance Medical Kacamata';
    PageType = ListPart;
    UsageCategory = Lists;
    SourceTable = "Medical Slot";
    SourceTableView = where("Medical Type" = const(Kacamata));
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                ShowCaption = false;

                field("Medical Code"; rec."Medical Code")
                {
                    ApplicationArea = All;
                }
                field(Description; frz_Description)
                {
                    ApplicationArea = All;
                }
                field(Quantity; frz_PerYear)
                {
                    Caption = 'Slot Year (Kacamata)';
                    ApplicationArea = All;
                }
                field(BalancePlafon; frz_BalanceAmount_kacamata)
                {
                    Caption = 'Balance Plafon';
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var
                        frz_PageLedgerMedical: Page "Medical Reim Ledger Entries";
                    begin
                        frz_PageLedgerMedical.SetTableView(frz_LedgerMedical);
                        frz_PageLedgerMedical.Run();
                    end;
                }
            }
        }
    }

    var
        frz_BalanceAmount_kacamata: Decimal;
        frz_Plafon: Decimal;
        frz_PerYear: Integer;
        frz_BalancePerYear: Integer;
        frz_Description: Text;
        frz_LedgerMedical: Record "Medical Reim Ledger Entries";
        frz_LedgerMedical_2: Record "Medical Reim Ledger Entries";
        frz_LedgerMedical_3: Record "Medical Reim Ledger Entries";

    trigger OnAfterGetRecord()
    var
        frz_MedicalValuesKacamata: Record "Medical Values";
        frz_MedicalValues: Record "Medical Values";
        frz_PostedMedicalLine: Record "Posted MR Line";


        frz_QtyTotalPosted: Integer;
        frz_TotalCount: Integer;
        frz_loncatTahun: Text;
    begin
        frz_Plafon := 0;
        frz_BalanceAmount_kacamata := 0;
        frz_PerYear := 0;

        frz_MedicalValuesKacamata.Reset();
        frz_MedicalValuesKacamata.SetRange(Code, rec."Medical Code");
        frz_MedicalValuesKacamata.SetRange("Medical Type", frz_MedicalValuesKacamata."Medical Type"::Kacamata);
        if frz_MedicalValuesKacamata.FindFirst() then begin
            frz_Plafon := frz_MedicalValuesKacamata.Plafon;
            frz_PerYear := frz_MedicalValuesKacamata."Quantity 2";
            frz_Description := frz_MedicalValuesKacamata.Description;

            frz_LedgerMedical.Reset();
            frz_LedgerMedical.SetRange("Employee No.", rec."Employee No.");
            frz_LedgerMedical.SetRange("Medical Type", frz_LedgerMedical."Medical Type"::Kacamata);
            frz_LedgerMedical.SetRange("Medical Value", frz_MedicalValuesKacamata.Code);
            frz_LedgerMedical.CalcSums(Amount);
            frz_BalanceAmount_kacamata := frz_LedgerMedical.Amount;

            frz_LedgerMedical_3.Reset();
            frz_LedgerMedical_3.SetRange("Employee No.", rec."Employee No.");
            frz_LedgerMedical_3.SetRange("Document No.", 'OPBAL');
            frz_LedgerMedical_3.SetRange("Medical Type", frz_LedgerMedical_3."Medical Type"::Kacamata);
            frz_LedgerMedical_3.SetRange("Medical Value", frz_MedicalValuesKacamata.Code);
            if frz_LedgerMedical_3.FindLast() then
                frz_PerYear := frz_LedgerMedical_3."Quantity 2";

            frz_LedgerMedical_2.Reset();
            frz_LedgerMedical_2.SetRange("Employee No.", rec."Employee No.");
            frz_LedgerMedical_2.SetRange("Medical Type", frz_LedgerMedical_2."Medical Type"::Kacamata);
            frz_LedgerMedical_2.SetRange("Medical Value", frz_MedicalValuesKacamata.Code);
            frz_LedgerMedical_2.SetFilter("expired date optical", '<> %1', 0D);
            if frz_LedgerMedical_2.FindLast() then begin
                if frz_LedgerMedical_2."Entry Type" = frz_LedgerMedical_2."Entry Type"::Negative then
                    if Today <= frz_LedgerMedical_2."expired date optical" then
                        frz_PerYear := 0;

            end;

        end;
    end;
}