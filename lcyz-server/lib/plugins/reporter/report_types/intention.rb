class Reporter::ReportTypes::Intention
  attr_reader :user, :name
  def initialize(user, params)
    @user = user
    @name = "意向导出#{Time.zone.now.strftime("%Y%m%d")}.xls"
    @params = params
  end

  def export
    HoneySheet::Excel.package(@name, self.class.title_bar, records)
  end

  def records
    Enumerator.new do |yielder|
      Intention::ListService.new(@user, @params).execute.each do |intention|
        yielder << self.class.row_format(intention)
      end
    end
  end

  def self.title_bar
    %w(
      编号 意向类型 姓名 联系电话 性别 来源 等级 归属人
      创建人 创建日期 跟进状态 最新跟进时间 下次跟进日期 意向内容
      意向车型 跟进历史
    )
  end

  def self.row_format(intention)
    [
      intention.id, # 编号
      intention.intention_type_text, # 意向类型
      intention.customer_name, # 姓名
      intention.customer_phone, # 联系电话
      intention.gender_text, # 性别
      intention.channel.try(:name), # 来源
      intention.intention_level.try(:name), # 等级
      intention.assignee.try(:name), # 归属人
      intention.creator.try(:name), # 创建人
      intention.created_at.to_date, # 创建时间
      intention.state_text, # 跟进状态
      # 最新跟进时间
      intention.latest_intention_push_history.try(:created_at).try(:to_date),
      intention.processing_time.try(:to_date), # 下次跟进日期
      intention.intention_note, # 意向内容
      intention.intention_cars_text, # 意向车型
      intention.push_histories_text # 意向跟进历史文字
    ]
  end
end
