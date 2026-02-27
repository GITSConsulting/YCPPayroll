table 60067 "Posted CTO Request Line"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(3; "Work Description"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Starting Time"; Time)
        {
            DataClassification = CustomerContent;

        }
        field(5; "Ending Time"; Time)
        {
            DataClassification = CustomerContent;
        }
        field(6; "Task Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(7; "Duration (Day)"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(8; "Duration (Hour)"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(9; "Duration (Minute)"; Integer)
        {
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
        key(SK; "Task Date")
        {
            SumIndexFields = "Duration (Hour)";
        }
    }
}