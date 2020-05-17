class App.MaintenanceRecords
  constructor: () ->

  render: ->
    @import_chejianding()
    @delete_item()
    @add_item()

  import_chejianding: () ->
    $(document).on "click", ".import-chejainding", (event) =>
      event.preventDefault()
      r = confirm("重新导入将覆盖现有记录, 确认吗?")
      if r
        $.ajax
          type: "get",
          url: "/admin/cars/" + $(event.target).attr("data-id") + "/maintenance_record/import",
          dataType: "json",
          success: (data) =>
            if data
              @fill_data(data)
            else
              alert "本车没有车鉴定维保记录，请在车来客中查询后再导入!"

  fill_data: (data) ->
    $("#maintenance_record_car_name").val(data.car_name)
    $("#maintenance_record_vin").val(data.vin)
    $("#maintenance_record_last_date").val(data.abstract_items.lastdate)
    $("#maintenance_record_mileage").val(data.abstract_items.mile)
    $("#maintenance_record_emission_standard").val(data.emission_standard_text)
    $("#maintenance_record_record_abstract_last_record_mileage").val(data.items.slice(-1)[0].mileage)
    $("#maintenance_record_record_abstract_last_record_date").val(data.abstract_items.lastdate)
    $("#maintenance_record_record_abstract_ab").val(@conv(data.abstract_items.ab))
    $("#maintenance_record_record_abstract_en").val(@conv(data.abstract_items.en))
    $("#maintenance_record_record_abstract_mi").val(@conv(data.abstract_items.mi))
    $("#maintenance_record_record_abstract_sd").val(@conv(data.abstract_items.sd))
    $("#maintenance_record_record_abstract_tr").val(@conv(data.abstract_items.tr))
    $(".detail-items").html('')
    for item in data.items
      $(".detail-items").append(@snippet(item))

  add_item: () ->
    $(document).on "click", ".add-item", (event) =>
      event.preventDefault()
      $(".detail-items").append(@snippet())

  snippet: (item) ->
    field_name = 'maintenance_record[record_detail][]'
    item = {"category": "", "date": "", "mileage": "", "item": "", "material": ""} unless item?
    '<div class="item">' +
      '<div class="form-group">' +
        '<label class="col-sm-1 control-label">类别</label>' +
        '<div class="col-sm-3">' +
          '<input class="form-control", name="' + field_name + '[category]", ' +
          'value="' + item.category + '">' +
        '</div>' +
        '<label class="col-sm-1 control-label">日期</label>' +
        '<div class="col-sm-2">' +
          '<input class="form-control", name="' + field_name + '[date]", ' +
          'value="' + item.date +  '">' +
        '</div>' +
        '<label class="col-sm-1 control-label">里程</label>' +
        '<div class="col-sm-2">' +
          '<input class="form-control", name="' + field_name + '[mileage]"' +
          'value="' + item.mileage + '">' +
        '</div>' +
      '</div>' +
      '<div class="form-group">' +
        '<label class="col-sm-1 control-label">项目</label>' +
        '<div class="col-sm-10">' +
          '<textarea rows="3" class="form-control", name="' + field_name + '[item]">' + item.item.replace('项目：', '') + '</textarea>' +
        '</div>' +
      '</div>' +
      '<div class="form-group">' +
        '<label class="col-sm-1 control-label">材料</label>' +
        '<div class="col-sm-10">' +
          '<textarea rows="3" class="form-control", name="' + field_name + '[material]">' + item.material.replace('材料：', '') + '</textarea>' +
        '</div>' +
      '</div>' +
      '<div class="form-group">' +
        '<div class="col-sm-2 col-sm-offset-1"><button class="btn btn-primary delete-item">删除</button></div><hr></div>'

  delete_item: () ->
    $(document).on "click", ".delete-item", (event) =>
      event.preventDefault()
      r = confirm "确定？"
      if r
        $(event.target).parents(".item").remove()

  conv: (text) ->
    if text == "有异常记录"
      "异常"
    else
      "正常"

$(document).ready ->
  return unless $(".maintenance_records.new").length > 0
  maintenance = new App.MaintenanceRecords
  maintenance.render()
