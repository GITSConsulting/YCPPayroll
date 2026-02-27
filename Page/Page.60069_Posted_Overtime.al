page 60069 "Posted Overtime"
{
    PageType = Card;
    //ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Posted Overtime Header";
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Reference Date"; Rec."Reference Date")
                {
                    ApplicationArea = all;
                }
                field(MonthToBeProcessed; MonthToBeProcessed)
                {
                    Caption = 'Payroll Month to Process';
                    ApplicationArea = all;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                /*
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
                }*/
                field("Overtime Start Date"; Rec."Overtime Start Date")
                {
                    ApplicationArea = all;
                }
                field("Overtime End Date"; Rec."Overtime End Date")
                {
                    ApplicationArea = all;
                }
            }
            part(Subform; "Posted Overtime Subform")
            {
                Caption = 'Lines';
                SubPageLink = "Document No." = field("No.");
                ApplicationArea = all;
            }
        }
    }

    trigger
    OnAfterGetRecord()
    begin
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
        FirstPeriod: Text;
        SecondPeriod: Text;
        MonthToBeProcessed: Text;
}