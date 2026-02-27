page 60105 "PTKP Setup List"
{
    PageType = List;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "PTKP Setup";
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
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