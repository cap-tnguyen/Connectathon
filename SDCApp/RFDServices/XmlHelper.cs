using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Xml;
using System.Xml.Linq;
using System.Text;

namespace SDC
{
    public class XmlHelper
    {

        public static XmlNode ClosestParentElement(XmlNode node, string Names)
        {
            
            string[] names = Names.Split(',');
            while (node.ParentNode != null)
            {
                foreach (string test in names)
                {
                    if (node.ParentNode.LocalName == test)
                        return node.ParentNode;
                }
                node = node.ParentNode;

            }

            return null;

        }

        public static string FormatXML(System.Xml.XmlDocument doc)
        {
            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            System.Xml.XmlWriterSettings settings = new System.Xml.XmlWriterSettings
            {
                Indent = true,
                IndentChars = "\t",
                NewLineChars = "\r\n",
                NewLineHandling = System.Xml.NewLineHandling.Replace
            };
            settings.OmitXmlDeclaration = true;

            using (System.Xml.XmlWriter writer = System.Xml.XmlWriter.Create(sb, settings))
            {
                doc.Save(writer);
            }
            return sb.ToString();
        }

        public static string FormatXML(string xml)
        {
            XmlDocument doc = new XmlDocument();
            doc.LoadXml(xml.Replace("\r\n",""));
            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            System.Xml.XmlWriterSettings settings = new System.Xml.XmlWriterSettings
            {
                Indent = true,
                IndentChars = "\t",
                NewLineChars = "\r\n",
                NewLineHandling = System.Xml.NewLineHandling.Replace
            };
            settings.OmitXmlDeclaration = true;

            using (System.Xml.XmlWriter writer = System.Xml.XmlWriter.Create(sb, settings))
            {
                doc.Save(writer);
            }
            return sb.ToString();
        }

        public static XmlDocument RemoveXmlns(String xml)
        {
            XDocument d = XDocument.Parse(xml);
            d.Root.Descendants().Attributes().Where(x => x.IsNamespaceDeclaration).Remove();

            foreach (var elem in d.Descendants())
                elem.Name = elem.Name.LocalName;

            var xmlDocument = new XmlDocument();
            xmlDocument.Load(d.CreateReader());

            return xmlDocument;
        }

        public static XmlDocument RemoveXmlns(XmlDocument doc)
        {
            XDocument d;
            using (var nodeReader = new XmlNodeReader(doc))
                d = XDocument.Load(nodeReader);

            d.Root.Descendants().Attributes().Where(x => x.IsNamespaceDeclaration).Remove();

            foreach (var elem in d.Descendants())
                elem.Name = elem.Name.LocalName;

            var xmlDocument = new XmlDocument();
            using (var xmlReader = d.CreateReader())
                xmlDocument.Load(xmlReader);

            return xmlDocument;
        }

        public static XmlDocument RemoveXmlns(XmlNode xNode)
        {
            XDocument d;
            using (var nodeReader = new XmlNodeReader(xNode))
                d = XDocument.Load(nodeReader);

            d.Root.Descendants().Attributes().Where(x => x.IsNamespaceDeclaration).Remove();

            foreach (var elem in d.Descendants())
                elem.Name = elem.Name.LocalName;

            var xmlDocument = new XmlDocument();
            using (var xmlReader = d.CreateReader())
                xmlDocument.Load(xmlReader);

            return xmlDocument;
        }

        public static string removeUnicode(string inpString)
        {

            string asAscii = Encoding.ASCII.GetString(
              Encoding.Convert(
               Encoding.UTF8,
               Encoding.GetEncoding(
                Encoding.ASCII.EncodingName,
                new EncoderReplacementFallback(string.Empty),
                new DecoderExceptionFallback()
                ),
               Encoding.UTF8.GetBytes(inpString)
              )
            );

            return asAscii;


        }   
    }
}