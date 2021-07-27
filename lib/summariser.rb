# frozen_string_literal: true

class Summariser
  def initialize(records)
    @records = records.dup.sort!.reverse!
  end

  def to_s
    <<~SUMMARY
      Latest <https://coronavirus.data.gov.uk/|UK numbers> (daily):
      - #{latest_cases_record.friendly_cases}
      - #{latest_admissions_record.friendly_admissions}
      - #{latest_deaths_record.friendly_deaths}
      - #{latest_tests_record.friendly_tests}
      - #{latest_vaccines_record.friendly_vaccinations}
      #<https://github.com/mcoms/miserybot|miseryBot>
    SUMMARY
  end

  private

  def latest_cases_record
    @latest_cases_record ||= @records.find(&:new_cases)
  end

  def latest_deaths_record
    @latest_deaths_record ||= @records.find(&:new_deaths)
  end

  def latest_tests_record
    @latest_tests_record ||= @records.find(&:new_tests)
  end

  def latest_vaccines_record
    @latest_vaccines_record ||= @records.find(&:new_vaccinations)
  end

  def latest_admissions_record
    @latest_admissions_record ||= @records.find(&:new_admissions)
  end
end
