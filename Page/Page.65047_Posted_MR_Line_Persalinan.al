page 65047 "Posted MR Line Persalinan"
{
    Caption = 'Medical Persalinan';
    PageType = ListPart;
    SourceTable = "Posted MR Line";
    SourceTableView = where("Medical Type" = const(Persalinan));
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
                    Editable = false;
                    ApplicationArea = all;
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
                }
                field("Claim Amount"; rec."Claim Amount")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        pesan: Label 'The claim amount is more than amount allowed %1';
                    begin
                        if rec."Claim Amount" >= frz_Plafon then
                            rec."Paid Amount" := frz_Plafon else
                            Rec."Paid Amount" := rec."Claim Amount";
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
        Type1: Code[20];
        getOption: array[4] of Boolean;
        getnama: array[4] of Text;
        Type2: Text;
        Type3: Text;
        Type4: Text;
        frz_Plafon: Decimal;

    trigger OnAfterGetRecord()
    var
        frz_MedicalValues: Record "Medical Values";
    begin
        frz_Plafon := 0;
        frz_MedicalValues.Reset();
        frz_MedicalValues.SetRange("Medical Type", Rec."Medical Type");
        frz_MedicalValues.SetRange(Code, rec."Medical Value");
        if frz_MedicalValues.FindFirst() then begin
            frz_Plafon := frz_MedicalValues.Plafon;
        end
    end;
}
