page 60067 "Editable Overtime Header"
{
    PageType = Card;
    //ApplicationArea = All;
    //UsageCategory = Administration;
    SourceTable = "Overtime Header";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    trigger
                    OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field("Reference Date"; Rec."Reference Date")
                {
                    ApplicationArea = all;

                    trigger
                    OnValidate()
                    begin
                        GetPeriods();
                    end;
                }
                field(MonthToBeProcessed; MonthToBeProcessed)
                {
                    Caption = 'Payroll Month to Process';
                    ApplicationArea = all;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                group("OVERTIME PERIOD FOR PAYROLL PAYMENT")
                {
                    field(FirstPeriod; FirstPeriod)
                    {
                        Caption = 'First Period';
                        ApplicationArea = all;
                        Editable = false;
                        Style = Favorable;
                        StyleExpr = true;
                        MultiLine = true;
                    }
                    field(SecondPeriod; SecondPeriod)
                    {
                        Caption = 'Second Period';
                        ApplicationArea = all;
                        Editable = false;
                        Style = Favorable;
                        StyleExpr = true;
                        MultiLine = true;
                    }
                }
                field("Overtime Start Date"; Rec."Overtime Start Date")
                {
                    ApplicationArea = all;
                }
                field("Overtime End Date"; Rec."Overtime End Date")
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    Style = Unfavorable;
                    StyleExpr = SedangProsesPayroll;
                }
            }
            part(Subform; "Overtime Subform")
            {
                Caption = 'Lines';
                SubPageLink = "Document No." = field("No.");
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Release)
            {
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;

                trigger OnAction()
                var
                    Line: Record "Overtime Line";
                begin
                    Line.Reset();
                    Line.SetRange("Document No.", Rec."No.");
                    Line.FindFirst();
                    Repeat
                        Line.TestField("Employee No.");
                        Line.TestField(Amount);
                    until Line.Next() = 0;

                    Rec.Status := Rec.Status::Released;
                    Rec.Modify();
                end;
            }
            action(Reopen)
            {
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Rec.Status = Rec.Status::"Payroll Process" then
                        Error('This overtime document is being procesed right now. \ ' +
                              'You cannot change the data.');

                    Rec.Status := Rec.Status::Open;
                    Rec.Modify();
                end;
            }
        }
    }

    trigger
    OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        GetPeriods();
        CurrPage.Update();
    end;

    trigger
    OnAfterGetRecord()
    begin
        if Rec.Status = Rec.Status::"Payroll Process" then
            SedangProsesPayroll := true
        else
            SedangProsesPayroll := false;

        GetPeriods();
    end;


    procedure GetPeriods()
    begin
        MonthToBeProcessed := format(Rec."Reference Date", 0, '<Month Text> <Year4>');

        if Rec.Tanggal1 <> 0D then
            FirstPeriod := 'Overtime conducted between ' + format(Rec.Tanggal1, 0, '<Day> <Month Text> <Year4>') + ' and ' +
                        format(Rec.Tanggal15, 0, '<Day> <Month Text> <Year4> will be paid this month');

        if Rec.Tanggal16 <> 0D then
            SecondPeriod := 'Overtime conducted between ' + format(Rec.Tanggal16, 0, '<Day> <Month Text> <Year4>') + ' and ' +
                            format(Rec.AkhirBulan, 0, '<Day> <Month Text> <Year4> will be paid next month');
    end;

    var
        SedangProsesPayroll: Boolean;
        FirstPeriod: Text;
        SecondPeriod: Text;
        MonthToBeProcessed: Text;
        zzTanggal1: Date;
        zzTanggal15: Date;
        zzTanggal16: Date;
        zzAkhirBulan: Date;
}