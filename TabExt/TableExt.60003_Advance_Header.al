tableextension 60003 ExtDREAdvanceHeader extends "Advance Header"
{
    fields
    {
        field(60003; "Severance Ledger Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(60004; "THR Ledger Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(60005; "Cuti Dibayar Ledger Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(60006; "Disbursement Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "","Severance Accrual","Leave Accrual",Salary,THR,"Tax Payroll - THR","BPJS TK","Severance THP","Unused Leave THP","Tax Severance - Unused Leave";
        }
        field(60008; "Delete via HR"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }
}