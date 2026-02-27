page 60032 "PPh Akhir Tahun"
{
    PageType = List;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "PPh Akhir Tahun";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                }
                field(Year; Rec.Year)
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                }
                field("Kurang Bayar"; Rec."Kurang Bayar")
                {
                    ApplicationArea = all;
                }
                field(Selisih; Rec.Selisih)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}