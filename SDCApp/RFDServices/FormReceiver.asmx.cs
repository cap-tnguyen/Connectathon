using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Security.Cryptography.X509Certificates;
using System.Net;
using System.Data.SqlClient;
using System.Web.Services.Protocols;
using System.Xml;
using System.Xml.Xsl;
using System.Web.Services.Description;
using System.Web.Script.Services;
using System.Data;
using System.IO;
using System.Text;
using System.Xml.Schema;
using System.Xml.Linq;
using TraceSoapExtension;

namespace SDC.Services
{
    /// <summary>
    /// Summary description for FormReceiver
    /// </summary>
    [WebService(Namespace = "urn:ihe:iti:rfd:2007")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    //[SoapDocumentService(RoutingStyle = SoapServiceRoutingStyle.RequestElement)]
   public class FormReceiver : System.Web.Services.WebService
    {
        /*Confusion about namespace - so read raw soap 
         * 
         * */
        public SoapUnknownHeader[] unknownHeaders;
        string requestUrl = "";
        string validationerror = "";
        [WebMethod(EnableSession = true), SoapHeader("unknownHeaders")]
        //[SoapDocumentMethod(Action = "urn:ihe:iti:rfd:2007:SubmitFormRequest", ResponseElementName = "SubmitFormResponse", RequestNamespace = "urn:ihe:iti:rfd:2007")]
        //public void SubmitFormRequest(XmlElement FormDesign)
        public void SubmitFormRequest()
        {
            foreach (SoapUnknownHeader header in unknownHeaders)
            {
                header.DidUnderstand = true;
            }

            requestUrl = HttpContext.Current.Request.Url.AbsoluteUri;
            TraceSoapExtension.SDCExtension.TraceSoapExtension.ResponseWriter = "";
            TraceSoapExtension.SDCExtension.TraceSoapExtension.ReturnMessage = "";
            bool validating = false;
            using (Stream instream = HttpContext.Current.Request.InputStream)
            {
                instream.Position = 0;
                string xml = "";
                using (StreamReader readStream = new StreamReader(instream, Encoding.UTF8))
                {
                    xml = readStream.ReadToEnd();
                }

               

                string ip = HttpContext.Current.Request.UserHostAddress;

                DBHelper.WriteTransactionLog("SubmitFormRequest", xml, "FR", "Src - " + HttpContext.Current.Request.UserHostAddress);
              
                    try
                    {
                        XmlDocument xdoc = new XmlDocument();
                        xdoc.LoadXml(xml);

                        XmlNamespaceManager mgr = new XmlNamespaceManager(xdoc.NameTable);
                        mgr.AddNamespace("urn", "urn:ihe:iti:rfd:2007");
                        mgr.AddNamespace("sdc", "urn:ihe:qrph:sdc:2016");
                        mgr.AddNamespace("soapenv", "http://schemas.xmlsoap.org/soap/envelope/");
                        mgr.AddNamespace("xsi", "http://www.w3.org/2001/XMLSchema-instance");
                        mgr.AddNamespace("def", "");
                      
                        //get the FormDesign element
                        XmlNode xNode = xdoc.SelectSingleNode("//sdc:SDCSubmissionPackage", mgr);

                        if (xNode != null)
                        {
                            xml = xNode.OuterXml;
                        }
                        else
                        {
                            //TraceSoapExtension.SDCExtension.TraceSoapExtension.ReturnMessage = CreateSubmitResponse("Fault:" + "Submitted form was not in the expected format. Could there be a namespace problem? FormDesign element is expected in the urn:ihe:qrph:sdc:2016 namespace.");
                            throw new SoapException("Could not find the SDCPackage element. SDCPackage element is expected in the urn:ihe:qrph:sdc:2016 namespace.", SoapException.ClientFaultCode);
                          
                        }


                        MemoryStream memStream = new MemoryStream();
                        StreamWriter writer = new StreamWriter(memStream);
                        writer.Write(xml);
                        writer.Flush();
                        memStream.Position = 0;

                   
                        XmlReaderSettings settings = new XmlReaderSettings();
                        settings.ValidationType = ValidationType.Schema;
                        settings.DtdProcessing = DtdProcessing.Prohibit;
                        
                        //settings.Schemas.Add("urn:ihe:qrph:sdc:2016", "https://raw.githubusercontent.com/esacinc/sdc-schema-package/master/schema/sdc/SDCSubmitForm.xsd");
                        //how do we know if the submitted form is in the new format or the old
                        //settings.Schemas.Add("urn:ihe:qrph:sdc:2016", Server.MapPath("NewSchema/SDCSubmitForm.xsd"));
                        string baseurl="";
                        string validationpath = "";
                        string transformpath = "";

                        DBHelper.GetHostParamaters(ref baseurl, ref validationpath, ref transformpath);
                        settings.Schemas.Add("urn:ihe:qrph:sdc:2016", Server.MapPath(validationpath + "/SDCSubmitForm.xsd"));
                       
                        XmlReader reader = XmlReader.Create(memStream, settings);

                        validating = true;
                        xdoc.Load(reader);


                        ValidationEventHandler eventHandler = new ValidationEventHandler(ValidationEventHandler);
                        xdoc.Validate(ValidationEventHandler);
                    }
                   catch(SoapException ex)
                    {
                        if (validating)
                        {
                            insertResponse(xml, ip, false, ex.Message);
                        }
                        TraceSoapExtension.SDCExtension.TraceSoapExtension.ReturnMessage = "fault";
                        throw ex;
                      
                    }
                    catch (Exception ex)
                    {
                        if (validating)
                        {
                            insertResponse(xml, ip, false, ex.Message);
                        }

                        TraceSoapExtension.SDCExtension.TraceSoapExtension.ReturnMessage = "fault";
                        throw ex;
                    }
               
                insertResponse(xml, ip,true, "Form validated");
                TraceSoapExtension.SDCExtension.TraceSoapExtension.ReturnMessage = CreateSubmitResponse("Submitted form validated successfully.");
                
            }
               
        }

        private void GetFormNameAndId(string xml, ref string form_name, ref string form_id  )
        {
             XmlDocument xdoc = new XmlDocument();
             XmlNamespaceManager mgr = new XmlNamespaceManager(xdoc.NameTable);
             
             mgr.AddNamespace("urn", "urn:ihe:iti:rfd:2007");
             mgr.AddNamespace("sdc", "urn:ihe:qrph:sdc:2016");
             mgr.AddNamespace("soapenv", "http://www.w3.org/2003/05/soap-envelope");
             mgr.AddNamespace("xsi", "http://www.w3.org/2001/XMLSchema-instance");
             mgr.AddNamespace("def", "");
              
            xdoc.LoadXml(xml);

            XmlNode xNode = xdoc.SelectSingleNode("//sdc:FormDesign/@ID", mgr);
            if(xNode!=null)
            {
                form_id = xNode.InnerText;
            }
                    
            xNode = xdoc.SelectSingleNode("//sdc:FormDesign/@formTitle", mgr);
            if (xNode != null)
            {
                form_name = xNode.InnerText;
            }

                
        }

        private void insertResponse(string xml, string ip, bool validated, string message)
        {
            using (SqlConnection con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["sdcdb"].ConnectionString))
            {
                string form_id = "";
                string form_name = "";
                GetFormNameAndId(xml, ref form_name, ref form_id);
                SqlCommand cmd = new SqlCommand("insert into sdc_submits (submit_form, submit_time, ip_address, validated, message, formname, formid) values (@submit_form, @submit_time, @ip_address, @validated, @message, @formname, @formid)");
                cmd.Connection = con;
                cmd.Parameters.AddWithValue("submit_form", xml);
                cmd.Parameters.AddWithValue("submit_time", DateTime.Now);
                cmd.Parameters.AddWithValue("ip_address", ip);
                cmd.Parameters.AddWithValue("validated", validated);
                cmd.Parameters.AddWithValue("message", message);
                cmd.Parameters.AddWithValue("formname", form_name);
                cmd.Parameters.AddWithValue("formid", form_id);

                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }
        }

        void ValidationEventHandler(object sender, ValidationEventArgs e)
        {
            switch (e.Severity)
            {
                case XmlSeverityType.Error:
                    validationerror = validationerror + "\n\r Error: " + e.Message;
                    
                    break;
                case XmlSeverityType.Warning:
                    validationerror = validationerror + "\n\r Warning: " + e.Message;
                   
                    break;
            }

        }

       

        private string CreateSubmitResponse(string msg)
        {
            XNamespace ns1 = "http://www.w3.org/2003/05/soap-envelope";
            XNamespace ns2 = "http://www.w3.org/2005/08/addressing";
            XNamespace ns3 = "urn:ihe:iti:rfd:2007";
            string msgId = Guid.NewGuid().ToString();
            XElement response = new XElement(ns1+"Envelope", new XAttribute(XNamespace.Xmlns + "soap", ns1)
                , new XAttribute(XNamespace.Xmlns + "wsa", ns2),
                new XElement(ns1 + "Header",
                    new XElement(ns2 + "To", new XText(requestUrl)),
                    new XElement(ns2 + "MessageID", new XText("urn:uuid:" + msgId)),
                    new XElement(ns2 + "Action", new XAttribute(ns1 + "mustUnderstand", "1"), new XText("urn:ihe:iti:rfd:2007:SubmitFormResponse"))),
                    new XElement(ns1 + "Body", new XElement(ns3+"SubmitFormResponse",new XText(msg))));
            string retval = response.ToString();

            DBHelper.WriteTransactionLog("SubmitFormResponse", retval, "FR", "Src - " + HttpContext.Current.Request.UserHostAddress);
            
            return retval;
        }

        private string CreateFaultResponse(string msg)
        {
            XNamespace ns1 = "http://www.w3.org/2003/05/soap-envelope";
            XNamespace ns2 = "http://www.w3.org/2005/08/addressing";
            XNamespace ns3 = "urn:ihe:iti:rfd:2007";
            string msgId = Guid.NewGuid().ToString();
            XElement response = new XElement("Envelope", new XAttribute(XNamespace.Xmlns + "soap", ns1)
                , new XAttribute(XNamespace.Xmlns + "wsa", ns2),
                new XElement(ns1 + "Header",
                    new XElement(ns2 + "To", new XText(requestUrl)),
                    new XElement(ns2 + "MessageID", new XText("urn:uuid:" + msgId)),
                    new XElement(ns2 + "Action", new XAttribute(ns1 + "mustUnderstand", "1"), new XText("urn:ihe:iti:rfd:2007:SubmitFormResponse"))),
                    new XElement(ns1 + "Body", new XElement(ns3 + "faultSubmitFormResponse", new XText(msg))));
            string retval = response.ToString();
            //XmlHelper.FormatXML(retval);
            return retval;
        }

       
    }
}
