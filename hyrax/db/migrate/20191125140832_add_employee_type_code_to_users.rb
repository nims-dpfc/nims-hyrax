class AddEmployeeTypeCodeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :employee_type_code, :string
    add_index :users, :employee_type_code
  end
end
