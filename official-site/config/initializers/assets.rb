# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w(
  desktop.js desktop.css
  mobile.js mobile.css
  admin.js admin.css
  dev.js
)

# 如果需要在 staging 打开
# Rails.application.config.assets.precompile += %w(dev.js) unless Rails.env.production?
