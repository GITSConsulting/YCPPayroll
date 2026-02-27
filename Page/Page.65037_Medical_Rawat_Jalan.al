page 65037 "Medical Rawat Jalan"
{
    Caption = 'Rawat Jalan';
    PageType = List;
    // ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Medical Values";
    SourceTableView = where("Medical Type" = const("Rawat Jalan"));
    DataCaptionFields = Code;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Medical Type"; rec."Medical Type"::"Rawat Jalan")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Plafon Header"; frz_Plafonnya)
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        frz_MedicalValues: Record "Medical Values";
                    begin
                        frz_MedicalValues.Reset();
                        frz_MedicalValues.SetRange("Medical Type", frz_MedicalValues."Medical Type"::"Rawat Jalan");
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
                }
                field(Plafon; rec.Plafon)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Apply New Settings to Employee")
            {
                ApplicationArea = All;
                Image = UpdateDescription;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;
                trigger OnAction()
                var
                    frz_CU_MasterMedicalUpdate: Codeunit "Medical Master Update";
                    frz_CU_ProsesMedical: Codeunit "Proses Medical Reimbersement";
                begin
                    frz_CU_MasterMedicalUpdate.UpdateSlot();
                    frz_CU_ProsesMedical.MedicalOpenBalanceNewYear();
                end;
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
        frz_medicalValues.SetRange("Medical Type", frz_medicalValues."Medical Type"::"Rawat Jalan");
        if frz_medicalValues.FindFirst() then
            frz_Plafonnya := frz_medicalValues.Plafon;
    end;

    trigger OnOpenPage()
    var
        frz_CodeUnit: Codeunit "User Setup Custome";
    begin
        if frz_CodeUnit.AttendanceAdminCheck(UserId) = false then
            frz_CodeUnit.ModuleNotReady();

    end;
}