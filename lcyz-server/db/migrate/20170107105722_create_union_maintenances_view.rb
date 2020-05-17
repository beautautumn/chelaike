class CreateUnionMaintenancesView < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE VIEW union_maintenance_records AS
        SELECT
          ('cjd' || id) as id,
          id as original_id,
          'cjd' as sp_type,
          maintenance_record_hub_id as hub_id,
          last_maintenance_record_hub_id as last_hub_id,
          engine as engine_num,
          null as request_at,
          null as response_at,
          company_id, car_id, vin, state, last_fetch_by as user_id, user_name,
          last_fetch_at, created_at, updated_at, shop_id, vin_image
        FROM maintenance_records
        UNION SELECT
          ('antQueen' || id) as id,
          id as original_id,
          'antQueen' as sp_type,
          ant_queen_record_hub_id as hub_id,
          last_ant_queen_record_hub_id as last_hub_id,
          engine_num,
          null as request_at,
          null as response_at,
          company_id, car_id, vin, state, last_fetch_by as user_id, user_name,
          last_fetch_at, created_at, updated_at, shop_id, vin_image
        FROM ant_queen_records
        UNION SELECT
          ('drCha' || id) as id,
          id as original_id,
          'drCha' as sp_type,
          cha_doctor_record_hub_id as hub_id,
          last_cha_doctor_record_hub_id as last_hub_id,
          '' as engine_num,
          null as request_at,
          null as response_at,
          company_id, car_id, vin, state, user_id , user_name,
          fetch_at as last_fetch_at, created_at, updated_at, shop_id, vin_image
        FROM cha_doctor_records
        UNION SELECT
          ('monkeyKing' || id) as id,
          id as original_id,
          'monkeyKing' as sp_type,
          dashenglaile_record_hub_id as hub_id,
          last_dashenglaile_record_hub_id as last_hub_id,
          engine_num,
          null as request_at,
          null as response_at,
          company_id, car_id, vin, state, last_fetch_by as user_id, user_name,
          last_fetch_at, created_at, updated_at, shop_id, vin_image
        FROM  dashenglaile_records
    SQL
  end

  def down
    execute "DROP VIEW union_maintenance_records"
  end
end
