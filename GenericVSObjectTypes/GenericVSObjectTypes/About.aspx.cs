using Newtonsoft.Json;
using System;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Xml.Serialization;

namespace GenericVSObjectTypes
{
    public partial class About : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Write("View GitUpResult");
            Response.Write("View GitUpResult");
            //Dbg_extensions.dump(object, )
            Dbg_extensions.dump(1, 2, 3);

            Item item = new Item
            {
                Name = "Chocolate",
                Number = 12345,
                CreatedDate = DateTime.Now,
                Price = 36.7M,
                Category = new Category(1, "Sweets")
            };
            ObjectHelper.Dump(item);
            DumpAsXml(item);
        }

        private static void DumpAsXml(object o)
        {
            //var stringBuilder = new StringBuilder();
            //XmlSerializer xser = new XmlSerializer(typeof(MyType));
            //var serializer = new XmlSerializer();
            XmlSerializer ser = new XmlSerializer(typeof(Item));
            //serializer.Serialize(new System.CodeDom.Compiler.IndentedTextWriter(new System.IO.StringWriter(stringBuilder)), o);
            //Console.WriteLine(stringBuilder);
            TextWriter writer = new StreamWriter("D:/a.xml");
            ser.Serialize(writer, o);
            writer.Close();
        }
    }

    public class Item
    {
        public string Name { get; set; }
        public int Number { get; set; }
        public DateTime CreatedDate { get; set; }
        public decimal Price { get; set; }
        public Category Category { get; set; }
    }

    public class Category
    {
        public int v1 { get; set; }
        public string v2 { get; set; }

        public Category(int v1, string v2)
        {
            this.v1 = v1;
            this.v2 = v2;
        }

        public Category() { }
    }

    #region Dbg_extensions

    /// <summary>
    /// Dbg_extensions
    /// </summary>
    public static class Dbg_extensions
    {
        static public T dump<T>(this T @object, params object[] args)
        {
            dbg.print(@object, args);
            return @object;
        }

        static public T print<T>(this T @object, params object[] args)
        {
            dbg.print(@object, args);
            return @object;
        }
    }

    partial class dbg
    {
        public static bool publicOnly = true;
        public static bool propsOnly = false;
        public static int max_items = 25;
        public static int depth = 1;

        public static void printf(string format, params object[] args)
        {
        }

        public static void print(object @object, params object[] args)
        {
        }
    }

    #endregion Dbg_extensions

    internal static class ObjectHelper
    {
        public static void Dump<T>(this T x)
        {
            string json = JsonConvert.SerializeObject(x, Formatting.Indented);
            HttpContext.Current.Response.Write(json);
        }
    }
}