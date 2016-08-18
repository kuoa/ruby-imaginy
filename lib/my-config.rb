require 'yaml'

class MyConfig

  def initialize(file_name)
    @file_name = file_name
    @data = load
  end

  # default configuration
  def default
    {
        cmd: 'feh --bg-fill ',
        website: 'https://alpha.wallhaven.cc/search?categories=111&purity=100&resolutions=1920x1080&sorting=favorites&order=desc&page=',
        folder: 'walls/',
        page_size: 24,
        page: 1,
        image_index: 0,
    }
  end

  # load a new configuration from file
  def load
    if File.file?(@file_name)
      File.open(@file_name, 'r') do |file|
        YAML::load(file)
      end
    else
      default
    end
  end

  # store the current configuration
  def store
    File.open(@file_name, 'w') do |file|
      file.write YAML::dump(@data)
    end
  end

  # get the property value
  def get_property(key)
    @data[key]
  end

  # set the property value
  def set_property(key, value)
    @data[key] = value
  end

  private :default, :load
end