page 60074 "CTO Request Subform"
{
    PageType = ListPart;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "CTO Request Line";
    AutoSplitKey = true;
    DelayedInsert = true;

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
                }
                field("Task Date"; Rec."Task Date")
                {
                    ApplicationArea = all;
                }
                field("Starting Time"; Rec."Starting Time")
                {
                    ApplicationArea = all;
                }
                field("Ending Time"; Rec."Ending Time")
                {
                    ApplicationArea = all;
                }
                field("Duration (Hour)"; Rec."Duration (Hour)")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Duration (Minute)"; Rec."Duration (Minute)")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }
        }
    }

    var
        ProjectedBalance: Integer;
        ProjectedCalculated: Boolean;
        Kanan: Integer;
        KananBgt: Integer;

    trigger
    OnAfterGetRecord()
    var
        Header: Record "CTO Request Header";
    begin
        Header.Get(Rec."Document No.");
        ProjectedBalance := Header."Projected CTO Balance";
        ProjectedCalculated := Header."Projected Calculated";
    end;
}