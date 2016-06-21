#encoding: UTF-8

xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title @post.title
    xml.link "#{request.protocol}#{request.host}#{post_path(@post)}"
    xml.lastBuildDate @post.date.to_s(:rfc822)
    xml.language "es-ES"

    xml.item do
      xml.title @post.title
      xml.pubDate @post.date.to_s(:rfc822)
      xml.link "#{request.protocol}#{request.host}#{post_path(@post)}"
      xml.author @post.user.username
      xml.description do
       xml.cdata!("<img src=\"#{request.protocol}#{request.host}/#{@post.cover_image_path('150x150')}\"/>#{@post.content}")
     end
    end
  end
end
