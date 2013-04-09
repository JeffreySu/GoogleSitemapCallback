<%@ Page Language="C#"  %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<script runat="server">
    public void Page_Load(object sender, System.EventArgs e)
    {
        //此页面必须包含2个参数：id和v，分别对应定制服务的id和验证码。encoding为可选参数，建议留空
        //访问地址如：/UpdateSitemap.aspx?id=123&v=1a2d
        
        //此处可以判断客户端是否为www.senparc.com的主机名或IP，以防被搜索引擎骚扰或攻击。
        //同时可以在robots.txt中添加过滤信息：Disallow: /UpdateSitemap.aspx
        
        string id = Request.QueryString["id"];
        string v = Request.QueryString["v"];
        string encoding = Request.QueryString["encoding"];

        if (string.IsNullOrEmpty(id) || string.IsNullOrEmpty(v))
        {
            Response.Write("错误！");
            Response.End();
        }
           
        string domain =  "http://www.senparc.com";
        string urlFormat = "{0}/Sitemap.xhtml/Download/{1}?v={2}&file={3}&encoding={4}";

        Action<string, string> saveSitemap = (filePath, fileType) =>
        {
            string url = string.Format(urlFormat, domain, id, v, fileType, encoding);
            string sitemapResult = this.GetSitemapResource(url);
            if (!string.IsNullOrEmpty(sitemapResult) && sitemapResult.Trim().StartsWith("<"))
            {
                if(sitemapResult.Length<=30)
                {
                    return;//判断收录条数是否成功，如果达不到预期效果，则返回，Length可以根据自己网站情况估计，也可以分别判断html和xml
                }
                
                using (StreamWriter sw = new StreamWriter(this.Server.MapPath(filePath), false))
                {
                    sw.Write(sitemapResult);
                }
            }
        };

        saveSitemap("~/sitemap.xml", "xml");//保存xml
        saveSitemap("~/sitemap.html", "html");//保存html

        Response.Write("OK");
        Response.End();
    }
    
    private string GetSitemapResource(string url)
    {
        HttpWebRequest webRequest = HttpWebRequest.Create(url) as HttpWebRequest;
        webRequest.Method = "GET";

        webRequest.MaximumAutomaticRedirections = 4;

        webRequest.Headers.Add(HttpRequestHeader.ContentLanguage, "zh-CN");
        //webRequest.Headers.Add(HttpRequestHeader.AcceptEncoding, "gzip, deflate");
        webRequest.KeepAlive = true;
        webRequest.UserAgent = "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0; Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1) ; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; InfoPath.2)";

        webRequest.Accept = "image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/x-shockwave-flash, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*";
        webRequest.Method = "GET";

        HttpWebResponse webResponse = (HttpWebResponse)webRequest.GetResponse();
        string result = null;
        using (StreamReader sr = new StreamReader(webResponse.GetResponseStream(), Encoding.UTF8))
        {
            result = sr.ReadToEnd();
        }
        return result;
    }
</script>