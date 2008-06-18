xml.instruct!

xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do

  xml.title "The Carbon Diet : Comments for " + h(@group.name)
  xml.subtitle h(@group.description)
  xml.link "href" => url_for(:only_path => false, :controller => 'groups', :action => 'view', :id => @group)
  xml.link "href" => url_for(:only_path => false, :controller => 'groups', :action => 'feed', :id => @group, :format => "xml"), "rel" => "self"
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
      xml.link "href" => url_for(:only_path => false, :controller => 'groups', :action => 'view', :id => @group, :anchor => "comment#{comment.id}")
      xml.id "tag:www.carbondiet.org,#{comment.created_at.strftime("%Y-%m-%d")}:comment#{comment.id}"
    end
      
  end

end
