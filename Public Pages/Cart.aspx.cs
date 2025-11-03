using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI.WebControls;
using TroikaClothingWeb.Models;

namespace TroikaClothingWeb.Public_Pages
{
    public partial class Cart : System.Web.UI.Page
    {
        private readonly string cs = ConfigurationManager.ConnectionStrings["LoginConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            //Only customers can access the cart
            if (Session["Role"] == null || Session["Role"].ToString() != "Customer" || Session["Username"] == null)
            {
                Session["ReturnUrl"] = "~/Public Pages/Cart.aspx";
                Response.Redirect("~/Login.aspx");
                return;
            }

            //Bind cart on first load
            if (!IsPostBack)
            {
                BindCart();
            }

            //Ensure handlers are attached
            rptCart.ItemCommand += rptCart_ItemCommand;
            btnBack.PostBackUrl = ResolveUrl("~/Public Pages/Products.aspx");

            // prefill existing address info and show current address summary
            if (!IsPostBack && Session["Username"] != null)
            {
                string username = Session["Username"].ToString();
                string customerID = GetCustomerIDByUsername(username);

                if (!string.IsNullOrEmpty(customerID))
                {
                    string cs = ConfigurationManager.ConnectionStrings["LoginConnectionString"].ConnectionString;
                    using (SqlConnection con = new SqlConnection(cs))
                    using (SqlCommand cmd = new SqlCommand("SELECT streetAddress, suburb, postCode FROM Customer WHERE customerID=@id", con))
                    {
                        cmd.Parameters.AddWithValue("@id", customerID);
                        con.Open();

                        using (SqlDataReader rdr = cmd.ExecuteReader())
                        {
                            if (rdr.Read())
                            {
                                string street = rdr["streetAddress"]?.ToString();
                                string suburb = rdr["suburb"]?.ToString();
                                string post = rdr["postCode"]?.ToString();

                                // Prefill textboxes (for editing)
                                txtStreet.Text = street;
                                txtSuburb.Text = suburb;
                                txtPostCode.Text = post;

                                // If a saved address exists, show the summary panel
                                if (!string.IsNullOrEmpty(street))
                                {
                                    PanelCurrentAddress.Visible = true;
                                    lblCurrentAddress.Text = $"{street}, {suburb}, {post}";
                                }
                            }
                        }
                    }
                }
            }
        }


        private void BindCart()
        {
            var cart = ShoppingCart.Get(Session);
            phEmpty.Visible = cart.Count == 0;
            phCart.Visible = cart.Count > 0;

            rptCart.DataSource = cart;
            rptCart.DataBind();

            decimal subtotal = ShoppingCart.Total(Session);
            decimal delivery = subtotal > 500 ? 0 : 80;
            decimal grandTotal = subtotal + delivery;

            lblEstDelivery.Text = CalculateEstimatedDelivery();

            lblSubtotal.Text = subtotal.ToString("0.00");
            lblDelivery.Text = delivery == 0 ? "Free" : $"R{delivery:0.00}";
            lblTotal.Text = grandTotal.ToString("0.00");
        }


        protected void rptCart_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            var args = (e.CommandArgument ?? "").ToString().Split('|');
            string pid = args.ElementAtOrDefault(0);
            string colour = args.ElementAtOrDefault(1);
            string size = args.ElementAtOrDefault(2);

            if (e.CommandName == "update")
            {
                var txt = (TextBox)e.Item.FindControl("txtQty");
                if (int.TryParse(txt.Text, out int q) && q > 0)
                    ShoppingCart.UpdateQuantity(Session, pid, colour, size, q);
            }
            else if (e.CommandName == "remove")
            {
                ShoppingCart.Remove(Session, pid, colour, size);
            }

            BindCart();
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ShoppingCart.Clear(Session);
            BindCart();
        }

        protected void btnCheckout_Click(object sender, EventArgs e)
        {
            string username = Session["Username"]?.ToString();

            if (string.IsNullOrEmpty(username))
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            string customerID = GetCustomerIDByUsername(username);
            if (string.IsNullOrEmpty(customerID))
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "Your customer account couldn’t be linked. Please re-register or contact support.";
                PanelAddress.Visible = true; // show panel just in case
                return;
            }


            // Check if address exists
            if (!HasAddress(customerID))
            {
                PanelAddress.Visible = true;
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "Please provide your delivery address before checking out.";
                return;
            }

            //Proceed with existing checkout logic (insert Sale + ProductSold)
            CompleteCheckout(customerID);
        }



        protected void btnSaveAddress_Click(object sender, EventArgs e)
        {
            string username = Session["Username"]?.ToString();
            if (string.IsNullOrEmpty(username)) return;

            string customerID = GetCustomerIDByUsername(username);
            if (string.IsNullOrEmpty(customerID)) return;

            string street = txtStreet.Text.Trim();
            string suburb = txtSuburb.Text.Trim();
            string post = txtPostCode.Text.Trim();

            if (string.IsNullOrEmpty(street) || string.IsNullOrEmpty(suburb) || string.IsNullOrEmpty(post))
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "All address fields are required.";
                return;
            }

            string cs = ConfigurationManager.ConnectionStrings["LoginConnectionString"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            using (SqlCommand cmd = new SqlCommand(@"
        UPDATE Customer
        SET streetAddress=@s, suburb=@sub, postCode=@p
        WHERE customerID=@id", con))
            {
                cmd.Parameters.AddWithValue("@s", street);
                cmd.Parameters.AddWithValue("@sub", suburb);
                cmd.Parameters.AddWithValue("@p", post);
                cmd.Parameters.AddWithValue("@id", customerID);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            PanelAddress.Visible = false;
            lblMessage.ForeColor = System.Drawing.Color.Green;
            lblMessage.Text = "Address saved! Please click Checkout again to confirm your order.";
        }


        private void CompleteCheckout(string customerID)
        {
            var cart = ShoppingCart.Get(Session);
            if (cart.Count == 0)
            {
                lblMessage.Text = "Your cart is empty.";
                return;
            }

            string username = Session["Username"].ToString();
            string payment = ddlPayment.SelectedValue;
            decimal subtotal = ShoppingCart.Total(Session);
            decimal delivery = subtotal > 500 ? 0 : 80;
            decimal total = subtotal + delivery;
            DateTime now = DateTime.Now;

            string newReceipt = GenerateNextReceiptNumber();

            string cs = ConfigurationManager.ConnectionStrings["LoginConnectionString"].ConnectionString;

            using (var con = new SqlConnection(cs))
            {
                con.Open(); //opens before the transaction
                using (var tx = con.BeginTransaction(System.Data.IsolationLevel.ReadCommitted))
                {
                    try
                    {
                        //Insert Sale
                        using (var cmd = new SqlCommand(@"
                    INSERT INTO Sale 
                    (receiptNum, dateOfIssue, discount, paymentTotal, paymentMethod, paymentDate, saleChannel, salesStatus, CustomerID)
                    VALUES (@r, @doi, @disc, @total, @method, @pdate, @channel, @status, @cust)", con, tx))
                        {
                            cmd.Parameters.AddWithValue("@r", newReceipt);
                            cmd.Parameters.AddWithValue("@doi", now);
                            cmd.Parameters.AddWithValue("@disc", 0m);
                            cmd.Parameters.AddWithValue("@total", total);
                            cmd.Parameters.AddWithValue("@method", payment);
                            cmd.Parameters.AddWithValue("@pdate", now);
                            cmd.Parameters.AddWithValue("@channel", "Website");
                            cmd.Parameters.AddWithValue("@status", "Placed");
                            cmd.Parameters.AddWithValue("@cust", customerID);
                            cmd.ExecuteNonQuery();
                        }

                        //Insert ProductSold
                        foreach (var line in cart)
                        {
                            using (var cmd = new SqlCommand(@"
                        INSERT INTO ProductSold (receiptID, ProductID, clothingSize, colour, quantity)
                        VALUES (@r, @pid, @size, @colour, @qty)", con, tx))
                            {
                                cmd.Parameters.AddWithValue("@r", newReceipt);
                                cmd.Parameters.AddWithValue("@pid", line.ProductID);
                                cmd.Parameters.AddWithValue("@size", (object)(line.ClothingSize ?? (object)DBNull.Value) ?? DBNull.Value);
                                cmd.Parameters.AddWithValue("@colour", (object)(line.Colour ?? (object)DBNull.Value) ?? DBNull.Value);
                                cmd.Parameters.AddWithValue("@qty", line.Quantity);
                                cmd.ExecuteNonQuery();
                            }
                        }

                        tx.Commit();
                        lblMessage.ForeColor = System.Drawing.Color.Green;
                        lblMessage.Text = "Order placed successfully!";
                        ShoppingCart.Clear(Session);
                        Response.Redirect($"~/Public Pages/OrderConfirmation.aspx?receipt={newReceipt}");
                        BindCart();
                    }
                    catch (Exception ex)
                    {
                        lblMessage.ForeColor = System.Drawing.Color.Red;
                        lblMessage.Text = "Checkout failed: " + ex.Message;
                    }
                }
            }
        }

        protected void btnToggleAddress_Click(object sender, EventArgs e)
        {
            // Toggle visibility of address form
            PanelAddress.Visible = !PanelAddress.Visible;
        }

        protected void btnCancelAddress_Click(object sender, EventArgs e)
        {
            // Hide form again
            PanelAddress.Visible = false;
        }



        private string CalculateEstimatedDelivery()
        {
            string cs = ConfigurationManager.ConnectionStrings["LoginConnectionString"].ConnectionString;
            var cart = ShoppingCart.Get(Session);
            int maxDays = 0;

            using (var con = new SqlConnection(cs))
            {
                con.Open();
                foreach (var item in cart)
                {
                    using (var cmd = new SqlCommand("SELECT ProductionTime FROM Product WHERE ProductID = @id", con))
                    {
                        cmd.Parameters.AddWithValue("@id", item.ProductID);
                        var result = cmd.ExecuteScalar();
                        if (result != null && int.TryParse(result.ToString(), out int prodDays))
                            maxDays = Math.Max(maxDays, prodDays);
                    }
                }
            }

            int totalDays = maxDays + 7; // 1 week delivery
            return $"{totalDays} days (Production + 1 week)";
        }


        private string GenerateNextReceiptNumber()
        {
            string cs = ConfigurationManager.ConnectionStrings["LoginConnectionString"].ConnectionString;
            int next = 1;

            using (var con = new SqlConnection(cs))
            {
                con.Open(); // must open
                using (var cmd = new SqlCommand(@"
            SELECT MAX(CAST(SUBSTRING(receiptNum, 4, 3) AS INT)) 
            FROM Sale 
            WHERE receiptNum LIKE 'REC%'", con))
                {
                    var obj = cmd.ExecuteScalar();
                    if (obj != DBNull.Value && obj != null)
                        next = Convert.ToInt32(obj) + 1;
                }
            }

            return "REC" + next.ToString("000");
        }

        private string GetCustomerIDByUsername(string username)
        {
            string cs = ConfigurationManager.ConnectionStrings["LoginConnectionString"].ConnectionString;
            string customerID = null;

            using (SqlConnection con = new SqlConnection(cs))
            using (SqlCommand cmd = new SqlCommand(@"
        SELECT c.customerID 
        FROM Customer c
        INNER JOIN WebsiteRegister r ON r.Email = c.email
        INNER JOIN WebsiteLogin l ON l.Username = r.Username
        WHERE l.Username = @u", con))
            {
                cmd.Parameters.AddWithValue("@u", username);
                con.Open();
                object result = cmd.ExecuteScalar();
                if (result != null && result != DBNull.Value)
                    customerID = result.ToString();
            }

            return customerID;
        }

        private bool HasAddress(string customerID)
        {
            string cs = ConfigurationManager.ConnectionStrings["LoginConnectionString"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            using (SqlCommand cmd = new SqlCommand(@"
        SELECT streetAddress FROM Customer WHERE customerID = @id", con))
            {
                cmd.Parameters.AddWithValue("@id", customerID);
                con.Open();
                object result = cmd.ExecuteScalar();
                return !(result == DBNull.Value || string.IsNullOrEmpty(Convert.ToString(result)));
            }
        }



    }
}
