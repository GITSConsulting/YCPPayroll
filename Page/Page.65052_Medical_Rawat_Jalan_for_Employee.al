page 65052 "Medical Rawat Jalan Balance"
{
    Caption = 'Balance Medical Rawat Jalan';
    PageType = ListPart;
    UsageCategory = Lists;
    SourceTable = "Medical Slot";
    SourceTableView = where("Medical Type" = const("Rawat Jalan"));
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
                field(Description; frz_description)
                {
                    ApplicationArea = All;
                }
                field(Percentage; frz_Percentage)
                {
                    ApplicationArea = All;
                }
            }
            group(balance)
            {
                ShowCaption = false;
                field("Basic Plafon"; frz_BasicPlafon)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(StatusPoint; StatusPoint)
                {
                    Caption = 'Point';
                    ApplicationArea = All;
                }
                field("Total Plafon"; frz_Plafon)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(frz_CurrentBalance; frz_CurrentBalance)
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
        frz_Plafon: Decimal;
        frz_BasicPlafon: Decimal;
        frz_CurrentBalance: decimal;
        frz_description: Text;
        StatusPoint: Integer;
        frz_Percentage: Decimal;
        frz_LedgerMedical: Record "Medical Reim Ledger Entries";

    trigger OnAfterGetRecord()
    var
        frz_MedicalValues: Record "Medical Values";
        frz_StatusPoint: Record "Master Point Status";
        frz_Employee: Record Employee;

        frz_totalAmountPaidPosted: Decimal;
        totalYear: Integer;
    begin
        StatusPoint := 0;
        frz_Percentage := 0;
        // get plafon dan basic plafonnya
        frz_Plafon := 0;
        frz_BasicPlafon := 0;
        frz_totalAmountPaidPosted := 0;

        frz_MedicalValues.Reset();
        frz_MedicalValues.SetRange("Medical Type", Rec."Medical Type");
        frz_MedicalValues.SetRange(Code, rec."Medical Code");
        if frz_MedicalValues.FindFirst() then begin

            ///////////////////////////////////////////
            frz_description := frz_MedicalValues.Description;
            frz_BasicPlafon := frz_MedicalValues.Plafon;
            frz_Percentage := frz_MedicalValues.Percentage;
            //////////////////////////////////////////
            frz_Employee.Reset();
            frz_Employee.SetRange("No.", Rec."Employee No.");
            if frz_Employee.FindFirst() then begin

                frz_StatusPoint.Reset();
                frz_StatusPoint.SetRange(Code, frz_Employee."Status Point Code");
                if frz_StatusPoint.FindFirst() then begin
                    if frz_StatusPoint.Point > 0 then
                        frz_Plafon := frz_BasicPlafon * frz_StatusPoint.Point else
                        frz_Plafon := frz_BasicPlafon;

                    StatusPoint := frz_StatusPoint.Point;
                end else
                    frz_Plafon := frz_BasicPlafon;

            end;
            /////////////////////////////////////////
            frz_LedgerMedical.Reset();
            frz_LedgerMedical.SetRange("Employee No.", rec."Employee No.");
            frz_LedgerMedical.SetRange("Medical Type", frz_LedgerMedical."Medical Type"::"Rawat Jalan");
            frz_LedgerMedical.CalcSums(Amount);
            frz_CurrentBalance := frz_LedgerMedical.Amount;

        end;
    end;

}