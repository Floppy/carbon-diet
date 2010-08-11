xml.instruct!

xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do

  xml.title "The Carbon Diet : Comments for " + h(@group.name)
  xml.subtitle h(@group.description)
  xml.link "href" => group_url(@group, :only_path => false)
  xml.link "href" => group_url(@group, :only_path => false, :format => :atom), "rel" => "self"
  xml.updated @comments.first.created_at.xmlschema rescue nil
  xml.id "tag:www.carbondiet.org,#{@group.created_at.strftime("%Y-%m-%d")}:group#{@group.id}"
  
  @comments.each do |comment|

    xml.entry do

      xml.title h(comment.user.name) + " @ " + comment.created_at.strftime("%H:%M on %d %b %y")
      xml.updated comment.created_at.xmlschema
      xml.summary comment.text
      xml.author do
        xml.name h(comment.user.name)
      end
      xml.link "href" => group_url(@group, :only_path => false, :anchor => "comment#{comment.id}")
      xml.id "tag:www.carbondiet.org,#{comment.created_at.strftime("%Y-%m-%d")}:comment#{comment.id}"
    end
      
  end

end
