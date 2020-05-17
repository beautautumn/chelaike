namespace :acquisition_car_infos do
  desc "把之前未完成的出售意向导入到收车评估里"
  task import: :environment do
    unfinished_intentions = Intention.includes(:intention_level, :channel)
                                     .where(intention_type: "sale")
                                     .where.not(state: Intention.state_finished)
    unfinished_intentions.find_each(batch_size: 500) do |intention|
      puts "processing intention: #{intention.id}"
      AcquisitionCarInfo.create!(
        acquirer_id: intention.assignee_id || intention.creator_id,
        company_id: intention.company_id,
        brand_name: intention.brand_name,
        series_name: intention.series_name,
        style_name: intention.style_name,
        licensed_at: intention.licensed_at,
        exterior_color: intention.color,
        mileage: intention.mileage,
        valuation_cents: intention.estimated_price_cents,
        state: "init",
        key_count: 2,
        owner_info: {
          name: intention.customer_name,
          phone: intention.customer_phone,
          expected_price_wan: intention.minimum_price_wan,
          intention_level: {
            id: intention.intention_level.try(:id),
            name: intention.intention_level.try(:name),
            note: intention.intention_level.try(:note)
          },
          channel: {
            id: intention.channel.try(:id),
            name: intention.channel.try(:name),
            note: intention.channel.try(:note)
          }
        },
        created_at: intention.created_at,
        updated_at: intention.updated_at
      )
    end
  end
end
