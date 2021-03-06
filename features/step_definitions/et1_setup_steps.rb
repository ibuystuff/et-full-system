Given(/^an employee making a claim$/) do
  @claimants = FactoryBot.create_list(:first_person, 1, :person_data)
  @representatives = FactoryBot.create_list(:representative, 1, :et3_information)
  @respondents = FactoryBot.create_list(:organisation_data, 1, :employer)
  @employment = FactoryBot.create(:employment)
  @claim = FactoryBot.create(:claim)
end

Given(/^an employee making a claim without a respresentative$/) do
  @claimants = FactoryBot.create_list(:first_person, 1, :person_data)
  @respondents = FactoryBot.create_list(:organisation_data, 1, :employer)
  @employment = FactoryBot.create(:employment)
  @claim = FactoryBot.create(:claim)
end

Given(/^2 employees making a claim$/) do
  @claimants = FactoryBot.create_list(:first_person, 2, :person_data)
  @representatives = FactoryBot.create_list(:representative, 1, :et3_information)
  @respondents = FactoryBot.create_list(:organisation_data, 1, :employer)
  @employment = FactoryBot.create(:employment)
  @claim = FactoryBot.create(:claim)
end

Given(/^7 employees making a claim by uploading CSV file$/) do
  @claimants = FactoryBot.create_list(:first_person, 1, :group_claims)
  @representatives = FactoryBot.create_list(:representative, 1, :et3_information)
  @respondents = FactoryBot.create_list(:organisation_data, 1, :employer)
  @employment = FactoryBot.create(:employment)
  @claim = FactoryBot.create(:claim)
end

Given(/^an employee making a claim by uploading a Rich Text Format document$/) do
  @claimants = FactoryBot.create_list(:first_person, 1, :person_data)
  @representatives = FactoryBot.create_list(:representative, 1, :et3_information)
  @respondents = FactoryBot.create_list(:organisation_data, 1, :employer)
  @employment = FactoryBot.create(:employment)
  @claim = FactoryBot.create_list(:claim, 1, :upload_your_claim_statement)[0]
end

Given(/^an employee making a claim against 3 employers$/) do
  @claimants = FactoryBot.create_list(:first_person, 1, :person_data)
  @representatives = FactoryBot.create_list(:representative, 1, :et3_information)
  @respondents = FactoryBot.create_list(:organisation_data, 3, :employer)
  @employment = FactoryBot.create(:employment)
  @claim = FactoryBot.create(:claim)
end

Given("a claimant submitted an ET1 form with work address {string}") do |string|
  @claimants = FactoryBot.create_list(:first_person, 1, :person_data, post_code: string)
  @representatives = FactoryBot.create_list(:representative, 1, :et3_information)
  @respondents = FactoryBot.create_list(:organisation_data, 1, :employer)
  @employment = FactoryBot.create(:employment)
  @claim = FactoryBot.create(:claim)

  start_a_new_et1_claim
  et1_answer_login
  et1_answer_claimant_questions
  et1_answer_group_claimants_questions
  et1_answer_representatives_questions
  et1_answer_respondents_questions
  et1_answer_employment_details_questions
  et1_answer_claim_type_questions
  et1_answer_claim_details_questions
  et1_answer_claim_outcome_questions
  et1_answer_more_about_the_claim_questions
  et1_submit_claim
end

Given("a claimant submitted an ET1 form with work address the same as respondents {string}") do |string|
  @claimants = FactoryBot.create_list(:first_person, 1, :person_data, post_code: string)
  @representatives = FactoryBot.create_list(:representative, 1, :et3_information)
  @respondents = FactoryBot.create_list(:respondent, 1, :employer)
  @employment = FactoryBot.create(:employment)
  @claim = FactoryBot.create(:claim)

  start_a_new_et1_claim
  et1_answer_login
  et1_answer_claimant_questions
  et1_answer_group_claimants_questions
  et1_answer_representatives_questions
  et1_answer_respondents_questions
  et1_answer_employment_details_questions
  et1_answer_claim_type_questions
  et1_answer_claim_details_questions
  et1_answer_claim_outcome_questions
  et1_answer_more_about_the_claim_questions
  et1_submit_claim
end