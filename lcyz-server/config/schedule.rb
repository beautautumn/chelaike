require File.expand_path(File.dirname(__FILE__) + "/environment")

set :output, {
  error: "#{environment == 'bm_production' ? '/home/deploy/bm-server' : '/home/deploy/lcyz-server'}/shared/log/whenever_error.log",
  standard: "#{environment == 'bm_production' ? '/home/deploy/bm-server' : '/home/deploy/lcyz-server'}/shared/log/whenever.log"
}

every 1.day, at: "00:10 am" do
  rake "car:grow_age"
end

every :monday, at: "00:10 am" do
  rake "chelaike:statistics"
end

every 1.day, at: "03:00 am" do
  rake "company:daily_report"
end

# every 1.day, at: "00:10 am", roles: [:pudge] do
#   rake "erp:syncs_all"
# end

every 4.day, at: "01:00 am" do
  rake "etl:execute"
end

every 1.day, at: "00:10 am" do
  rake "finance:monthly_shop_fee_generation"
end

every 1.day, at: "10:00 am" do
  rake "company:daily_reminder"
end

every 1.day, at: "8:00 am" do
  rake "expiration_notification:run"
end

# every 1.day, at: "12:00 am", roles: [:arc_warden, :lina] do
#   rake "alliance:cars_created_statistic"
# end
