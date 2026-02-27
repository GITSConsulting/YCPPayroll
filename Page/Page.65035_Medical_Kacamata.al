page 65035 "Medical Kacamata"
{
    Caption = 'Kacamata';
    PageType = List;
    // ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Medical Values";
    SourceTableView = where("Medical Type" = const(Kacamata));
    DataCaptionFields = Code;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Medical Type"; rec."Medical Type"::Kacamata)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }
            repeater(GroupName)
            {
                ShowCaption = false;
                field(Code; rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Plafon; rec.Plafon)
                {
                    ApplicationArea = All;
                }
                field(Quantity; rec."Quantity 2")
                {
                    Caption = 'Per Year';
                    ApplicationArea = All;
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
    trigger OnOpenPage()
    var
        frz_CodeUnit: Codeunit "User Setup Custome";
    begin
        if frz_CodeUnit.AttendanceAdminCheck(UserId) = false then
            frz_CodeUnit.ModuleNotReady();

    end;
}