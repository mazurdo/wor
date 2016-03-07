xml.instruct! :xml, :version => "1.0"

xml.urlset('xmlns'=>'http://www.sitemaps.org/schemas/sitemap/0.9',
'xmlns:xsi'=>'http://www.w3.org/2001/XMLSchema-instance',
'xsi:schemaLocation'=>'http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd') do

  @tags.all.each do |tag|
    xml.url do
      xml.loc "#{request.protocol}#{request.host}#{tag_path(tag)}"
      xml.lastmod tag.updated_at.strftime( "%Y-%m-%dT%H:%M:%S%:z" )
      xml.changefreq "monthly"
      xml.priority "0.8"
    end
  end
end
