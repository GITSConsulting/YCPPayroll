table 60057 "Cuti Dibayar Line"
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
            TableRelation = Employee;

            trigger
            OnValidate()
            var
                LeaveLedgerEntry: Record "Leave Ledger Entry";
                JumlahCutiValid: Decimal;
                Contract: Record "Position Ledger Entry";
            begin
                Header.Get("Document No.");
                Header.TestField("Document Date");

                Contract.Reset();
                Contract.SetRange("Employee No.", "Employee No.");
                Contract.FindLast();
                "Contract End Date" := Contract."Contract End Date";

                LeaveLedgerEntry.Reset();
                LeaveLedgerEntry.SetRange("Employee No.", "Employee No.");
                LeaveLedgerEntry.SetRange("Document No.", 'OBAL');
                LeaveLedgerEntry.SetRange(Reversed, false);
                LeaveLedgerEntry.SetFilter("Period Start", '<=%1', Contract."Contract Start Date");
                LeaveLedgerEntry.SetFilter("Period End", '>=%1', Contract."Contract End Date");
                LeaveLedgerEntry.SetRange(Type, LeaveLedgerEntry.Type::Positive);
                LeaveLedgerEntry.FindFirst();

                "Maximum Leave Disburtion" := LeaveLedgerEntry."Maximum Leave Disburtion";
                CalcFields("Jumlah Cuti");

                if "Jumlah Cuti" > "Maximum Leave Disburtion" then
                    JumlahCutiValid := "Maximum Leave Disburtion"
                else
                    JumlahCutiValid := "Jumlah Cuti";

                Validate("Cuti Dibayarkan", JumlahCutiValid);
            end;
        }
        field(4; "Jumlah Cuti"; Decimal)
        {
            Caption = 'Unused Leave';
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Leave Ledger Entry".Quantity where("Employee No." = field("Employee No.")));
        }
        field(5; "Jumlah Cuti (Value)"; Decimal)
        {
            Caption = 'Unused Leave (Value)';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(6; "Cuti Dibayarkan"; Decimal)
        {
            Caption = 'Unused to be Paid';
            DecimalPlaces = 3 : 3;
            DataClassification = CustomerContent;
            trigger
            OnValidate()
            var
                PayrollLedgerEntry: Record "Payroll Ledger Entry";
                Duitnya: Decimal;
                Basicnya: Decimal;
                Oldnya: Decimal;
                Fixnya: Decimal;
            begin
                if "Cuti Dibayarkan" > "Maximum Leave Disburtion" then
                    Error('You cannot exceed the maximum leave disburtion');

                CalcFields("Document Date Header");

                PayrollLedgerEntry.Reset();
                PayrollLedgerEntry.SetRange("Employee No.", "Employee No.");
                PayrollLedgerEntry.FindLast();

                ValueToBePaid("Employee No.", "Cuti Dibayarkan", PayrollLedgerEntry."Posting Date",
                "Apply to Old Basic Salary", Duitnya, Basicnya, Fixnya);

                "Cuti Dibayarkan (Value)" := Duitnya;
                "Basic Salary Used" := Basicnya;
                "Fix Allowance Used" := Fixnya;
            end;
        }
        field(7; "Cuti Dibayarkan (Value)"; Decimal)
        {
            Caption = 'Unused to be paid (Value)';
            DataClassification = CustomerContent;
        }
        field(8; "Maximum Leave Disburtion"; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(9; "Document Date Header"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Cuti Dibayar Header"."Document Date" where("No." = field("Document No.")));
        }
        field(10; "Contract End Date"; Date)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(12; "Apply to Old Basic Salary"; Boolean)
        {
            DataClassification = CustomerContent;
            trigger
            OnValidate()
            begin
                Validate("Cuti Dibayarkan");
            end;
        }
        field(17; "Basic Salary Used"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(18; "Fix Allowance Used"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(19; "Actual Payment Date"; Date)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    trigger
    OnInsert()
    var
        CutiDibayarLine: Record "Cuti Dibayar Line";
    begin
        CutiDibayarLine.Reset();
        CutiDibayarLine.SetRange("Employee No.", "Employee No.");
        if CutiDibayarLine.FindFirst() then
            Error('Employee %1 already exist in unused leave no %2', "Employee No.", CutiDibayarLine."Document No.");
    end;

    var
        Header: Record "Cuti Dibayar Header";

    procedure ValueToBePaid(EmpNo: Code[20]; ToBePaid: Decimal; PostingDate: Date;
    Old: Boolean; var Valuenya: Decimal; var _Basicnya: Decimal; var _Fixnya: Decimal);
    var
        DailySalary: Decimal;
        Employee: Record Employee;
        BasicSalary: Decimal;
    begin
        BasicSalary := 0;

        Employee.Reset();
        Employee.SetRange("No.", EmpNo);
        Employee.SetRange("Date Filter", PostingDate);
        Employee.FindFirst();
        Employee.CalcFields("MSI_HRIS Total Allowance Fix");
        _Fixnya := Employee."MSI_HRIS Total Allowance Fix";

        if Old then begin
            Employee.TestField("MSI_HRIS Old Basic Salary");
            BasicSalary := Employee."MSI_HRIS Old Basic Salary";
        end else begin
            BasicSalary := Employee."MSI_HRIS Basic Salary";
        end;

        DailySalary := (BasicSalary + Employee."MSI_HRIS Total Allowance Fix") / 21;

        Valuenya := DailySalary * ToBePaid;
        _Basicnya := BasicSalary;
    end;
}