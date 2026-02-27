table 60006 "Employee Salary Component"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Employee No."; code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee;
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(3; "Allowance Component Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Allowance Component";

            trigger
            OnValidate()
            begin
                Employee.Get("Employee No.");

                //Prevent double input allowance
                /*
                sementara tutup dulu prevent ini
                EmployeeSalaryComponent.Reset();
                EmployeeSalaryComponent.SetRange("Employee No.", "Employee No.");
                EmployeeSalaryComponent.SetRange("Allowance Component Code",
                                                    "Allowance Component Code");
                if EmployeeSalaryComponent.FindFirst() then
                    Error('Allowance component %1 is already exist for %2', "Allowance Component Code",
                            Employee.FullName());
                */

                AllowanceComp.Get("Allowance Component Code");
                if AllowanceComp."Indirect Income" then begin
                    AllowanceComp.TestField("Deduction Code");
                    Validate("Deduction Component Code", AllowanceComp."Deduction Code");
                end;
            end;
        }
        field(4; "Deduction Component Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Deduction Component";

            trigger
            OnValidate()
            begin
                Employee.Get("Employee No.");
                //Prevent double input deduction
                /*sementara tutup dulu prevent ini
                EmployeeSalaryComponent.Reset();
                EmployeeSalaryComponent.SetRange("Employee No.", "Employee No.");
                EmployeeSalaryComponent.SetRange("Deduction Component Code",
                                                    "Deduction Component Code");
                if EmployeeSalaryComponent.FindFirst() then
                    Error('Deduction component %1 is already exist for %2', "Deduction Component Code",
                            Employee.FullName());
                */

                AllowanceComp.Reset();
                AllowanceComp.SetRange("Deduction Code", "Deduction Component Code");
                if AllowanceComp.FindFirst() then
                    "Allowance Component Code" := AllowanceComp.Kode;
            end;
        }
        field(5; "Allowance Component Name"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Allowance Component".Name WHERE(Kode = FIELD("Allowance Component Code")));
        }
        field(6; "Deduction Component Name"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Deduction Component".Name WHERE(Kode = FIELD("Deduction Component Code")));
        }
        field(7; "Indirect Income"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Allowance Component"."Indirect Income" WHERE(Kode = FIELD("Allowance Component Code")));
        }
        field(8; "Apply Allowance To Old"; Boolean)
        {
            Caption = 'Apply this Allowance to Old Basic Salary';
            DataClassification = CustomerContent;
        }
        field(9; "Apply Deduction To Old"; Boolean)
        {
            Caption = 'Apply this Deduction to Old Basic Salary';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Employee No.", "Line No.")
        {
            Clustered = true;
        }
    }

    var
        AllowanceComp: Record "Allowance Component";
        EmployeeSalaryComponent: Record "Employee Salary Component";
        Employee: Record Employee;

    procedure CheckIndirectIncome()
    begin
        if "Allowance Component Code" <> '' then begin
            AllowanceComp.Get("Allowance Component Code");
            if AllowanceComp."Indirect Income" then
                TestField("Deduction Component Code", AllowanceComp."Deduction Code");
        end;
    end;
}