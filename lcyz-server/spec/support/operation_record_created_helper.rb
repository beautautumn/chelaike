RSpec.shared_examples "operation_record created" do
  it "creates an operation_record record" do
    expect do
      request_query
    end.to change { OperationRecord.count }.by(1)
  end
end
