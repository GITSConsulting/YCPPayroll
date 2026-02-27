query 60001 "CTO Request Line Distinct"
{
    QueryType = Normal;

    elements
    {
        dataitem(CTO_Request_Line; "CTO Request Line")
        {
            column(Document_No_; "Document No.")
            {

            }
            column(Task_Date; "Task Date")
            {

            }
            column(Duration__Hour_; "Duration (Hour)")
            {
                Method = Sum;
            }
        }
    }
}