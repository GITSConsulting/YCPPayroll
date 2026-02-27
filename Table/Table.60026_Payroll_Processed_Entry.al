table 60026 "Payroll Processed Entry"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "Payroll Processed Entries";
    LookupPageId = "Payroll Processed Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(2; "Posting Date Salary"; Date)
        {
            DataClassification = CustomerContent;

            trigger
            OnValidate()
            begin
                Month := Date2DMY("Posting Date Salary", 2);
                Year := Date2DMY("Posting Date Salary", 3);
                MonthString := Format("Posting Date Salary", 0, '<Month Text>');
            end;
        }
        field(3; Month; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(4; Year; Integer)
        {
            Caption = 'Year Salary';
            DataClassification = CustomerContent;
        }
        field(5; MonthString; Text[20])
        {
            Caption = 'Month Salary';
            DataClassification = CustomerContent;
        }
        field(6; "Charging Processed"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(7; "Employee Charging Doc. No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Posted Employee Charg. Header";
        }
        field(8; "Posting Date Charging"; Date)
        {
            DataClassification = CustomerContent;
            trigger
            OnValidate()
            begin
                if "Posting Date Charging" <> 0D then begin
                    "Month Charging" := Date2DMY("Posting Date Charging", 2);
                    "Year Charging" := Date2DMY("Posting Date Charging", 3);
                    MonthChargingString := Format("Posting Date Charging", 0, '<Month Text>');
                end else begin
                    "Month Charging" := 0;
                    "Year Charging" := 0;
                    MonthChargingString := '';
                end;
            end;
        }
        field(9; "Month Charging"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(10; "Year Charging"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(11; MonthChargingString; Text[20])
        {
            Caption = 'Month Charging';
            DataClassification = CustomerContent;
        }
        field(29; "Year End Process"; Option)
        {
            OptionMembers = " ","Awaiting Process",Processed;
            DataClassification = CustomerContent;
        }
        field(30; "Akhir Tahun (Year)"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(31; "Paid Taxes Retrieved"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(32; "Tax Per Year Calculated"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(33; "Posting Date Year End"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(34; "GP Document No."; Code[20])
        {
            Caption = 'GP For Payroll/THR';
            DataClassification = CustomerContent;
        }
        field(35; "THR Compensation Exist"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(36; "THR Regular Exist"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(37; "THR Regular Posting Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(38; "GP For Tax"; Code[20])
        {
            Caption = 'GP For Tax (Payroll/THR)';
            DataClassification = CustomerContent;
        }
        field(39; "GP For BPJS TK"; Code[20])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Posting Date Salary")
        {
            Clustered = true;
        }
    }

}