table 65022 "Posted MR Line"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            TableRelation = "Posted MR Header";
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Day"; Integer)
        {
        }
        field(4; "Medical Type"; Enum "Type Medical")
        {
        }
        field(5; "Date"; Date)
        {
        }
        field(6; "Claim Amount"; Decimal)
        {
        }
        field(7; "Shortcut Dimension 1 Code"; Code[20])
        {
        }
        field(8; "Total Claim"; Decimal)
        {
        }
        field(9; "Amount Day"; Decimal)
        {
        }
        field(10; "Employee No."; Code[20])
        {
        }
        field(11; Category; Enum "Categpry Medical")
        {
        }
        field(12; "Medical Value"; Code[20])
        {
            TableRelation = "Medical Values".Code;
        }
        field(13; Description; Text[100])
        {
        }
        field(14; Quantity; Integer)
        {
        }
        field(15; "Paid Amount"; Decimal)
        {
        }
        field(16; "Status Poin"; code[50])
        {
            TableRelation = "Master Point Status".Code;
        }
        field(17; "Poin"; Decimal)
        {

        }
        field(18; "Rawat Inat Type"; Enum "Rawat Inap Type")
        {

        }
        field(19; "Daily rate - room"; Boolean)
        {

        }
        field(20; Reversed; Boolean)
        {

        }
        field(21; "Quantity 2"; Decimal)
        {
            Caption = 'Quantity';
        }
    }
    keys
    {
        key(PK; "Document No.", "Medical Type", "Line No.")
        {
        }
    }
}