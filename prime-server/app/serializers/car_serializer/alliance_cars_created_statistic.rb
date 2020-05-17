module CarSerializer
  class AllianceCarsCreatedStatistic < AllianceCarsList
    attribute :intentions_count

    def intentions_count
      instance_options[:result][object.id.to_s].size
    end
  end
end
