# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  require 'md5'

  def kg(amount,precision=0)
    "<b>" + (amount ? number_with_precision(amount, precision) : "?") + "</b> kg"
  end

  def tonnes(amount,precision=0)
    "<b>" + (amount ? number_with_precision(amount.to_f/1000, precision) : "?") + "</b> tonnes"
  end

  def image_tag_with_tooltip(location, options={})
    options[:title] ||= location.split('.').first.capitalize
    image_tag(location, options)
  end

  def pagination_links(pages) 
    render :partial => "/shared/pagination", :locals => { :pages => pages }
  end

  def tip_box(text)
    render :partial => "/shared/tip", :locals => { :text => text }
  end

  def help(text)
    '<span class="help">' + image_tag('help.png') + '<span>' + text + '</span></span>'
  end

  def friend_link(user, small=false)
    render :partial => "/shared/friend_link", :locals => { :user => user, :small => small }
  end
  
  def option(name, locals = {})
    render :partial => "/options/" + name, :locals => locals
  end

  def pagetitle(name, icon = nil)
    @content_for_pagename = name
    @content_for_pageicon = image_tag(icon)
  end

  def whitelabel_content(file)
    render :partial => "/sites/#{@style}/#{file}"
  rescue
    nil
  end

end
