page 60009 "Employee Family Entries"
{
    PageType = ListPart;
    //ApplicationArea = All;
    SourceTable = "Employee Family Entry";
    UsageCategory = Lists;
    DelayedInsert = true;
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Line No."; Rec."Line No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = all;
                }
                field(Relationship; Rec.Relationship)
                {
                    ApplicationArea = all;
                }
                field("Date of Birth"; Rec."Date of Birth")
                {
                    ApplicationArea = all;
                }
                field(Dependent; Rec.Dependent)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}