set :output, {
  error: "/home/deploy/prime-server/shared/log/whenever_error.log",
  standard: "/home/deploy/prime-server/shared/log/whenever.log"
}

every 1.day, at: "00:10 am", roles: [:chaos_knight, :lina] do
  rake "car:grow_age"
end

every 1.day, at: "11:00 pm", roles: [:arc_warden] do
  rake "car:ensure_etl"
end

every :monday, at: "00:10 am", roles: [:arc_warden] do
  rake "chelaike:statistics"
end

every 1.day, at: "03:00 am", roles: [:pudge, :lina] do
  rake "company:daily_report"
end

# every 1.day, at: "00:10 am", roles: [:pudge] do
#   rake "erp:syncs_all"
# end

every 4.day, at: "01:00 am", roles: [:pudge] do
  rake "etl:execute"
end

every 1.day, at: "00:10 am", roles: [:pudge, :lina] do
  rake "finance:monthly_shop_fee_generation"
end

every 1.day, at: "10:00 am", roles: [:arc_warden, :lina] do
  rake "company:daily_reminder"
end

every 1.day, at: "8:00 am", roles: [:arc_warden] do
  rake "expiration_notification:run"
end

# every 1.day, at: "12:00 am", roles: [:arc_warden, :lina] do
#   rake "alliance:cars_created_statistic"
# end
