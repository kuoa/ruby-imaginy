require 'nokogiri'
require 'open-uri'

class ImageManager

  def initialize(config)
    @config = config
    @image_list = load_image_list
  end

  # load the image url list for the current page
  def load_image_list

    # construct the web-page url with the current page
    website_url = @config.get_property(:website) + @config.get_property(:page).to_s

    # get the source code of the website page
    website_page = Nokogiri::HTML(open(website_url))

    # get the list of image url's
    website_page.css("a[class='preview']")
  end

  # set the current image as background
  def change_background_image
    # get the current image path
    image_path = download_current_image

    # construct the system command
    set_background_cmd = @config.get_property(:cmd) + image_path

    # set the background image
    system(set_background_cmd)

    # update the existing config
    update_config
  end

  # download the current image
  # return the image path
  def download_current_image

    image_index = @config.get_property(:image_index)

    # get the html block describing the current image
    image_block = @image_list[image_index]

    # get the image page url
    image_page_url = image_block['href']

    # get the source code of the specific image page
    image_page = Nokogiri::HTML(open(image_page_url))

    # get the image url block
    image_partial_url = image_page.css("img[id='wallpaper']")

    # get the image url and name
    image_url = 'https:' + image_partial_url[0]['src']
    image_name = Date.today.to_s + '-' + @config.get_property(:image_index).to_s

    # construct the image path
    image_path = @config.get_property(:folder) + image_name + File.extname(image_url)

    # download the image to disk
    save_image(image_path, image_url)

    image_path
  end

  # save the image at @image_url locally as @image_name
  def save_image(image_name, image_url)
    File.open(image_name, 'wb') do |fo|
      fo.write open(image_url).read
    end
  end

  # update the current config file
  def update_config
    image_index = @config.get_property(:image_index)

    if image_index == @config.get_property(:page_size) - 1
      # record a new page
      current_page = @config.get_property(:page)
      @config.set_property(:page, current_page + 1)
      @config.set_property(:image_index, 0)
    else
      # increase the image index
      @config.set_property(:image_index, image_index + 1)
    end
  end

  private :load_image_list, :download_current_image, :save_image,  :update_config
end