page 65043 "Attendance List Button"
{
    Caption = 'Employee Attendence List';
    // ApplicationArea = BasicHR;
    DataCaptionFields = "Employee No.";
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Employee Attendance Header";
    UsageCategory = Lists;
    CardPageId = "Attendance Registration Card";
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
                }
                field("Name Employee"; rec."Name Employee")
                {
                    ApplicationArea = all;
                }
                field(Month; rec.Month)
                {
                    Caption = 'Month';
                    Editable = false;
                    ApplicationArea = all;
                }
                field(Year; Rec.Year)
                {
                    Caption = 'Year';
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Effective Date"; rec."Effective Date")
                {
                    Caption = 'Effective Date';
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the first day of the employee''s absence registered on this line.';
                }
                field("Office Location Code"; rec."Office Location Code")
                {
                    ApplicationArea = all;
                    Visible = false;
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
    trigger OnAfterGetRecord()
    begin
        if rec."Effective Date" <> 0D then
            getNameMonth(Date2DMY(rec."Effective Date", 2)) else
            frz_Month := '';
    end;

    var
        EmployeeName: text;
        frz_Month: Text;
        frz_MonthInteger: Integer;

    local procedure getNameMonth(NoBulan: Integer)
    begin
        case NoBulan of
            1:
                frz_Month := 'January';
            2:
                frz_Month := 'February';
            3:
                frz_Month := 'March';
            4:
                frz_Month := 'April';
            5:
                frz_Month := 'May';
            6:
                frz_Month := 'June';
            7:
                frz_Month := 'July';
            8:
                frz_Month := 'August';
            9:
                frz_Month := 'September';
            10:
                frz_Month := 'October';
            11:
                frz_Month := 'November';
            12:
                frz_Month := 'December';
        end;
    end;
}

