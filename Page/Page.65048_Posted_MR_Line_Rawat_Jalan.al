page 65048 "Posted MR Line Rawat Jalan"
{
    Caption = 'Medical Rawat Jalan';
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
                    Editable = false;
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
                field("Claim Amount"; rec."Claim Amount")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
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

                        if rec."Claim Amount" = 0 then
                            rec."Paid Amount" := 0
                        else begin

                            if frz_CurrentBalance = 0 then
                                Rec."Paid Amount" := 0 else begin
                                if rec."Claim Amount" >= frz_CurrentBalance then begin
                                    if frz_Persentasenya = 0 then
                                        rec."Paid Amount" := frz_CurrentBalance * 1 else
                                        rec."Paid Amount" := frz_CurrentBalance * (frz_Persentasenya / 100);
                                end else
                                    if frz_Persentasenya = 0 then
                                        Rec."Paid Amount" := rec."Claim Amount" * 1 else
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
                        frz_CurrentBalance := frz_Plafon - frz_TotalPaidCurrent;
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
            // group(General)
            // {
            //     ShowCaption = false;
            //     field(frz_CurrentBalance; frz_CurrentBalance)
            //     {
            //         Caption = 'Current Balance Plafon';
            //         ApplicationArea = all;
            //         Editable = false;
            //     }
            // }
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
        frz_BasicPlafon: Decimal;
        frz_CurrentBalance: decimal;

    trigger OnAfterGetRecord()
    var
        frz_MedicalValues: Record "Medical Values";
        frz_MedicalLines: Record "Medical Reimbursement Line";
        frz_TotalPaidCurrent: Decimal;
    begin
        // get plafon dan basic plafonnya
        frz_Plafon := 0;
        frz_BasicPlafon := 0;
        frz_MedicalValues.Reset();
        frz_MedicalValues.SetRange("Medical Type", Rec."Medical Type");
        frz_MedicalValues.SetRange(Code, rec."Medical Value");
        if frz_MedicalValues.FindFirst() then begin
            frz_BasicPlafon := frz_MedicalValues.Plafon;
            if rec.Poin > 0 then
                frz_Plafon := frz_BasicPlafon * rec.Poin else
                frz_Plafon := frz_BasicPlafon;

            frz_MedicalLines.Reset();
            frz_MedicalLines.SetRange("Document No.", rec."Document No.");
            frz_MedicalLines.SetRange("Medical Type", Rec."Medical Type"::"Rawat Jalan");
            if frz_MedicalLines.FindFirst() then
                repeat
                    frz_TotalPaidCurrent += frz_MedicalLines."Paid Amount";
                until frz_MedicalLines.Next() = 0;
            frz_CurrentBalance := frz_Plafon - frz_TotalPaidCurrent;
        end
    end;
}
