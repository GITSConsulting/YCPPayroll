page 65000 "Medical List"
{
    PageType = List;
    LinksAllowed = false;
    PopulateAllFields = true;
    UsageCategory = Lists;
    ApplicationArea = all;
    Caption = 'HR - Master Medical';

    layout
    {
        area(Content)
        {
            group("Master Type Medical")
            {
                field(TextMenu4; TextMenu[4])
                {
                    ApplicationArea = all;
                    ShowCaption = false;
                    trigger
                    OnDrillDown()
                    begin
                        page.Run(65035);
                    end;
                }
                field(TextMenu5; TextMenu[5])
                {
                    ApplicationArea = all;
                    ShowCaption = false;
                    trigger
                    OnDrillDown()
                    begin
                        page.Run(65036);
                    end;
                }
                field(TextMenu6; TextMenu[6])
                {
                    ApplicationArea = all;
                    ShowCaption = false;
                    trigger
                    OnDrillDown()
                    begin
                        page.Run(65037);
                    end;
                }
                field(TextMenu7; TextMenu[7])
                {
                    ApplicationArea = all;
                    ShowCaption = false;
                    trigger
                    OnDrillDown()
                    begin
                        page.Run(65038);
                    end;
                }
            }
            group("Setup Medical Reimbursement")
            {
                field(TextMenu8; TextMenu[8])
                {
                    ApplicationArea = all;
                    ShowCaption = false;
                    trigger
                    OnDrillDown()
                    begin
                        page.Run(65042);
                    end;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Post FY Medical")
            {
                ApplicationArea = All;
                Image = UpdateDescription;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
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
        TextMenu: Array[10] of text;

    trigger
    OnOpenPage()
    begin
        TextMenu[1] := '';
        TextMenu[2] := 'Medical Reimbursement';
        TextMenu[3] := 'Posted Medical Reimbursement';
        TextMenu[4] := 'Master Kacamata';
        TextMenu[5] := 'Master Persalinan';
        TextMenu[6] := 'Master Rawat Jalan';
        TextMenu[7] := 'Master Rawat Inap';
        TextMenu[8] := 'Master Status Patient';
    end;
}