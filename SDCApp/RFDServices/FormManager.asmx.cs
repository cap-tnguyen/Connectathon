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
using System.Xml.Schema;
using System.Xml.Linq;
using System.Xml.Serialization;
using HtmlAgilityPack;
using System.ServiceModel.Web;
using System.IO;
using System.Text;

namespace SDC.Services
{
    /// <summary>
    /// Summary description for FormManager
    /// </summary>
    [WebService(Namespace = "urn:ihe:iti:rfd:2007")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class FormManager : System.Web.Services.WebService
    {
        
        public SoapUnknownHeader[] unknownHeaders;
        [WebMethod(EnableSession=true), SoapHeader("unknownHeaders")]
        [SoapDocumentMethod(Action = "RetrieveFormRequest",RequestNamespace="urn:ihe:iti:rfd:2007")]
        public string RetrieveFormRequest(XmlElement prepopData, 
          [XmlAnyElement]   XmlElement workflowData )
        {

            //get the raw soap request
                        
            XmlDocument xmlSoapRequest = new XmlDocument();
            using (Stream receiveStream = HttpContext.Current.Request.InputStream)
            {
                // Move to begining of input stream and read
                receiveStream.Position = 0;
                using (StreamReader readStream =
                                       new StreamReader(receiveStream, Encoding.UTF8))
                {
                    // Load into XML document
                    xmlSoapRequest.Load(readStream);
                }
            }

            string ip = HttpContext.Current.Request.UserHostAddress;
            
            
            //unpack request
            foreach (SoapUnknownHeader header in unknownHeaders)
            {
                header.DidUnderstand = true;
            }

            
            XmlDocument xRequest = new XmlDocument();
            XmlNamespaceManager reqmgr = new XmlNamespaceManager(xRequest.NameTable);
            reqmgr.AddNamespace("urn", "urn:ihe:iti:rfd:2007");
            reqmgr.AddNamespace("sdc", "urn:ihe:qrph:sdc:2016");
            reqmgr.AddNamespace("soapenv", "http://www.w3.org/2003/05/soap-envelope");
            reqmgr.AddNamespace("xsi", "http://www.w3.org/2001/XMLSchema-instance");
            xRequest.LoadXml(workflowData.OuterXml);
            string packageid = xRequest.SelectSingleNode("//urn:formID", reqmgr).InnerText;
            string format = "";
            XmlNode instance = xRequest.SelectSingleNode("//urn:instanceID", reqmgr);
            string instanceId = "";
            if (instance != null)
                instanceId = instance.InnerText;

            XmlNode xEncodedResponse = xRequest.SelectSingleNode("//urn:encodedResponse", reqmgr);

           
            
            string replyto = HttpContext.Current.Request.UserHostAddress;
            string prepop = "";
            int trace = 0;
            //is prepop data available?
            
            if (prepopData!=null && prepopData.OuterXml != "")
            {
                prepop = prepopData.OuterXml;
              

            }
            trace = 1;
            if(xEncodedResponse.Attributes["responseContentType"]!=null)
            {
                 format = xEncodedResponse.Attributes["responseContentType"].Value;


            }

            //write to transaction log
            DBHelper.WriteTransactionLog("RetrieveFormRequest, format=" + format, xmlSoapRequest.OuterXml, "FM", "Src - " + HttpContext.Current.Request.UserHostAddress);
            trace = 2;
            //get xml of form from the db
            string xmlpackage = GetXMLContent(packageid);
            trace = 3;
            if (xmlpackage.Length == 0)
            {
                string fault = @"<Code>
                                    <Value>Receiver</Value>
                                 </Code>
                                <Reason>
                                    <Text xml:lang='en-US'>Error: " + "PackageID = " + packageid + " not found." + @"</Text>
                                </Reason>
                            ";
                TraceSoapExtension.SDCExtension.TraceSoapExtension.ResponseWriter = "CreateRetrieveFault";
                TraceSoapExtension.SDCExtension.TraceSoapExtension.ReturnMessage = fault;
                return "Success";
            }

            trace = 4;
            //if response type is url, create urn response and return 
            if(xEncodedResponse.InnerText=="false")
            {    
                string uri = GetUri(packageid);
                uri = Server.UrlEncode(uri);
                TraceSoapExtension.SDCExtension.TraceSoapExtension.ResponseWriter = "";
                TraceSoapExtension.SDCExtension.TraceSoapExtension.ReturnMessage = CreateRetrieveResponse(uri, "uri", packageid, prepop, xmlpackage, replyto, instanceId);
                return "Success";               
            }
            else if (format == "text/html+sdc")
                {
                    try
                    {
                        //create html on the fly
                        xmlpackage = Prepop(xmlpackage, prepop, instanceId);
                        string html = CreateHTMLForm(xmlpackage,
                            DBHelper.GetdefaultReceivers(packageid),
                            DBHelper.GetTransformPath(packageid));

                        html = Base64Encode(html);
                        
                        TraceSoapExtension.SDCExtension.TraceSoapExtension.ResponseWriter = "";


                        TraceSoapExtension.SDCExtension.TraceSoapExtension.ReturnMessage = CreateRetrieveResponse(html, "html", packageid, prepop, xmlpackage, replyto, instanceId);
                        Context.Response.StatusCode = 200;
                        return "Success";
                    }
                    catch (Exception ex)
                    {
                        string fault = @"<Code>
                                    <Value>Receiver</Value>
                                 </Code>
                                <Reason>
                                    <Text xml:lang='en-US'>Error: " + ex.Message + ", trace= " + trace + @"</Text>
                                </Reason>
                            ";
                        TraceSoapExtension.SDCExtension.TraceSoapExtension.ResponseWriter = "CreateRetrieveFault";
                        TraceSoapExtension.SDCExtension.TraceSoapExtension.ReturnMessage = fault;
                        return "Success";
                    }

                }
            
            else if (format=="application/xml+sdc")
            {
                XmlDocument xResponse = new XmlDocument();

                xmlpackage = Prepop(xmlpackage, prepop, instanceId);
                xResponse.LoadXml(xmlpackage);
                XmlNamespaceManager mgr = new XmlNamespaceManager(xResponse.NameTable);
                mgr.AddNamespace("urn", "urn:ihe:iti:rfd:2007");
                mgr.AddNamespace("sdc", "urn:ihe:qrph:sdc:2016");
                mgr.AddNamespace("soapenv", "http://www.w3.org/2003/05/soap-envelope");
                mgr.AddNamespace("xsi", "http://www.w3.org/2001/XMLSchema-instance");

                //ADD instance id, destinations, etc if 


                //get formdesign element and add instance attributes
                XmlNode xNode = xResponse.SelectSingleNode("//sdc:FormDesign", mgr);
                if (xNode.Attributes["formInstanceURI"] != null)
                {
                    xNode.Attributes.Remove(xNode.Attributes["formInstanceURI"]);

                }

                if (xNode.Attributes["formInstanceVersionURI"] != null)
                {
                    xNode.Attributes.Remove(xNode.Attributes["formInstanceURI"]);

                }

                if (xNode.Attributes["formPreviousInstanceVersionURI"] != null)
                {
                    xNode.Attributes.Remove(xNode.Attributes["formPreviousInstanceVersionURI"]);

                }

                Guid g;
                g = Guid.NewGuid();
                XmlAttribute att = xResponse.CreateAttribute("formInstanceURI");
                att.Value = g.ToString();
                xNode.Attributes.Append(att);

                string instanceid = xNode.Attributes["formInstanceURI"].Value;
                att = xResponse.CreateAttribute("formInstanceVersionURI");
                att.Value = instanceid + "/ver1";
                xNode.Attributes.Append(att);

                XmlNode package = xResponse.SelectSingleNode("//sdc:SDCPackage", mgr);
                xmlpackage = package.OuterXml;
                

                TraceSoapExtension.SDCExtension.TraceSoapExtension.ResponseWriter = "";
                TraceSoapExtension.SDCExtension.TraceSoapExtension.ReturnMessage = CreateRetrieveResponse(xmlpackage, "xml", packageid, prepop, xmlpackage, replyto, instanceId);
                Context.Response.StatusCode = 200;
                
            }
            else
            {
                string fault = @"<Code>
                                    <Value>Receiver</Value>
                                 </Code>
                                <Reason>
                                    <Text xml:lang='en-US'>Error: Unknown format</Text>
                                </Reason>
                            ";
                TraceSoapExtension.SDCExtension.TraceSoapExtension.ResponseWriter = "CreateRetrieveFault";
                TraceSoapExtension.SDCExtension.TraceSoapExtension.ReturnMessage = fault;
                return "Success";
            }
            
            
            
            return "Success";
        }

        
        [WebMethod(EnableSession = true), SoapHeader("unknownHeaders")]
        public string GetReceiverUrls(string receiverids)
        {
            if (receiverids == "")
                return "";
            using (SqlConnection con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["sdcdb"].ConnectionString))
            {

                SqlCommand cmd = new SqlCommand(@"select submit_endpoint from sdc_receivers where id in (" + receiverids + ")");
                string urls = "";
                cmd.Connection = con;
                con.Open();
                DataTable dt = new DataTable();
                SqlDataAdapter ad = new SqlDataAdapter();
                ad.SelectCommand = cmd;
                ad.Fill(dt);
                foreach(DataRow dr in dt.Rows)
                {
                    urls = urls + "|" + dr[0].ToString();
                }
                
                con.Close();
                return urls.Substring(1);

            }
        }

       //[WebMethod(EnableSession = true), SoapHeader("unknownHeaders")]
       // public string GetFormHtml(string MessageId)
       // {
       //     using (SqlConnection con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["sdcdb"].ConnectionString))
       //     {
       //         SqlCommand cmd = new SqlCommand(@"select form from SDC_FormRequestsQ where TransactionID = '" + MessageId + "'");
       //         cmd.Connection = con;
       //         con.Open();
       //         string retval = cmd.ExecuteScalar().ToString();
       //         con.Close();
       //         return retval;
                
       //     }
       // }

        public string GetHtml(string transform_path, string xml)
        {
            
            string xsltPath = Server.MapPath(transform_path) + "\\sdctemplate.xslt";
            string csspath = Server.MapPath(transform_path) + "\\sdctemplate.css";
            //3/10/2016 - change encoding to unicode 
            System.IO.MemoryStream stream = new System.IO.MemoryStream(System.Text.UnicodeEncoding.ASCII.GetBytes(xml));
            System.Xml.XPath.XPathDocument document = new System.Xml.XPath.XPathDocument(stream);
            System.IO.StringWriter writer = new System.IO.StringWriter();
            System.Xml.Xsl.XslCompiledTransform transform = new System.Xml.Xsl.XslCompiledTransform();

            System.Xml.Xsl.XsltSettings settings = new System.Xml.Xsl.XsltSettings(true, true);

            System.Xml.XmlSecureResolver resolver = new System.Xml.XmlSecureResolver(new System.Xml.XmlUrlResolver(), csspath);
            try
            {
                transform.Load(xsltPath, settings, resolver);
                transform.Transform(document, null, writer);
            }
            catch (Exception ex)
            {
                return "";
            }

            //now header

            return writer.ToString();
        }

        private string GetXMLContent(string packageid)
        {
            using (SqlConnection con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["sdcdb"].ConnectionString))
            {
                SqlCommand cmd = new SqlCommand("select package_content from sdc_packages where package_id = '" + packageid + "'");
                cmd.Connection = con;
                SqlDataAdapter ad = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                ad.Fill(dt);
                if (dt.Rows.Count == 1)
                {
                    string xml = dt.Rows[0][0].ToString();
                    return xml;

                }

            }
            return "";
        }

        //private string GetHTMLContent(string packageid)
        //{
        //    using (SqlConnection con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["sdcdb"].ConnectionString))
        //    {
        //        SqlCommand cmd = new SqlCommand("select html_content from sdc_packages where package_id = '" + packageid + "'");
        //        cmd.Connection = con;
        //        SqlDataAdapter ad = new SqlDataAdapter(cmd);
        //        DataTable dt = new DataTable();
        //        ad.Fill(dt);
        //        if (dt.Rows.Count == 1)
        //        {
        //            string xml = dt.Rows[0][0].ToString();
        //            return xml;

        //        }

        //    }
        //    return "";
        //}

//        private List<SDCForm> GetForms(string packageid)
//        {
//            using (SqlConnection con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["sdcdb"].ConnectionString))
//            {
//                SqlCommand cmd = new SqlCommand(@"select a.form_id, form_type, form_name from sdc_package_forms a 
//                                    join sdc_forms b on a.form_id = b.form_id where package_id = '" + packageid + "'");
//                cmd.Connection = con;
//                SqlDataAdapter ad = new SqlDataAdapter(cmd);
//                DataTable dt = new DataTable();
//                ad.Fill(dt);
//                List<SDCForm> forms = new List<SDCForm>();

//                foreach (DataRow dr in dt.Rows)
//                {
//                    SDCForm form = new SDCForm();
//                    form.FormID = dr["form_id"].ToString();
//                    form.FormName = dr["form_name"].ToString();
//                    form.FormType = dr["form_type"].ToString();
//                    forms.Add(form);
//                }
//                return forms;
//            }
//        }

        private string GetUri(string packageid)
        {

            //return formmanager address
            return Server.MapPath("UriRequestHandler.aspx");
          
        }


        
      
        private string CreateRetrieveResponse(string msg, string format, string packageid, string prepop, string formxml, string replyto, string instanceId)
        {          
            
           string html = "";
           string retval = "";
           int trace = 0;
           try
           {
               replyto = "fsahfhaskjfha";
               html = GenerateForm(formxml, prepop, format, packageid, instanceId);
               trace = 1;

               string MessageId = Guid.NewGuid().ToString().ToLower();
               SaveFormInQ(formxml, html, MessageId, replyto, packageid);
               trace = 2;
               XNamespace ns1 = "http://www.w3.org/2003/05/soap-envelope";
               XNamespace ns2 = "http://www.w3.org/2005/08/addressing";
               XNamespace ns3 = "urn:ihe:iti:rfd:2007";
               XNamespace ns4 = "urn:ihe:qrph:sdc:2016";

               trace = 3;
               if (format == "uri")
               {
                   //string url = HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Path);
                   //url = url.Substring(0, url.LastIndexOf("/")) + "/UriRequestHandler.aspx";
                  
                   msg = GetFormlistEndpoint() + "API/Forms/" + MessageId;
                   //msg = "https://pappsnodts04.cap.org/SDCWebAPI/API/Forms/" + MessageId;
               }

               XElement response = null;
               if (format == "xml")
               {

                   response = new XElement(ns1 + "Envelope", new XAttribute(XNamespace.Xmlns + "soap", ns1)
                , new XAttribute(XNamespace.Xmlns + "wsa", ns2),
                new XElement(ns1 + "Header",
                    //new XElement(ns2 + "To", new XText(replyto)),
                       //new XElement(ns2 + "MessageID", new XText("urn:uuid:6d39ebfe-2db4-4ea9-b6f6-06c7962f6050")),
                    new XElement(ns2 + "MessageID", new XText("urn:uuid:" + MessageId)),
                    new XElement(ns2 + "Action", new XAttribute(ns1 + "mustUnderstand", "1"), new XText("urn:ihe:iti:rfd:2007:RetrieveFormResponse"))),
                    new XElement(ns1 + "Body", new XElement(ns3 + "RetrieveFormResponse",
                        new XElement(ns3 + "form", new XElement(ns3 + "Structured", new XText("|msg|"))),
                        new XElement(ns3 + "contentType", new XText("application/xml+sdc")),
                        new XElement(ns3 + "responseCode", new XText("Request succeeded")))));


               }
               else if (format == "html")
               {


                   response = new XElement(ns1 + "Envelope", new XAttribute(XNamespace.Xmlns + "soap", ns1)
                , new XAttribute(XNamespace.Xmlns + "wsa", ns2),
                new XElement(ns1 + "Header",
                       //new XElement(ns2 + "To", new XText("")),
                       //new XElement(ns2 + "MessageID", new XText("urn:uuid:6d39ebfe-2db4-4ea9-b6f6-06c7962f6050")),
                    new XElement(ns2 + "MessageID", new XText("urn:uuid:" + MessageId)),
                    new XElement(ns2 + "Action", new XAttribute(ns1 + "mustUnderstand", "1"), new XText("urn:ihe:iti:rfd:2007:RetrieveFormResponse"))),
                    new XElement(ns1 + "Body", new XElement(ns3 + "RetrieveFormResponse",
                        new XElement(ns3 + "form", new XElement(ns3 + "Structured",
                            new XElement(ns4 + "SDCPackage", new XAttribute("packageID", packageid),
                            new XElement(ns4 + "HTMLPackage", new XText("|msg|"))))),
                            new XElement(ns3 + "contentType", new XText("text/html+sdc")),
                            new XElement(ns3 + "responseCode", new XText("Request succeded")))));
               }
               else if (format == "uri")
               {

                   response = new XElement(ns1 + "Envelope", new XAttribute(XNamespace.Xmlns + "soap", ns1)
                , new XAttribute(XNamespace.Xmlns + "wsa", ns2),
                new XElement(ns1 + "Header",
                       //new XElement(ns2 + "To", new XText(replyto)),
                       //new XElement(ns2 + "MessageID", new XText("urn:uuid:6d39ebfe-2db4-4ea9-b6f6-06c7962f6050")),
                    new XElement(ns2 + "MessageID", new XText("urn:uuid:" + MessageId)),
                    new XElement(ns2 + "Action", new XAttribute(ns1 + "mustUnderstand", "1"), new XText("urn:ihe:iti:rfd:2007:RetrieveFormResponse"))),
                    new XElement(ns1 + "Body", new XElement(ns3 + "RetrieveFormResponse",
                        new XElement(ns3 + "form", new XElement(ns3 + "URL", new XText("|msg|"))),
                        new XElement(ns3 + "contentType", new XText("URL")),
                        new XElement(ns3 + "responseCode", new XText("Request succeeded")))));
               }
               
               retval = response.ToString();
               retval = retval.Replace("|msg|", "\r\n" + msg);



               if (format == "xml")
                   XmlHelper.FormatXML(retval);


               //write to transaction table
               DBHelper.WriteTransactionLog("RetrieveFormResponse, format=" + format, retval, "FM", "Src - " + HttpContext.Current.Request.UserHostAddress);
           }
            catch(Exception ex)
           {
               string fault = @"<Code>
                                    <Value>Receiver</Value>
                                 </Code>
                                <Reason>
                                    <Text xml:lang='en-US'>Error: " + ex.Message + ", Trace=" + trace + @"</Text>
                                </Reason>
                            ";
               TraceSoapExtension.SDCExtension.TraceSoapExtension.ResponseWriter = "CreateRetrieveFault";
               TraceSoapExtension.SDCExtension.TraceSoapExtension.ReturnMessage = fault;
               return "Success";
           }
           

            return retval;
        }

        private string GetFormlistEndpoint()
        {
            using (SqlConnection con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["sdcdb"].ConnectionString))
            {
                SqlCommand cmd = new SqlCommand();
                con.Open();
                cmd.Connection = con;

                cmd.CommandText = "select WebAPIBaseUri FROM SDC_host";

                string baseuri = cmd.ExecuteScalar().ToString();


                con.Close();
                return baseuri;

            }
        }

        private string GenerateForm(string xml, string prepop, string format, string packageid, string instanceId)
        {
            //parse prepop
            try
            {
                xml = Prepop(xml, prepop, instanceId);

                //if the format in xml we are done
                if (format == "xml")
                    return xml;

                //generate html form - receivers are fixed (written to a textbox) and transform
                string html = CreateHTMLForm(xml, DBHelper.GetdefaultReceivers(packageid), DBHelper.GetTransformPath(packageid));

                return html;
            }
            catch(Exception ex)
            {
                throw new Exception("GenerateForm: " + ex.Message);
            }
        }

        private string Prepop(string xml, string prepop, string instanceId)
        {
            if (xml == "")
                return "";
            XmlDocument xmlpackage = new XmlDocument();
            xmlpackage.LoadXml(xml);

            //manipulate prepop here to add <InstanceId xmlns="urn:hl7-org:v3">Instance Id: 123456</InstanceId>
            
            if (prepop == "")
            {
                if(instanceId=="")
                {
                    return xml;
                }
                else
                {
                    prepop = @"<InstanceId xmlns=""urn:hl7-org:v3"">" + instanceId + "</InstanceId>";
                }
            }
                

            XmlDocument cda = new XmlDocument();
            cda.LoadXml(prepop);

            //find elements to prepop
            XmlNamespaceManager cdans = new XmlNamespaceManager(cda.NameTable);
            cdans.AddNamespace("urn", "urn:hl7-org:v3");
            cdans.AddNamespace("xsi", "http://www.w3.org/2001/XMLSchema-instance");
            cdans.AddNamespace("rfd", "urn:ihe:iti:rfd:2007");
            cdans.AddNamespace("sdtc", "urn:hl7-org:sdtc");
            cdans.AddNamespace("fn", " http://www.w3.org/2005/xpath-functions");

            XmlNamespaceManager packagemgr = new XmlNamespaceManager(xmlpackage.NameTable);
            packagemgr.AddNamespace("urn", "urn:ihe:iti:rfd:2007");
            packagemgr.AddNamespace("sdc", "urn:ihe:qrph:sdc:2016");
            packagemgr.AddNamespace("soapenv", "http://www.w3.org/2003/05/soap-envelope");
            packagemgr.AddNamespace("xsi", "http://www.w3.org/2001/XMLSchema-instance");

            try
            {
                using (SqlConnection con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["sdcdb"].ConnectionString))
                {
                    SqlCommand cmd = new SqlCommand(@"select * from sdc_prepopmap", con);
                    DataTable dt = new DataTable();
                    SqlDataAdapter ad = new SqlDataAdapter();
                    ad.SelectCommand = cmd;
                    ad.Fill(dt);
                    foreach (DataRow dr in dt.Rows)
                    {
                        
                        string xpath = dr["cdapath"].ToString().Replace("\r\n", "");
                        if(xpath=="InstanceId")
                        {
                            int c = 0;
                        }
                        decimal ckey = decimal.Parse(dr["sdcid"].ToString());
                        xpath = DecorateXPathWithNameSpace(xpath, "urn");
                        XmlNodeList xNodeList = cda.SelectNodes(xpath, cdans);
                        if (xNodeList.Count > 0)
                        {
                            xpath = @"//*[@ID='" + ckey.ToString() + "']";

                            //find it in xmlpackage
                            XmlNode xNode = xmlpackage.SelectSingleNode(xpath, packagemgr);
                            if (xNode != null)
                            {
                                string value = xNodeList[0].InnerText;
                                if (xNode.LocalName == "ListItem")
                                {
                                    XmlAttribute attr = xmlpackage.CreateAttribute("selected");
                                    attr.Value = "true";
                                    xNode.Attributes.Append(attr);

                                }
                                else if (xNode.LocalName == "DisplayedItem")
                                {
                                    xNode.Attributes["title"].Value = value;
                                }
                                else//free response
                                {
                                    XmlNode xValue = xNode.SelectSingleNode("sdc:ResponseField/sdc:Response/sdc:string", packagemgr);
                                    if (xValue != null) //string
                                    {
                                        XmlAttribute attr = xmlpackage.CreateAttribute("val");
                                        attr.Value = value;
                                        xValue.Attributes.Append(attr);
                                    }
                                    else
                                    {
                                        xValue = xNode.SelectSingleNode("sdc:ResponseField/sdc:Response/sdc:integer", packagemgr);
                                        if (xValue != null)  //integer
                                        {
                                            XmlAttribute attr = xmlpackage.CreateAttribute("val");
                                            attr.Value = value;
                                            xValue.Attributes.Append(attr);
                                        }
                                    }

                                }
                            }
                        }
                    }

                }
            }
            catch(Exception ex)
            {
                throw new Exception("Error in Prepop: " + ex.Message);
            }
            
           



            return xmlpackage.OuterXml;
        }

        private void SaveFormInQ(string xml, string html, string messageid, string replyto, string packageid)
        {

            //packageid = Server.UrlDecode(packageid);
            using (SqlConnection con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["sdcdb"].ConnectionString))
            {
                SqlCommand cmd = new SqlCommand(@"insert into SDC_FormRequestsQ (TransactionID, PackageID, Requestor, xml, html, DateCreated) values (@TransactionID, @PackageID, @Requestor, @Xml, @Html, @DateCreated)");
                cmd.Connection = con;
                con.Open();

                cmd.Parameters.AddWithValue("TransactionID", messageid);
                cmd.Parameters.AddWithValue("PackageID", packageid);
                cmd.Parameters.AddWithValue("Requestor", replyto);
                cmd.Parameters.AddWithValue("Xml", xml);
                cmd.Parameters.AddWithValue("Html", html);
                cmd.Parameters.AddWithValue("DateCreated", DateTime.Now);

                cmd.ExecuteNonQuery();
                con.Close();

                cmd.Dispose();

            }
        }

        

        private string CreateHTMLForm(string xmlpackage, string receivers, string transformpath)
        {
            //create starter html by applying xslt
            string html = GetHtml("Transforms/" + transformpath, xmlpackage);

            int trace = 0;
            //now add new html elements to it.

            try
            {
                
                var doc = new HtmlDocument();

                trace = 1;
                doc.LoadHtml(html);
                trace = 2;
                HtmlNode cssnode = doc.DocumentNode.SelectSingleNode("html/head/link[@rel='stylesheet']");
                if (cssnode != null)
                    cssnode.Remove();
                trace = 3;
                HtmlNode scriptnode = doc.DocumentNode.SelectSingleNode("html/head/script");
                //replace local css reference with CAP server reference
                trace = 4;
                string csslink = "<link rel='stylesheet' href='" + DBHelper.GetBaseUrl() + "Transforms/working/sdctemplate.css' type='text/css'>";
                trace = 5;
                var cssdoc = new HtmlDocument();
                cssdoc.LoadHtml(csslink);
                doc.DocumentNode.SelectSingleNode("html/head")
                    .InsertAfter(cssdoc.DocumentNode,scriptnode);
                trace = 6;
                //create a div and add elements for debugging

                string parameterhtml = @"<div id='parameters' style='margin-top:50px;padding:8px;border:dashed thick blue'>
                            <button id='btnParameters'>Show/Hide Parameters</button>
                            <table id='options'>
                                <tr>
                                    <td title='Use pipes (|) to separate multiple urls'>Submit URL(s):</td>
                                    <td><input style='width:100%' type='text' id='submiturl' value='" + receivers + @"'/></td>
                                </tr>
                                <tr>
                                    <td colspan='2'><input type='checkbox' id='scriptsubmit' checked/>Use JavaScript Submit</td>
                                </tr>
                                <tr>
                                    <td title='Populated after you hit Submit'>Submit Soap:</td>
                                    <td><textarea cols='180' rows='10' id='submitsoap'/></td>
                                </tr>
                                <tr>
                                    <td title='This XML is used to generate HTML form, and is updated with your responses before submitting to receivers.'>XML Packet</td>
                                    <td><textarea cols='180' rows='10' id='rawxml'>"
                                    + System.Security.SecurityElement.Escape(xmlpackage)
                                    + @"</textarea></td>
                                </tr>
                               
                          
                            </table></div>";
                trace = 7;
                HtmlDocument parametersdoc = new HtmlDocument();
                parametersdoc.LoadHtml(parameterhtml);
                trace = 8;
                /*
                HtmlNode parameters = doc.CreateElement("div");
                HtmlAttribute id = doc.CreateAttribute("Id","parameters");


                HtmlNode node = doc.CreateElement("textarea");
                HtmlAttribute attr = doc.CreateAttribute("Id", "rawxml");
                node.Attributes.Add(attr);
                attr = doc.CreateAttribute("cols", "200");
                node.Attributes.Add(attr);
                attr = doc.CreateAttribute("rows", "10");
                node.Attributes.Add(attr);
                attr = doc.CreateAttribute("style", "display:none");
                node.Attributes.Add(attr);
                //escape xml
                xmlpackage = System.Security.SecurityElement.Escape(xmlpackage);

                HtmlTextNode text = doc.CreateTextNode( xmlpackage);
                node.AppendChild(text);


                HtmlNode submiturllabel = doc.CreateTextNode("Submit Url:");
                HtmlNode submitsoaplabel = doc.CreateTextNode("<br/>Submit Soap:");
                HtmlNode rawxmllabel = doc.CreateTextNode("Raw XML:");
                HtmlNode script = doc.CreateTextNode("Use JavaScript to submit");

                HtmlNode urlnode = doc.CreateElement("input");
                attr = doc.CreateAttribute("type", "text");
                urlnode.Attributes.Add(attr);
                attr = doc.CreateAttribute("id", "submiturl");
                urlnode.Attributes.Add(attr);
                attr = doc.CreateAttribute("value", receivers);
                urlnode.Attributes.Add(attr);
                attr = doc.CreateAttribute("style", "width:400px;background-color:yellow");
                urlnode.Attributes.Add(attr);

                HtmlNode checknode = doc.CreateElement("input");
                attr = doc.CreateAttribute("type", "checkbox");
                checknode.Attributes.Add(attr);
                attr = doc.CreateAttribute("id", "scriptsubmit");
                checknode.Attributes.Add(attr);
                attr = doc.CreateAttribute("checked", "checked");
                checknode.Attributes.Add(attr);
                //attr = doc.CreateAttribute("style", "display:none");
                //checknode.Attributes.Add(attr);

                
                HtmlAttribute styleattr = doc.CreateAttribute("style", "padding:4px;margin-top:20px;display:block;border:solid");

                HtmlNode submitsoap = doc.CreateElement("textarea");
                attr = doc.CreateAttribute("Id", "submitsoap");
                submitsoap.Attributes.Add(attr);
                attr = doc.CreateAttribute("cols", "180");
                submitsoap.Attributes.Add(attr);
                attr = doc.CreateAttribute("rows", "10");
                submitsoap.Attributes.Add(attr);

                
                parameters.AppendChild(submiturllabel);
                parameters.AppendChild(urlnode);
                parameters.AppendChild(submitsoaplabel);
                parameters.AppendChild(submitsoap);
                parameters.AppendChild(checknode);
                parameters.AppendChild(script);

                parameters.AppendChild(testdoc.DocumentNode);
                parameters.Attributes.Add(styleattr);
                */
                trace = 9;
                HtmlNode raxmlnode = doc.DocumentNode.SelectSingleNode("//input[@id='rawxml']");
                if(raxmlnode!=null)
                   raxmlnode.Remove();

                trace = 10;

                //doc.DocumentNode.SelectSingleNode("//body").AppendChild(node);


                doc.DocumentNode.SelectSingleNode("//div[@id='FormData']").AppendChild(parametersdoc.DocumentNode);
                trace = 11;
                //doc.DocumentNode.SelectSingleNode("//div[@id='FormData']").AppendChild(label);
                //doc.DocumentNode.SelectSingleNode("//div[@id='FormData']").AppendChild(urlnode);
                //doc.DocumentNode.SelectSingleNode("//div[@id='FormData']").AppendChild(submitsoap);
                //doc.DocumentNode.SelectSingleNode("//body").AppendChild(checknode);

                //HtmlNode htmlnode = doc.DocumentNode.SelectSingleNode("//div[@id='parameters']//textarea[@id='html']");
                //if(htmlnode!=null)
                //{
                //    HtmlTextNode text = doc.CreateTextNode(doc.DocumentNode.OuterHtml);
                //    htmlnode.AppendChild(text);
                    
                //}
                return doc.DocumentNode.OuterHtml;
                
            }
            catch(Exception ex)
            {
                throw new Exception("CreateHTMLForm: " + ex.Message + ", Trace = " + trace);
            }
           
             
             

        }
        private class SDCForm
        {
            public string FormID { get; set; }
            public string FormName { get; set; }
            public string FormType { get; set; }

        }

        public static string Base64Encode(string plainText)
        {
            var plainTextBytes = System.Text.Encoding.UTF8.GetBytes(plainText);
            return System.Convert.ToBase64String(plainTextBytes);
        }


        public static string DecorateXPathWithNameSpace(string XPath, string NS)
        {
            if(XPath.Length>0)
            {
                string[] temp = XPath.Split('/');
                int i = 0;
                foreach (string test in temp)
                {
                    if(test.Length>0)
                    {
                        if(test.IndexOf("sdtc:")==-1 && test.IndexOf("sdc")==-1)
                        {
                            if(test.Substring(0,1)!="@")
                            {
                                temp[i]= NS + ":" + test;
                            }
                        }

                    }
                    i++;
                }

                XPath=String.Join("/",temp);
            }

            return XPath;
        }

    }
    
}
