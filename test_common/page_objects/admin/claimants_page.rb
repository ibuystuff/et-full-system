module EtFullSystem
  module Test
    module Admin
      class ClaimantsPage < Admin::BasePage
        set_url "/claimants"
        section :main_table, '#index_table_claimants tbody tr' do
          element :first_name, 'td.col.col-first_name'
        end

        def check_claimants_details(user)
          load
          main_table.first_name.text == user
        end
      end
    end
  end
end