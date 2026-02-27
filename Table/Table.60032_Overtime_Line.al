table 60032 "Overtime Line"
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
        field(3; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee where(Status = const(Active));
            trigger
            OnValidate()
            begin
                isHeaderOpen();
            end;
        }

        field(5; "Emp. Overtime Starting Date"; Date)
        {
            DataClassification = CustomerContent;
            trigger
            OnValidate()
            begin
                isHeaderOpen();

                if "Emp. Overtime Starting Date" <> 0D then begin
                    validasiTanggalHeader();

                    CalcFields("Header Start Date");
                    CalcFields("Header End Date");

                    if "Emp. Overtime Starting Date" < "Header Start Date" then
                        Error('Overtime dates must be between %1 and %2',
                              Format("Header Start Date", 0, '<Day> <Month Text> <Year4>'),
                              Format("Header End Date", 0, '<Day> <Month Text> <Year4>'));

                    if "Emp. Overtime Ending Date" <> 0D then begin
                        if "Emp. Overtime Starting Date" > "Emp. Overtime Ending Date" then
                            Error('Ending date must be at least the same as starting date.');
                        Duration := "Emp. Overtime Ending Date" - "Emp. Overtime Starting Date" + 1;
                    end;
                end;
            end;
        }
        field(6; "Emp. Overtime Ending Date"; Date)
        {
            DataClassification = CustomerContent;
            trigger
            OnValidate()
            begin
                isHeaderOpen();

                if "Emp. Overtime Ending Date" <> 0D then begin
                    validasiTanggalHeader();
                    TestField("Emp. Overtime Starting Date");

                    CalcFields("Header Start Date");
                    CalcFields("Header End Date");

                    if "Emp. Overtime Ending Date" > "Header End Date" then
                        Error('Overtime dates must be between %1 and %2',
                              Format("Header Start Date", 0, '<Day> <Month Text> <Year4>'),
                              Format("Header End Date", 0, '<Day> <Month Text> <Year4>'));

                    if "Emp. Overtime Starting Date" > "Emp. Overtime Ending Date" then
                        Error('Ending date must be at least the same as starting date.');

                    Duration := "Emp. Overtime Ending Date" - "Emp. Overtime Starting Date" + 1;
                end;
            end;
        }
        field(7; "Duration"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 1;
            Editable = false;
        }
        field(8; Amount; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0;
            trigger
            OnValidate()
            begin
                isHeaderOpen();
            end;
        }
        field(9; "Header Start Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Overtime Header"."Overtime Start Date" where("No." = field("Document No.")));
        }
        field(10; "Header End Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Overtime Header"."Overtime End Date" where("No." = field("Document No.")));
        }
    }

    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
        key(SK; "Document No.", "Employee No.")
        {
            SumIndexFields = Amount;
        }
    }

    procedure isHeaderOpen()
    begin
        Header.Get("Document No.");
        Header.TestField(Status, Header.Status::Open);
    end;

    procedure validasiTanggalHeader()
    begin
        Header.Get("Document No.");
        Header.TestField("Overtime Start Date");
        Header.TestField("Overtime End Date");

        Header.Validate("Overtime Start Date");
        Header.Validate("Overtime End Date");
    end;

    var
        Header: Record "Overtime Header";
}