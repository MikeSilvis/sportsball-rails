class QueryBase
  def self.attr_accessor(*vars)
    @attributes ||= []
    @attributes.concat vars
    super(*vars)
  end

  def self.attributes
    @attributes
  end

  def attributes
    self.class.attributes
  end

  def as_json(*)
    {}.tap do |hash|
      attributes.map do |a|
        hash[a] = public_send(a)
      end
    end.compact
  end

  def api_image_url(path)
    self.api_image_url(path)
  end

  def self.api_image_url(path)
    Rails.application.routes.url_helpers.api_image_url("#{path}.png")
  end
end
