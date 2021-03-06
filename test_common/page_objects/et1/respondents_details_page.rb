require_relative './base_page'
module EtFullSystem
  module Test
    module Et1
      class RespondentsDetailsPage < BasePage
        section :main_content, '#content .main-section .main-content' do
          section :about_the_respondent, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("About the respondent")]] }) do
            element :name, 'input[name="respondent[name]"]'
            element :building, 'input[name="respondent[address_building]"]'
            element :street, 'input[name="respondent[address_street]"]'
            element :locality, 'input[name="respondent[address_locality]"]'
            element :county, 'input[name="respondent[address_county]"]'
            element :post_code, 'input[name="respondent[address_post_code]"]'
            element :telephone_number, 'input[name="respondent[address_telephone_number]"]'
          end
          section :your_work_address, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Your work address")]] }) do
            element :building, 'input[name="respondent[work_address_building]"]'
            element :street, 'input[name="respondent[work_address_street]"]'
            element :locality, 'input[name="respondent[work_address_locality]"]'
            element :county, 'input[name="respondent[work_address_county]"]'
            element :post_code, 'input[name="respondent[work_address_post_code]"]'
            element :telephone_number, 'input[name="respondent[work_address_telephone_number]"]'
            section :same_address, '.respondent_worked_at_same_address' do
              def set(value)
                choose value, name: 'respondent[worked_at_same_address]'
              end
            end
          end
          section :acas, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Acas early conciliation certificate number")]] }) do
            element :certificate_number, 'input[name="respondent[acas_early_conciliation_certificate_number]"]'
          end
          element :save_and_continue_button, 'form.edit_respondent input[value="Save and continue"]'
        end

        def save_and_continue
          main_content.save_and_continue_button.click
        end

        def set_for(respondent)
          data = respondent[0].to_h
          return if data.nil? || data.empty?
          main_content.about_the_respondent do |s|
            set_field s, :name, data
            set_field s, :building, data
            set_field s, :street, data
            set_field s, :locality, data
            set_field s, :county, data
            set_field s, :post_code, data
            set_field s, :telephone_number, data
          end
          if data.key?(:work_address)
            address = data[:work_address].to_h
            main_content.your_work_address do |s|
              s.same_address.set('No')
              set_field s, :building, address
              set_field s, :street, address
              set_field s, :locality, address
              set_field s, :county, address
              set_field s, :post_code, address
              set_field s, :telephone_number, address
            end
          else
            main_content.your_work_address.same_address.set('Yes')
          end
          main_content.acas do |s|
            s.certificate_number.set data[:acas_number] if data.key?(:acas_number)
          end
        end

        private

        def set_field(s, key, data)
          s.send(key).set(data[key]) if data.key?(key)
        end
      end
    end
  end
end