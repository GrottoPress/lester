struct Lester::Image::Alias::Endpoint
  include Hapi::Endpoint

  def list(**params)
    yield list(**params)
  end

  def list(**params) : List
    params = @client.recurse(**params)

    @client.get("#{uri.path}?#{URI::Params.encode(params)}") do |response|
      List.from_json(response.body_io)
    end
  end

  def create(project = nil, **params)
    yield create(project, **params)
  end

  def create(project : String? = nil, **params) : Operation::Item
    @client.post(
      "#{uri.path}?project=#{project}",
      body: params.to_json
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def delete(name, project = nil)
    yield delete(name, project)
  end

  def delete(name : String, project : String? = nil) : Operation::Item
    @client.delete("#{uri.path}/#{name}?project=#{project}") do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def fetch(name, **params)
    yield fetch(name, **params)
  end

  def fetch(name : String, **params) : Item
    @client.get(
      "#{uri.path}/#{name}?#{URI::Params.encode(params)}"
    ) do |response|
      Item.from_json(response.body_io)
    end
  end

  def update(name, project = nil, **params)
    yield update(name, project, **params)
  end

  def update(name : String, project : String? = nil, **params) : Operation::Item
    @client.patch(
      "#{uri.path}/#{name}?project=#{project}",
      body: params.to_json
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def rename(name, new_name, project = nil)
    yield rename(name, new_name, project)
  end

  def rename(
    name : String,
    new_name : String,
    project : String? = nil
  ) : Operation::Item
    @client.post(
      "#{uri.path}/#{name}?project=#{project}",
      body: {name: new_name}.to_json
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def replace(name, project = nil, **params)
    yield replace(name, project, **params)
  end

  def replace(name : String, project = nil, **params) : Operation::Item
    @client.put(
      "#{uri.path}/#{name}?project=#{project}",
      body: params.to_json
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def uri : URI
    uri = @client.uri.dup
    uri.path += "/images/aliases"
    uri
  end
end
