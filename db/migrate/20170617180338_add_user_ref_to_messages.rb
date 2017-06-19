class AddUserRefToMessages < ActiveRecord::Migration[5.1]
  def change
    add_reference :messages, :user, index: true
  end
end
