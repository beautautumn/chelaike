module KeywordRecordable
  def record_recent_keywords(type, keyword = nil)
    Search::RecentKeywordsService.new(type, current_user.id)
                                 .append(keyword || params[:keyword])
  end
end
