page 60077 "CTO Realization Subform"
{
    PageType = ListPart;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "CTO Realization Line";
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Work Description"; Rec."Work Description")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Task Date"; Rec."Task Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Starting Time Realization"; Rec."Starting Time Realization")
                {
                    ApplicationArea = all;
                }
                field("Ending Time Realization"; Rec."Ending Time Realization")
                {
                    ApplicationArea = all;
                }
                field("Duration Realization (Day)"; Rec."Duration Realization (Day)")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Duration Realization (Hour)"; Rec."Duration Realization (Hour)")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Duration Realization (Minute)"; Rec."Duration Realization (Minute)")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Starting Time (Requested)"; Rec."Starting Time (Requested)")
                {
                    ApplicationArea = all;
                }
                field("Ending Time (Requested)"; Rec."Ending Time (Requested)")
                {
                    ApplicationArea = all;
                }
                field("Duration Requested (Day)"; Rec."Duration Requested (Day)")
                {
                    ApplicationArea = all;
                }
                field("Duration Requested (Hour)"; Rec."Duration Requested (Hour)")
                {
                    ApplicationArea = all;
                }
                field("Duration Requested (Minute)"; Rec."Duration Requested (Minute)")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}