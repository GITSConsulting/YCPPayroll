page 60054 "Employee Charging"
{
    PageType = Card;
    //ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Employee Charging Header";
    RefreshOnActivate = true;

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
                field("Posting Date"; Rec."Posting Date")
                {
                    Caption = 'Posting Date Payroll';
                    ApplicationArea = all;
                }
                field(PostingDateWords; PostingDateWords)
                {
                    ApplicationArea = all;
                    ShowCaption = false;
                    Style = StrongAccent;
                    StyleExpr = true;
                    Editable = false;
                }
                field("Posting Date Charging"; Rec."Posting Date Charging")
                {
                    ApplicationArea = all;
                }
                field(ChrgPostingDateWords; ChrgPostingDateWords)
                {
                    ApplicationArea = all;
                    ShowCaption = false;
                    Style = StrongAccent;
                    StyleExpr = true;
                    Editable = false;
                }
            }
            part(subform; "Employee Charging Subform")
            {
                SubPageLink = "Document No." = field("No.");
                Caption = 'Lines';
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Post)
            {
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;
                ApplicationArea = all;

                trigger OnAction()
                var
                    Misc: Codeunit Miscellaneous;
                begin
                    if not confirm('Proceed with posting this document?') then exit;
                    Misc.ChargingCheckLine(Rec);
                    Misc.PostCharging(Rec);
                end;
            }
            action("Test MSI - Test")
            {
                Image = TestFile;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;
                ApplicationArea = all;
                Visible = false;

                trigger OnAction()
                var
                    AccrualMgt: Codeunit "Accrual Management";
                    Employee: Record Employee;
                begin
                    Employee.Get('E0001');
                    AccrualMgt.PencadanganLeave(Employee, Rec."Posting Date", 10000, 1, 'ddd');
                    Message('Done.');
                end;
            }
            action("Import From Excel")
            {
                Image = Excel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;
                ApplicationArea = all;

                trigger OnAction()
                var
                    Misc: Codeunit Miscellaneous;
                begin
                    Rec.TestField("No.");
                    Rec.TestField("Posting Date");
                    Rec.TestField("Posting Date Charging");

                    Misc.ImportExcelIntoChargingLine(Rec."No.");
                    CurrPage.Update();
                end;
            }
        }
    }

    trigger
    OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        PostingDateWords := format(Rec."Posting Date", 0, '<Day> <Month Text> <Year4>') +
                            ' is the payroll date to be processed in charging.';

        ChrgPostingDateWords := format(Rec."Posting Date Charging", 0, '<Day> <Month Text> <Year4>') +
                            ' is the charging date to be processed.';
    end;

    trigger
    OnAfterGetRecord()
    begin
        PostingDateWords := format(Rec."Posting Date", 0, '<Day> <Month Text> <Year4>') +
                            ' is the payroll date to be processed in charging.';
        ChrgPostingDateWords := format(Rec."Posting Date Charging", 0, '<Day> <Month Text> <Year4>') +
                            ' is the charging date to be processed.';
    end;

    var
        PostingDateWords: Text;
        ChrgPostingDateWords: Text;

}