using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TroikaClothingWeb
{
    public partial class Reports : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                imgReport1.Visible = false;
                imgReport2.Visible = false;
                btnPrint.Visible = false;
            }
        }

        protected void ddlReports_SelectedIndexChanged(object sender, EventArgs e)
        {
            string selected = ddlReports.SelectedValue;

            // Hide everything by default
            imgReport1.Visible = false;
            imgReport2.Visible = false;
            btnPrint.Visible = false;

            if (string.IsNullOrEmpty(selected))
                return;

            if (selected == "monthlyproducts")
            {
                imgReport1.ImageUrl = "~/Images/Reports/Monthly Performance Report.png";
                imgReport1.Visible = true;
                btnPrint.Visible = true;
            }
            else if (selected == "sales")
            {
                imgReport1.ImageUrl = "~/Images/Reports/Sales Report.png";
                imgReport2.ImageUrl = "~/Images/Reports/Sales Report 2.png";
                imgReport1.Visible = true;
                imgReport2.Visible = true;
                btnPrint.Visible = true;
            }
        }

    }
}