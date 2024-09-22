class CreateTodos < ActiveRecord::Migration[7.2]
  def change
    create_table :todos, id: :uuid do |t|
      t.string :title
      t.boolean :completed
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.text :description
      t.datetime :due_date

      t.timestamps
    end
  end
end
