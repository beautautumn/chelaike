require "rails_helper"

RSpec.describe DailyActiveRecord do
  fixtures :cars

  let(:aodi) { cars(:aodi) }

  def start_date
    Date.new(2016, 03, 01)
  end

  def end_date
    Date.new(2016, 03, 10)
  end

  def invalid_date
    Date.new(2016, 3, 6)
  end

  def company1
    @_company1 ||= company(name: "company1", cars_count: 23, created_at: 1.year.ago)
  end

  def company2
    @_company2 ||= company(name: "company2", cars_count: 24, created_at: 1.year.ago, valid: false)
  end

  def company3
    @_company3 ||= company(name: "company3", cars_count: 10, created_at: 1.year.ago)
  end

  def company4
    @_company4 ||= company(name: "company4", cars_count: 8, created_at: end_date - 5)
  end

  def company5
    @_company5 ||= company(name: "company5", cars_count: 5, created_at: end_date - 5, valid: false)
  end

  def company(name: nil, cars_count: nil, created_at: nil, valid: true)
    company = Company.create!(name: name, created_at: created_at, city: "杭州")

    1.upto(cars_count) do
      company.cars.create!(cars(:aodi).attributes
                                      .except!("id", "company_id")
                                      .merge(stock_number: SecureRandom.hex(10))
                          )
    end

    (start_date..end_date).each do |date|
      if date == invalid_date
        count = valid ? 5 : 2
        count.times do
          DailyActiveRecord.create(company_id: company.id, created_at: date)
        end
      else
        5.times do
          DailyActiveRecord.create(company_id: company.id, created_at: date, city: "杭州市")
        end
      end
    end
    company
  end

  before do
    @c1 = company1
    @c2 = company2
    @c3 = company3
    @c4 = company4
    @c5 = company5
  end

  after do
    Company.destroy_all
    DailyActiveRecord.destroy_all
  end

  describe "#valid_companies" do
    context "all pass" do
      it "returns the list of valid companies" do
        date = Date.new(2016, 3, 9)
        service = DailyActiveService.new(date, date)

        companies = service.valid_companies
        expect(companies.map(&:id)).to match_array [@c1, @c2, @c4, @c5].map(&:id)
      end
    end

    context "invalid_date" do
      it "returns the list of valid companies" do
        date = invalid_date
        service = DailyActiveService.new(date, date)

        companies = service.valid_companies
        expect(companies.map(&:id)).to match_array [@c1, @c4].map(&:id)
      end
    end
  end

  describe "#company_dac" do
    it "returns count for place" do
      date = Date.new(2016, 3, 9)
      service = DailyActiveService.new(date, date)
      result = service.company_dac(@c1.id)
      expect(result).to eq(total: 5, local: 5, nonlocal: 0)
    end
  end
end
