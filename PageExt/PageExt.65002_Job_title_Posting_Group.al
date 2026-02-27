pageextension 65002 "Job title group" extends "Job Title Group Setup"
{
    layout
    {
        addafter("Project Advance Limit")
        {
            field("Working Start"; rec."Working Start")
            {
                ApplicationArea = all;
            }
            field("Working Out"; rec."Working Out")
            {
                ApplicationArea = all;
            }
        }
    }
}