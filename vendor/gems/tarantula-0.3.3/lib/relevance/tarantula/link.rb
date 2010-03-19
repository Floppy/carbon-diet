class Relevance::Tarantula::Link
  include Relevance::Tarantula
  
  class << self
    include ActionView::Helpers::UrlHelper
    # method_javascript_function needs this method
    def protect_against_forgery?
      false
    end
  end
  
  METHOD_REGEXPS = {}
  [:put, :delete, :post].each do |m|
    # remove submit from the end so we'll match with or without forgery protection
    s = method_javascript_function(m).gsub( /f.submit();/, "" )
    # don't just match this.href in case a different url was passed originally
    s = Regexp.escape(s).gsub( /this.href/, ".*" )
    METHOD_REGEXPS[m] = /#{s}/
  end
  
  attr_accessor :href, :crawler, :referrer
  
  def initialize(link, crawler, referrer)
    @crawler, @referrer = crawler, referrer
    
    if String === link || link.nil?
      @href = transform_url(link)
      @method = :get
    else # should be a tag
      @href = link['href'] ? transform_url(link['href'].downcase) : nil
      @tag = link
    end
  end
  
  def crawl
    response = crawler.follow(method, href)
    log "Response #{response.code} for #{self}"
    crawler.handle_link_results(self, make_result(response))
  end
  
  def make_result(response)
    crawler.make_result(:method    => method,
                        :url       => href,
                        :response  => response,
                        :referrer  => referrer)
  end
  
  def method
    @method ||= begin
      (@tag &&
       [:put, :delete, :post].detect do |m| # post should be last since it's least specific
         @tag['onclick'] =~ METHOD_REGEXPS[m]
       end) ||
      :get
    end
  end
  
  def transform_url(link)
    crawler.transform_url(link)
  end
  
  def ==(obj)
    obj.respond_to?(:href) && obj.respond_to?(:method) &&
      self.href.to_s == obj.href.to_s && self.method.to_s == obj.method.to_s
  end
  alias :eql? :==
  
  def hash
    to_s.hash
  end
  
  def to_s
    "<Relevance::Tarantula::Link href=#{href}, method=#{method}>"
  end
  
end
