class AddCompletedAtToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :completed_at, :datetime
    remove_column :tasks, :completed
  end
end
