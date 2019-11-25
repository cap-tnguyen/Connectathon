using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
namespace SDC
{
    public class DBHelper
    {
        public static void WriteTransactionLog(string Type, string Message, string actor, string SourceIP)
        {

            using (SqlConnection con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["sdcdb"].ConnectionString))
            {
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = con;
                con.Open();
                cmd.CommandText = "insert into sdc_transactions (TransactionType, TransactionContent, DateCreated, SourceIP, actor) values (@Type, @Content, @DateCreated, @IP, @Actor)";
                cmd.Parameters.AddWithValue("Type", Type);
                cmd.Parameters.AddWithValue("Content", Message);
                cmd.Parameters.AddWithValue("DateCreated", DateTime.Now);
                cmd.Parameters.AddWithValue("IP", SourceIP);
                cmd.Parameters.AddWithValue("Actor", actor);
                cmd.ExecuteNonQuery();
                con.Close();
            }


        }

        public static void WriteBaseUrl(string Url)
        {
            using (SqlConnection con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["sdcdb"].ConnectionString))
            {
                SqlCommand cmd = new SqlCommand();
                con.Open();
                cmd.Connection = con;
                cmd.CommandText = "select count(*) from SDC_Host";
                if (int.Parse(cmd.ExecuteScalar().ToString()) == 0)
                {
                    cmd.CommandText = "insert into SDC_Host(BaseURL) values ('" + Url + "')";
                }
                else
                {
                    cmd.CommandText = "update SDC_Host set BaseURL = '" + Url + "'";
                }
                cmd.ExecuteNonQuery();
                cmd.CommandText = "update sdc_host set FormManagerEndpoint = '" + Url + "/services/FormManager.asmx'";

                con.Close();


            }
        }

        public static void GetLogDetail(int Id, ref string Type, ref DateTime dtCreated, ref string Message)
        {
            using (SqlConnection con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["sdcdb"].ConnectionString))
            {
                SqlCommand cmd = new SqlCommand();
                cmd.CommandText = "select * from sdc_transactions where transactionid = " + Id.ToString();
                con.Open();
                cmd.Connection = con;
                System.Data.DataTable dt = new System.Data.DataTable();
                SqlDataAdapter ad = new SqlDataAdapter();
                ad.SelectCommand = cmd;
                ad.Fill(dt);
                if(dt.Rows.Count>0)
                {
                    Type=dt.Rows[0]["TransactionType"].ToString();
                    dtCreated = DateTime.Parse(dt.Rows[0]["DateCreated"].ToString());
                    Message = dt.Rows[0]["TransactionContent"].ToString();
                }
                con.Close();
            }
        }

        public static void GetHostParamaters(ref string BaseURL, ref string ValidationPath, ref string TransformPath)
        {
            using (SqlConnection con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["sdcdb"].ConnectionString))
            {
                SqlCommand cmd = new SqlCommand();
                cmd.CommandText = "select * from sdc_host";
                con.Open();
                cmd.Connection = con;
                System.Data.DataTable dt = new System.Data.DataTable();
                SqlDataAdapter ad = new SqlDataAdapter();
                ad.SelectCommand = cmd;
                ad.Fill(dt);
                if(dt.Rows.Count>0)
                {
                    BaseURL = dt.Rows[0]["BaseURL"].ToString();
                    ValidationPath = dt.Rows[0]["ValidationFolder"].ToString();
                    TransformPath = dt.Rows[0]["TransformFolder"].ToString();
                }
            }
        }

        public static System.Data.DataTable GetLogData()
        {
            using (SqlConnection con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["sdcdb"].ConnectionString))
            {
                SqlCommand cmd = new SqlCommand();
                cmd.CommandText = "select transactionid, transactiontype, datecreated, sourceip, actor from sdc_transactions order by transactionid desc";
                con.Open();
                cmd.Connection = con;
                System.Data.DataTable dt = new System.Data.DataTable();
                SqlDataAdapter ad = new SqlDataAdapter();
                ad.SelectCommand = cmd;
                ad.Fill(dt);
                return dt;
            }
        }

        public static string GetBaseUrl()
        {
            using (SqlConnection con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["sdcdb"].ConnectionString))
            {
                SqlCommand cmd = new SqlCommand();
                con.Open();
                cmd.Connection = con;
                cmd.CommandText = "select BaseUrl from SDC_Host";
                return cmd.ExecuteScalar().ToString();
            }
        }

        public static string GetdefaultReceivers(string PackageID)
        {
            using (SqlConnection con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["sdcdb"].ConnectionString))
            {
                SqlCommand cmd = new SqlCommand();
                cmd.CommandText = "select default_receiver from sdc_packages where package_id = '" + PackageID + "'";
                cmd.Connection = con;
                con.Open();
                var retval = cmd.ExecuteScalar();
                if(retval!=null)
                {
                    string ids = retval.ToString();
                    string[] receivers = ids.Split(',');
                    string allreceivers = "";
                    foreach(string id in receivers)
                    {
                        allreceivers = allreceivers + "|" + GetReceiverURL(id);
                    }
                    return allreceivers.Substring(1);
                }
                else
                {
                    return "";
                }
            }
        }
    
        public static string GetReceiverURL(string id)
        {
            using (SqlConnection con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["sdcdb"].ConnectionString))
            {
                if(id != "")
                {
                    SqlCommand cmd = new SqlCommand();
                    cmd.CommandText = "select submit_endpoint from sdc_receivers where id = " + id;
                    cmd.Connection = con;
                    con.Open();
                    return cmd.ExecuteScalar().ToString();
                }
                else
                {
                    return "";
                }
                
            }

        }

        public static string GetReceiverName(string id)
        {
            using (SqlConnection con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["sdcdb"].ConnectionString))
            {
                if(id!="")
                {
                    SqlCommand cmd = new SqlCommand();
                    cmd.CommandText = "select name from sdc_receivers where id = " + id;
                    cmd.Connection = con;
                    con.Open();
                    return cmd.ExecuteScalar().ToString();
                }
                else
                {
                    return "";
                }
               
            }

        }

        public static void TruncateTransactions()
        {
            using (SqlConnection con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["sdcdb"].ConnectionString))
            {
                SqlCommand cmd = new SqlCommand();
                cmd.CommandText = "truncate table sdc_transactions";
                cmd.Connection = con;
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }
        }
        public static string GetTransformPath(string packageid)
        {
            using (SqlConnection con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["sdcdb"].ConnectionString))
            {
                SqlCommand cmd = new SqlCommand();
                cmd.CommandText = "select path from sdc_packages a join sdc_transformpath b on a.transform_path = b.id where package_id = '" + packageid + "'"; 
                cmd.Connection = con;
                con.Open();
                var retval = cmd.ExecuteScalar();
                if (retval == null)                    
                {
                    cmd.CommandText = "select transformfolder from sdc_host";
                    retval = cmd.ExecuteScalar();
                }
                    return retval.ToString();

                
            }
        }

        public static string GetValidationPath(string packageid)
        {
            using (SqlConnection con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["sdcdb"].ConnectionString))
            {
                SqlCommand cmd = new SqlCommand();
                cmd.CommandText = "select path from sdc_packages a join sdc_validationpath b on a.validation_path = b.id where package_id = '" + packageid + "'";
                cmd.Connection = con;
                con.Open();
                var retval = cmd.ExecuteScalar();
                if (retval != null)
                    return retval.ToString();
                else
                {
                    cmd.CommandText = "select path from sdc_validationpath where id= (select max(id) from sdc_validationpath)";
                    retval = cmd.ExecuteScalar();
                    return retval.ToString();
                }
                    

                
            }
        }
    }
}