tableextension 60000 MSIHRISEmployee extends Employee
{
    fields
    {
        field(60000; "MSI_HRIS Basic Salary"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Basic Salary';
            DecimalPlaces = 0 : 0;
        }
        field(60001; "MSI_HRIS Total Allowance"; Decimal)
        {
            Caption = 'Total Allowance';
            FieldClass = FlowField;
            DecimalPlaces = 0 : 0;
            CalcFormula = Sum("Detailed Payroll Ledger Entry".Amount WHERE
            ("Type" = CONST(Allowance), "Employee No." = FIELD("No."), "Posting Date" = FIELD("Date Filter")));
        }
        field(60002; "MSI_HRIS Total Deduction"; Decimal)
        {
            Caption = 'Total Deduction';
            FieldClass = FlowField;
            DecimalPlaces = 0 : 0;
            CalcFormula = Sum("Detailed Payroll Ledger Entry".Amount WHERE
            ("Type" = CONST(Deduction), "Employee No." = FIELD("No."), "Posting Date" = FIELD("Date Filter")));
        }
        field(60003; "MSI_HRIS PPh 21"; Decimal)
        {
            Caption = 'PPh 21';
            FieldClass = FlowField;
            DecimalPlaces = 0 : 0;
            CalcFormula = Sum("Tarif PKP Ledger Entry"."Owed PPh 21" WHERE
            ("Employee No." = FIELD("No."), "Posting Date" = FIELD("Date Filter")));
        }
        field(60004; "MSI_HRIS NPWP No."; Text[100])
        {
            Caption = 'NPWP No.';
            DataClassification = CustomerContent;
        }
        field(60005; "MSI_HRIS Marital Status"; Enum "Marital Status")
        {
            Caption = 'Marital Status';
            DataClassification = CustomerContent;
        }
        field(60006; "MSI_HRIS Marital Date"; Date)
        {
            Caption = 'Marital Date';
            DataClassification = CustomerContent;

            trigger
            OnValidate()
            begin
                //testfield to "Marital Status" = Married
                TestField("MSI_HRIS Marital Status", 1);
            end;
        }
        field(60007; "MSI_HRIS Shortcut Dim No."; Enum "Dimension No.")
        {
            FieldClass = FlowField;
            Caption = 'Dimension No.';
            //OptionMembers = ,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code","Shortcut Dimension 3 Code","Shortcut Dimension 4 Code","Shortcut Dimension 5 Code","Shortcut Dimension 6 Code","Shortcut Dimension 7 Code","Shortcut Dimension 8 Code","Shortcut Dimension 9 Code","Shortcut Dimension 10 Code";
            CalcFormula = lookup("Payroll General Setup"."Shortcut Dimension Code Used");
        }
        field(60008; "MSI_HRIS Shortcut Dim Code"; Code[20])
        {
            //ini isi dari dimension itu sendiri. Namanya dimension code.
            //Contoh: kalo shortcut dim=DEPT, maka isinya mungkin: ADM, SALES, PURCHASE, 
            //atau kalo shortcut dim=AREA, isinya bisa JAKSEL, JAKUT, dsb
            DataClassification = CustomerContent;

            trigger
            OnLookup()
            var
                DimensionValue: Record "Dimension Value";
                PageDimensionValues: Page "Dimension Value List";
                PayrollGeneralSetup: Record "Payroll General Setup";
            begin
                PayrollGeneralSetup.Get();
                PayrollGeneralSetup.TestField("Shortcut Dimension Code Used");
                CalcFields("MSI_HRIS Shortcut Dim No.");
                DimensionValue.Reset();
                DimensionValue.SetRange("Global Dimension No.", "MSI_HRIS Shortcut Dim No.");
                DimensionValue.FindSet();

                PageDimensionValues.LookupMode(true);
                PageDimensionValues.SetTableView(DimensionValue);
                if PageDimensionValues.RunModal() = Action::LookupOK then begin
                    PageDimensionValues.GetRecord(DimensionValue);
                    "MSI_HRIS Shortcut Dim Code" := DimensionValue.code;
                end;
            end;
        }
        field(60009; "MSI_HRIS THR Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'THR Amount (Entered)';
            DecimalPlaces = 0 : 0;
            Editable = false;
        }
        field(60010; "MSI_HRIS THR Amount Processed"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'THR Amount (Processed)';
            Editable = false;
            DecimalPlaces = 0 : 0;
        }
        field(60011; "MSI_HRIS PPh 21 THR"; Decimal)
        {
            Caption = 'PPh 21 THR';
            FieldClass = FlowField;
            DecimalPlaces = 0 : 0;
            CalcFormula = Sum("THR Ledger Entry"."PPh 21 THR" WHERE
            ("Employee No." = FIELD("No."), "Posting Date" = FIELD("Date Filter")));
        }
        field(60012; "MSI_HRIS Overtime Entered"; Decimal)
        {
            Caption = 'Overtime (Entered)';
            DecimalPlaces = 0 : 0;
            Editable = false;

            FieldClass = FlowField;
            CalcFormula = Sum("Overtime Ledger Entry".Amount WHERE
            ("Employee No." = FIELD("No."), "Reference Date" = FIELD("Date Filter")));
        }

        field(60013; "MSI_HRIS Overtime Processed"; Decimal)
        {
            Caption = 'Overtime';
            Editable = false;
            DecimalPlaces = 0 : 0;
            FieldClass = FlowField;
            CalcFormula = Sum("Overtime Ledger Entry".Amount WHERE
            ("Employee No." = FIELD("No."), "Payroll Posting Date" = FIELD("Date Filter")));
        }

        field(60014; "MSI_HRIS Yearly Bonus Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Yearly Bonus Amount (Entered)';
            DecimalPlaces = 0 : 0;
            Editable = false;
        }
        field(60015; "MSI_HRIS Year Bonus Amt. Proc."; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Yearly Bonus Amount (Processed)';
            Editable = false;
            DecimalPlaces = 0 : 0;
        }
        field(60016; "MSI_HRIS PPh 21 Yearly Bonus"; Decimal)
        {
            Caption = 'PPh 21 Yearly Bonus';
            DataClassification = CustomerContent;
        }
        field(60017; "MSI_HRIS Bank Code 1"; Code[20])
        {
            Caption = 'Bank Code 1';
            DataClassification = CustomerContent;
            TableRelation = "SWIFT Code";
        }
        field(60018; "MSI_HRIS ID Card"; Text[30])
        {
            Caption = 'ID Card';
            DataClassification = CustomerContent;
        }
        field(60019; "MSI_HRIS Leave Balance"; Decimal)
        {
            Caption = 'Leave Balance';
            FieldClass = FlowField;
            CalcFormula = sum("Leave Ledger Entry".Quantity
            where("Employee No." = field("No.")));
        }
        field(60020; "MSI_HRIS Leave Eligbl. Balance"; Decimal)
        {
            Caption = 'Leave Eligible Balance';
            FieldClass = FlowField;
            CalcFormula = sum("Leave Eligible Ledger Entry".Quantity
            where("Employee No." = field("No.")));
        }
        field(60021; "MSI_HRIS Total Severance Accr."; Decimal)
        {
            Caption = 'Severance Accrual';
            FieldClass = FlowField;
            CalcFormula = Sum("Severance Accrual Ledger Entry"."Accrual Amount" WHERE
            ("Employee No." = FIELD("No."), Disbursed = const(false), "Payment Delayed" = const(false)));
        }
        field(60022; TotalHariLengthOfService; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(60023; "MSI_HRIS THR Accrual"; Decimal)
        {
            Caption = 'THR Accrual';
            FieldClass = FlowField;
            CalcFormula = Sum("THR Accrual Ledger Entry"."Accrual Amount" WHERE
            ("Employee No." = FIELD("No.")));
        }
        field(60024; "MSI_HRIS PTKP"; Decimal)
        {
            Caption = 'PTKP';
            FieldClass = FlowField;
            DecimalPlaces = 0 : 0;
            CalcFormula = Sum("Payroll Ledger Entry".PTKP WHERE
            ("Employee No." = FIELD("No."), "Posting Date" = FIELD("Date Filter")));
        }
        field(60025; "MSI_HRIS Bijab Reguler"; Decimal)
        {
            Caption = 'Bijab Reguler';
            FieldClass = FlowField;
            CalcFormula = Sum("Payroll Ledger Entry"."Bijab Reguler" WHERE
            ("Employee No." = FIELD("No."), "Posting Date" = FIELD("Date Filter")));
        }
        field(60026; "MSI_HRIS CTO Balance"; Integer)
        {
            Caption = 'CTO Balance';
            FieldClass = FlowField;
            CalcFormula = sum("CTO Ledger Entry"."Day Balance" where(
                "Employee No." = field("No.") /*, Expired = const(false)*/ ));
        }
        // fadhil
        field(60027; "Total Medical Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Medical Reim Ledger Entries".Amount where("Employee No." = field("No.")));
            // CalcFormula = sum("Medical Slot"."Max Amount Allowance" where("Employee No." = field("No.")));
        }
        field(60028; "Total Medical Amount Balance"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Medical Reim Ledger Entries".Amount where("Employee No." = field("No.")));
            // CalcFormula = sum("Medical Slot"."Max Amount Allowance" where("Employee No." = field("No.")));
        }
        field(60029; "Status Point Code"; Code[20])
        {
            // FieldClass = FlowField;
            TableRelation = "Master Point Status".Code;
        }
        // fadhil
        field(60030; "THR Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger
            OnValidate()
            begin
                "THR Amount Entered Date" := Today;
            end;
        }
        field(60031; "THR Amount Entered Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(60032; "Adjustment Prorate"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger
            OnValidate()
            begin
                "Adjstmt. Prorate Entered Date" := Today;
            end;
        }
        field(60033; "Uang Pisah"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger
            OnValidate()
            begin
                "Uang Pisah Entered Date" := Today;
            end;
        }
        field(60034; "Adjstmt. Prorate Entered Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(60035; "Uang Pisah Entered Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(60036; "MSI_HRIS Overtime"; Decimal)
        {
            Caption = 'Overtime';
            FieldClass = FlowField;
            DecimalPlaces = 0 : 0;
            CalcFormula = sum("Overtime Ledger Entry".Amount where(
                "Employee No." = field("No."), "Payroll Posting Date" = field("Date Filter")
            ));
        }
        field(60037; "Bayarkan Cuti"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(60038; "Cuti Dibayar Accrual"; Decimal)
        {
            Caption = 'Annual Leave Accrual';
            FieldClass = FlowField;
            CalcFormula = sum("Sisa Cuti Accrual Ledger Entry"."Accrual Amount"
            where("Employee No." = field("No."), Disbursed = const(false)/*, "Payment Delayed" = const(false)*/));
        }
        field(60039; "Inactive Status"; Option)
        {
            OptionMembers = "--",Resigned,"Contract Terminated";
            DataClassification = CustomerContent;
        }
        field(60040; "Tax Status"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(60041; "Newly Hired"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(60042; "Unpaid Leave Exist"; Boolean)
        {
            DataClassification = CustomerContent;
        }

        field(60043; Attendance; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Employee Absence Line" where("Employee No." = field("No."),
            Date = field("Date Filter")));
        }
        field(60044; "Nomor Rekening Bank"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(60045; "Nama Pemilik Rekening"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(60046; "MSI_HRIS Total Allowance Taxed"; Decimal)
        {
            Caption = 'Total Premium (Taxed)';
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Payroll Ledger Entry".Amount WHERE
            ("Type" = CONST(Allowance), "Employee No." = FIELD("No."), "Posting Date" = FIELD("Date Filter"),
            Taxed = const(true), "Allowance Type" = const(Premium)));
        }
        field(60047; "MSI_HRIS Total Deduction Taxed"; Decimal)
        {
            Caption = 'Total Deduction (Taxed)';
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Payroll Ledger Entry".Amount WHERE
            ("Type" = CONST(Deduction), "Employee No." = FIELD("No."), "Posting Date" = FIELD("Date Filter"),
            Taxed = const(true)));
        }
        field(60048; "MSI_HRIS PTKP Baru"; Decimal)
        {
            Caption = 'PTKP';
            FieldClass = FlowField;
            DecimalPlaces = 0 : 0;
            CalcFormula = lookup("PTKP Setup"."Tarif PTKP" where(Kode = field("MSI_HRIS PTKP Kode")));
        }
        field(60049; "MSI_HRIS PTKP Entry No."; Integer)
        {
            Caption = 'Kode PTKP';
            DataClassification = CustomerContent;
            TableRelation = "PTKP Setup";
            trigger
            OnValidate()
            var
                PTKPSetup: Record "PTKP Setup";
            begin
                PTKPSetup.Get("MSI_HRIS PTKP Entry No.");
                "MSI_HRIS PTKP Kode" := PTKPSetup.Kode;
                "MSI_HRIS PTKP Desc." := PTKPSetup.Description;
            end;
        }
        field(60050; "MSI_HRIS PTKP Kode"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(60051; "MSI_HRIS PTKP Desc."; Text[100])
        {
            Caption = 'PTKP Description';
            DataClassification = CustomerContent;
        }
        field(60052; "MSI_HRIS THR Ledger"; Decimal)
        {
            FieldClass = FlowField;
            DecimalPlaces = 0 : 0;
            CalcFormula = Sum("THR Ledger Entry"."PPh 21 THR" WHERE
            ("Employee No." = FIELD("No."), "Posting Date" = FIELD("Date Filter")));
        }
        field(60053; "MSI_HRIS Less/Over Deduct Tax"; Decimal)
        {
            Caption = 'Less/Over Deduct Tax';
            DataClassification = CustomerContent;
            trigger
            OnValidate()
            begin
                TestField(Status, Status::Active);
                TestField("MSI_HRIS Last Payroll");
            end;
        }
        field(60054; "MSI_HRIS Last Payroll"; Boolean)
        {
            Caption = 'Last Payroll';
            DataClassification = CustomerContent;

            trigger
            OnValidate()
            var
                PositionLedgerEntry: Record "Position Ledger Entry";
            begin
                TestField(Status, Status::Active);
                PositionLedgerEntry.Reset();
                PositionLedgerEntry.SetRange("Employee No.", "No.");
                PositionLedgerEntry.FindLast();
                PositionLedgerEntry.TestField("Resign Date");


                if "MSI_HRIS Last Payroll" then
                    "MSI_HRIS Last Payroll Date" := Today
                else begin
                    "MSI_HRIS Last Payroll Date" := 0D;
                    "MSI_HRIS Less/Over Deduct Tax" := 0;
                end;
            end;
        }
        field(60055; "MSI_HRIS Last Payroll Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(60056; "MSI_HRIS Less/Over Deduct Tax2"; Decimal)
        {
            Caption = 'Less/Over Deduct Tax Processed';
            DataClassification = CustomerContent;
        }
        field(60057; "MSI_HRIS Total Allowance Fix"; Decimal)
        {
            Caption = 'Total Allowance (Fix)';
            FieldClass = FlowField;
            DecimalPlaces = 0 : 0;
            CalcFormula = Sum("Detailed Payroll Ledger Entry".Amount WHERE
            ("Type" = CONST(Allowance), "Employee No." = FIELD("No."), "Posting Date" = FIELD("Date Filter"),
            "Allowance Type" = const(Fix)));
        }
        field(60058; "MSI_HRIS Total Allownc. NonFix"; Decimal)
        {
            Caption = 'Total Allowance (Non-Fix)';
            FieldClass = FlowField;
            DecimalPlaces = 0 : 0;
            CalcFormula = Sum("Detailed Payroll Ledger Entry".Amount WHERE
            ("Type" = CONST(Allowance), "Employee No." = FIELD("No."), "Posting Date" = FIELD("Date Filter"),
            "Allowance Type" = const("Non Fix")));
        }
        field(60059; "MSI_HRIS Old Basic Salary"; Decimal)
        {
            Caption = 'Old Basic Salary';
            DataClassification = CustomerContent;
        }
        field(60060; "MSI_HRIS Allowance Tangg. YCP"; Decimal)
        {
            Caption = 'Total Allowance Tanggungan YCP';
            FieldClass = FlowField;
            DecimalPlaces = 0 : 0;
            CalcFormula = Sum("Detailed Payroll Ledger Entry".Amount WHERE
            ("Type" = CONST(Allowance), "Employee No." = FIELD("No."), "Posting Date" = FIELD("Date Filter"),
            "Indirect Income" = const(true)));
        }
        field(60061; "MSI_HRIS Deduction Paid Empl."; Decimal)
        {
            Caption = 'Total Deduction Paid By Employee';
            FieldClass = FlowField;
            DecimalPlaces = 0 : 0;
            CalcFormula = Sum("Detailed Payroll Ledger Entry".Amount WHERE
            ("Type" = CONST(Deduction), "Employee No." = FIELD("No."), "Posting Date" = FIELD("Date Filter"),
            "Paid by Employee" = const(true)));
        }
        field(60062; "MSI_HRIS Tax Per Year"; Decimal)
        {
            Caption = 'Tax Per Year';
            FieldClass = FlowField;
            CalcFormula = sum("Tarif PPh21 Entry".Tax where("Employee No." = field("No."),
            "Posting Date Payroll" = field("Date Filter")));
        }
        field(60063; "With Muslim THR Disbursement"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(60064; "MSI_HRIS Tax Per Year THR"; Decimal)
        {
            Caption = 'Tax Per Year THR';
            FieldClass = FlowField;
            CalcFormula = sum("Tarif PPh21 THR Entry".Tax where("Employee No." = field("No."),
            "Posting Date THR" = field("Date Filter")));
        }
        field(60065; "MSI_HRIS THR LoS"; Decimal)
        {
            Caption = 'THR LoS';
            DataClassification = CustomerContent;
            DecimalPlaces = 7 : 7;
        }
        field(60066; "MSI_HRIS THR Calc. LoS"; Decimal)
        {
            Caption = 'THR Calc. Based on LoS';
            DataClassification = CustomerContent;
            DecimalPlaces = 7 : 7;
        }
        field(60067; "MSI_HRIS BPJS Kesehatan Staff"; Decimal)
        {
            Caption = 'BPJS Kesehatan Staff Portion';
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Payroll Ledger Entry".Amount WHERE
            ("Type" = CONST(Deduction), "Employee No." = FIELD("No."), "Posting Date" = FIELD("Date Filter"),
            "Paid by Employee" = const(true), Taxed = const(false)));
        }
        field(60068; "MSI_HRIS Termination Status"; Option)
        {
            Caption = 'Termination Status';
            OptionMembers = " ","Contract Not Extended","Resigned/Terminated";
            DataClassification = CustomerContent;
        }
        field(60069; "MSI_HRIS THR Compensation"; Boolean)
        {
            Caption = 'THR Compensation';
            DataClassification = CustomerContent;
            trigger
            OnValidate()
            begin
                //TestField("MSI_HRIS Last Payroll");
            end;
        }
        field(60070; "MSI_HRIS Los Newly Calc."; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(60071; "MSI_HRIS Admin By"; Code[20])
        {
            Caption = 'Admin By';
            TableRelation = "User Setup";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestField("User ID", '');
            end;
        }
        field(60072; "MSI_HRIS Shift Schedule"; Boolean)
        {
            Caption = 'Shift Schedule';
            DataClassification = CustomerContent;
        }
        field(60073; "MSI_HRIS Severance"; Boolean)
        {
            Caption = 'Severance';
            DataClassification = CustomerContent;
            trigger
            OnValidate()
            var
                HiringInfo: Record "Position Ledger Entry";
            begin
                TestField(Status, Status::Active);
                HiringInfo.Reset();
                HiringInfo.SetRange("Employee No.", "No.");
                HiringInfo.FindLast();

                /*
                if not "MSI_HRIS Last Payroll" then
                    if HiringInfo."Contract End Date" > Today then
                        Error('Today is %2, bigger then contract end date.\' +
                        'The contract for this employee is not expiring. The end date is %1.\' +
                        'Change the contract end date or fill the resign/termination date.',
                        Format(HiringInfo."Contract End Date", 0, '<Day> <Month Text> <Year4>'),
                        Format(Today, 0, '<Day> <Month Text> <Year4>'));
                */
            end;
        }
        field(60074; "MSI_HRIS Yearly Gross Income"; Decimal)
        {
            Caption = 'Yearly Gross Income';
            FieldClass = FlowField;
            DecimalPlaces = 0 : 0;
            CalcFormula = Sum("Payroll Ledger Entry"."Gross Income" WHERE
            ("Employee No." = FIELD("No."), "Posting Date" = FIELD("Date Filter")));
        }
        field(60075; "MSI_HRIS Yearly THR Amount"; Decimal)
        {
            Caption = 'Yearly THR Amount';
            FieldClass = FlowField;
            DecimalPlaces = 0 : 0;
            CalcFormula = sum("THR Ledger Entry"."THR Amount" where(
            "Employee No." = field("No."), "Posting Date" = field("Date Filter")));
        }
        field(60076; "MSI_HRIS Tax Paid"; Decimal)
        {
            Caption = 'Tax Paid';
            FieldClass = FlowField;
            DecimalPlaces = 0 : 0;
            CalcFormula = sum("Tax Paid Entry"."Tax Paid" where(
            "Employee No." = field("No."), "Posting Date" = field("Date Filter")));
        }
        field(60077; "MSI_HRIS Tax Per Year Tahunan"; Decimal)
        {
            Caption = 'Tax Per Year - End';
            FieldClass = FlowField;
            CalcFormula = sum("Tarif PPh21 Entry Tahunan".Tax where("Employee No." = field("No."),
            "Posting Date Payroll" = field("Date Filter")));
        }
        field(60078; "Nama Bank Tujuan"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(60079; "BPJS Kesehatan No."; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(60080; "BP Jamsostek No."; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(60081; "MSI_HRIS Bank Code 2"; Code[20])
        {
            Caption = 'Bank Code 2';
            DataClassification = CustomerContent;
            TableRelation = "SWIFT Code";
        }
        field(60082; "MSI_HRIS BPJS TK Paid by YCP"; Decimal)
        {
            Caption = 'BPJS TK Paid by YCP';
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Payroll Ledger Entry".Amount WHERE
            ("Type" = CONST(Allowance), "Employee No." = FIELD("No."), "Posting Date" = FIELD("Date Filter"),
            "Component Code" = filter('*JHT*|*JKK*|*JKM*|*JP*')));
        }
        field(60083; "MSI_HRIS BPJS TK YCP Staff"; Decimal)
        {
            Caption = 'BPJS TK YCP/Staff Portion';
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Payroll Ledger Entry".Amount WHERE
            ("Type" = CONST(Deduction), "Employee No." = FIELD("No."), "Posting Date" = FIELD("Date Filter"),
            "Component Code" = filter('*JHT*|*JKK*|*JKM*|*JP*')));
        }
        field(60084; "MSI_HRIS BPJS Kes. YCP Staff"; Decimal)
        {
            Caption = 'BPJS Kes. YCP/Staff Portion';
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Payroll Ledger Entry".Amount WHERE
            ("Type" = CONST(Deduction), "Employee No." = FIELD("No."), "Posting Date" = FIELD("Date Filter"),
            "Component Code" = filter('*KES*|*BPJS_KES*')));
        }
        field(60085; "MSI_HRIS BPJS Kes. Paid by YCP"; Decimal)
        {
            Caption = 'BPJS Kesehatan Paid by YCP';
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Payroll Ledger Entry".Amount WHERE
            ("Type" = CONST(Allowance), "Employee No." = FIELD("No."), "Posting Date" = FIELD("Date Filter"),
            "Component Code" = filter('*KES*|*BPJS_KES*')));
        }
        field(60086; "MSI_HRIS AKDHK Paid by YCP"; Decimal)
        {
            Caption = 'AKDHK Paid by YCP';
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Payroll Ledger Entry".Amount WHERE
            ("Type" = CONST(Allowance), "Employee No." = FIELD("No."), "Posting Date" = FIELD("Date Filter"),
            "Component Code" = filter('*JSHK*')));
        }
        field(60087; "MSI_HRIS Tax Per Year End"; Decimal)
        {
            Caption = 'Tax Per Year - End For December';
            FieldClass = FlowField;
            CalcFormula = sum("Tarif PPh21 Entry Tahunan".Tax where("Employee No." = field("No."),
            "Posting Date December Payroll" = field("Date Filter")));
        }
        field(60088; "MSI_HRIS PPh 21 Terutang"; Decimal)
        {
            Caption = 'PPh 21 Terutang';
            FieldClass = FlowField;
            CalcFormula = sum("Year End Ledger Entry"."PPh 21 Terutang" where("Employee No." = field("No."),
            "Posting Date December Payroll" = field("Date Filter")));
        }
        field(60089; "MSI_HRIS Other Deduction"; Decimal)
        {
            Caption = 'Other Deduction';
            DataClassification = CustomerContent;
        }
        field(60090; "MSI_HRIS SafeSec Accrual"; Decimal)
        {
            Caption = 'Safety & Security Accrual';
            FieldClass = FlowField;
            CalcFormula = sum("SS Welfare Accr. Ledger Entry"."Accrual Amount" where("Employee No." = field("No."),
            "Entry Type" = const("Safety & Security")));
        }
        field(60091; "MSI_HRIS Welfare Accrual"; Decimal)
        {
            Caption = 'Welfare Accrual';
            FieldClass = FlowField;
            CalcFormula = sum("SS Welfare Accr. Ledger Entry"."Accrual Amount" where("Employee No." = field("No."),
            "Entry Type" = const(Welfare)));
        }
        field(60092; "MSI_HRIS Tax Severance Leave"; Decimal)
        {
            Caption = 'Tax Severance & Leave';
            FieldClass = FlowField;
            CalcFormula = sum("Tarif PPh21 Sevr. Leave Entry".Tax where("Employee No." = field("No."),
            "Posting Date" = field("Date Filter")));
        }
        field(60093; "MSI_HRIS Sevr. Apply to Old"; Boolean)
        {
            Caption = 'Severance Apply to Old Basic Salary';
            DataClassification = CustomerContent;
        }
        field(60094; "MSI_HRIS Type Shift"; Enum "Shift Type")
        {
            DataClassification = CustomerContent;
        }
        field(60095; "MSI_HRIS Department"; code[50])
        {
            DataClassification = CustomerContent;
            trigger OnLookup()
            var
                DimensionValue: Record "Dimension Value";
                PageDimensionValues: Page "Dimension Value List";
                PayrollGeneralSetup: Record "Payroll General Setup";
            begin
                PayrollGeneralSetup.Get();
                DimensionValue.Reset();
                DimensionValue.SetRange("Dimension Code", PayrollGeneralSetup.Department);
                DimensionValue.FindSet();

                PageDimensionValues.LookupMode(true);
                PageDimensionValues.SetTableView(DimensionValue);
                if PageDimensionValues.RunModal() = Action::LookupOK then begin
                    PageDimensionValues.GetRecord(DimensionValue);
                    "MSI_HRIS Department" := DimensionValue.code;
                end;
            end;
        }
        field(60096; "MSI_HRIS THR Apply to Old"; Boolean)
        {
            Caption = 'Apply THR to Old Basic Salary';
            DataClassification = CustomerContent;

            trigger
            OnValidate()
            begin
                TestField("MSI_HRIS Old Basic Salary");
            end;
        }
        field(60097; "MSI_HRIS Actual Payment Date"; Date)
        {
            Caption = 'Actual Payment Date';
            DataClassification = CustomerContent;
        }
        field(60098; "Employee Type"; Option)
        {
            Caption = 'Employee Type';
            OptionMembers = Staff,TDP;
            DataClassification = CustomerContent;
        }
    }

    procedure UnpaidLeave(PostingDate: Date; var Bolos: Decimal; var Potongan: Decimal);
    var
        UnpaidLeaveRequest: Record "Posted Leave Request";
        TanggalAwal: Date;
        TanggalAkhir: Date;
    begin
        //Error('HAHA=%1 hehe=%2', PostingDate, Rec.FullName());
        Clear(Bolos);
        Clear(Potongan);

        TanggalAwal := CalcDate('-CM', PostingDate);
        TanggalAkhir := CalcDate('CM', PostingDate);

        //Error('Awal=%1 Akhir=%2', TanggalAwal, TanggalAkhir);

        UnpaidLeaveRequest.Reset();
        UnpaidLeaveRequest.SetRange("Leave Type", UnpaidLeaveRequest."Leave Type"::Unpaid);
        UnpaidLeaveRequest.SetRange("Employee No.", Rec."No.");
        UnpaidLeaveRequest.SetFilter("Starting Date", '>=%1', TanggalAwal);
        UnpaidLeaveRequest.SetFilter("Ending Date", '<=%1', TanggalAkhir);
        UnpaidLeaveRequest.SetRange(Reversed, false);
        UnpaidLeaveRequest.SetCurrentKey("Leave Type", "Employee No.", "Starting Date", "Ending Date", Reversed);
        if UnpaidLeaveRequest.FindSet() then begin
            UnpaidLeaveRequest.CalcSums("Total Number of Days");
            UnpaidLeaveRequest.CalcSums("Salary Deduction");

            Bolos := UnpaidLeaveRequest."Total Number of Days";
            Potongan := UnpaidLeaveRequest."Salary Deduction";
            //Error('Bolos=%1', Bolos);
        end else begin
            Bolos := 0;
            Potongan := 0;
        end;

        //Error('emp=%1', Rec.FullName());

    end;


    procedure LeaveValue(): Decimal;
    var
        DailySalary: Decimal;
        EligibleLeaveBalance: Decimal;
    begin
        Rec.CalcFields("MSI_HRIS Leave Balance");
        DailySalary := Rec."MSI_HRIS Basic Salary" / 21;

        if Rec."MSI_HRIS Leave Balance" >= 0 then begin
            if Rec."MSI_HRIS Leave Balance" >= 5 then
                EligibleLeaveBalance := 5
            else
                EligibleLeaveBalance := Rec."MSI_HRIS Leave Balance";

            exit(DailySalary * EligibleLeaveBalance);
        end else
            exit(0);
    end;


    procedure GeneralLedgerDimensionSetup(var StrDimension: Code[20]; DimensionNo: enum "Dimension No.")
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        GeneralLedgerSetup.Get();
        case DimensionNo of
            DimensionNo::"Shortcut Dimension 1 Code":
                StrDimension := GeneralLedgerSetup."Shortcut Dimension 1 Code";
            DimensionNo::"Shortcut Dimension 2 Code":
                StrDimension := GeneralLedgerSetup."Shortcut Dimension 2 Code";
            DimensionNo::"Shortcut Dimension 3 Code":
                StrDimension := GeneralLedgerSetup."Shortcut Dimension 3 Code";
            DimensionNo::"Shortcut Dimension 4 Code":
                StrDimension := GeneralLedgerSetup."Shortcut Dimension 4 Code";
            DimensionNo::"Shortcut Dimension 5 Code":
                StrDimension := GeneralLedgerSetup."Shortcut Dimension 5 Code";
            DimensionNo::"Shortcut Dimension 6 Code":
                StrDimension := GeneralLedgerSetup."Shortcut Dimension 6 Code";
            DimensionNo::"Shortcut Dimension 7 Code":
                StrDimension := GeneralLedgerSetup."Shortcut Dimension 7 Code";
            DimensionNo::"Shortcut Dimension 8 Code":
                StrDimension := GeneralLedgerSetup."Shortcut Dimension 8 Code";
        end;
    end;
}