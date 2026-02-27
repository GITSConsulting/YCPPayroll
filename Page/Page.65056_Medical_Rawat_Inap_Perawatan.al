page 65056 "Medical Rawat Inap Perawatan"
{
    Caption = 'Jasa Perawatan';
    PageType = ListPart;
    UsageCategory = Lists;
    SourceTable = "Medical Values";
    SourceTableView = where("Medical Type" = const("Rawat Inap"), "Rawat Inat Type" = const("Biaya Jasa Perawatan"));
    DataCaptionFields = Code;

    layout
    {
        area(Content)
        {
            group(General)
            {
                ShowCaption = false;
                field("Plafon Header"; frz_Plafonnya)
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        frz_MedicalValues: Record "Medical Values";
                    begin
                        frz_MedicalValues.Reset();
                        frz_MedicalValues.SetRange("Medical Type", frz_MedicalValues."Medical Type"::"Rawat Inap");
                        frz_MedicalValues.SetRange("Rawat Inat Type", frz_MedicalValues."Rawat Inat Type"::"Biaya Jasa Perawatan");
                        if frz_MedicalValues.FindFirst() then
                            repeat
                                frz_MedicalValues.Plafon := frz_Plafonnya;
                                frz_MedicalValues.Modify();
                            until frz_MedicalValues.Next() = 0;
                        CurrPage.Update();
                    end;
                }
            }
            repeater(GroupName)
            {
                ShowCaption = false;
                field(Code; rec.Code)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        if frz_Plafonnya > 0 then
                            rec.Plafon := frz_Plafonnya;
                        CurrPage.Update();
                    end;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Percentage; rec.Percentage)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Plafon; rec.Plafon)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
    var
        frz_Plafonnya: Decimal;

    trigger OnAfterGetRecord()
    var
        frz_medicalValues: Record "Medical Values";
    begin
        frz_Plafonnya := 0;
        frz_medicalValues.Reset();
        frz_medicalValues.SetRange("Medical Type", frz_medicalValues."Medical Type"::"Rawat Inap");
        frz_medicalValues.SetRange("Rawat Inat Type", frz_medicalValues."Rawat Inat Type"::"Biaya Jasa Perawatan");
        frz_medicalValues.SetRange("Daily rate - room", false);
        if frz_medicalValues.FindFirst() then
            frz_Plafonnya := frz_medicalValues.Plafon;
    end;
}