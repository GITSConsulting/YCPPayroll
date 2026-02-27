page 65038 "Medical Rawat Inap"
{
    Caption = 'Rawat Inap';
    PageType = List;
    // ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Medical Values";
    SourceTableView = where("Medical Type" = const("Rawat Inap"));
    DataCaptionFields = Code;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Medical Type"; rec."Medical Type"::"Rawat Inap")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }
            part(PartName; "Medical Rawat Inap Room")
            {
                ApplicationArea = all;
                SubPageLink = "Medical Type" = const("Rawat Inap");
            }
            part(PartName2; "Medical Rawat Inap Pembedahan")
            {
                ApplicationArea = all;
                SubPageLink = "Medical Type" = const("Rawat Inap");
            }
            part(PartName3; "Medical Rawat Inap Perawatan")
            {
                ApplicationArea = all;
                SubPageLink = "Medical Type" = const("Rawat Inap");
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
                Visible = false;
                PromotedOnly = true;
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

    trigger OnOpenPage()
    var
        frz_CodeUnit: Codeunit "User Setup Custome";
    begin
        if frz_CodeUnit.AttendanceAdminCheck(UserId) = false then
            frz_CodeUnit.ModuleNotReady();

    end;

    trigger OnAfterGetRecord()
    var
        frz_medicalValues: Record "Medical Values";
    begin
        frz_Plafonnya := 0;
        frz_medicalValues.Reset();
        frz_medicalValues.SetRange("Medical Type", frz_medicalValues."Medical Type"::"Rawat Inap");
        frz_medicalValues.SetRange("Daily rate - room", false);
        if frz_medicalValues.FindFirst() then
            frz_Plafonnya := frz_medicalValues.Plafon;
    end;

}