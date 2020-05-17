RSpec.shared_examples "permission check" do |authority|
  before do
    deprive_authority(zhangsan, authority)
    login_user(zhangsan)
  end

  it "can not do this action without authority #{authority}" do
    request_query
    expect(response.status).to eq 403
  end
end
