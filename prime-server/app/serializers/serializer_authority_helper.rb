module SerializerAuthorityHelper
  def authority_filter(*authorities)
    User::Pundit.filter(scope, object, authorities)
  end

  def can_read_transfer_records
    authority_filter("牌证信息查看")
  end
end
