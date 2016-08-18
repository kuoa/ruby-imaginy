#!/usr/bin/env ruby

require_relative 'lib/my-config'
require_relative 'lib/image-manager'

CONFIG_FILE_NAME = 'config.data'

config = MyConfig.new(CONFIG_FILE_NAME)
image_manager = ImageManager.new(config)

image_manager.change_background_image
config.store