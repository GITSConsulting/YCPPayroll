table 60071 "Upcoming Contract"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(2; "Employee No."; code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee;
        }
        field(3; "Career Transition"; enum "Career Transition")
        {
            DataClassification = CustomerContent;
        }
        field(4; "Contract Start Date"; Date)
        {
            DataClassification = CustomerContent;
            trigger
            OnValidate()
            begin
                PositionLedgerEntry.Reset();
                PositionLedgerEntry.SetRange("Employee No.", "Employee No.");
                if PositionLedgerEntry.FindLast() then begin
                    if "Contract Start Date" <= PositionLedgerEntry."Contract End Date" then
                        Error('Contract Start Date for the new contract must be bigger than ' +
                        'Contract End Date of the previous one.');
                end;
            end;
        }
        field(5; "Contract End Date"; Date)
        {
            DataClassification = CustomerContent;
            trigger
            OnValidate()
            begin
                if "Contract End Date" <= "Contract Start Date" then
                    Error('Contract End Date must be bigger than Contract Starting Date.');
            end;
        }
        field(6; "Employment Status"; Enum "Employment Status")
        {
            DataClassification = CustomerContent;
        }
        field(7; "Resign Date"; Date)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Employee No.", "Entry No.")
        {
        }
    }

    var
        PositionLedgerEntry: Record "Position Ledger Entry";
}