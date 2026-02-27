table 60043 "Posted CTO Realization Line"
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
            Editable = false;
        }
        field(3; "Work Description"; Text[250])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(6; Date; Date)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(10; "Starting Time Realization"; Time)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(11; "Ending Time Realization"; Time)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(12; "Duration Realization (Day)"; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(13; "Duration Realization (Hour)"; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(14; "Duration Realization (Minute)"; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(15; "Starting Time (Requested)"; Time)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(16; "Ending Time (Requested)"; Time)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(17; "Duration Requested (Day)"; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(18; "Duration Requested (Hour)"; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(19; "Duration Requested (Minute)"; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
}