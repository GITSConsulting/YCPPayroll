page 60014 "Tunjangan Jabatan Setup"
{
    PageType = Card;
    //ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Payroll General Setup";
    DataCaptionExpression = 'Tunjangan Jabatan';
    layout
    {
        area(Content)
        {
            group("General")
            {
                field("Tunjangan Jabatan Percentage"; Rec."Tunjangan Jabatan Percentage")
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