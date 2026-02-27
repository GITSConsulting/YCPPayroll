page 65057 "Rawat Inap Balance Pembedahan"
{
    Caption = 'Rawat Inap - Pembedahan';
    PageType = ListPart;
    UsageCategory = Lists;
    SourceTable = "Medical Slot";
    SourceTableView = where("Medical Type" = const("Rawat Inap"), "Rawat Inat Type" = const(Pembedahan));
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
            }
            group(Total)
            {
                ShowCaption = false;
                field("Basic Plafon"; frz_BasicPlafonROOM)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Balance Plafon"; frz_CurrentBalanceROOM)
                {
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
        frz_BasicPlafonROOM: Decimal;

        frz_totalAmountPaidPostedROOM: Decimal;
        frz_CurrentBalanceROOM: decimal;
        frz_Description: Text;
        frz_LedgerMedical: Record "Medical Reim Ledger Entries";

    trigger OnAfterGetRecord()
    var
        frz_MedicalValues: Record "Medical Values";
    begin
        // get plafon dan basic plafonnya
        frz_BasicPlafonROOM := 0;
        frz_totalAmountPaidPostedROOM := 0;
        frz_CurrentBalanceROOM := 0;
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////
        frz_MedicalValues.Reset();
        frz_MedicalValues.SetRange("Medical Type", frz_MedicalValues."Medical Type"::"Rawat Inap");
        frz_MedicalValues.SetRange(Code, rec."Medical Code");
        frz_MedicalValues.SetRange("Daily rate - room", false);
        frz_MedicalValues.SetRange("Rawat Inat Type", frz_MedicalValues."Rawat Inat Type"::Pembedahan);
        if frz_MedicalValues.FindFirst() then begin
            frz_Description := frz_MedicalValues.Description;
            frz_BasicPlafonROOM := frz_MedicalValues.Plafon;
        end;

        frz_LedgerMedical.Reset();
        frz_LedgerMedical.SetRange("Employee No.", rec."Employee No.");
        frz_LedgerMedical.SetRange("Medical Type", frz_LedgerMedical."Medical Type"::"Rawat Inap");
        frz_LedgerMedical.SetRange("Daily rate - room", false);
        frz_LedgerMedical.SetRange("Rawat Inat Type", frz_LedgerMedical."Rawat Inat Type"::Pembedahan);
        frz_LedgerMedical.CalcSums(Amount);
        frz_CurrentBalanceROOM := frz_LedgerMedical.Amount;
    end;

}