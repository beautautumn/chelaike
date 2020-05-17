module Download
  class Engine < ::Rails::Engine
    isolate_namespace Download

    initializer "download.assets.precompile" do |app|
      app.config.assets.precompile += %w(*.png)
    end
  end
end
