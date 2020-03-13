class AddNameTaskConstraintToTask < ActiveRecord::Migration[5.2]
  def up
    execute "ALTER TABLE tasks ADD CONSTRAINT name_task_should_not_be_NULL CHECK (
    name_task IS NOT NULL
    )"
  end

  def down
    execute "ALTER TABLE projects DROP CONSTRAINT IF EXISTS name_task_should_not_be_NULL"
  end
end
