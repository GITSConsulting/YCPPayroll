page 60098 "Tariff THR 21 Setup"
{
    PageType = List;
    SourceTable = "Tariff THR Setup";
    //ApplicationArea = all;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Kode; Rec.Kode)
                {
                    ApplicationArea = all;
                }
                field("Lower Limit"; Rec."Lower Limit")
                {
                    ApplicationArea = all;
                }
                field("Upper Limit"; Rec."Upper Limit")
                {
                    ApplicationArea = all;
                }
                field("% Tariff"; Rec."% Tariff")
                {
                    ApplicationArea = all;
                }
                field("% Tariff Non NPWP"; Rec."% Tariff Non NPWP")
                {
                    ApplicationArea = all;
                }
            }
        }
        area(Factboxes)
        {

        }
    }
}