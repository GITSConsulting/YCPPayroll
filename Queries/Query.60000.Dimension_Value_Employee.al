query 60000 "Dimension Value Employee"
{
    QueryType = Normal;

    elements
    {
        dataitem(DimensionValueGitu; "Dimension Value")
        {
            column(Code; Code)
            {

            }
            column(Global_Dimension_No_; "Global Dimension No.")
            {

            }
            dataitem(EmployeeGitu; Employee)
            {
                DataItemLink = "MSI_HRIS Shortcut Dim Code" = DimensionValueGitu.Code;

                column(No_; "No.")
                {

                }
                column(First_Name; "First Name")
                {

                }
                column(Last_Name; "Last Name")
                {

                }
            }

        }

    }
}