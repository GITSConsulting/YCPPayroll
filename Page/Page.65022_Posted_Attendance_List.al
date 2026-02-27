page 65022 "Posted Emp Attendance List"
{
    Caption = 'Posted Employee Attendence List';
    // ApplicationArea = BasicHR;
    DataCaptionFields = "Employee No.";
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Posted Employee Attendance";
    UsageCategory = Lists;
    CardPageId = "Posted Attendance Card";
    SourceTableView = SORTING("No.");
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; rec."No.")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies a number for the employee.';
                    // Visible = false;
                }
                field("Employee No."; rec."Employee No.")
                {
                    ApplicationArea = BasicHR;
                    caption = 'Created By No.';
                    Visible = false;
                    ToolTip = 'Specifies a number for the employee.';
                    // Visible = false;
                }
                field("Name Employee"; rec."Name Employee")
                {
                    Caption = 'Created By Name';
                    Visible = false;
                    ApplicationArea = all;
                }
                field("Effective Date"; rec."Effective Date")
                {
                    Caption = 'Effective Date';
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the first day of the employee''s absence registered on this line.';
                }
                field(Status; rec.Status)
                {
                    Caption = 'Status';
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the first day of the employee''s absence registered on this line.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("A&bsence")
            {
                Caption = 'A&bsence';
                Image = Absence;
                action("Co&mments")
                {
                    ApplicationArea = Comments;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Human Resource Comment Sheet";
                    RunPageLink = "Table Name" = CONST("Employee Absence"),
                                  "Table Line No." = FIELD("Entry No.");
                    ToolTip = 'View or add comments for the record.';
                }
            }
        }
    }
    var
        EmployeeName: text;
}

