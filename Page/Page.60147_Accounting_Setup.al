page 60147 "Accounting Setup"
{
    PageType = Card;
    UsageCategory = Administration;
    SourceTable = "Payroll General Setup";
    DataCaptionExpression = 'Accounting';

    layout
    {
        area(Content)
        {

            group("Accrual Journal")
            {
                field("Jnl. Template Name Accrual"; Rec."Jnl. Template Name Accrual")
                {
                    Caption = 'Journal Template Name';
                    ApplicationArea = all;
                }
                field("Jnl. Batch Name Accrual"; Rec."Jnl. Batch Name Accrual")
                {
                    Caption = 'Journal Batch Name';
                    ApplicationArea = all;
                }
                group("Severance Accrual")
                {
                    field("Sevr. Accr. Debit Acc. No."; Rec."Sevr. Accr. Debit Acc. No.")
                    {
                        Caption = 'Debit Account No.';
                        ApplicationArea = all;
                    }
                    field("Sevr. Accr. Credit Acc. No."; Rec."Sevr. Accr. Credit Acc. No.")
                    {
                        Caption = 'Credit Account No.';
                        ApplicationArea = all;
                    }
                    field("Sevr. Income Acc. No."; Rec."Sevr. Income Acc. No.")
                    {
                        ApplicationArea = all;
                        Caption = 'Income Account No. (for Reversal)';
                    }
                }
                group("THR Accrual")
                {
                    field("THR Accr. Debit Acc. No."; Rec."THR Accr. Debit Acc. No.")
                    {
                        Caption = 'Debit Account No.';
                        ApplicationArea = all;
                    }
                    field("THR Accr. Credit Acc. No."; Rec."THR Accr. Credit Acc. No.")
                    {
                        Caption = 'Credit Account No.';
                        ApplicationArea = all;
                    }
                    field("THR Income Acc. No."; Rec."THR Income Acc. No.")
                    {
                        ApplicationArea = all;
                        Caption = 'Income Account No. (for Reversal)';
                    }
                }
                group("Leave Accrual")
                {
                    field("Leave Accr. Debit Acc. No."; Rec."Leave Accr. Debit Acc. No.")
                    {
                        Caption = 'Debit Account No.';
                        ApplicationArea = all;
                    }
                    field("Leave Accr. Credit Acc. No."; Rec."Leave Accr. Credit Acc. No.")
                    {
                        Caption = 'Credit Account No.';
                        ApplicationArea = all;
                    }
                    field("Leave Income Acc. No."; Rec."Leave Income Acc. No.")
                    {
                        ApplicationArea = all;
                        Caption = 'Income Account No. (for Reversal)';
                    }
                }
            }

            group("THR Disbursement")
            {
                field("THR Amount Acc. No."; Rec."THR Amount Acc. No.")
                {
                    ApplicationArea = all;
                }
                field("THR Tax Acc. No."; Rec."THR Tax Acc. No.")
                {
                    ApplicationArea = all;
                }
                field("THR THP Acc. No."; Rec."THR THP Acc. No.")
                {
                    ApplicationArea = all;
                }
            }

            group("Severance & Unused Leave Disbursement")
            {
                field("Severance THP Acc. No."; Rec."Severance THP Acc. No.")
                {
                    ApplicationArea = all;
                }
                field("Severance-Unused Tax Acc. No."; Rec."Severance-Unused Tax Acc. No.")
                {
                    ApplicationArea = all;
                }
                field("Unused Leave THP Acc. No."; Rec."Unused Leave THP Acc. No.")
                {
                    ApplicationArea = all;
                }
            }

            group(Charging)
            {
                field("Journal Template Name"; Rec."Journal Template Name")
                {
                    ApplicationArea = all;
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ApplicationArea = all;
                }
                field("Charging Gross Salary Acc. No."; Rec."Charging Gross Salary Acc. No.")
                {
                    ApplicationArea = all;
                }
                field("Overtime Account No."; Rec."Overtime Account No.")
                {
                    ApplicationArea = all;
                }
                field("Charg. Other Benefits Acc. No."; Rec."Charg. Other Benefits Acc. No.")
                {
                    ApplicationArea = all;
                }
                field("Charg. BPJS TK Acc. No."; Rec."Charg. BPJS TK Acc. No.")
                {
                    ApplicationArea = all;
                }
                field("Charg. BPJS Health Acc. No."; Rec."Charg. BPJS Health Acc. No.")
                {
                    ApplicationArea = all;
                }
                field("Charg. AKDHK Debit Acc. No."; Rec."Charg. AKDHK Debit Acc. No.")
                {
                    ApplicationArea = all;
                }
                field("Tax Account No."; Rec."Tax Account No.")
                {
                    ApplicationArea = all;
                }
                field("Charg. BPJS TK Staff Acc. No."; Rec."Charg. BPJS TK Staff Acc. No.")
                {
                    ApplicationArea = all;
                }
                field("Charg. BPJS Health Staff Acc."; Rec."Charg. BPJS Health Staff Acc.")
                {
                    ApplicationArea = all;
                }
                field("Charg. AKDHK Credit Acc. No."; Rec."Charg. AKDHK Credit Acc. No.")
                {
                    ApplicationArea = all;
                }
                field("Take Home Pay Account No."; Rec."Take Home Pay Account No.")
                {
                    ApplicationArea = all;
                }

            }
            group("Monthly Payroll General Payment Setup")
            {
                field("Salary Expense Accrue Acc. No."; Rec."Salary Expense Acc. No.")
                {
                    ApplicationArea = all;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = all;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = all;
                }
            }
            group("Safety & Security - Welfare")
            {
                field("Charg. SafeSec Debit Acc. No."; Rec."Charg. SafeSec Debit Acc. No.")
                {
                    ApplicationArea = all;
                }
                field("Charg. SafeSec Credit Acc. No."; Rec."Charg. SafeSec Credit Acc. No.")
                {
                    ApplicationArea = all;
                }
                field("Charg. Welfare Debit Acc. No."; Rec."Charg. Welfare Debit Acc. No.")
                {
                    ApplicationArea = all;
                }
                field("Charg. Welfare Credit Acc. No."; Rec."Charg. Welfare Credit Acc. No.")
                {
                    ApplicationArea = all;
                }
                field("Charg. Welfare Amount"; Rec."Charg. Welfare Amount")
                {
                    ApplicationArea = all;
                }
            }
            group("Medical")
            {
                field("Medical Reimbursement Acc. No."; Rec."Medical Reimbursement Acc. No.")
                {
                    ApplicationArea = all;
                }
            }
            group("Unpaid Leave")
            {
                field("Unpaid Leave Acc. No."; Rec."Unpaid Leave Acc. No.")
                {
                    ApplicationArea = all;
                }
            }
            group("Other Deduction")
            {
                field("Other Deduction Acc. No."; Rec."Other Deduction Acc. No.")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    trigger
    OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}