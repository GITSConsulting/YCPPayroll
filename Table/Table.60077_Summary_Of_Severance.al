table 60077 "Summary Of Severance"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(2; "Document Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(3; "Severance Ledger Count"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Severance Ledger Entry" where("Sum of Sev. Ledger Entry No." = field("Entry No.")));
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }
}