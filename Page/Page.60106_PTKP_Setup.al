page 60106 "PTKP Setup"
{
    PageType = List;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "PTKP Setup";
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                }
                field(Kode; Rec.Kode)
                {
                    ApplicationArea = All;
                }
                field(Golongan; Rec.Golongan)
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Tarif PTKP"; Rec."Tarif PTKP")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}