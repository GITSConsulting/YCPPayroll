table 60009 "Payroll General Setup"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(2; "PTKP Single"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 0;
        }
        field(3; "PTKP Married"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 0;
        }
        field(4; "PTKP Dependent"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 0;
        }
        field(5; "Yearly Brutto Inc. Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(6; "Monthly Max Income"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 0;
        }
        field(7; "Yearly Max Income"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 0;
        }
        field(8; "Tunjangan Jabatan Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(9; "Journal Template Name"; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Template";
        }
        field(10; "Journal Batch Name"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Batch".Name
            WHERE("Journal Template Name" = FIELD("Journal Template Name"));
        }
        field(11; "Basic Salary Account No."; Code[20])
        {
            Caption = 'Salary Expense Account No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
        }
        field(12; "Salary Bank Account"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Bank Account";
        }
        field(13; "PPh 21 G/L Account"; Code[20])
        {
            //Caption = 'PPh 21 Payable Account No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
        }
        field(14; "Shortcut Dimension Code Used"; Enum "Dimension No.")
        {
            Caption = 'Dimension No. Used';
            DataClassification = CustomerContent;
            trigger
            OnValidate()
            var
                GeneralLedgerSetup: Record "General Ledger Setup";
            begin
                GeneralLedgerSetup.Get();
                case "Shortcut Dimension Code Used" of
                    "Shortcut Dimension Code Used"::"Shortcut Dimension 1 Code":
                        GeneralLedgerSetup.TestField("Shortcut Dimension 1 Code");
                    "Shortcut Dimension Code Used"::"Shortcut Dimension 2 Code":
                        GeneralLedgerSetup.TestField("Shortcut Dimension 2 Code");
                    "Shortcut Dimension Code Used"::"Shortcut Dimension 3 Code":
                        GeneralLedgerSetup.TestField("Shortcut Dimension 3 Code");
                    "Shortcut Dimension Code Used"::"Shortcut Dimension 4 Code":
                        GeneralLedgerSetup.TestField("Shortcut Dimension 4 Code");
                    "Shortcut Dimension Code Used"::"Shortcut Dimension 5 Code":
                        GeneralLedgerSetup.TestField("Shortcut Dimension 5 Code");
                    "Shortcut Dimension Code Used"::"Shortcut Dimension 6 Code":
                        GeneralLedgerSetup.TestField("Shortcut Dimension 6 Code");
                    "Shortcut Dimension Code Used"::"Shortcut Dimension 7 Code":
                        GeneralLedgerSetup.TestField("Shortcut Dimension 7 Code");
                    "Shortcut Dimension Code Used"::"Shortcut Dimension 8 Code":
                        GeneralLedgerSetup.TestField("Shortcut Dimension 8 Code");
                end;
            end;
        }
        field(15; "THR Source"; Enum "THR Source")
        {
            DataClassification = CustomerContent;
        }
        field(16; "Overtime Account No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";

            trigger
            OnValidate()
            begin
                DirectPostingCheck("Overtime Account No.");
            end;
        }
        field(17; "THR Account No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
        }
        field(18; "Yearly Leave Quota"; Integer)
        {
            Caption = 'Yearly Leave Quota (in days)';
            DataClassification = CustomerContent;
        }
        field(19; "Paid Leave Request Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(20; "Unpaid Leave Request Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        // fadhil 
        field(65000; "Other Attendance Request Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        // tutup fadhil 
        field(21; "Salary Expense Acc. No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account" where("Account Type" = const(Posting));
        }
        field(22; "Salary Expense Bank Acc. No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Bank Account";
        }
        field(23; "Global Dimension 1 Code"; Code[10])
        {
            DataClassification = CustomerContent;
            NotBlank = true;
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1), Blocked = const(false));
        }
        field(24; "Global Dimension 2 Code"; Code[10])
        {
            DataClassification = CustomerContent;
            NotBlank = true;
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2), Blocked = const(false));
        }
        field(25; "Employee Charging Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(26; "Overtime Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(27; "CTO Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(29; "CTO Realization Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(30; "User ID Filter"; Code[50])
        {
            FieldClass = FlowFilter;
        }
        field(31; "CTO Request"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("CTO Request Header" WHERE(Status = const("Pending Approval"),
                                                           "Approver ID" = FIELD("User ID Filter")));
        }
        field(32; "CTO Realization"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("CTO Realization Header" WHERE(Status = const("Pending Approval"),
                                                           "Approver ID" = FIELD("User ID Filter 2")));
        }
        field(33; "User ID Filter 2"; Code[50])
        {
            FieldClass = FlowFilter;
        }
        field(34; "Medical Reimbursement Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(35; "Activate Approval"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(36; "Unconditional Leave Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(37; "Attendance Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(38; "Base Calendar Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Base Calendar";
        }
        field(39; "Tax for THR Account No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
        }
        field(40; "Tax for Uang Pisah Account No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
        }
        field(41; "THR Threshold Days"; Integer)
        {
            Caption = 'Termination/Resignation Threshold Days';
            DataClassification = CustomerContent;
        }
        field(42; "Severance Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(43; "Cuti Dibayar Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(44; "Base Calendar Shift-1"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Base Calendar";
        }
        field(45; "Base Calendar Shift-2"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Base Calendar";
        }
        field(46; "Jnl. Template Name Sev. Accr."; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Template";
        }
        field(47; "Jnl. Batch Name Sev. Accr."; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Batch".Name
            WHERE("Journal Template Name" = FIELD("Jnl. Template Name Sev. Accr."));
        }
        field(48; "Sevr. Accr. Debit Acc. No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account" where("Account Type" = const(Posting));

            trigger
            OnValidate()
            begin
                DirectPostingCheck("Sevr. Accr. Debit Acc. No.");
            end;
        }
        field(49; "Sevr. Accr. Credit Acc. No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account" where("Account Type" = const(Posting));
            trigger
            OnValidate()
            begin
                DirectPostingCheck("Sevr. Accr. Credit Acc. No.");
            end;
        }
        field(50; "Jnl. Template Name THR Accr."; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Template";
        }
        field(51; "Jnl. Batch Name THR Accr."; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Batch".Name
            WHERE("Journal Template Name" = FIELD("Jnl. Template Name THR Accr."));
        }
        field(52; "THR Accr. Debit Acc. No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account" where("Account Type" = const(Posting));

            trigger
            OnValidate()
            begin
                DirectPostingCheck("THR Accr. Debit Acc. No.");
            end;
        }
        field(53; "THR Accr. Credit Acc. No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account" where("Account Type" = const(Posting));

            trigger
            OnValidate()
            begin
                DirectPostingCheck("THR Accr. Credit Acc. No.");
            end;

        }
        field(54; "Jnl. Template Name Leave Accr."; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Template";
        }
        field(55; "Jnl. Batch Name Leave Accr."; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Batch".Name
            WHERE("Journal Template Name" = FIELD("Jnl. Template Name Leave Accr."));
        }
        field(56; "Leave Accr. Debit Acc. No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account" where("Account Type" = const(Posting));

            trigger
            OnValidate()
            begin
                DirectPostingCheck("Leave Accr. Debit Acc. No.");
            end;
        }
        field(57; "Leave Accr. Credit Acc. No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account" where("Account Type" = const(Posting));

            trigger
            OnValidate()
            begin
                DirectPostingCheck("Leave Accr. Credit Acc. No.");
            end;

        }
        field(58; "Sevr. Income Acc. No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account" where("Account Type" = const(Posting));

            trigger
            OnValidate()
            begin
                DirectPostingCheck("Sevr. Income Acc. No.");
            end;
        }
        field(59; "THR Income Acc. No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account" where("Account Type" = const(Posting));

            trigger
            OnValidate()
            begin
                DirectPostingCheck("THR Income Acc. No.");
            end;
        }
        field(60; "Leave Income Acc. No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account" where("Account Type" = const(Posting));

            trigger
            OnValidate()
            begin
                DirectPostingCheck("Leave Income Acc. No.");
            end;
        }
        field(61; "Charging Gross Salary Acc. No."; Code[20])
        {
            Caption = 'Gross Salary Account No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account" where("Account Type" = const(Posting));

            trigger
            OnValidate()
            begin
                DirectPostingCheck("Charging Gross Salary Acc. No.");
            end;
        }
        field(62; "Charg. Other Benefits Acc. No."; Code[20])
        {
            Caption = 'Other Benefits Domestic Acc. No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account" where("Account Type" = const(Posting));

            trigger
            OnValidate()
            begin
                DirectPostingCheck("Charg. Other Benefits Acc. No.");
            end;
        }
        field(63; "Charg. BPJS TK Acc. No."; Code[20])
        {
            Caption = 'BPJS TK Paid by YCP Acc. No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account" where("Account Type" = const(Posting));

            trigger
            OnValidate()
            begin
                DirectPostingCheck("Charg. BPJS TK Acc. No.");
            end;
        }
        field(64; "Charg. BPJS Health Acc. No."; Code[20])
        {
            Caption = 'BPJS Health Paid by YCP Acc. No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account" where("Account Type" = const(Posting));

            trigger
            OnValidate()
            begin
                DirectPostingCheck("Charg. BPJS Health Acc. No.");
            end;
        }
        field(65; "Charg. AKDHK Debit Acc. No."; Code[20])
        {
            Caption = 'AKDHK Debit Acc. No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account" where("Account Type" = const(Posting));

            trigger
            OnValidate()
            begin
                DirectPostingCheck("Charg. AKDHK Debit Acc. No.");
            end;
        }
        field(66; "Tax Account No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account" where("Account Type" = const(Posting));

            trigger
            OnValidate()
            begin
                DirectPostingCheck("Tax Account No.");
            end;
        }
        field(67; "Charg. BPJS TK Staff Acc. No."; Code[20])
        {
            Caption = 'BPJS TK YCP/Staff Portion Acc. No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account" where("Account Type" = const(Posting));

            trigger
            OnValidate()
            begin
                DirectPostingCheck("Charg. BPJS TK Staff Acc. No.");
            end;
        }
        field(68; "Charg. BPJS Health Staff Acc."; Code[20])
        {
            Caption = 'BPJS Health YCP/Staff Acc. No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account" where("Account Type" = const(Posting));

            trigger
            OnValidate()
            begin
                DirectPostingCheck("Charg. BPJS Health Staff Acc.");
            end;
        }
        field(69; "Charg. AKDHK Credit Acc. No."; Code[20])
        {
            Caption = 'AKDHK Credit Acc. No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account" where("Account Type" = const(Posting));

            trigger
            OnValidate()
            begin
                DirectPostingCheck("Charg. AKDHK Credit Acc. No.");
            end;
        }
        field(70; "Take Home Pay Account No."; Code[20])
        {
            Caption = 'Take Home Pay Acc. No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account" where("Account Type" = const(Posting));

            trigger
            OnValidate()
            begin
                DirectPostingCheck("Take Home Pay Account No.");
            end;
        }
        field(71; "Charg. Welfare Debit Acc. No."; Code[20])
        {
            Caption = 'Welfare Debit Acc. No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account" where("Account Type" = const(Posting));

            trigger
            OnValidate()
            begin
                DirectPostingCheck("Charg. Welfare Debit Acc. No.");
            end;
        }
        field(72; "Charg. Welfare Credit Acc. No."; Code[20])
        {
            Caption = 'Welfare Credit Acc. No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account" where("Account Type" = const(Posting));

            trigger
            OnValidate()
            begin
                DirectPostingCheck("Charg. Welfare Credit Acc. No.");
            end;
        }
        field(73; "Charg. SafeSec Debit Acc. No."; Code[20])
        {
            Caption = 'Safety & Security Debit Acc. No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account" where("Account Type" = const(Posting));

            trigger
            OnValidate()
            begin
                DirectPostingCheck("Charg. SafeSec Debit Acc. No.");
            end;
        }
        field(74; "Charg. SafeSec Credit Acc. No."; Code[20])
        {
            Caption = 'Safety & Security Credit Acc. No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account" where("Account Type" = const(Posting));

            trigger
            OnValidate()
            begin
                DirectPostingCheck("Charg. SafeSec Credit Acc. No.");
            end;
        }
        field(75; "Charg. Welfare Amount"; Decimal)
        {
            Caption = 'Welfare Amount';
            DataClassification = CustomerContent;
        }
        field(76; "THR Amount Acc. No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account" where("Account Type" = const(Posting));

            trigger
            OnValidate()
            begin
                DirectPostingCheck("THR Amount Acc. No.");
            end;
        }
        field(77; "THR Tax Acc. No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account" where("Account Type" = const(Posting));

            trigger
            OnValidate()
            begin
                DirectPostingCheck("THR Tax Acc. No.");
            end;
        }
        field(78; "THR THP Acc. No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account" where("Account Type" = const(Posting));

            trigger
            OnValidate()
            begin
                DirectPostingCheck("THR THP Acc. No.");
            end;
        }
        field(79; "Medical Reimbursement Acc. No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account" where("Account Type" = const(Posting));

            trigger
            OnValidate()
            begin
                DirectPostingCheck("Medical Reimbursement Acc. No.");
            end;
        }
        field(80; "Unpaid Leave Acc. No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account" where("Account Type" = const(Posting));

            trigger
            OnValidate()
            begin
                DirectPostingCheck("Unpaid Leave Acc. No.");
            end;
        }
        field(81; "Jnl. Template Name Accrual"; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Template";
        }
        field(82; "Jnl. Batch Name Accrual"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Batch".Name
            WHERE("Journal Template Name" = FIELD("Jnl. Template Name Accrual"));
        }
        field(83; "Other Deduction Acc. No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account" where("Account Type" = const(Posting));

            trigger
            OnValidate()
            begin
                DirectPostingCheck("Other Deduction Acc. No.");
            end;
        }
        field(84; Live; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(85; "Working Start"; time)
        {
            DataClassification = CustomerContent;
        }
        field(86; "Working Out"; time)
        {
            DataClassification = CustomerContent;
        }
        field(87; "Severance THP Acc. No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account" where("Account Type" = const(Posting));

            trigger
            OnValidate()
            begin
                DirectPostingCheck("Severance THP Acc. No.");
            end;
        }
        field(88; "Severance-Unused Tax Acc. No."; Code[20])
        {
            Caption = 'Tax Acc. No. Severance/Unused Leave';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account" where("Account Type" = const(Posting));

            trigger
            OnValidate()
            begin
                DirectPostingCheck("Severance-Unused Tax Acc. No.");
            end;
        }
        field(89; "Unused Leave THP Acc. No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account" where("Account Type" = const(Posting));

            trigger
            OnValidate()
            begin
                DirectPostingCheck("Unused Leave THP Acc. No.");
            end;
        }
        field(90; "Department"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Dimension;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    local procedure DirectPostingCheck(Akun: Code[20])
    var
        GLAccount: Record "G/L Account";
    begin
        GLAccount.Get(Akun);
        GLAccount.TestField("Direct Posting");
    end;
}