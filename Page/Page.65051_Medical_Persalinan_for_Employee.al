page 65051 "Medical Persalinan Balance"
{
    Caption = 'Balance Medical Persalinan';
    PageType = ListPart;
    UsageCategory = Lists;
    SourceTable = "Medical Slot";
    SourceTableView = where("Medical Type" = const(Persalinan));
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
                field(Plafon; frz_Plafon)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Total Claim"; frz_TotalClaim)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(frz_CurrentBalance; frz_CurrentBalance)
                {
                    Caption = 'Current Balance Plafon';
                    ApplicationArea = all;
                    Editable = false;
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
        frz_Plafon: Decimal;
        frz_Description: Text;
        frz_TotalClaim: Decimal;
        frz_CurrentBalance: Decimal;
        frz_LedgerMedical: Record "Medical Reim Ledger Entries";

    trigger OnAfterGetRecord()
    var
        frz_PositionLedger: Record "Position Ledger Entry";
        frz_MedicalValues: Record "Medical Values";
        frz_PostedMedicalLine: Record "Posted MR Line";
        frz_totalAmountPaidPosted: Decimal;
        totalYear: Integer;
    begin
        // get plafon dan basic plafonnya
        frz_Plafon := 0;
        frz_CurrentBalance := 0;
        frz_MedicalValues.Reset();

        frz_MedicalValues.SetRange("Medical Type", Rec."Medical Type");
        frz_MedicalValues.SetRange(Code, rec."Medical Code");
        if frz_MedicalValues.FindFirst() then begin

            frz_Plafon := frz_MedicalValues.Plafon;
            frz_Description := frz_MedicalValues.Description;

            frz_LedgerMedical.Reset();
            frz_LedgerMedical.SetRange("Employee No.", rec."Employee No.");
            frz_LedgerMedical.SetRange("Medical Type", frz_LedgerMedical."Medical Type"::Persalinan);
            frz_LedgerMedical.SetRange("Medical Value", frz_MedicalValues.Code);
            frz_LedgerMedical.CalcSums(Amount);
            frz_CurrentBalance := frz_LedgerMedical.Amount;

        end;

    end;
}