page 60013 "Biaya Jabatan Setup"
{
    PageType = Card;
    //ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Payroll General Setup";
    DataCaptionExpression = 'Biaya Jabatan';

    layout
    {
        area(Content)
        {
            group("General")
            {
                field("Yearly Brutto Inc. Percentage"; Rec."Yearly Brutto Inc. Percentage")
                {
                    ApplicationArea = all;
                }
                field("Monthly Max Income"; Rec."Monthly Max Income")
                {
                    ApplicationArea = all;
                }
                field("Yearly Max Income"; Rec."Yearly Max Income")
                {
                    ApplicationArea = all;
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
    end;
}