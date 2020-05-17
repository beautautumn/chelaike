namespace :configuration do
  desc "修复款式配置奥迪一汽大众问题"
  task fix_aodi: :environment do
    series_codes = Series.all.pluck(:code)
    configurations = StyleConfiguration.in(series_code: series_codes)

    configurations.each do |c|
      c.data["基本参数"]["厂商"].gsub!(/无/, "-")
      c.save
    end
  end
end
