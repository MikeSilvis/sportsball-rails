class QueryBase
  ASSET_STRING = 'ASSET_STRING_1'
  ASSET_HASH = Digest::MD5.hexdigest(ASSET_STRING)

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
    self.class.api_image_url(path)
  end

  def self.api_image_url(path)
    Rails.application.routes.url_helpers.image_url(encode_path(path))
  end

  def self.encode_path(path)
    "#{path}-#{ASSET_HASH}.png"
  end

  def self.decode_path(path)
    path.gsub("-#{ASSET_HASH}", '')
  end
end
