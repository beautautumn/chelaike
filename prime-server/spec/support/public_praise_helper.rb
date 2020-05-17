module PublicPraiseHelper
  def mock_requests
    {
      brand_id: 33,
      series_id: 3170,
      style_id: 25_898
    }.each do |attr, value|
      allow_any_instance_of(AutohomePublicPraise::ModelBase).to receive(attr).and_return(value)
    end

    allow_any_instance_of(AutohomePublicPraise::Parser)
      .to receive(:sumup).and_return(
        AutohomePublicPraise::Spec::Fixtures.sumup.nested_under_indifferent_access
      )
    allow_any_instance_of(AutohomePublicPraise::Parser)
      .to receive(:quality_problems).and_return(
        AutohomePublicPraise::Spec::Fixtures.quality_problems
      )
    allow_any_instance_of(PublicPraiseService)
      .to receive(:collect_public_praises).and_return(
        [AutohomePublicPraise::Spec::Fixtures.public_praise.nested_under_indifferent_access]
      )
  end
end
