page 60064 "Overtime Subform"
{
    PageType = ListPart;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Overtime Line";
    DelayedInsert = true;
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                    trigger
                    OnValidate()
                    begin
                        Employee.Get(Rec."Employee No.");
                        FullName := Employee.FullName();
                    end;
                }
                field(FullName; FullName)
                {
                    Caption = 'Employee Name';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Emp. Overtime Starting Date"; Rec."Emp. Overtime Starting Date")
                {
                    ApplicationArea = all;
                }
                field("Emp. Overtime Ending Date"; Rec."Emp. Overtime Ending Date")
                {
                    ApplicationArea = all;
                }
                field(Duration; Rec.Duration)
                {
                    ApplicationArea = all;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                }
            }
        }
    }


    trigger
    OnDeleteRecord(): Boolean
    begin
        Clear(FullName);
        getFullName();
        CurrPage.Update();
    end;

    trigger
    OnAfterGetRecord()
    begin
        Clear(FullName);
        getFullName();
    end;

    trigger
    OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(FullName);
    end;

    procedure getFullName()
    begin
        if Employee.Get(Rec."Employee No.") then
            FullName := Employee.FullName()
        else
            FullName := '';
    end;


    var
        Employee: Record Employee;
        FullName: Text;
}