page 65053 "Medical Rawat Inap Balance"
{
    Caption = 'Rawat Inap - Daily Rate Room';
    PageType = ListPart;
    UsageCategory = Lists;
    SourceTable = "Medical Slot";
    SourceTableView = where("Medical Type" = const("Rawat Inap"), "Daily rate - room" = const(true));
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
                field("Daily rate - room"; rec."Daily rate - room")
                {
                    ApplicationArea = All;
                }
                field(Description; frz_Description)
                {
                    ApplicationArea = All;
                }
                field("Days"; frz_Days)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Basic Plafon"; frz_BasicPlafonROOM)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Total Plafon"; frz_PlafonROOM)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Days Balance"; frz_DaysBalance)
                {
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var
                        frz_PageLedgerMedical: Page "Medical Reim Ledger Entries";
                    begin
                        frz_PageLedgerMedical.SetTableView(frz_LedgerMedical_2);
                        frz_PageLedgerMedical.Run();
                    end;
                }
                field("Balance Plafon"; frz_CurrentBalanceROOM)
                {
                    ApplicationArea = All;
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
        frz_BasicPlafonROOM: Decimal;
        frz_PlafonROOM: Decimal;

        frz_totalAmountPaidPostedROOM: Decimal;
        frz_CurrentBalanceROOM: decimal;
        frz_Days: Decimal;
        frz_DaysBalance: Decimal;
        frz_Description: Text;
        frz_LedgerMedical: Record "Medical Reim Ledger Entries";
        frz_LedgerMedical_2: Record "Medical Reim Ledger Entries";

    trigger OnAfterGetRecord()
    var
        frz_MedicalValues: Record "Medical Values";
    begin
        // get plafon dan basic plafonnya
        frz_PlafonROOM := 0;
        frz_BasicPlafonROOM := 0;
        frz_Days := 0;
        frz_DaysBalance := 0;
        frz_totalAmountPaidPostedROOM := 0;
        frz_CurrentBalanceROOM := 0;
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////
        frz_MedicalValues.Reset();
        frz_MedicalValues.SetRange("Medical Type", frz_MedicalValues."Medical Type"::"Rawat Inap");
        frz_MedicalValues.SetRange(Code, rec."Medical Code");
        frz_MedicalValues.SetRange("Daily rate - room", true);
        if frz_MedicalValues.FindFirst() then begin

            frz_Description := frz_MedicalValues.Description;
            frz_BasicPlafonROOM := frz_MedicalValues.Plafon;
            frz_Days := frz_MedicalValues."Quantity 2";

            frz_LedgerMedical.Reset();
            frz_LedgerMedical.SetRange("Employee No.", rec."Employee No.");
            frz_LedgerMedical.SetRange("Medical Type", frz_LedgerMedical."Medical Type"::"Rawat Inap");
            frz_LedgerMedical.SetRange("Daily rate - room", true);
            frz_LedgerMedical.CalcSums(Amount);
            frz_CurrentBalanceROOM := frz_LedgerMedical.Amount;

            frz_LedgerMedical_2.Reset();
            frz_LedgerMedical_2.SetRange("Employee No.", rec."Employee No.");
            frz_LedgerMedical_2.SetRange("Medical Type", frz_LedgerMedical_2."Medical Type"::"Rawat Inap");
            frz_LedgerMedical_2.SetRange("Daily rate - room", true);
            frz_LedgerMedical_2.CalcSums("Quantity 2");
            frz_DaysBalance := frz_LedgerMedical_2."Quantity 2";

        end;
    end;

}