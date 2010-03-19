class Relevance::Tarantula::FormSubmission
  include Relevance::Tarantula
  attr_accessor :method, :action, :data, :attack, :form

  class << self
    def attacks
      # normalize from hash input to Attack
      @attacks = @attacks.map do |val|
        Hash === val ? Relevance::Tarantula::Attack.new(val) : val
      end
      @attacks
    end
    def attacks=(atts)
      # normalize from hash input to Attack
      @attacks = atts.map do |val|
        Hash === val ? Relevance::Tarantula::Attack.new(val) : val
      end
    end
  end
  @attacks = [Relevance::Tarantula::BasicAttack.new]

  def initialize(form, attack = Relevance::Tarantula::BasicAttack.new)
    @form = form
    @method = form.method
    @action = form.action
    @attack = attack
    @data = mutate_selects(form).merge(mutate_text_areas(form)).merge(mutate_inputs(form))
  end
  
  def crawl
    begin
      response = form.crawler.submit(method, action, data)
      log "Response #{response.code} for #{self}"
    rescue ActiveRecord::RecordNotFound => e
      log "Skipping #{action}, presumed ok that record is missing"
      response = Relevance::Tarantula::Response.new(:code => "404", :body => e.message, :content_type => "text/plain")
    end
    form.crawler.handle_form_results(self, response)
    response
  end

  def self.mutate(form)
    attacks.map{|attack| new(form, attack)} if attacks
  end

  def to_s
    "#{action} #{method} #{data.inspect} #{attack.inspect}"
  end

  # a form's signature is what makes it unique (e.g. action + fields)
  # used to keep track of which forms we have submitted already
  def signature
    [action, data.keys.sort, attack.name]
  end

  def create_random_data_for(form, tag_selector)
    form.search(tag_selector).inject({}) do |form_args, input|
      # TODO: test
      form_args[input['name']] = random_data(input) if input['name']
      form_args
    end
  end

  def mutate_inputs(form)
    create_random_data_for(form, 'input')
  end

  def mutate_text_areas(form)
    create_random_data_for(form, 'textarea')
  end

  def mutate_selects(form)
    form.search('select').inject({}) do |form_args, select|
      options = select.search('option')
      option = options.rand
      form_args[select['name']] = option['value']
      form_args
    end
  end

  def random_data(input)
    case input['name']
    when /^_method$/      then input['value']
    else
      attack.input(input)
    end
  end
end
