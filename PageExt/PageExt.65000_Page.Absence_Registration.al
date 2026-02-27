pageextension 65000 "Absence Registration" extends "Absence Registration"
{
    // Editable = false;

    layout
    {
        modify("Cause of Absence Code")
        {
            Visible = false;
        }
        modify(Quantity)
        {
            Caption = 'Quantity Hours';
        }
        modify("From Date")
        {
            trigger OnAfterValidate()
            begin
                if rec."From Date" = 0D then
                    rec.Day := 1
                else
                    rec.Day := rec."From Date" - rec."To Date";
            end;
        }
        modify("To Date")
        {
            Visible = false;
            trigger OnAfterValidate()
            begin
                if rec."From Date" = 0D then
                    rec.Day := 1
                else
                    rec.Day := rec."From Date" - rec."To Date";
            end;
        }
        addafter("To Date")
        {
            field("Time From"; rec."Time From") { ApplicationArea = all; }
            field("Time To"; rec."Time To") { ApplicationArea = all; }
        }
        addafter("Unit of Measure Code")
        {
            field("Duration (Hour)"; rec."Duration (Hour)")
            {
                ApplicationArea = all;
            }
            field("Duration (Minute)"; rec."Duration (Minute)")
            {
                ApplicationArea = all;
            }
            field("Late Duration (Hours)"; rec."Late Duration (Hours)")
            {
                ApplicationArea = all;
            }
            field("Late Duration (Minutes)"; rec."Late Duration (Minutes)")
            {
                ApplicationArea = all;
            }
            field(Day; rec.Day)
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter("A&bsence")
        {
            action("New")
            {
                Image = Add;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;
                trigger OnAction()
                begin
                    Page.run(Page::"Attendance Registration Card");
                end;
            }
        }
    }
    var
        orange: page "Employee Absences";
}