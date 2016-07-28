#!/usr/bin/env ruby
require 'nokogiri'
require 'open-uri'
require 'yaml'
require 'date'

CONFIG_FILE = 'config.data'

def default_config
  config = {
      cmd: 'gsettings set org.gnome.desktop.background picture-uri file://',
      website: 'https://alpha.wallhaven.cc/search?categories=111&purity=100&resolutions=1920x1080&sorting=favorites&order=desc&page=',
      folder: 'walls/',
      page_size: 24,
      page: 1,
      image_index: 0,
      date: Date.today.prev_day
  }
end

def save_config(config)
  File.open(CONFIG_FILE, 'w') do |file|
    file.write YAML::dump(config)
  end
end

def load_config
  if File.file?(CONFIG_FILE)
    File.open(CONFIG_FILE, 'r') do |file|
      YAML::load(file)
    end
  else
    default_config
  end
end

def save_image(image_name, url)
  File.open(image_name, 'wb') do |fo|
    fo.write open(url).read
  end
end

def imaginy
  config = load_config

  if config[:date] < Date.today
    
    if config[:image_index] == config[:page_size]
      config[:page] += 1
      config[:image_index] = -1
    end

    website_url = config[:website] + config[:page].to_s
    page = Nokogiri::HTML(open(website_url))
    images = page.css("a[class='preview']")

    image = images[config[:image_index]]
    image_page_url = image['href']
    image_page = Nokogiri::HTML(open(image_page_url))
    image_url = image_page.css("img[id='wallpaper']")
    url = 'https:' + image_url[0]['src']
    image_relative_path = config[:folder] + config[:date].to_s + File.extname(url)

    save_image(image_relative_path, url)

    image_full_path = Dir.pwd + '/' + image_relative_path

    set_background_cmd = config[:cmd] + image_full_path

    system(set_background_cmd)

    config[:image_index] += 1
    config[:date] += 1

    save_config(config)
  end
end

imaginy

