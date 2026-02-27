page 60059 "Posted Employee Charging"
{
    PageType = Card;
    UsageCategory = Administration;
    SourceTable = "Posted Employee Charg. Header";
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
                    Editable = false;
                }
                field("Ignore Error On Cancelation"; Rec."Ignore Error On Cancelation")
                {
                    ApplicationArea = all;
                    Visible = UserMSI;
                }
            }
            part(subform; "Posted Employee Charg. Subform")
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
            action("Cancel This Document")
            {
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;
                ApplicationArea = all;

                trigger
                OnAction()
                var
                    Misc: Codeunit Miscellaneous;
                begin
                    if not Confirm('Are you sure to cancel this document?') then exit;
                    Misc.CancelCharging(Rec."No.");
                    CurrPage.Close();
                end;
            }
        }
    }


    trigger
    OnAfterGetRecord()
    begin
        PostingDateWords := format(Rec."Posting Date", 0, '<Day> <Month Text> <Year4>') +
                            ' is the payroll date already processed with this charging';

        if UserId = 'MSI' then
            UserMSI := true
        else
            UserMSI := false;
    end;

    var
        PostingDateWords: Text;
        UserMSI: Boolean;
}