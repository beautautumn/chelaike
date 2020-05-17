class App.Insurance
  constructor: () ->

  render: ->
    @add_claim_abstract()
    @delete_claim_abstract()
    @add_claim_detail()
    @delete_claim_detail()

  # 点击添加摘要
  add_claim_abstract: () ->
    $("#add-claim-abstract-button").on "click", ->
      tpl = '<div class="claim-abstract-form">' +
            '<div class="form-group">' +
            '<div class="col-sm-10">' +
            '<label class="col-sm-2 control-label">记录时间：</label>' +
            '<div class="col-sm-4">' +
            '<input class="form-control" name="insurance_record[claims_abstract][periods][][dates]" type="text" id="insurance_record_claims_abstract_dates">' +
            '</div>' +
            '<label class="col-sm-2 control-label">事故次数(次)：</label>' +
            '<div class="col-sm-4">' +
            '<input class="form-control" name="insurance_record[claims_abstract][periods][][claims_count]" type="text" id="insurance_record_claims_abstract_claims_count">' +
            '</div>' +
            '</div>' +
            '<div class="col-sm-2">' +
            '<button type="button" class="btn btn-info delete-claim-abstract-btn">删除</button>'
            '</div>' + '</div>'

      $(".claim-abstract-forms").append(tpl)

  # 删除事故摘要
  delete_claim_abstract: () ->
    $("body").on "click", ".delete-claim-abstract-btn", (e)->
      parent_form = $(e.target).parents(".claim-abstract-form")
      parent_form.remove()

  # 添加记录详情
  add_claim_detail: () ->
    $("#add-claim-detail-button").on "click", ->
      tpl = """
  <div class="claim-detail-form clearfix">
  <div class="col-sm-10">
    <div class="form-group">
        <label class="col-sm-2 control-label">记录日期：</label>
        <div class="col-sm-4">
          <input class="form-control" name="insurance_record[claims_details][][claim_date]" type="text" id="insurance_record_claims_details_claim_date">
        </div>

        <label class="col-sm-2 control-label">事故损失：</label>
        <div class="col-sm-4">
          <input class="form-control" name="insurance_record[claims_details][][lobor_fee]" type="text" id="insurance_record_claims_details_lobor_fee" placeholder="元">
        </div>
    </div>

    <div class="form-group">
      <label class="col-sm-2 control-label">事故类型：</label>
      <div class="col-sm-4">
        <input class="form-control" name="insurance_record[claims_details][][accident_type]" type="text" id="insurance_record_claims_details_accident_type">
      </div>

      <label class="col-sm-2 control-label">事故经过：</label>
      <div class="col-sm-4">
        <input class="form-control" name="insurance_record[claims_details][][description]" type="text" id="insurance_record_claims_details_description">
      </div>
    </div>

    <div class="form-group">
      <label class="col-sm-2 control-label">维修内容：</label>
      <div class="col-sm-10">
        <input value="" class="form-control" name="insurance_record[claims_details][][repair_detail]" type="text" id="insurance_record_claims_details_repair_detail">
      </div>
    </div>

    <div class="form-group">
      <label class="col-sm-2 control-label">更换配件：</label>
      <div class="col-sm-10">
        <input value="" class="form-control" name="insurance_record[claims_details][][material]" type="text" id="insurance_record_claims_details_material">
      </div>
    </div>
  </div>

  <div class="col-sm-2">
    <button type="button" class="btn btn-info delete-claim-detail-btn">删除</button>
  </div>
</div>
      """
      $(".claim-details-forms").append(tpl)

  delete_claim_detail: () ->
    $("body").on "click", ".delete-claim-detail-btn", (e) ->
      parent_form = $(e.target).parents(".claim-detail-form")
      parent_form.remove()

$(document).ready ->
  return unless $(".insurance_records.new").length > 0
  insurance = new App.Insurance
  insurance.render()
