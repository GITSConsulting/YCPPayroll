tableextension 60004 ExtDREGenJnlLine extends "Gen. Journal Line"
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
        field(60006; "Charging Doc. No"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(60007; TipeDuit; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "",Salary,THR,"THR Compensation",Severance,"Unused Leave","Tax Payroll","BPJS TK","Tax THR","Tax THR Compensation","Severance-Unused Tax";
        }
        field(60008; "Delete via HR"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }
}