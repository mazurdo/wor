xml.instruct! :xml, :version => "1.0"

xml.sitemapindex('xmlns'=>'http://www.sitemaps.org/schemas/sitemap/0.9',
'xmlns:xsi'=>'http://www.w3.org/2001/XMLSchema-instance',
'xsi:schemaLocation'=>'http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd') do

  @posts.each do |post|
    xml.sitemap do
      xml.loc wor_engine.url_for(:host => request.host, controller: 'wor/sitemap', action: 'posts', date: post.date.strftime("%Y-%m-%d"), trailing_slash: false, format: :xml)
      xml.lastmod post.updated_at.strftime( "%Y-%m-%dT%H:%M:%S%:z" )
    end
  end


  xml.sitemap do 
    xml.loc wor_engine.url_for(:host => request.host, controller: 'wor/sitemap', action: 'tags', trailing_slash: false, format: :xml)
  end

  xml.sitemap do 
    xml.loc wor_engine.url_for(:host => request.host, controller: 'wor/sitemap', action: 'categories', trailing_slash: false, format: :xml)
  end
end
