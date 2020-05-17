require "rails_helper"

RSpec.describe ImportIntentionsWorker do
  fixtures :all

  let(:import_intentions_record) { import_tasks(:import_intentions_record) }
  let(:sheet) do
    Intention::ImportService.open_sheet(import_intentions_record.info.fetch("import_file"))
  end

  before do
    allow(Intention::ImportService).to receive(:open_sheet).and_return(sheet)
  end

  it "import intentions from excel" do
    ImportIntentionsWorker.new.perform(import_intentions_record.id)

    imported_intentions = Intention.where(import_task_id: import_intentions_record.id)

    expect(imported_intentions.size).to eq 2
  end
end
