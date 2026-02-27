page 60089 "HRIS Cue"
{
    Caption = '';
    PageType = CardPart;
    UsageCategory = Administration;
    //ApplicationArea = All;
    SourceTable = "Manufacturing Cue";
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            cuegroup("HR Notification")
            {
                field("CTO Request"; Rec."CTO Request")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "CTO Request List -DrillApp";
                }
                field("CTO Realization"; Rec."CTO Realization")
                {
                    ApplicationArea = all;
                    DrillDownPageId = "CTO Realization List -DrillApp";
                }
                field("Annual Leave"; Rec."Annual Leave")
                {
                    ApplicationArea = all;
                    DrillDownPageId = "Annual Leave List";
                }
                field("Unpaid Leave"; Rec."Unpaid Leave")
                {

                    ApplicationArea = all;
                    DrillDownPageId = "Drilldown Cue of Unpaid Leave";
                }
                field("Medical Reimbursement"; Rec."Medical Reimbursement")
                {
                    ApplicationArea = all;
                    DrillDownPageId = "Medical Reimbursement List";
                    Visible = gVisible;
                }
                field("Other Attendance"; Rec."Other Attendance")
                {
                    ApplicationArea = all;
                    DrillDownPageId = "Drilldown Cue of Other Attnd.";
                }
                field("Unconditional Leave"; Rec."Unconditional Leave")
                {
                    Caption = 'Other Paid Leave';
                    ApplicationArea = all;
                    DrillDownPageId = "Drilldown Cue of Uncond. Leave";
                }
            }
        }
    }


    trigger OnOpenPage()
    var
        _Employee: Record Employee;
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;

        Rec.SetRange("User ID Filter DRE", UserId);

        _Employee.SetRange("User ID", USERID);
        if _Employee.FindFirst() then begin
            if _Employee."Employee Type" = _Employee."Employee Type"::TDP then
                gVisible := true
            else
                gVisible := false;
        end;

    end;

    trigger OnAfterGetRecord()
    begin

        //HRCue.SetFilter("User ID Filter", UserId);
    end;

    var
        HRCue: Record "Payroll General Setup";
        gVisible: Boolean;
}