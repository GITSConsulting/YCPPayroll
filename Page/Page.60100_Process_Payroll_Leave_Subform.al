page 60100 "Process Payroll Leave Subform"
{
    PageType = ListPart;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Process Payroll Cuti Dibayar";
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                }
                field(FullName; FullName)
                {
                    Caption = 'Employee Name';
                    ApplicationArea = all;
                }
                field("Leave Balance"; Rec."Leave Balance")
                {
                    ApplicationArea = all;
                }
                field(MaximumLeaveToBePaid; MaximumLeaveToBePaid)
                {
                    Caption = 'Maximum Leave to be Paid';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Leave Balance (Value)"; Rec."Leave Balance (Value)")
                {
                    ApplicationArea = all;
                }
                field("To Be Paid"; Rec."To Be Paid")
                {
                    ApplicationArea = all;
                    trigger
                    OnValidate()
                    begin
                        if Rec."To Be Paid" > MaximumLeaveToBePaid then
                            Error('Cannot exceeds %1', MaximumLeaveToBePaid);
                    end;
                }
                field("To Be Paid (Value)"; Rec."To Be Paid (Value)")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }
        }
    }

    trigger
    OnAfterGetRecord()
    begin
        Employee.Get(Rec."Employee No.");
        FullName := Employee.FullName();

        if Rec."Leave Balance" >= 5 then
            MaximumLeaveToBePaid := 5
        else
            MaximumLeaveToBePaid := Rec."Leave Balance";
    end;

    var
        MaximumLeaveToBePaid: Decimal;
        Employee: Record Employee;
        FullName: Text[100];
}