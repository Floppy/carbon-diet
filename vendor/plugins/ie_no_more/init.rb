require File.join(File.dirname(__FILE__), '/lib/ie_no_more')

ActionView::Base.send(:include, IENoMore)
ActionController::Base.append_view_path File.join(Rails.root, "vendor", "plugins", "ie_no_more", "app", "views")
