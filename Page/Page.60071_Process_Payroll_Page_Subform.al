page 60071 "Process Payroll Page Subform"
{
    PageType = ListPart;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Proc. Payroll Setup Line Table";
    InsertAllowed = false;
    ModifyAllowed = false;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(LineDocNoOvertime; Rec.LineDocNoOvertime)
                {
                    Caption = 'Document No.';
                    ApplicationArea = All;
                }
                field(ReferenceDateLine; ReferenceDateLine)
                {
                    Caption = 'Reference Date';
                    ApplicationArea = all;
                }
                field(OTStartingLine; OTStartingLine)
                {
                    Caption = 'Overtime Start Date';
                    ApplicationArea = all;
                }
                field(OTEndingLine; OTEndingLine)
                {
                    Caption = 'Overtime End Date';
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Show Document")
            {
                Image = Navigate;

                ApplicationArea = all;

                trigger
                OnAction()
                var
                    PageOvertime: page Overtime;
                    OvertimeHeader: Record "Overtime Header";
                begin
                    OvertimeHeader.Get(Rec.LineDocNoOvertime);
                    PageOvertime.SetRecord(OvertimeHeader);
                    PageOvertime.Run();
                end;
            }
        }
    }

    trigger
    OnDeleteRecord(): Boolean
    begin
        Clear(ReferenceDateLine);
        Clear(OTStartingLine);
        Clear(OTEndingLine);
        Clear(RemarksLine);
        getInfo();
        CurrPage.Update();
    end;

    trigger
    OnAfterGetRecord()
    begin
        Clear(ReferenceDateLine);
        Clear(OTStartingLine);
        Clear(OTEndingLine);
        Clear(RemarksLine);
        getInfo();
    end;

    var
        OvertimeHeader: Record "Overtime Header";
        ReferenceDateLine: Date;
        OTStartingLine: Date;
        OTEndingLine: Date;
        RemarksLine: Text[50];

    procedure getInfo()
    begin
        OvertimeHeader.Get(Rec.LineDocNoOvertime);
        ReferenceDateLine := OvertimeHeader."Reference Date";
        OTStartingLine := OvertimeHeader."Overtime Start Date";
        OTEndingLine := OvertimeHeader."Overtime End Date";
    end;
}