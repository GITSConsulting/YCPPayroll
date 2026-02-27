tableextension 65001 "Ext jobtitle group Setup" extends "Job Title Group"
{
    fields
    {
        field(65000; "Working Start"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(65001; "Working Out"; Time)
        {
            DataClassification = ToBeClassified;
        }
    }
}