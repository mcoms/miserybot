# frozen_string_literal: true

class Record
  include Comparable

  attr_reader :date, :new_cases, :new_deaths, :new_tests, :new_vaccinations,
              :new_admissions

  def initialize(hash)
    @date = Date.parse(hash['date'])
    @new_cases = hash['newCasesByPublishDate']
    @new_deaths = hash['newDeaths28DaysByPublishDate']
    @new_tests = hash['newVirusTestsByPublishDate']
    @new_vaccinations = hash['newVaccinesGivenByPublishDate']
    @new_admissions = hash['newAdmissions']
  end

  def <=>(other)
    date <=> other.date
  end

  def friendly_cases
    friendly_message "#{friendly_number @new_cases} cases"
  end

  def friendly_deaths
    friendly_message "#{friendly_number @new_deaths} deaths"
  end

  def friendly_tests
    friendly_message "#{friendly_number @new_tests} tests"
  end

  def friendly_vaccinations
    friendly_message "#{friendly_number @new_vaccinations} vaccines"
  end

  def friendly_admissions
    friendly_message "#{friendly_number @new_admissions} admitted"
  end

  private

  def friendly_number(number)
    number.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
  end

  def friendly_date
    date.strftime('%d/%b')
  end

  def friendly_message(message)
    "#{message} (#{friendly_date})"
  end
end
