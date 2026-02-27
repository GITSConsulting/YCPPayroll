page 60095 "HRIS Cue2"
{
    Caption = '';
    PageType = CardPart;
    UsageCategory = Administration;
    //ApplicationArea = All;
    SourceTable = "Payroll General Setup";
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            cuegroup("CTO Realization Cue")
            {
                Caption = 'CTO Realization';
                field("CTO Realization"; Rec."CTO Realization")
                {
                    ShowCaption = false;
                    ApplicationArea = all;
                    DrillDownPageId = "CTO Realization List";
                }
            }
        }
    }


    trigger
    OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;

        //Rec.SetRange("User ID Filter", UserId);
        Rec.SetRange("User ID Filter 2", UserId);
    end;

    trigger
    OnAfterGetRecord()
    begin

        //HRCue.SetFilter("User ID Filter", UserId);
    end;

    var
        HRCue: Record "Payroll General Setup";
}