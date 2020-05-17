# rubocop:disable Rails/Output
module Spy
  module V2
    class Additional
      def initialize
        additional = YAML.load_file("#{Rails.root}/lib/spy/additional.yml")
                     .with_indifferent_access
        @brands = additional[:brands]
        @series = additional[:series]
        @styles = additional[:styles]
      end

      def import_brands
        (@brands || []).each do |_name, brand|
          the_brand = Brand.find_or_initialize_by(name: brand[:name])

          next if the_brand.code

          the_brand.update_attributes(brand)

          puts "==> Brand #{brand[:name]} Storage Finished.".green
        end
      end

      def import_series
        (@series || []).each do |_name, series|
          the_series = ::Series.find_or_initialize_by(name: series[:name])

          next if the_series.code

          the_series.update_attributes(series)

          puts "==> Series #{series[:name]} Storage Finished.".green
        end
      end

      def import_styles
        (@styles || []).each do |_name, style|
          the_style = ::Style.find_or_initialize_by(series_code: style[:series_code])

          model = { id: style[:id], name: style[:name] }

          found = false
          styles = the_style.styles || []
          styles.each do |s|
            next unless s[:year] == style[:year]

            found = true

            unless s[:models].map { |m| m[:name] }.include?(model[:name])
              s[:models] << model
            end

            break
          end

          style_data = { year: style[:year], models: [model] }
          styles << style_data unless found

          the_style.update_attributes(styles: styles)

          puts "==> Style #{style[:name]} Storage Finished.".green
        end
      end

      def import
        import_brands
        import_series
        import_styles
      end
    end
  end
end
# rubocop:enable Rails/Output
