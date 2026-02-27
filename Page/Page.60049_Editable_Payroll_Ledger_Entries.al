page 60049 "Edit Payroll Ledger Entries"
{
    PageType = List;
    //ApplicationArea = All;
    //UsageCategory = Lists;
    SourceTable = "Payroll Ledger Entry";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Tanggal 20 Processed"; Rec."Tanggal 20 Processed")
                {
                    ApplicationArea = all;
                }
                field("Tanggal 31 Processed"; Rec."Tanggal 31 Processed")
                {
                    ApplicationArea = all;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                }
                field("Adjustment Prorate"; Rec."Adjustment Prorate")
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Biaya Jabatan"; Rec."Biaya Jabatan")
                {
                    ApplicationArea = All;
                }
                field("Periode Penghasilan"; Rec."Periode Penghasilan")
                {
                    ApplicationArea = All;
                }
                field("Total Income"; Rec."Total Income")
                {
                    ApplicationArea = All;
                }
                field("Pensiun JHT THT Setahun"; Rec."Pensiun JHT THT Setahun")
                {
                    ApplicationArea = all;
                }
                field("Gross Income"; Rec."Gross Income")
                {
                    ApplicationArea = All;
                }
                field("Reguler Setahun"; Rec."Reguler Setahun")
                {
                    ApplicationArea = All;
                }
                field("Bijab Reguler"; Rec."Bijab Reguler")
                {
                    ApplicationArea = All;
                }
                field(PTKP; Rec.PTKP)
                {
                    ApplicationArea = All;
                }
                field("PPh 21"; Rec."PPh 21")
                {
                    ApplicationArea = All;
                }
                field("Total Allowance"; Rec."Total Allowance")
                {
                    ApplicationArea = All;
                }
                field("Total Deduction"; Rec."Total Deduction")
                {
                    ApplicationArea = All;
                }
                field("Jumlah Pengurangan"; Rec."Jumlah Pengurangan")
                {
                    ApplicationArea = all;
                }
                field("PKP Correct"; Rec."PKP Correct")
                {
                    ApplicationArea = all;
                }
                field("Penghasilan Netto Setahun"; Rec."Penghasilan Netto Setahun")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}