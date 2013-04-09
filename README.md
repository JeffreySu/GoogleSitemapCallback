GoogleSitemapCallback
=====================

Senparc GoogleSitemap这是一个由盛派网络（Senparc）发起的免费Google Sitemap定制（收集）服务。

工作原理是：通过网页，一个运行在Senparc云端的机器人（SenMapic）发送收录网站请求，SenMapic完成收录后，将结果整理成标准的Google Sitemap格式，包含响应统计结果、html文件返回给请求方。

所生成的所有页面URL是SenMapic根据网页入口模拟搜索引擎蜘蛛爬行得到的，宝货其中出现的各种页面错误也可以及时发现。

同时SenMapic还接收定制服务，每天定时为用户推送最新sitemap.xml/.html以及统计结果，这样就可以在完全没有人共参与的情况下完成对网站Sitemap的更新。

为了实践sitemap.xml/.html的自动更新，目标网站上需要放置一个接收每天推送信息的接口。这个项目中的UpdateSitemap.aspx就是这样一个demo文件。可以直接复制到网站根目录使用。
