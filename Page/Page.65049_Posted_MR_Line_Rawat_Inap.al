page 65049 "Posted MR Line Rawat Inap"
{
    Caption = 'Medical Rawat Inap';
    PageType = ListPart;
    SourceTable = "Posted MR Line";
    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    RefreshOnActivate = true;
    Editable = false;
    layout
    {
        area(content)
        {
            repeater(Line)
            {
                ShowCaption = false;
                field("Medical Type"; rec."Medical Type"::"Rawat Inap")
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
                    TableRelation = "Medical Values".Code where("Medical Type" = const("Rawat Inap"));
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
                field(Description; rec.Description)
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field(Day; rec."Quantity 2")
                {
                    ApplicationArea = all;
                    Editable = frz_DailyRoom;
                    trigger OnValidate()
                    begin
                        if rec."Quantity 2" >= frz_Days then begin
                            Rec."Quantity 2" := frz_Days;
                        end else begin
                            rec."Quantity 2" := rec."Quantity 2";
                        end;
                        frz_DaysBalance := frz_Days - rec."Quantity 2";
                    end;
                }
                field("Claim Amount"; rec."Claim Amount")
                {
                    Caption = 'Claim Amount per-Day';
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        frz_MedicalLines: Record "Medical Reimbursement Line";
                        frz_TotalPaidCurrent: Decimal;
                    begin
                        if Rec."Quantity 2" = 0 then begin
                            frz_PaidAmountDay := 0;
                            if rec."Claim Amount" >= frz_BasicPlafon then begin
                                rec."Paid Amount" := frz_BasicPlafon;
                            end else begin
                                Rec."Paid Amount" := rec."Claim Amount";
                            end;
                            // end;
                        end else begin
                            if rec."Claim Amount" >= frz_BasicPlafon then begin
                                rec."Paid Amount" := frz_BasicPlafon * rec."Quantity 2";
                                frz_PaidAmountDay := frz_BasicPlafon;
                            end else begin
                                Rec."Paid Amount" := rec."Claim Amount" * rec."Quantity 2";
                                frz_PaidAmountDay := rec."Claim Amount";
                            end;
                            // end;
                        end;

                        frz_MedicalLines.Reset();
                        frz_MedicalLines.SetRange("Document No.", rec."Document No.");
                        frz_MedicalLines.SetRange("Medical Type", Rec."Medical Type"::"Rawat Inap");
                        if frz_MedicalLines.FindFirst() then
                            repeat
                                frz_TotalPaidCurrent += frz_MedicalLines."Paid Amount";
                            until frz_MedicalLines.Next() = 0;
                        frz_CurrentBalance := frz_Plafon - frz_TotalPaidCurrent;
                        CurrPage.Update();
                    end;
                }
                field("Paid Amount Per-Day"; frz_PaidAmountDay)
                {
                    Caption = 'Paid Amount per-Day';
                    ApplicationArea = All;
                    Editable = false;
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
        frz_BasicPlafon: Decimal;
        frz_CurrentBalance: decimal;
        frz_Days: Decimal;
        frz_DaysBalance: Decimal;
        frz_DailyRoom: Boolean;
        frz_PaidAmountDay: Decimal;

    trigger OnAfterGetRecord()
    var
        frz_MedicalValues: Record "Medical Values";
        frz_MedicalLines: Record "Medical Reimbursement Line";
        frz_TotalPaidCurrent: Decimal;
    begin
        // get plafon dan basic plafonnya
        frz_Plafon := 0;
        frz_BasicPlafon := 0;
        frz_PaidAmountDay := 0;
        frz_Days := 0;
        frz_DaysBalance := 0;
        frz_MedicalValues.Reset();
        frz_MedicalValues.SetRange("Medical Type", Rec."Medical Type");
        frz_MedicalValues.SetRange(Code, rec."Medical Value");
        if frz_MedicalValues.FindFirst() then begin
            frz_BasicPlafon := frz_MedicalValues.Plafon;
            frz_Plafon := frz_BasicPlafon * frz_Days;

            frz_MedicalLines.Reset();
            frz_MedicalLines.SetRange("Document No.", rec."Document No.");
            frz_MedicalLines.SetRange("Medical Type", Rec."Medical Type"::"Rawat Inap");
            if frz_MedicalLines.FindFirst() then
                repeat
                    frz_TotalPaidCurrent += frz_MedicalLines."Paid Amount";
                until frz_MedicalLines.Next() = 0;
            frz_CurrentBalance := frz_Plafon - frz_TotalPaidCurrent;

            frz_Days := frz_MedicalValues."Quantity 2";

            if frz_MedicalValues."Quantity 2" = 0 then
                frz_DaysBalance := 0 else
                frz_DaysBalance := frz_MedicalValues."Quantity 2" - rec."Quantity 2";
            frz_DailyRoom := frz_MedicalValues."Daily rate - room";

            if Rec."Quantity 2" > 0 then begin

                if rec."Claim Amount" >= frz_BasicPlafon then begin
                    frz_PaidAmountDay := frz_BasicPlafon;
                end else begin
                    frz_PaidAmountDay := rec."Claim Amount";
                end;

            end;
            // end;

        end;
    end;
}
